class Education {
  final int? id;
  final String degree;
  final String school;
  final String year;
  int position;

  Education({
    this.id,
    required this.degree,
    required this.school,
    required this.year,
    this.position = 0,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'degree': degree,
      'school': school,
      'year': year,
      'position': position,
    };
  }

  factory Education.fromMap(Map<String, dynamic> map) {
    return Education(
      id: map['id'] as int?,
      degree: map['degree'] as String,
      school: map['school'] as String,
      year: map['year'] as String,
      position: map['position'] as int? ?? 0,
    );
  }
}