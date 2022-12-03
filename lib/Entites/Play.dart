import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_vlc_player/flutter_vlc_player.dart';
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

  String generateUrl() {
    String dns = 'http://king-play.newtvhd.com:7070/';
    String user = 'king00818';
    String pass = 'p6t6q84y';
    return '$dns$type/$user/$pass/$id.$extension';
  }

  @override
  State<Play> createState() => _PlayState();
}

class _PlayState extends State<Play> {
  late VlcPlayerController _videoPlayerController;

  late AnimationController _scaleVideoAnimationController;
  Animation<double> _scaleVideoAnimation =
      const AlwaysStoppedAnimation<double>(1.0);
  double? _targetVideoScale;

  // Cache value for later usage at the end of a scale-gesture
  final double _lastZoomGestureScale = 1.0;

  void setTargetNativeScale(double newValue) {
    if (!newValue.isFinite) {
      return;
    }
    _scaleVideoAnimation =
        Tween<double>(begin: 1.0, end: newValue).animate(CurvedAnimation(
      parent: _scaleVideoAnimationController,
      curve: Curves.easeInOut,
    ));

    if (_targetVideoScale == null) {
      _scaleVideoAnimationController.forward();
    }
    _targetVideoScale = newValue;
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
  void initState() {
    _forceLandscape();
    Wakelock.enable();
    _videoPlayerController = VlcPlayerController.network(
      widget.generateUrl(),
      hwAcc: HwAcc.full,
      autoPlay: true,
      options: VlcPlayerOptions(),
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Scaffold(
        body: Column(
      children: [
        AspectRatio(
          aspectRatio: screenSize.width / screenSize.height,
          child: GestureDetector(
            onTap: () {
              print(
                  '=====================================================================================');
            },
            child: VlcPlayer(
              controller: _videoPlayerController,
              aspectRatio: screenSize.width / screenSize.height,
              placeholder: const Center(child: CircularProgressIndicator()),
            ),
          ),
        ),
      ],
    ));
  }

  @override
  void dispose() async {
    super.dispose();
    await _forcePortrait();
    await Wakelock.disable();
    await _videoPlayerController.stopRendererScanning();
    await _videoPlayerController.dispose();
  }
}
