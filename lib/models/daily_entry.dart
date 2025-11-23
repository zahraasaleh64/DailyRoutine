class DailyEntry {
  final DateTime date;
  final String mood;
  final List<String> completedHabits; // List of habit IDs

  DailyEntry({
    required this.date,
    required this.mood,
    required this.completedHabits,
  });

  // Convert to JSON for storage
  Map<String, dynamic> toJson() => {
    'date': date.toIso8601String(),
    'mood': mood,
    'completedHabits': completedHabits,
  };

  // Create from JSON
  factory DailyEntry.fromJson(Map<String, dynamic> json) => DailyEntry(
    date: DateTime.parse(json['date']),
    mood: json['mood'],
    completedHabits: List<String>.from(json['completedHabits']),
  );

  // Helper method to get completion count
  int get completedCount => completedHabits.length;
}