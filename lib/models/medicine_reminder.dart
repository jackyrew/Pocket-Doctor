class MedicineReminder {
  final String id;
  final String name;
  final String time; // HH:mm
  final String? dosage;
  final int intervalHours;
  final String repeat;

  MedicineReminder({
    required this.id,
    required this.name,
    required this.time,
    this.dosage,
    required this.intervalHours,
    required this.repeat,
  });

  factory MedicineReminder.fromMap(String id, Map data) {
    return MedicineReminder(
      id: id,
      name: data['name'] ?? '',
      time: data['time'] ?? '',
      dosage: data['dosage'],
      intervalHours: data['intervalHours'] ?? 24,
      repeat: data['repeat'] ?? 'daily',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'time': time,
      'dosage': dosage,
      'intervalHours': intervalHours,
      'repeat': repeat,
    };
  }
}
