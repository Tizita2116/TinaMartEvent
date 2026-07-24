import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EditEventScreen extends StatefulWidget {
  final String documentId;
  final String title;
  final String date;
  final String location;
  final String description;

  const EditEventScreen({
    super.key,
    required this.documentId,
    required this.title,
    required this.date,
    required this.location,
    required this.description,
  });

  @override
  State<EditEventScreen> createState() => _EditEventScreenState();
}

class _EditEventScreenState extends State<EditEventScreen> {

  late TextEditingController titleController;
  late TextEditingController dateController;
  late TextEditingController locationController;
  late TextEditingController descriptionController;

  bool loading = false;

  @override
  void initState() {
    super.initState();

    titleController =
        TextEditingController(text: widget.title);

    dateController =
        TextEditingController(text: widget.date);

    locationController =
        TextEditingController(text: widget.location);

    descriptionController =
        TextEditingController(text: widget.description);
  }

  InputDecoration decoration(
      String label,
      IconData icon,
      ) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon),
      border: OutlineInputBorder(
        borderRadius:
        BorderRadius.circular(12),
      ),
    );
  }
    Future<void> updateEvent() async {
    if (titleController.text.isEmpty ||
        dateController.text.isEmpty ||
        locationController.text.isEmpty ||
        descriptionController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please fill all fields"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      loading = true;
    });

    try {
      await FirebaseFirestore.instance
          .collection("events")
          .doc(widget.documentId)
          .update({
        "title": titleController.text.trim(),
        "date": dateController.text.trim(),
        "location": locationController.text.trim(),
        "description": descriptionController.text.trim(),
      });

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Event Updated Successfully"),
          backgroundColor: Colors.green,
        ),
      );

      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
          backgroundColor: Colors.red,
        ),
      );
    }

    if (mounted) {
      setState(() {
        loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Event"),
        centerTitle: true,
        backgroundColor: Colors.green,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: titleController,
              decoration: decoration(
                "Event Title",
                Icons.event,
              ),
            ),

            const SizedBox(height: 20),

            TextField(
              controller: dateController,
              decoration: decoration(
                "Date",
                Icons.calendar_today,
              ),
            ),

            const SizedBox(height: 20),

            TextField(
              controller: locationController,
              decoration: decoration(
                "Location",
                Icons.location_on,
              ),
            ),

            const SizedBox(height: 20),

            TextField(
              controller: descriptionController,
              maxLines: 5,
              decoration: decoration(
                "Description",
                Icons.description,
              ),
            ),


            const SizedBox(height: 30),
                        SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: loading ? null : updateEvent,
                icon: loading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : const Icon(
                        Icons.save,
                        color: Colors.white,
                      ),
                label: Text(
                  loading ? "Updating..." : "Update Event",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    titleController.dispose();
    dateController.dispose();
    locationController.dispose();
    descriptionController.dispose();
    super.dispose();
  }
}