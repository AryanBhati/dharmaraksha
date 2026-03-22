class Consultation {
  final String id;
  final String userId;
  final String lawyerId;
  final String type;
  final int durationMinutes;
  final double cost;
  final String status;
  final DateTime createdAt;

  const Consultation({
    required this.id,
    required this.userId,
    required this.lawyerId,
    required this.type,
    required this.durationMinutes,
    required this.cost,
    required this.status,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'userId': userId,
      'lawyerId': lawyerId,
      'type': type,
      'durationMinutes': durationMinutes,
      'cost': cost,
      'status': status,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory Consultation.fromJson(Map<String, dynamic> json) {
    return Consultation(
      id: json['id'] as String,
      userId: json['userId'] as String,
      lawyerId: json['lawyerId'] as String,
      type: json['type'] as String,
      durationMinutes: (json['durationMinutes'] as num).toInt(),
      cost: (json['cost'] as num).toDouble(),
      status: json['status'] as String,
      createdAt: DateTime.tryParse(json['createdAt'] as String? ?? '') ??
          DateTime.now(),
    );
  }
}
