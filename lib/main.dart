// flutter run -d web-server --web-hostname 0.0.0.0 --web-port 8080

import 'package:flutter/material.dart';
import 'firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'mqtt.dart';
import 'fire_base.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/mqtt',
      routes: {
        '/mqtt': (context) => const MyMqttPage(title: 'MQTT Page'),
        '/firebase': (context) => const MyFirebasePage(title: 'Firebase Page'),
      },
    );
  }
}
