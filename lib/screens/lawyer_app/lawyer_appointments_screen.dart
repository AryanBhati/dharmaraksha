import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../../theme/app_colors.dart';

class LawyerAppointmentsScreen extends StatefulWidget {
  const LawyerAppointmentsScreen({super.key});

  @override
  State<LawyerAppointmentsScreen> createState() => _LawyerAppointmentsScreenState();
}

class _LawyerAppointmentsScreenState extends State<LawyerAppointmentsScreen> {
  bool _isCalendarView = false;

  // Mock appointment data
  final _appointments = [
    _MockApt(client: 'Arjun Mehta', type: 'Video', status: 'Pending',
        time: DateTime.now().add(const Duration(hours: 4)), topic: 'Employment dispute'),
    _MockApt(client: 'Priya Nair', type: 'Call', status: 'Accepted',
        time: DateTime.now().add(const Duration(days: 1, hours: 2)), topic: 'Property agreement'),
    _MockApt(client: 'Rohan Gupta', type: 'Chat', status: 'Completed',
        time: DateTime.now().subtract(const Duration(days: 1)), topic: 'Consumer complaint'),
    _MockApt(client: 'Sneha Kapoor', type: 'Video', status: 'Cancelled',
        time: DateTime.now().subtract(const Duration(days: 2)), topic: 'Divorce consultation'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Appointments', style: GoogleFonts.philosopher(fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            onPressed: () => setState(() => _isCalendarView = !_isCalendarView),
            icon: Icon(_isCalendarView ? Icons.list_rounded : Icons.calendar_month_rounded),
          ),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _appointments.length,
        itemBuilder: (context, index) {
          final apt = _appointments[index];
          return _AppointmentCard(
            apt: apt,
            onAccept: apt.status == 'Pending' ? () => setState(() => apt.status = 'Accepted') : null,
            onReject: apt.status == 'Pending' ? () => setState(() => apt.status = 'Cancelled') : null,
          );
        },
      ),
    );
  }
}

class _MockApt {
  final String client;
  final String type;
  String status;
  final DateTime time;
  final String topic;

  _MockApt({
    required this.client,
    required this.type,
    required this.status,
    required this.time,
    required this.topic,
  });
}

class _AppointmentCard extends StatelessWidget {
  final _MockApt apt;
  final VoidCallback? onAccept;
  final VoidCallback? onReject;

  const _AppointmentCard({
    required this.apt,
    this.onAccept,
    this.onReject,
  });

  Color get _statusColor {
    switch (apt.status) {
      case 'Accepted': return AppColors.success;
      case 'Pending': return AppColors.warning;
      case 'Completed': return AppColors.primary;
      default: return AppColors.error;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 14),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: AppColors.primary.withValues(alpha: 0.1),
                  child: Text(
                    apt.client[0],
                    style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.primary),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(apt.client, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                      Text(apt.topic, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: _statusColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    apt.status,
                    style: TextStyle(
                      color: _statusColor,
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                _Pill(icon: Icons.calendar_today_rounded, text: DateFormat('MMM d').format(apt.time)),
                const SizedBox(width: 8),
                _Pill(icon: Icons.access_time_rounded, text: DateFormat('h:mm a').format(apt.time)),
                const SizedBox(width: 8),
                _Pill(
                  icon: apt.type == 'Video' ? Icons.videocam_rounded :
                        apt.type == 'Call' ? Icons.phone_rounded : Icons.chat_rounded,
                  text: apt.type,
                ),
              ],
            ),
            if (onAccept != null || onReject != null) ...[
              const SizedBox(height: 14),
              Row(
                children: [
                  if (onAccept != null)
                    Expanded(
                      child: ElevatedButton(
                        onPressed: onAccept,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.success,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        child: const Text('Accept'),
                      ),
                    ),
                  if (onAccept != null && onReject != null) const SizedBox(width: 10),
                  if (onReject != null)
                    Expanded(
                      child: OutlinedButton(
                        onPressed: onReject,
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.error,
                          side: const BorderSide(color: AppColors.error),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        child: const Text('Reject'),
                      ),
                    ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _Pill extends StatelessWidget {
  final IconData icon;
  final String text;
  const _Pill({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: AppColors.textSecondary),
          const SizedBox(width: 4),
          Text(text, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}
