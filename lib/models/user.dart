class AppUser {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String profilePhoto;
  final double walletBalance;
  final bool isVerified;
  final int consultationsCompleted;
  final List<String> savedLawyers;
  final List<String> uploadedDocuments;
  final DateTime createdAt;
  final DateTime? dateOfBirth;

  const AppUser({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.profilePhoto,
    required this.walletBalance,
    required this.isVerified,
    required this.consultationsCompleted,
    this.savedLawyers = const <String>[],
    this.uploadedDocuments = const <String>[],
    required this.createdAt,
    this.dateOfBirth,
  });

  AppUser copyWith({
    String? name,
    String? email,
    String? phone,
    String? profilePhoto,
    double? walletBalance,
    bool? isVerified,
    int? consultationsCompleted,
    List<String>? savedLawyers,
    List<String>? uploadedDocuments,
    DateTime? createdAt,
    DateTime? dateOfBirth,
    List<String>? savedLawyerIds,
    List<String>? savedDocumentIds,
  }) {
    return AppUser(
      id: id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      profilePhoto: profilePhoto ?? this.profilePhoto,
      walletBalance: walletBalance ?? this.walletBalance,
      isVerified: isVerified ?? this.isVerified,
      consultationsCompleted:
          consultationsCompleted ?? this.consultationsCompleted,
      savedLawyers: savedLawyers ?? savedLawyerIds ?? this.savedLawyers,
      uploadedDocuments:
          uploadedDocuments ?? savedDocumentIds ?? this.uploadedDocuments,
      createdAt: createdAt ?? this.createdAt,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
    );
  }

  int? get age {
    final dob = dateOfBirth;
    if (dob == null) return null;
    final now = DateTime.now();
    int a = now.year - dob.year;
    if (now.month < dob.month || 
        (now.month == dob.month && now.day < dob.day)) {
      a--;
    }
    return a;
  }

  String get profileImageUrl => profilePhoto;
  List<String> get savedLawyerIds => savedLawyers;
  List<String> get savedDocumentIds => uploadedDocuments;

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'profilePhoto': profilePhoto,
      'walletBalance': walletBalance,
      'consultationsCompleted': consultationsCompleted,
      'savedLawyers': savedLawyers,
      'uploadedDocuments': uploadedDocuments,
      'createdAt': createdAt.toIso8601String(),
      'dateOfBirth': dateOfBirth?.toIso8601String(),
      'isVerified': isVerified,
    };
  }

  factory AppUser.fromJson(Map<String, dynamic> json) {
    return AppUser(
      id: json['id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      phone: json['phone'] as String,
      profilePhoto: json['profilePhoto'] as String,
      walletBalance: (json['walletBalance'] as num?)?.toDouble() ?? 0,
      consultationsCompleted:
          (json['consultationsCompleted'] as num?)?.toInt() ?? 0,
      savedLawyers:
          (json['savedLawyers'] as List<dynamic>? ?? const <dynamic>[])
              .map((dynamic item) => item as String)
              .toList(growable: false),
      uploadedDocuments:
          (json['uploadedDocuments'] as List<dynamic>? ?? const <dynamic>[])
              .map((dynamic item) => item as String)
              .toList(growable: false),
      createdAt: DateTime.tryParse(json['createdAt'] as String? ?? '') ??
          DateTime.now(),
      dateOfBirth: json['dateOfBirth'] != null ? DateTime.tryParse(json['dateOfBirth'] as String) : null,
      isVerified: json['isVerified'] as bool? ?? false,
    );
  }
}
