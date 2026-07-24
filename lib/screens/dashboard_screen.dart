import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  Future<int> getCount(String collection) async {
    final snapshot =
        await FirebaseFirestore.instance.collection(collection).get();

    return snapshot.docs.length;
  }

  Future<int> getCategoryCount(String category) async {
    final snapshot = await FirebaseFirestore.instance
        .collection("events")
        .where("category", isEqualTo: category)
        .get();

    return snapshot.docs.length;
  }

  Widget buildCard(
    String title,
    IconData icon,
    Color color,
    Future<int> future,
  ) {
    return FutureBuilder<int>(
      future: future,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Card(
            child: SizedBox(
              height: 120,
              child: Center(
                child: CircularProgressIndicator(),
              ),
            ),
          );
        }

        return Card(
          elevation: 5,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          child: Container(
            height: 120,
            padding: const EdgeInsets.all(15),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 28,
                  backgroundColor: color.withOpacity(.15),
                  child: Icon(
                    icon,
                    color: color,
                    size: 30,
                  ),
                ),
                const SizedBox(width: 15),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      snapshot.data.toString(),
                      style: TextStyle(
                        fontSize: 28,
                        color: color,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Dashboard"),
        centerTitle: true,
        backgroundColor: Colors.green,
      ),
      body: ListView(
        padding: const EdgeInsets.all(15),
        children: [

          buildCard(
            "Total Events",
            Icons.event,
            Colors.green,
            getCount("events"),
          ),

          buildCard(
            "Employees",
            Icons.people,
            Colors.blue,
            getCount("users"),
          ),

          buildCard(
            "Promotions",
            Icons.local_offer,
            Colors.orange,
            getCategoryCount("Promotion"),
          ),

          buildCard(
            "Meetings",
            Icons.groups,
            Colors.purple,
            getCategoryCount("Meeting"),
          ),

          buildCard(
            "Trainings",
            Icons.school,
            Colors.teal,
            getCategoryCount("Training"),
          ),

          buildCard(
            "Holidays",
            Icons.beach_access,
            Colors.red,
            getCategoryCount("Holiday"),
          ),

          buildCard(
            "Announcements",
            Icons.campaign,
            Colors.indigo,
            getCategoryCount("Announcement"),
          ),

          buildCard(
            "New Products",
            Icons.shopping_bag,
            Colors.brown,
            getCategoryCount("New Product"),
          ),
        ],
      ),
    );
  }
}