import 'dart:io';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';

class AddEventScreen extends StatefulWidget {
  const AddEventScreen({super.key});

  @override
  State<AddEventScreen> createState() => _AddEventScreenState();
}

class _AddEventScreenState extends State<AddEventScreen> {
  final titleController = TextEditingController();
  final dateController = TextEditingController();
  final timeController = TextEditingController();
  final locationController = TextEditingController();
  final descriptionController = TextEditingController();

  bool isLoading = false;

  File? selectedImage;

  final ImagePicker picker = ImagePicker();
  String selectedCategory = "Announcement";

final List<String> categories = [
  "Promotion",
  "Meeting",
  "Holiday",
  "Training",
  "Announcement",
  "New Product",
];

  Future<void> pickImage() async {
    final XFile? image =
        await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        selectedImage = File(image.path);
      });
    }
  }

  Future<void> saveEvent() async {
if (titleController.text.isEmpty ||
    dateController.text.isEmpty ||
    timeController.text.isEmpty ||
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
      isLoading = true;
    });

    try {
   await FirebaseFirestore.instance.collection("events").add({
  "title": titleController.text.trim(),
  "category": selectedCategory,
  "date": dateController.text.trim(),
  "time": timeController.text.trim(),
  "location": locationController.text.trim(),
  "description": descriptionController.text.trim(),
  "image": "",
  "createdAt": FieldValue.serverTimestamp(),
});

// Save notification automatically
await FirebaseFirestore.instance.collection("notifications").add({
  "title": titleController.text.trim(),
  "category": selectedCategory,
  "message": descriptionController.text.trim(),
  "date": dateController.text.trim(),
  "image": "",
  "isRead": false,
  "createdAt": FieldValue.serverTimestamp(),
});

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Event Added Successfully"),
          backgroundColor: Colors.green,
        ),
      );

    titleController.clear();
    dateController.clear();
    timeController.clear();
    locationController.clear();
    descriptionController.clear(); 

      setState(() {
        selectedImage = null;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
          backgroundColor: Colors.red,
        ),
      );
    }

    setState(() {
      isLoading = false;
    });
  }

  InputDecoration inputDecoration(
    String label,
    IconData icon,
  ) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Event"),
        centerTitle: true,
        backgroundColor: Colors.green,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: titleController,
              decoration: inputDecoration(
                "Event Title",
                Icons.event,
              ),
            ),
            const SizedBox(height: 20),

DropdownButtonFormField<String>(
  value: selectedCategory,
  decoration: inputDecoration(
    "Category",
    Icons.category,
  ),
  items: categories.map((category) {
    return DropdownMenuItem<String>(
      value: category,
      child: Text(category),
    );
  }).toList(),
  onChanged: (value) {
    setState(() {
      selectedCategory = value!;
    });
  },
),

            const SizedBox(height: 20),

           TextField(
  controller: dateController,
  readOnly: true,
  decoration: inputDecoration(
    "Date",
    Icons.calendar_today,
  ),
  onTap: () async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2025),
      lastDate: DateTime(2035),
    );

   if (pickedDate != null) {
  setState(() {
    dateController.text =
        "${pickedDate.day}/${pickedDate.month}/${pickedDate.year}";
      });
    }
  },
),


const SizedBox(height: 20),

TextField(
  controller: timeController,
  readOnly: true,
  decoration: inputDecoration(
    "Time",
    Icons.access_time,
  ),
  onTap: () async {
    TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (pickedTime != null) {
      setState(() {
        timeController.text =
            pickedTime.format(context);
      });
    }
  },
),

            const SizedBox(height: 20),

            TextField(
              controller: locationController,
              decoration: inputDecoration(
                "Location",
                Icons.location_on,
              ),
            ),

            const SizedBox(height: 20),

            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                ),
                onPressed: pickImage,
                icon: const Icon(
                  Icons.photo,
                  color: Colors.white,
                ),
                label: const Text(
                  "Select Image (Optional)",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),

            if (selectedImage != null)
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.file(
                  selectedImage!,
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),

            const SizedBox(height: 20),

            TextField(
              controller: descriptionController,
              maxLines: 5,
              decoration: inputDecoration(
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
                onPressed: isLoading ? null : saveEvent,
                icon: isLoading
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
                  isLoading ? "Saving..." : "Save Event",
                  style: const TextStyle(
                    fontSize: 18,
                    color: Colors.white,
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
  timeController.dispose();
  locationController.dispose();
  descriptionController.dispose();
  super.dispose();
}
}