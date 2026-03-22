class LegalBook {
  final String id;
  final String title;
  final String category;
  final String author;
  final int year;
  final String description;
  final List<String> chapters;

  const LegalBook({
    required this.id,
    required this.title,
    required this.category,
    required this.author,
    required this.year,
    required this.description,
    required this.chapters,
  });

  String get content => chapters.join('\n\n');

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'title': title,
      'category': category,
      'author': author,
      'year': year,
      'description': description,
      'chapters': chapters,
    };
  }

  factory LegalBook.fromJson(Map<String, dynamic> json) {
    return LegalBook(
      id: json['id'] as String,
      title: json['title'] as String,
      category: json['category'] as String,
      author: json['author'] as String,
      year: (json['year'] as num).toInt(),
      description: json['description'] as String,
      chapters: (json['chapters'] as List<dynamic>)
          .map((dynamic item) => item as String)
          .toList(growable: false),
    );
  }
}
