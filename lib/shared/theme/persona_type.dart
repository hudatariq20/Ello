enum PersonaType {
  nova,
  zen,
  spark,
  sage,
}

extension PersonaTypeX on PersonaType {
  String get displayName {
    return switch (this) {
      PersonaType.nova => 'Nova',
      PersonaType.zen => 'Zen',
      PersonaType.spark => 'Spark',
      PersonaType.sage => 'Sage',
    };
  }
}