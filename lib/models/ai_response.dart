class AIResponse {
  final String problemUnderstanding;
  final List<String> applicableLaws;
  final List<String> legalPathwaySteps;
  final List<String> requiredDocuments;
  final String recommendedLawyerType;

  const AIResponse({
    required this.problemUnderstanding,
    required this.applicableLaws,
    required this.legalPathwaySteps,
    required this.requiredDocuments,
    required this.recommendedLawyerType,
  });

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'problemUnderstanding': problemUnderstanding,
      'applicableLaws': applicableLaws,
      'legalPathwaySteps': legalPathwaySteps,
      'requiredDocuments': requiredDocuments,
      'recommendedLawyerType': recommendedLawyerType,
    };
  }

  factory AIResponse.fromJson(Map<String, dynamic> json) {
    return AIResponse(
      problemUnderstanding: json['problemUnderstanding'] as String,
      applicableLaws: (json['applicableLaws'] as List<dynamic>)
          .map((dynamic item) => item as String)
          .toList(growable: false),
      legalPathwaySteps: (json['legalPathwaySteps'] as List<dynamic>)
          .map((dynamic item) => item as String)
          .toList(growable: false),
      requiredDocuments: (json['requiredDocuments'] as List<dynamic>)
          .map((dynamic item) => item as String)
          .toList(growable: false),
      recommendedLawyerType: json['recommendedLawyerType'] as String,
    );
  }
}
