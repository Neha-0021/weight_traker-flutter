class WeightEntry {
  final String id;
  final double weight;
  final String date;
  final String note;

  WeightEntry({
    required this.id,
    required this.weight,
    required this.date,
    required this.note,
  });

  
  factory WeightEntry.fromMap(Map<String, dynamic> map) {
    return WeightEntry(
      id: map['id'],
      weight: map['weight'],
      date: map['date'],
      note: map['note'],
    );
  }

  
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'weight': weight,
      'date': date,
      'note': note,
    };
  }
}
