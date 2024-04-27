import 'package:flutter/material.dart';
import 'package:firebase_intro/services/auth_service.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthService authService = AuthService();
    return Scaffold(
      appBar: AppBar(
        title: const Text("Ana Sayfa"),
        actions: [
          IconButton(
            icon: const Icon(Icons.exit_to_app),
            onPressed: () async {
              await authService.signOut();
            },
          ),
        ],
      ),
      body: const Center(
        child: Text("Ana sayfa içeriği"),
      ),
    );
  }
}
