import 'package:flutter/material.dart';
import '../models/user.dart';
import '../utils/storage.dart';
import 'dart:io';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<User?>(
      future: Storage.getUser(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        final user = snapshot.data;
        return Scaffold(
          appBar: AppBar(title: const Text('Profile')),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundImage:
                      (user?.image != null && user!.image.isNotEmpty)
                      ? (user.image.startsWith('assets/')
                            ? AssetImage(user.image)
                            : FileImage(File(user.image)))
                      : const AssetImage('assets/user.jpg') as ImageProvider,
                ),
                const SizedBox(height: 16),
                Text('Name: ${user?.fullName ?? ''}'),
                Text('Email: ${user?.email ?? ''}'),
                Text('Phone: ${user?.phone ?? ''}'),
                Text('Address: ${user?.address ?? ''}'),
                Text('Date of Birth: ${user?.dob ?? ''}'),
                Text('Gender: ${user?.gender ?? ''}'),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () async {
                    await Storage.clearUser();
                    if (!context.mounted) return;
                    await Navigator.pushReplacementNamed(context, '/login');
                  },
                  child: const Text('Logout'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
