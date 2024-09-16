import 'package:cms/Pages/address.dart';
import 'package:cms/Pages/bhogam.dart';
import 'package:cms/Pages/dashboard.dart';
import 'package:cms/Pages/homepage.dart';
import 'package:cms/Pages/sishyas.dart';

import 'package:cms/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

// final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
//     FlutterLocalNotificationsPlugin();
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.web);

  // const AndroidInitializationSettings initializationSettingsAndroid =
  //     AndroidInitializationSettings('@mipmap/ic_launcher');

  // final InitializationSettings initializationSettings =
  //     InitializationSettings(android: initializationSettingsAndroid);

  // await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  // scheduler.startPeriodicChecks();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: HomePage.id,
      routes: {
        Dashboard.id: (context) => Dashboard(),
        AddAddress.id: (context) => AddAddress(),
        SishyasScreen.id: (context) => SishyasScreen(),
        Bhogam.id: (context) => Bhogam(),
      },
      home: const HomePage(),
    );
  }
}
