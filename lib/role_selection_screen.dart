import 'package:flutter/material.dart';
import 'caretaker_page.dart';
import 'user_page.dart';

class RoleSelectionScreen extends StatelessWidget {
  const RoleSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Select Role")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton.icon(
              icon: const Icon(Icons.shield),
              label: const Text("Caretaker"),
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const CaretakerPage()),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              icon: const Icon(Icons.person),
              label: const Text("Elder"),
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const UserPage()),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
