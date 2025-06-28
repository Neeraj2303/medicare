import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MedicationControlButtons extends StatelessWidget {
  const MedicationControlButtons({super.key});

  Future<void> _sendCommand(String command) async {
    await FirebaseFirestore.instance
        .collection('commands')
        .doc('dispenser')
        .set({'command': command});
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 20),
        Text(
          "Manual Dispense",
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton.icon(
              onPressed: () => _sendCommand("med1"),
              icon: const Icon(Icons.medication),
              label: const Text("Send Med1"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
              ),
            ),
            const SizedBox(width: 20),
            ElevatedButton.icon(
              onPressed: () => _sendCommand("med2"),
              icon: const Icon(Icons.medication_liquid),
              label: const Text("Send Med2"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
