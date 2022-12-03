import 'package:first_fp/providers/starred_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_vlc_player/flutter_vlc_player.dart';
import 'package:provider/provider.dart';
import 'package:wakelock/wakelock.dart';

class Play extends StatefulWidget {
  final String id;
  final String type;
  final String extension;
  final String name;

  const Play({
    required this.id,
    required this.type,
    required this.extension,
    required this.name,
    Key? key,
  }) : super(key: key);

  String generateUrl(logins) {
    String host = logins['host'];
    String dns = 'http://$host/';
    String user = logins['username'];
    String pass = logins['password'];
    print('$dns$type/$user/$pass/$id.$extension');
    return '$dns$type/$user/$pass/$id.$extension';
  }

  @override
  State<Play> createState() => _PlayState();
}

class _PlayState extends State<Play> {
  late VlcPlayerController videoPlayerController;

  late AnimationController scaleVideoAnimationController;
  Animation<double> scaleVideoAnimation =
      const AlwaysStoppedAnimation<double>(1.0);
  double? targetVideoScale;
  late bool isMute = false;
  late bool hasBeenSet = false;

  // Cache value for later usage at the end of a scale-gesture
  late double lastZoomGestureScale = 1.0;

  void setTargetNativeScale(double newValue) {
    if (!newValue.isFinite) {
      return;
    }
    scaleVideoAnimation =
        Tween<double>(begin: 1.0, end: newValue).animate(CurvedAnimation(
      parent: scaleVideoAnimationController,
      curve: Curves.easeInOut,
    ));

    if (targetVideoScale == null) {
      scaleVideoAnimationController.forward();
    }
    targetVideoScale = newValue;
  }

  Future<void> _forceLandscape() async {
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);
    await SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  }

  Future<void> _forcePortrait() async {
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    await SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: SystemUiOverlay.values); // to re-show bars
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    if (!hasBeenSet) {
      _forceLandscape();
      Wakelock.enable();
      videoPlayerController = VlcPlayerController.network(
        widget.generateUrl(context.read<Starred>().login?.get('logins')),
        hwAcc: HwAcc.full,
        autoPlay: true,
        options: VlcPlayerOptions(),
      );
      hasBeenSet = true;
    }

    return Scaffold(
        body: Column(
      children: [
        AspectRatio(
          aspectRatio: screenSize.width / screenSize.height,
          child: GestureDetector(
              onTap: () async {
                setState(() {
                  isMute = !isMute;
                });
                await videoPlayerController.setVolume(isMute ? 100 : 0);
              },
              child: VlcPlayer(
                controller: videoPlayerController,
                aspectRatio: screenSize.width / screenSize.height,
                placeholder: const Center(
                    child: CircularProgressIndicator(
                  color: Colors.deepPurple,
                )),
              )),
        ),
      ],
    ));
  }

  @override
  void dispose() async {
    await Wakelock.disable();
    await videoPlayerController.stop();
    await videoPlayerController.stopRendererScanning();
    await videoPlayerController.dispose();
    await _forcePortrait();
    super.dispose();
  }
}
