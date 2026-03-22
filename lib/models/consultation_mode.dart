import 'package:flutter/material.dart';

enum ConsultationMode { chat, voice, video }

extension ConsultationModeX on ConsultationMode {
  String get label {
    switch (this) {
      case ConsultationMode.chat:
        return 'Chat';
      case ConsultationMode.voice:
        return 'Voice';
      case ConsultationMode.video:
        return 'Video';
    }
  }

  IconData get icon {
    switch (this) {
      case ConsultationMode.chat:
        return Icons.chat_outlined;
      case ConsultationMode.voice:
        return Icons.call_outlined;
      case ConsultationMode.video:
        return Icons.videocam_outlined;
    }
  }

  double feeMultiplier() {
    switch (this) {
      case ConsultationMode.chat:
        return 1;
      case ConsultationMode.voice:
        return 1.2;
      case ConsultationMode.video:
        return 1.4;
    }
  }

  String get subtitle {
    switch (this) {
      case ConsultationMode.chat:
        return 'Best for quick legal clarifications';
      case ConsultationMode.voice:
        return 'For detailed spoken guidance';
      case ConsultationMode.video:
        return 'For face-to-face legal discussion';
    }
  }
}
