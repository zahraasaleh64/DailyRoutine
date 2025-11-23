class Habit {
  final String id;
  final String name;

  Habit({
    required this.id,
    required this.name,
  });

  // Convert to JSON for storage
  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
  };

  // Create from JSON
  factory Habit.fromJson(Map<String, dynamic> json) => Habit(
    id: json['id'],
    name: json['name'],
  );
}
