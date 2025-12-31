class MedicineReminder {
  final String id;
  final String name;
  final String time; // HH:mm
  final String? dosage;

  MedicineReminder({
    required this.id,
    required this.name,
    required this.time,
    this.dosage,
  });

  factory MedicineReminder.fromMap(String id, Map data) {
    return MedicineReminder(
      id: id,
      name: data['name'] ?? '',
      time: data['time'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'time': time,
    };
  }
}
