import 'ai_response.dart';

class LegalGuidance {
  final String id;
  final String problemTitle;
  final String explanation;
  final List<String> applicableLaws;
  final List<String> pathwaySteps;
  final List<String> requiredDocuments;
  final String recommendedLawyerType;
  final List<String> keywords;

  const LegalGuidance({
    required this.id,
    required this.problemTitle,
    required this.explanation,
    required this.applicableLaws,
    required this.pathwaySteps,
    required this.requiredDocuments,
    required this.recommendedLawyerType,
    this.keywords = const <String>[],
  });

  AIResponse toAIResponse() {
    return AIResponse(
      problemUnderstanding: explanation,
      applicableLaws: applicableLaws,
      legalPathwaySteps: pathwaySteps,
      requiredDocuments: requiredDocuments,
      recommendedLawyerType: recommendedLawyerType,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'problemTitle': problemTitle,
      'explanation': explanation,
      'applicableLaws': applicableLaws,
      'pathwaySteps': pathwaySteps,
      'requiredDocuments': requiredDocuments,
      'recommendedLawyerType': recommendedLawyerType,
      'keywords': keywords,
    };
  }

  factory LegalGuidance.fromJson(Map<String, dynamic> json) {
    return LegalGuidance(
      id: json['id'] as String,
      problemTitle: json['problemTitle'] as String,
      explanation: json['explanation'] as String,
      applicableLaws: (json['applicableLaws'] as List<dynamic>)
          .map((dynamic item) => item as String)
          .toList(growable: false),
      pathwaySteps: (json['pathwaySteps'] as List<dynamic>)
          .map((dynamic item) => item as String)
          .toList(growable: false),
      requiredDocuments: (json['requiredDocuments'] as List<dynamic>)
          .map((dynamic item) => item as String)
          .toList(growable: false),
      recommendedLawyerType: json['recommendedLawyerType'] as String,
      keywords: (json['keywords'] as List<dynamic>? ?? const <dynamic>[])
          .map((dynamic item) => item as String)
          .toList(growable: false),
    );
  }
}
