import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';


class NotificationService {


  final FirebaseMessaging messaging =
      FirebaseMessaging.instance;



  Future<void> initFCM() async {


    // Permission
    await messaging.requestPermission();



    // Get Token
    String? token =
        await messaging.getToken();



    print("FCM TOKEN:");
    print(token);



    // Save Token
    if(token != null){

      final user =
          FirebaseAuth.instance.currentUser;


      if(user != null){

        await FirebaseFirestore.instance
            .collection("users")
            .doc(user.uid)
            .update({

          "fcmToken": token,

        });

      }

    }

  }


}