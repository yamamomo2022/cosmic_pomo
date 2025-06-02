class Duration {
  const Duration({required this.inSeconds});

  final int inSeconds;

  factory Duration.fromMinutes(int minutes) {
    return Duration(inSeconds: minutes * 60);
  }

  int get inMinutes => inSeconds ~/ 60;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Duration && other.inSeconds == inSeconds;
  }

  @override
  int get hashCode => inSeconds.hashCode;

  @override
  String toString() => 'Duration(${inSeconds}s)';
}
