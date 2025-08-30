// lib/models/mood.dart

class Mood {
  final String emoji;
  final String label;
  final int intensity; // scale 1–5

  const Mood({
    required this.emoji,
    required this.label,
    this.intensity = 3,
  });

  Map<String, dynamic> toMap() => {
        'emoji': emoji,
        'label': label,
        'intensity': intensity,
      };

  factory Mood.fromMap(Map<String, dynamic> map) => Mood(
        emoji: map['emoji'],
        label: map['label'],
        intensity: map['intensity'] ?? 3,
      );
}

// You can access this list anywhere by importing mood.dart
const List<Mood> moodOptions = [
  Mood(emoji: '😌', label: 'Calm', intensity: 1),
  Mood(emoji: '😞', label: 'Sad', intensity: 4),
  Mood(emoji: '😡', label: 'Angry', intensity: 5),
  Mood(emoji: '😢', label: 'Crying', intensity: 4),
  Mood(emoji: '🥱', label: 'Tired', intensity: 2),
];
