class LawyerReview {
  final String id;
  final String lawyerId;
  final String userId;
  final String reviewerName;
  final double rating;
  final String comment;
  final DateTime createdAt;

  const LawyerReview({
    required this.id,
    required this.lawyerId,
    required this.userId,
    required this.reviewerName,
    required this.rating,
    required this.comment,
    required this.createdAt,
  });

  String get dateLabel {
    final now = DateTime.now();
    final difference = now.difference(createdAt);
    if (difference.inDays >= 30) {
      final months = (difference.inDays / 30).floor();
      return months == 1 ? '1 month ago' : '$months months ago';
    }
    if (difference.inDays > 0) {
      return difference.inDays == 1
          ? '1 day ago'
          : '${difference.inDays} days ago';
    }
    if (difference.inHours > 0) {
      return difference.inHours == 1
          ? '1 hour ago'
          : '${difference.inHours} hours ago';
    }
    return 'Just now';
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'lawyerId': lawyerId,
      'userId': userId,
      'reviewerName': reviewerName,
      'rating': rating,
      'comment': comment,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory LawyerReview.fromJson(Map<String, dynamic> json) {
    return LawyerReview(
      id: json['id'] as String,
      lawyerId: json['lawyerId'] as String,
      userId: json['userId'] as String,
      reviewerName: json['reviewerName'] as String,
      rating: (json['rating'] as num).toDouble(),
      comment: json['comment'] as String,
      createdAt: DateTime.tryParse(json['createdAt'] as String? ?? '') ??
          DateTime.now(),
    );
  }
}
