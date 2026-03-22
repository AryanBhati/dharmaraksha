import 'lawyer_review.dart';

class Lawyer {
  final String id;
  final String name;
  final String profilePhoto;
  final String firmId;
  final String specialization;
  final List<String> practiceAreas;
  final int experienceYears;
  final List<String> courtsPracticed;
  final List<String> languages;
  final double rating;
  final int reviewCount;
  final double consultationFeeChat;
  final double consultationFeeVoice;
  final double consultationFeeVideo;
  final bool availableNow;
  final String location;
  final int averageResponseMinutes;
  final String bio;
  final String recommendedLawyerType;
  final List<String> expertise;
  final List<LawyerReview> reviews;
  final String? introVideoUrl;
  final bool isFeatured;
  final bool hasFreeFirstMessage;
  final String status; // Online, Busy, Offline

  const Lawyer({
    required this.id,
    required this.name,
    required this.profilePhoto,
    required this.firmId,
    required this.specialization,
    required this.practiceAreas,
    required this.experienceYears,
    required this.courtsPracticed,
    required this.languages,
    required this.rating,
    required this.reviewCount,
    required this.consultationFeeChat,
    required this.consultationFeeVoice,
    required this.consultationFeeVideo,
    required this.availableNow,
    required this.location,
    required this.averageResponseMinutes,
    required this.bio,
    required this.recommendedLawyerType,
    required this.expertise,
    required this.status,
    this.isFeatured = false,
    this.hasFreeFirstMessage = false,
    this.introVideoUrl,
    this.reviews = const <LawyerReview>[],
  });

  int get reviewsCount => reviewCount;
  double get consultationFeePerMinute => consultationFeeChat;
  bool get isAvailable => availableNow;
  String get imageUrl => profilePhoto;

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'profilePhoto': profilePhoto,
      'firmId': firmId,
      'specialization': specialization,
      'practiceAreas': practiceAreas,
      'experienceYears': experienceYears,
      'courtsPracticed': courtsPracticed,
      'languages': languages,
      'rating': rating,
      'reviewCount': reviewCount,
      'consultationFeeChat': consultationFeeChat,
      'consultationFeeVoice': consultationFeeVoice,
      'consultationFeeVideo': consultationFeeVideo,
      'availableNow': availableNow,
      'location': location,
      'averageResponseMinutes': averageResponseMinutes,
      'bio': bio,
      'recommendedLawyerType': recommendedLawyerType,
      'expertise': expertise,
      'reviews':
          reviews.map((review) => review.toJson()).toList(growable: false),
    };
  }

  factory Lawyer.fromJson(Map<String, dynamic> json) {
    return Lawyer(
      id: json['id'] as String,
      name: json['name'] as String,
      profilePhoto: json['profilePhoto'] as String,
      firmId: json['firmId'] as String,
      specialization: json['specialization'] as String,
      practiceAreas: (json['practiceAreas'] as List<dynamic>)
          .map((dynamic item) => item as String)
          .toList(growable: false),
      experienceYears: (json['experienceYears'] as num).toInt(),
      courtsPracticed: (json['courtsPracticed'] as List<dynamic>)
          .map((dynamic item) => item as String)
          .toList(growable: false),
      languages: (json['languages'] as List<dynamic>)
          .map((dynamic item) => item as String)
          .toList(growable: false),
      rating: (json['rating'] as num).toDouble(),
      reviewCount: (json['reviewCount'] as num).toInt(),
      consultationFeeChat: (json['consultationFeeChat'] as num).toDouble(),
      consultationFeeVoice: (json['consultationFeeVoice'] as num).toDouble(),
      consultationFeeVideo: (json['consultationFeeVideo'] as num).toDouble(),
      availableNow: json['availableNow'] as bool,
      location: json['location'] as String,
      averageResponseMinutes: (json['averageResponseMinutes'] as num).toInt(),
      bio: json['bio'] as String,
      recommendedLawyerType: json['recommendedLawyerType'] as String,
      expertise: (json['expertise'] as List<dynamic>)
          .map((dynamic item) => item as String)
          .toList(growable: false),
      status: json['status'] as String? ?? 'Offline',
      isFeatured: json['isFeatured'] as bool? ?? false,
      hasFreeFirstMessage: json['hasFreeFirstMessage'] as bool? ?? false,
      introVideoUrl: json['introVideoUrl'] as String?,
      reviews: (json['reviews'] as List<dynamic>? ?? const <dynamic>[])
          .map((dynamic item) =>
              LawyerReview.fromJson(item as Map<String, dynamic>))
          .toList(growable: false),
    );
  }
}
