import 'package:flutter/material.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../injection.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final authRepository = getIt<AuthRepository>();
    final email = authRepository.getCurrentUserEmail() ?? 'N/A';
    final name = authRepository.getCurrentUserName() ?? 'N/A';

    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Name: $name', style: const TextStyle(fontSize: 20)),
            const SizedBox(height: 10),
            Text('Email: $email', style: const TextStyle(fontSize: 20)),
          ],
        ),
      ),
    );
  }
}
