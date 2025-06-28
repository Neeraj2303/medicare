import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserPage extends StatefulWidget {
  const UserPage({super.key});

  @override
  State<UserPage> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  Future<void> _markTaken(DocumentSnapshot doc) async {
    await FirebaseFirestore.instance
        .collection('medication_logs')
        .doc(doc.id)
        .update({'taken': true});
  }

  Future<void> _markMissed(DocumentSnapshot doc) async {
    await FirebaseFirestore.instance
        .collection('medication_logs')
        .doc(doc.id)
        .update({'taken': false});
  }

  Future<void> _handleEmergency() async {
    await FirebaseFirestore.instance.collection('emergencies').add({
      'timestamp': Timestamp.now(),
      'message': 'Emergency button pressed',
      'user': FirebaseAuth.instance.currentUser?.uid,
    });

    if (mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Emergency reported!')));
    }
  }

  Future<void> _sendCommand(String command) async {
    await FirebaseFirestore.instance
        .collection('commands')
        .doc('dispenser')
        .set({'command': command});
    if (mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Command "$command" sent')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("User Page")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('medication_logs')
                    .orderBy('date')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.data!.docs.isEmpty) {
                    return const Center(
                      child: Text("No medications scheduled"),
                    );
                  }

                  return ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      final doc = snapshot.data!.docs[index];
                      final data = doc.data() as Map<String, dynamic>;

                      final medication = data['medication'] ?? '';
                      final dosage = data['dosage'] ?? '';
                      final time = data['time'] ?? '';
                      final taken = data['taken'];

                      return Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        elevation: 3,
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Medication: $medication",
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text("Dosage: $dosage"),
                              Text("Time: $time"),
                              const SizedBox(height: 8),
                              if (taken == null)
                                Row(
                                  children: [
                                    ElevatedButton(
                                      onPressed: () => _markTaken(doc),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.green,
                                      ),
                                      child: const Text("Taken"),
                                    ),
                                    const SizedBox(width: 8),
                                    ElevatedButton(
                                      onPressed: () => _markMissed(doc),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.red,
                                      ),
                                      child: const Text("Missed"),
                                    ),
                                  ],
                                )
                              else
                                Text(
                                  "Status: ${taken ? 'Taken' : 'Missed'}",
                                  style: TextStyle(
                                    color: taken ? Colors.green : Colors.red,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  onPressed: () => _sendCommand("med1"),
                  icon: const Icon(Icons.local_pharmacy),
                  label: const Text("Dispense Med 1"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () => _sendCommand("med2"),
                  icon: const Icon(Icons.local_pharmacy),
                  label: const Text("Dispense Med 2"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: _handleEmergency,
              icon: const Icon(Icons.warning, color: Colors.white),
              label: const Text(
                'Emergency',
                style: TextStyle(color: Colors.white),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 14,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
