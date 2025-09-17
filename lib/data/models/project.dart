class Project {
  final int? id;
  final String title;
  final String techStack;
  final String description;
  int position;

  Project({
    this.id,
    required this.title,
    required this.techStack,
    required this.description,
    this.position = 0,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'techStack': techStack,
      'description': description,
      'position': position,
    };
  }

  factory Project.fromMap(Map<String, dynamic> map) {
    return Project(
      id: map['id'] as int?,
      title: map['title'] as String,
      techStack: map['techStack'] as String,
      description: map['description'] as String,
      position: map['position'] as int? ?? 0,
    );
  }
}
