import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'login_screen.dart';
import '../services/theme_service.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
final themeService = ThemeService();

  Future<void> changePassword(BuildContext context) async {
    final user = FirebaseAuth.instance.currentUser;

    if (user?.email != null) {
      await FirebaseAuth.instance.sendPasswordResetEmail(
        email: user!.email!,
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Password reset email sent.'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  Future<void> logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();

    if (!mounted) return;

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (_) => const LoginScreen(),
      ),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        centerTitle: true,
        backgroundColor: Colors.green,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const SizedBox(height: 10),

          const CircleAvatar(
            radius: 45,
            backgroundColor: Colors.green,
            child: Icon(
              Icons.settings,
              color: Colors.white,
              size: 50,
            ),
          ),

          const SizedBox(height: 20),

          const Center(
            child: Text(
              'App Settings',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          const SizedBox(height: 30),

          Card(
            elevation: 4,
            child: ListTile(
              leading: const Icon(
                Icons.person,
                color: Colors.green,
              ),
              title: const Text('Account'),
              subtitle: const Text('Manage your profile'),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {},
            ),
          ),

          const SizedBox(height: 10),

          Card(
            elevation: 4,
            child: ListTile(
              leading: const Icon(
                Icons.notifications,
                color: Colors.green,
              ),
              title: const Text('Notifications'),
              subtitle: const Text('Manage notification settings'),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {},
            ),
          ),

          const SizedBox(height: 10),

          Card(
            elevation: 4,
            child: SwitchListTile(
              secondary: const Icon(
                Icons.dark_mode,
                color: Colors.green,
              ),
              title: const Text('Dark Mode'),
              subtitle: const Text('Enable dark theme'),
value: themeService.isDark,

onChanged: (value) {

  setState(() {

    themeService.toggleTheme(value);

  });



  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        value
        ? 'Dark Mode Enabled'
        : 'Dark Mode Disabled',
      ),
    ),
  );

},
            ),
          ),

          const SizedBox(height: 10),

          Card(
            elevation: 4,
            child: ListTile(
              leading: const Icon(
                Icons.lock,
                color: Colors.green,
              ),
              title: const Text('Change Password'),
              subtitle: const Text('Reset your password'),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () => changePassword(context),
            ),
          ),

          const SizedBox(height: 10),

          Card(
            elevation: 4,
            child: ListTile(
              leading: const Icon(
                Icons.language,
                color: Colors.green,
              ),
              title: const Text('Language'),
              subtitle: const Text('English / አማርኛ'),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {},
            ),
          ),

          const SizedBox(height: 10),

          Card(
            elevation: 4,
            child: const ListTile(
              leading: Icon(
                Icons.info,
                color: Colors.green,
              ),
              title: Text('About App'),
              subtitle: Text('Tina Mart Event Notification System\nVersion 1.0'),
            ),
          ),

          const SizedBox(height: 40),

          SizedBox(
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
                'Logout',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                ),
              ),
              onPressed: () => logout(context),
            ),
          ),
        ],
      ),
    );
  }
}