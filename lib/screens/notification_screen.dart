import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});


  Widget buildNotification(
    String title,
    String message,
    String date,
    String image,
  ) {

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10),
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),

      child: ListTile(

        leading: image.isNotEmpty
            ? CircleAvatar(
                radius: 28,
                backgroundImage: NetworkImage(image),
              )
            : const CircleAvatar(
                radius: 28,
                backgroundColor: Colors.green,
                child: Icon(
                  Icons.notifications,
                  color: Colors.white,
                ),
              ),


        title: Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),


        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            const SizedBox(height: 5),

            Text(
              message,
              style: const TextStyle(
                fontSize: 15,
              ),
            ),


            const SizedBox(height: 8),


            Text(
              date,
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 12,
              ),
            ),

          ],
        ),

        isThreeLine: true,
      ),
    );
  }



  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title: const Text("Notifications"),
        centerTitle: true,
        backgroundColor: Colors.green,
      ),



      body: StreamBuilder<QuerySnapshot>(

        stream: FirebaseFirestore.instance
            .collection("notifications")
            .orderBy(
              "createdAt",
              descending: true,
            )
            .snapshots(),



        builder: (context, snapshot) {


          if (snapshot.hasError) {

            return Center(
              child: Text(
                snapshot.error.toString(),
              ),
            );

          }



          if (snapshot.connectionState ==
              ConnectionState.waiting) {

            return const Center(
              child: CircularProgressIndicator(),
            );

          }



          if (!snapshot.hasData ||
              snapshot.data!.docs.isEmpty) {


            return const Center(

              child: Text(
                "No Notifications Found",

                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),

              ),

            );

          }



          final notifications =
              snapshot.data!.docs;



          return ListView.builder(

            padding: const EdgeInsets.all(15),

            itemCount: notifications.length,


            itemBuilder: (context,index){


              final data =
                  notifications[index].data()
                  as Map<String,dynamic>;



              return buildNotification(

                data["title"] ?? "",

                data["message"] ?? "",

                data["date"] ?? "",

                data["image"] ?? "",

              );

            },

          );


        },

      ),

    );

  }

}