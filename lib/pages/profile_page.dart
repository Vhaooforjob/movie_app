import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  final VoidCallback toggleTheme;
  final bool isDarkMode;

  const ProfilePage(
      {super.key, required this.toggleTheme, required this.isDarkMode});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tài khoản'),
        actions: [
          IconButton(
            icon: Icon(isDarkMode ? Icons.wb_sunny : Icons.nightlight_round),
            onPressed: toggleTheme,
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircleAvatar(
              radius: 50,
              backgroundImage: NetworkImage('https://via.placeholder.com/150'),
            ),
            const SizedBox(height: 20),
            const Text(
              'VAN HAO',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text(
              'vhaooforjob@gmail.com',
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {},
              child: const Text('Edit Profile'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {},
              child: const Text('Logout'),
            ),
          ],
        ),
      ),
    );
  }
}
