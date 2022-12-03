import 'package:first_fp/Screens/login.dart';
import 'package:first_fp/providers/starred_provider.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:provider/provider.dart';

late Box? starred;
late Box? login;
void main() async {
  await Hive.initFlutter();
  starred = await Hive.openBox('starred');
  if (starred?.get('entries') == null) {
    await starred?.put('entries', []);
  }

  login = await Hive.openBox('starred');
  if (login?.get('logins') == null) {
    await login?.put('logins', {
      'host': '',
      'username': '',
      'password': '',
    });
  }
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => Starred(box: starred, login: login))
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
      ),
      home: const Login(),
    );
  }
}
