/// Represents the position of a planet
class PlanetPosition {
  const PlanetPosition({
    required this.x,
    required this.y,
    required this.radius,
  });

  final double x;
  final double y;
  final double radius;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is PlanetPosition &&
        other.x == x &&
        other.y == y &&
        other.radius == radius;
  }

  @override
  int get hashCode => Object.hash(x, y, radius);

  @override
  String toString() => 'PlanetPosition(x: $x, y: $y, radius: $radius)';
}
