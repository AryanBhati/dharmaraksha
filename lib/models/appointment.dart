class Appointment {
  final String id;
  final String clientId;
  final String lawyerId;
  final String lawyerName;
  final String lawyerImageUrl;
  final String specialization;
  final DateTime scheduledAt;
  final int durationMinutes;
  final String type; // Chat, Call, Video
  final String status; // Pending, Accepted, Completed, Cancelled

  const Appointment({
    required this.id,
    required this.clientId,
    required this.lawyerId,
    required this.lawyerName,
    required this.lawyerImageUrl,
    required this.specialization,
    required this.scheduledAt,
    required this.durationMinutes,
    required this.type,
    required this.status,
  });

  Appointment copyWith({String? status}) {
    return Appointment(
      id: id,
      clientId: clientId,
      lawyerId: lawyerId,
      lawyerName: lawyerName,
      lawyerImageUrl: lawyerImageUrl,
      specialization: specialization,
      scheduledAt: scheduledAt,
      durationMinutes: durationMinutes,
      type: type,
      status: status ?? this.status,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'clientId': clientId,
        'lawyerId': lawyerId,
        'lawyerName': lawyerName,
        'lawyerImageUrl': lawyerImageUrl,
        'specialization': specialization,
        'scheduledAt': scheduledAt.toIso8601String(),
        'durationMinutes': durationMinutes,
        'type': type,
        'status': status,
      };

  factory Appointment.fromJson(Map<String, dynamic> json) {
    return Appointment(
      id: json['id'] as String,
      clientId: json['clientId'] as String,
      lawyerId: json['lawyerId'] as String,
      lawyerName: json['lawyerName'] as String,
      lawyerImageUrl: json['lawyerImageUrl'] as String,
      specialization: json['specialization'] as String,
      scheduledAt: DateTime.parse(json['scheduledAt'] as String),
      durationMinutes: json['durationMinutes'] as int,
      type: json['type'] as String,
      status: json['status'] as String,
    );
  }
}
