class LawFirm {
  final String id;
  final String name;
  final String logo;
  final String description;
  final String city;
  final String address;
  final int foundedYear;
  final int totalLawyers;
  final List<String> practiceAreas;

  const LawFirm({
    required this.id,
    required this.name,
    required this.logo,
    required this.description,
    required this.city,
    required this.address,
    required this.foundedYear,
    required this.totalLawyers,
    required this.practiceAreas,
  });

  String get logoPlaceholder {
    final words = name
        .split(' ')
        .where((word) => word.trim().isNotEmpty)
        .take(3)
        .toList(growable: false);
    if (words.isEmpty) {
      return 'LF';
    }
    return words.map((word) => word[0].toUpperCase()).join();
  }

  int get numberOfLawyers => totalLawyers;
  String get officeAddress => address;
  String get imageUrl => logo;

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'logo': logo,
      'description': description,
      'city': city,
      'address': address,
      'foundedYear': foundedYear,
      'totalLawyers': totalLawyers,
      'practiceAreas': practiceAreas,
    };
  }

  factory LawFirm.fromJson(Map<String, dynamic> json) {
    return LawFirm(
      id: json['id'] as String,
      name: json['name'] as String,
      logo: json['logo'] as String,
      description: json['description'] as String,
      city: json['city'] as String,
      address: json['address'] as String,
      foundedYear: (json['foundedYear'] as num).toInt(),
      totalLawyers: (json['totalLawyers'] as num).toInt(),
      practiceAreas: (json['practiceAreas'] as List<dynamic>)
          .map((dynamic item) => item as String)
          .toList(growable: false),
    );
  }
}
