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
      'user': FirebaseAuth.instance.currentUser?.uid ?? 'unknown',
    });

    if (mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Emergency reported!')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Elder Dashboard")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              "Today's Medications",
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 12),
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
                                    ElevatedButton.icon(
                                      onPressed: () => _markTaken(doc),
                                      icon: const Icon(Icons.check),
                                      label: const Text("Taken"),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.green,
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    ElevatedButton.icon(
                                      onPressed: () => _markMissed(doc),
                                      icon: const Icon(Icons.close),
                                      label: const Text("Missed"),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.red,
                                      ),
                                    ),
                                  ],
                                )
                              else
                                Row(
                                  children: [
                                    Icon(
                                      taken ? Icons.check_circle : Icons.cancel,
                                      color: taken ? Colors.green : Colors.red,
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      "Status: ${taken ? 'Taken' : 'Missed'}",
                                      style: TextStyle(
                                        color: taken
                                            ? Colors.green
                                            : Colors.red,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
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
            ElevatedButton.icon(
              onPressed: _handleEmergency,
              icon: const Icon(Icons.warning, color: Colors.white),
              label: const Text(
                'Emergency',
                style: TextStyle(color: Colors.white, fontSize: 16),
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
