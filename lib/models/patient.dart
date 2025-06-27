class Patient {
  final String id;
  final String name;
  final String nextDoseTime;

  Patient({required this.id, required this.name, required this.nextDoseTime});

  Map<String, dynamic> toMap() {
    return {'id': id, 'name': name, 'nextDoseTime': nextDoseTime};
  }

  factory Patient.fromMap(Map<String, dynamic> map) {
    return Patient(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      nextDoseTime: map['nextDoseTime'] ?? '',
    );
  }
}
