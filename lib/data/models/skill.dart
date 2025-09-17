class Skill {
  final int? id;
  final String name;
  final String level; // e.g. Beginner, Intermediate, Advanced
  int position;

  Skill({
    this.id,
    required this.name,
    required this.level,
    this.position = 0,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'level': level,
      'position': position,
    };
  }

  factory Skill.fromMap(Map<String, dynamic> map) {
    return Skill(
      id: map['id'] as int?,
      name: map['name'] as String,
      level: map['level'] as String,
      position: map['position'] as int? ?? 0,
    );
  }
}
