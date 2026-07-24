import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'edit_profile_screen.dart';
import 'login_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return const Scaffold(
        body: Center(
          child: Text("User not logged in"),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("My Profile"),
        centerTitle: true,
        backgroundColor: Colors.green,
      ),

      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection("users")
            .doc(user.uid)
            .snapshots(),
        builder: (context, snapshot) {

          if (snapshot.connectionState ==
              ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (!snapshot.hasData || !snapshot.data!.exists) {
            return const Center(
              child: Text("Profile not found"),
            );
          }

          final data =
              snapshot.data!.data() as Map<String, dynamic>;

          final name = data["name"] ?? "";
          final email = data["email"] ?? "";
          final phone = data["phone"] ?? "";
          final department =
              data["department"] ?? "";
          final employeeId =
              data["employeeId"] ?? "";
          final role = data["role"] ?? "";

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [

                const CircleAvatar(
                  radius: 55,
                  backgroundColor: Colors.green,
                  child: Icon(
                    Icons.person,
                    color: Colors.white,
                    size: 60,
                  ),
                ),

                const SizedBox(height: 20),

                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 5),

                Text(
                  email,
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 16,
                  ),
                ),

                const SizedBox(height: 25),
                Card(
  child: ListTile(
    leading: const Icon(Icons.badge, color: Colors.green),
    title: const Text("Employee ID"),
    subtitle: Text(employeeId),
  ),
),

const SizedBox(height: 10),

Card(
  child: ListTile(
    leading: const Icon(Icons.work, color: Colors.green),
    title: const Text("Department"),
    subtitle: Text(department),
  ),
),

const SizedBox(height: 10),

Card(
  child: ListTile(
    leading: const Icon(Icons.phone, color: Colors.green),
    title: const Text("Phone"),
    subtitle: Text(phone),
  ),
),

const SizedBox(height: 10),

Card(
  child: ListTile(
    leading: const Icon(Icons.admin_panel_settings,
        color: Colors.green),
    title: const Text("Role"),
    subtitle: Text(role.toUpperCase()),
  ),
),

const SizedBox(height: 30),

SizedBox(
  width: double.infinity,
  height: 50,
  child: ElevatedButton.icon(
    style: ElevatedButton.styleFrom(
      backgroundColor: Colors.green,
    ),
    icon: const Icon(Icons.edit, color: Colors.white),
    label: const Text(
      "Edit Profile",
      style: TextStyle(
        color: Colors.white,
        fontSize: 18,
      ),
    ),
    onPressed: () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => EditProfileScreen(),
        ),
      );
    },
  ),
),

const SizedBox(height: 15),

SizedBox(
  width: double.infinity,
  height: 50,
  child: ElevatedButton.icon(
    style: ElevatedButton.styleFrom(
      backgroundColor: Colors.red,
    ),
    icon: const Icon(
      Icons.logout,
      color: Colors.white,
    ),
    label: const Text(
      "Logout",
      style: TextStyle(
        color: Colors.white,
        fontSize: 18,
      ),
    ),
    onPressed: () async {
      await FirebaseAuth.instance.signOut();

      if (context.mounted) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (_) => const LoginScreen(),
          ),
          (route) => false,
        );
      }
    },
  ),
),

              ],
            ),
          );
        },
      ),
    );
  }
}