import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'screens/splash_screen.dart';
import 'services/theme_service.dart';


final ThemeService themeService = ThemeService();



Future<void> main() async {

  WidgetsFlutterBinding.ensureInitialized();


  await Firebase.initializeApp();



  // Notification Permission
  NotificationSettings settings =
      await FirebaseMessaging.instance.requestPermission(
    alert: true,
    badge: true,
    sound: true,
  );


  print(
    "Permission: ${settings.authorizationStatus}",
  );



  // Get FCM Token

  String? token =
      await FirebaseMessaging.instance.getToken();


  print("==============================");
  print("FCM TOKEN:");
  print(token);
  print("==============================");



  // Save Token to Firestore

  User? user =
      FirebaseAuth.instance.currentUser;


  if (user != null && token != null) {

    await FirebaseFirestore.instance
        .collection("users")
        .doc(user.uid)
        .update({

      "fcmToken": token,

    });


    print("FCM Token Saved");

  }



  // Foreground Notification

  FirebaseMessaging.onMessage.listen(
    (RemoteMessage message) {


      print("Notification Received");


      print(
        "Title: ${message.notification?.title}",
      );


      print(
        "Body: ${message.notification?.body}",
      );


    },
  );



  runApp(
    const TinaMartApp(),
  );

}





class TinaMartApp extends StatefulWidget {

  const TinaMartApp({
    super.key,
  });


  @override
  State<TinaMartApp> createState() => _TinaMartAppState();

}



class _TinaMartAppState extends State<TinaMartApp> {


  @override
  Widget build(BuildContext context) {


    return AnimatedBuilder(

      animation: themeService,


      builder: (context, child) {


        return MaterialApp(


          debugShowCheckedModeBanner: false,


          title: "Tina Notification",



          themeMode: themeService.isDark
              ? ThemeMode.dark
              : ThemeMode.light,



          theme: ThemeData(

            primarySwatch: Colors.green,

          ),



          darkTheme: ThemeData.dark(),



          home: const SplashScreen(),


        );


      },

    );

  }

}