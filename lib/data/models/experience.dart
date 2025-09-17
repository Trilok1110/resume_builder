class Experience {
  final int? id;
  final String job;
  final String company;
  final String duration;
  final String description;
  int position;

  Experience({
    this.id,
    required this.job,
    required this.company,
    required this.duration,
    required this.description,
    this.position = 0,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'job': job,
      'company': company,
      'duration': duration,
      'description': description,
      'position': position,
    };
  }

  factory Experience.fromMap(Map<String, dynamic> map) {
    return Experience(
      id: map['id'] as int?,
      job: map['job'] as String,
      company: map['company'] as String,
      duration: map['duration'] as String,
      description: map['description'] as String,
      position: map['position'] as int? ?? 0,
    );
  }
}
