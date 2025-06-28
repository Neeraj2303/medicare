import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';

class CaretakerPage extends StatefulWidget {
  const CaretakerPage({super.key});
  @override
  State<CaretakerPage> createState() => _CaretakerPageState();
}

class _CaretakerPageState extends State<CaretakerPage> {
  final medicationController = TextEditingController();
  final dosageController = TextEditingController();
  final dateController = TextEditingController();
  final timeController = TextEditingController();

  DateTime? selectedDate;
  TimeOfDay? selectedTime;

  Future<void> _pickDate() async {
    final DateTime? p = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime(2023),
      lastDate: DateTime(2030),
    );
    if (p != null) {
      setState(() {
        selectedDate = p;
        dateController.text =
            "${p.year}-${p.month.toString().padLeft(2, '0')}-${p.day.toString().padLeft(2, '0')}";
      });
    }
  }

  Future<void> _pickTime() async {
    final t = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (t != null) {
      setState(() {
        selectedTime = t;
        timeController.text =
            "${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}";
      });
    }
  }

  Future<void> _assignMedication() async {
    if (medicationController.text.isEmpty ||
        dosageController.text.isEmpty ||
        selectedDate == null ||
        selectedTime == null) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Please fill all fields')));
      }
      return;
    }

    final command = medicationController.text.toLowerCase().contains("2")
        ? "med2"
        : "med1";

    await FirebaseFirestore.instance.collection('medication_logs').add({
      'medication': medicationController.text,
      'dosage': dosageController.text,
      'date': Timestamp.fromDate(selectedDate!),
      'time': timeController.text,
      'taken': null,
    });

    await FirebaseFirestore.instance
        .collection('hardware_control')
        .doc('dispenser')
        .set({'command': command});

    medicationController.clear();
    dosageController.clear();
    dateController.clear();
    timeController.clear();

    if (mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Assigned!')));
    }
  }

  Widget buildGraph(List<QueryDocumentSnapshot> logs) {
    final spots = <FlSpot>[];
    final labels = <double, String>{};

    for (int i = 0; i < logs.length; i++) {
      final d = logs[i].data() as Map<String, dynamic>;
      if (d['taken'] != null && d['date'] is Timestamp) {
        final dt = (d['date'] as Timestamp).toDate();
        final y = d['taken'] == true ? 1.0 : 0.0;
        spots.add(FlSpot(i.toDouble(), y));
        labels[i.toDouble()] = "${dt.month}/${dt.day}";
      }
    }

    return LineChart(
      LineChartData(
        minY: -0.2,
        maxY: 1.2,
        gridData: FlGridData(
          show: true,
          drawVerticalLine: true,
          horizontalInterval: 1,
          verticalInterval: 1,
          getDrawingHorizontalLine: (value) =>
              FlLine(color: Colors.grey.shade300, strokeWidth: 1),
          getDrawingVerticalLine: (value) =>
              FlLine(color: Colors.grey.shade200, strokeWidth: 1),
        ),
        borderData: FlBorderData(
          show: true,
          border: Border.all(color: Colors.grey.shade400, width: 1),
        ),
        titlesData: FlTitlesData(
          leftTitles: AxisTitles(
            axisNameWidget: const Text('Status'),
            sideTitles: SideTitles(
              showTitles: true,
              interval: 1,
              getTitlesWidget: (v, _) {
                switch (v.toInt()) {
                  case 1:
                    return const Text(
                      "Taken",
                      style: TextStyle(color: Colors.green),
                    );
                  case 0:
                    return const Text(
                      "Missed",
                      style: TextStyle(color: Colors.red),
                    );
                  default:
                    return const Text("");
                }
              },
            ),
          ),
          bottomTitles: AxisTitles(
            axisNameWidget: const Text('Date'),
            sideTitles: SideTitles(
              showTitles: true,
              interval: 1,
              getTitlesWidget: (v, _) =>
                  Text(labels[v] ?? '', style: const TextStyle(fontSize: 10)),
            ),
          ),
          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        lineBarsData: [
          LineChartBarData(
            spots: spots,
            isCurved: true,
            color: Colors.green,
            barWidth: 4,
            isStrokeCapRound: true,
            belowBarData: BarAreaData(
              show: true,
              gradient: LinearGradient(
                colors: [Colors.green.withOpacity(0.4), Colors.transparent],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            dotData: FlDotData(
              show: true,
              getDotPainter: (spot, _, __, ___) {
                return FlDotCirclePainter(
                  radius: 5,
                  color: Colors.white,
                  strokeWidth: 3,
                  strokeColor: spot.y == 1.0 ? Colors.green : Colors.red,
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    medicationController.dispose();
    dosageController.dispose();
    dateController.dispose();
    timeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Caretaker Dashboard")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Card(
              margin: const EdgeInsets.symmetric(vertical: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 6,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Text(
                      'Assign Medication',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: medicationController,
                      decoration: const InputDecoration(
                        labelText: 'Medication',
                      ),
                    ),
                    TextField(
                      controller: dosageController,
                      decoration: const InputDecoration(labelText: 'Dosage'),
                    ),
                    TextField(
                      controller: dateController,
                      decoration: const InputDecoration(
                        labelText: 'Date',
                        suffixIcon: Icon(Icons.calendar_month),
                      ),
                      readOnly: true,
                      onTap: _pickDate,
                    ),
                    TextField(
                      controller: timeController,
                      decoration: const InputDecoration(
                        labelText: 'Time',
                        suffixIcon: Icon(Icons.schedule),
                      ),
                      readOnly: true,
                      onTap: _pickTime,
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: _assignMedication,
                        icon: const Icon(Icons.check_circle),
                        label: const Text("Assign"),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Compliance Chart',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 300,
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('medication_logs')
                    .orderBy('date')
                    .snapshots(),
                builder: (c, s) {
                  if (!s.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (s.data!.docs.isEmpty) {
                    return const Center(child: Text("No records yet"));
                  }
                  return buildGraph(s.data!.docs);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
