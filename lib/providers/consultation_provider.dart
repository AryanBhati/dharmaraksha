import 'package:flutter/material.dart';

import '../models/appointment.dart';
import '../models/chat_message.dart';

/// Tracks active consultations, scheduled appointments, and past history.
class ConsultationProvider extends ChangeNotifier {
  // Mock active chats (lawyer ID → messages)
  final Map<String, List<ChatMessage>> _activeChats = {};
  final List<Appointment> _appointments = [];
  final List<PastConsultation> _pastConsultations = [];

  List<String> get activeChatLawyerIds => _activeChats.keys.toList();
  Map<String, List<ChatMessage>> get activeChats => _activeChats;
  List<Appointment> get appointments => _appointments;
  List<Appointment> get upcomingAppointments =>
      _appointments.where((a) => a.status == 'Accepted' || a.status == 'Pending').toList();
  List<PastConsultation> get pastConsultations => _pastConsultations;

  ConsultationProvider() {
    _loadMockData();
  }

  void _loadMockData() {
    final now = DateTime.now();

    // Mock active chats
    _activeChats['lawyer_1'] = [
      ChatMessage(
        id: 'msg1',
        senderId: 'user_1',
        receiverId: 'lawyer_1',
        content: 'Hello, I need help with a tenancy dispute.',
        type: 'text',
        timestamp: now.subtract(const Duration(minutes: 10)),
      ),
      ChatMessage(
        id: 'msg2',
        senderId: 'lawyer_1',
        receiverId: 'user_1',
        content: 'Sure! Can you share the rental agreement?',
        type: 'text',
        timestamp: now.subtract(const Duration(minutes: 8)),
        isRead: true,
      ),
    ];

    _activeChats['lawyer_3'] = [
      ChatMessage(
        id: 'msg3',
        senderId: 'user_1',
        receiverId: 'lawyer_3',
        content: 'Hi, I received a legal notice for a cheque bounce. What should I do?',
        type: 'text',
        timestamp: now.subtract(const Duration(hours: 2)),
      ),
    ];

    // Mock appointments
    _appointments.addAll([
      Appointment(
        id: 'apt1',
        clientId: 'user_1',
        lawyerId: 'lawyer_2',
        lawyerName: 'Adv. Priya Sharma',
        lawyerImageUrl: 'https://i.pravatar.cc/150?u=priya',
        specialization: 'Family Law',
        scheduledAt: now.add(const Duration(days: 1, hours: 2)),
        durationMinutes: 30,
        type: 'Video',
        status: 'Accepted',
      ),
      Appointment(
        id: 'apt2',
        clientId: 'user_1',
        lawyerId: 'lawyer_5',
        lawyerName: 'Adv. Rajesh Mehta',
        lawyerImageUrl: 'https://i.pravatar.cc/150?u=rajesh',
        specialization: 'Corporate Law',
        scheduledAt: now.add(const Duration(days: 3, hours: 4)),
        durationMinutes: 45,
        type: 'Call',
        status: 'Pending',
      ),
    ]);

    // Mock past consultations
    _pastConsultations.addAll([
      PastConsultation(
        lawyerName: 'Adv. Karan Singh',
        lawyerImageUrl: 'https://i.pravatar.cc/150?u=karan',
        type: 'Chat',
        durationMinutes: 22,
        cost: 330.0,
        date: now.subtract(const Duration(days: 3)),
        summary: 'Discussed tenant rights under the Rent Control Act.',
      ),
      PastConsultation(
        lawyerName: 'Adv. Anita Desai',
        lawyerImageUrl: 'https://i.pravatar.cc/150?u=anita',
        type: 'Video',
        durationMinutes: 15,
        cost: 525.0,
        date: now.subtract(const Duration(days: 7)),
        summary: 'Reviewed employment termination letter and discussed options.',
      ),
    ]);
  }

  void sendMessage(String lawyerId, ChatMessage message) {
    _activeChats.putIfAbsent(lawyerId, () => []);
    _activeChats[lawyerId]!.add(message);
    notifyListeners();
  }

  void bookAppointment(Appointment appointment) {
    _appointments.add(appointment);
    notifyListeners();
  }

  void updateAppointmentStatus(String appointmentId, String status) {
    final index = _appointments.indexWhere((a) => a.id == appointmentId);
    if (index != -1) {
      _appointments[index] = _appointments[index].copyWith(status: status);
      notifyListeners();
    }
  }

  ChatMessage? getLastMessage(String lawyerId) {
    final messages = _activeChats[lawyerId];
    if (messages != null && messages.isNotEmpty) {
      return messages.last;
    }
    return null;
  }

  int getUnreadCount(String lawyerId) {
    final messages = _activeChats[lawyerId];
    if (messages == null) return 0;
    return messages.where((m) => !m.isRead && m.senderId == lawyerId).length;
  }
}

class PastConsultation {
  final String lawyerName;
  final String lawyerImageUrl;
  final String type;
  final int durationMinutes;
  final double cost;
  final DateTime date;
  final String summary;

  const PastConsultation({
    required this.lawyerName,
    required this.lawyerImageUrl,
    required this.type,
    required this.durationMinutes,
    required this.cost,
    required this.date,
    required this.summary,
  });
}
