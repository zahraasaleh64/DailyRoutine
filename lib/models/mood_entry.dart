class MoodEntry {
  final String mood;
  final String emoji;

  MoodEntry({
    required this.mood,
    required this.emoji,
  });

  static List<MoodEntry> getDefaultMoods() => [
    MoodEntry(mood: 'happy', emoji: '😊'),
    MoodEntry(mood: 'tired', emoji: '😴'),
    MoodEntry(mood: 'stressed', emoji: '😰'),
    MoodEntry(mood: 'calm', emoji: '😌'),
    MoodEntry(mood: 'sad', emoji: '😢'),
    MoodEntry(mood: 'excited', emoji: '😃'),
    MoodEntry(mood: 'down', emoji: '😔'),
    MoodEntry(mood: 'neutral', emoji: '😐'),
  ];
}