import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'event_details_screen.dart';
import 'edit_event_screen.dart';

class EventScreen extends StatefulWidget {
  const EventScreen({super.key});

  @override
  State<EventScreen> createState() => _EventScreenState();
}

class _EventScreenState extends State<EventScreen> {
  final TextEditingController searchController =
    TextEditingController();

String searchText = "";

  Future<bool> isAdmin() async {
    final uid = FirebaseAuth.instance.currentUser!.uid;

    final doc = await FirebaseFirestore.instance
        .collection("users")
        .doc(uid)
        .get();

    return doc.data()?["role"] == "admin";
  }

  Widget buildEventCard(
    BuildContext context,
    String documentId,
    String title,
    String date,
    String description,
    String location,
    String image,
    String category,
    bool isAdminUser,
  ) {
    return Card(
      elevation: 5,
      margin: const EdgeInsets.symmetric(vertical: 10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: ListTile(
        leading: const Icon(
          Icons.event,
          color: Colors.green,
          size: 40,
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        subtitle: Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    Text(date),
    const SizedBox(height: 5),
    Text(
      category,
      style: const TextStyle(
        color: Colors.green,
        fontWeight: FontWeight.bold,
      ),
    ),
  ],
),
               trailing: isAdminUser
            ? Row(
                mainAxisSize: MainAxisSize.min,
                children: [

                  IconButton(
                    icon: const Icon(
                      Icons.edit,
                      color: Colors.orange,
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => EditEventScreen(
                            documentId: documentId,
                            title: title,
                            date: date,
                            location: location,
                            description: description,
                          ),
                        ),
                      );
                    },
                  ),

                  IconButton(
                    icon: const Icon(
                      Icons.delete,
                      color: Colors.red,
                    ),
                    onPressed: () async {

                      bool? confirm = await showDialog(
                        context: context,
                        builder: (_) => AlertDialog(
                          title: const Text("Delete Event"),
                          content: const Text(
                            "Are you sure you want to delete this event?",
                          ),
                          actions: [

                            TextButton(
                              onPressed: () {
                                Navigator.pop(context, false);
                              },
                              child: const Text("Cancel"),
                            ),

                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red,
                              ),
                              onPressed: () {
                                Navigator.pop(context, true);
                              },
                              child: const Text(
                                "Delete",
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );

                      if (confirm == true) {

                        await FirebaseFirestore.instance
                            .collection("events")
                            .doc(documentId)
                            .delete();

                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              "Event Deleted Successfully",
                            ),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    },
                  ),
                ],
              )
            : null,

        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => EventDetailsScreen(
                title: title,
                date: date,
                description: description,
                location: location,
                image: image,
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
         return Scaffold(
      appBar: AppBar(
        title: const Text("Events"),
        centerTitle: true,
        backgroundColor: Colors.green,
      ),

      body: Column(
  children: [
    Padding(
      padding: const EdgeInsets.all(10),
      child: TextField(
        controller: searchController,
        decoration: InputDecoration(
          hintText: "Search Event...",
          prefixIcon: const Icon(Icons.search),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        onChanged: (value) {
          setState(() {
            searchText = value.toLowerCase();
          });
        },
      ),
    ),

    Expanded(
      child: FutureBuilder<bool>(
        future: isAdmin(),
        builder: (context, adminSnapshot) {
          if (!adminSnapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          final isAdminUser = adminSnapshot.data!;

          return StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection("events")
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Center(
                  child: Text(snapshot.error.toString()),
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
                    "No Events Found",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                );
              }
final events = snapshot.data!.docs.where((event) {

  final data = event.data() as Map<String, dynamic>;

  final title = (data["title"] ?? "")
      .toString()
      .toLowerCase();

  final category = (data["category"] ?? "")
      .toString()
      .toLowerCase();

  return title.contains(searchText) ||
      category.contains(searchText);

}).toList();

    return ListView.builder(
  padding: const EdgeInsets.all(15),
  itemCount: events.length,
  itemBuilder: (context, index) {

    final event = events[index];

    final data = event.data() as Map<String, dynamic>;

    return buildEventCard(
      context,
      event.id,
      data["title"] ?? "",
      data["date"] ?? "",
      data["description"] ?? "",
      data["location"] ?? "",
      data["image"] ?? "",
      data["category"] ?? "General",
      isAdminUser,
    );
  },
);
            },
          );
        },
      ),
    ),
  ],
),
          );
      }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }
}