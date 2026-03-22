class PracticeArea {
  final String id;
  final String name;
  final String description;

  const PracticeArea({
    required this.id,
    required this.name,
    required this.description,
  });

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'description': description,
    };
  }

  factory PracticeArea.fromJson(Map<String, dynamic> json) {
    return PracticeArea(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
    );
  }
}
