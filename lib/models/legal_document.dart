class LegalDocument {
  final String id;
  final String userId;
  final String name;
  final String type;
  final DateTime uploadDate;
  final String? relatedConsultationId;

  const LegalDocument({
    required this.id,
    required this.userId,
    required this.name,
    required this.type,
    required this.uploadDate,
    this.relatedConsultationId,
  });

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'userId': userId,
      'name': name,
      'type': type,
      'uploadDate': uploadDate.toIso8601String(),
      'relatedConsultationId': relatedConsultationId,
    };
  }

  factory LegalDocument.fromJson(Map<String, dynamic> json) {
    return LegalDocument(
      id: json['id'] as String,
      userId: json['userId'] as String,
      name: json['name'] as String,
      type: json['type'] as String,
      uploadDate: DateTime.tryParse(json['uploadDate'] as String? ?? '') ??
          DateTime.now(),
      relatedConsultationId: json['relatedConsultationId'] as String?,
    );
  }
}
