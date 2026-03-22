import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../models/appointment.dart';
import '../models/lawyer.dart';
import '../providers/consultation_provider.dart';
import '../theme/app_colors.dart';
import '../theme/app_theme.dart';
import '../widgets/app_scaffold.dart';

class BookAppointmentScreen extends StatefulWidget {
  final Lawyer lawyer;

  const BookAppointmentScreen({super.key, required this.lawyer});

  @override
  State<BookAppointmentScreen> createState() => _BookAppointmentScreenState();
}

class _BookAppointmentScreenState extends State<BookAppointmentScreen> {
  DateTime _selectedDate = DateTime.now().add(const Duration(days: 1));
  int _selectedSlotIndex = -1;
  String _selectedType = 'Video';
  bool _isBooking = false;

  // Mock available time slots
  List<String> get _timeSlots {
    final slots = <String>[];
    for (int h = 9; h <= 18; h++) {
      slots.add('${h.toString().padLeft(2, '0')}:00');
      if (h < 18) slots.add('${h.toString().padLeft(2, '0')}:30');
    }
    return slots;
  }

  bool _isSlotAvailable(int index) {
    final seed = _selectedDate.day + index;
    return seed % 4 != 0;
  }

  void _book() async {
    if (_selectedSlotIndex < 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a time slot')),
      );
      return;
    }

    setState(() => _isBooking = true);
    await Future.delayed(const Duration(milliseconds: 800));

    final timeParts = _timeSlots[_selectedSlotIndex].split(':');
    final scheduledAt = DateTime(
      _selectedDate.year,
      _selectedDate.month,
      _selectedDate.day,
      int.parse(timeParts[0]),
      int.parse(timeParts[1]),
    );

    if (!mounted) return;

    final apt = Appointment(
      id: 'apt_${DateTime.now().millisecondsSinceEpoch}',
      clientId: 'user_1',
      lawyerId: widget.lawyer.id,
      lawyerName: widget.lawyer.name,
      lawyerImageUrl: widget.lawyer.imageUrl,
      specialization: widget.lawyer.specialization,
      scheduledAt: scheduledAt,
      durationMinutes: 30,
      type: _selectedType,
      status: 'Pending',
    );

    context.read<ConsultationProvider>().bookAppointment(apt);

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppTheme.kCardBorderRadius)),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.success.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.check_circle_rounded, color: AppColors.success),
            ),
            const SizedBox(width: 12),
            Text('Booked!', style: GoogleFonts.philosopher(fontWeight: FontWeight.bold)),
          ],
        ),
        content: Text(
          'Your ${_selectedType.toLowerCase()} appointment with ${widget.lawyer.name} is confirmed for ${DateFormat('MMM d, yyyy \'at\' h:mm a').format(scheduledAt)}.',
          style: GoogleFonts.outfit(),
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context); // dialog
              Navigator.pop(context); // booking screen
            },
            child: const Text('Done'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'Schedule Appointment',
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Lawyer summary card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(AppTheme.kCardBorderRadius),
                border: Border.all(color: AppColors.glassBorder),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 32,
                    backgroundImage: NetworkImage(widget.lawyer.imageUrl),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.lawyer.name,
                          style: GoogleFonts.philosopher(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        Text(
                          widget.lawyer.specialization,
                          style: GoogleFonts.outfit(
                            color: AppColors.textSecondary,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.accent.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.star_rounded, color: AppColors.accent, size: 16),
                        const SizedBox(width: 4),
                        Text(
                          '${widget.lawyer.rating}',
                          style: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 13),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // Consultation type
            Text(
              'Consultation Type',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 16),
            Row(
              children: ['Chat', 'Call', 'Video'].map((type) {
                final selected = _selectedType == type;
                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: GestureDetector(
                      onTap: () => setState(() => _selectedType = type),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        decoration: BoxDecoration(
                          color: selected ? AppColors.accent : AppColors.glassColor,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: selected ? AppColors.accent : AppColors.glassBorder,
                          ),
                        ),
                        child: Column(
                          children: [
                            Icon(
                              type == 'Chat'
                                  ? Icons.chat_bubble_outline_rounded
                                  : type == 'Call'
                                      ? Icons.phone_outlined
                                      : Icons.videocam_outlined,
                              color: selected ? Colors.white : AppColors.textSecondary,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              type,
                              style: GoogleFonts.outfit(
                                color: selected ? Colors.white : AppColors.textSecondary,
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 32),

            // Calendar
            Text(
              'Select Date',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 90,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: 14,
                itemBuilder: (context, index) {
                  final date = DateTime.now().add(Duration(days: index + 1));
                  final isSelected = _selectedDate.year == date.year &&
                      _selectedDate.month == date.month &&
                      _selectedDate.day == date.day;

                  return GestureDetector(
                    onTap: () => setState(() {
                      _selectedDate = date;
                      _selectedSlotIndex = -1;
                    }),
                    child: Container(
                      width: 64,
                      margin: const EdgeInsets.only(right: 12),
                      decoration: BoxDecoration(
                        color: isSelected ? AppColors.accent : AppColors.glassColor,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: isSelected ? AppColors.accent : AppColors.glassBorder,
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            DateFormat('EEE').format(date),
                            style: GoogleFonts.outfit(
                              fontSize: 12,
                              color: isSelected ? Colors.white70 : AppColors.textSecondary,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${date.day}',
                            style: GoogleFonts.outfit(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: isSelected ? Colors.white : AppColors.textPrimary,
                            ),
                          ),
                          Text(
                            DateFormat('MMM').format(date),
                            style: GoogleFonts.outfit(
                              fontSize: 11,
                              color: isSelected ? Colors.white70 : AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 32),

            // Time slots
            Text(
              'Available Slots',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: List.generate(_timeSlots.length, (index) {
                final available = _isSlotAvailable(index);
                final selected = _selectedSlotIndex == index;

                return GestureDetector(
                  onTap: available ? () => setState(() => _selectedSlotIndex = index) : null,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                    decoration: BoxDecoration(
                      color: !available
                          ? AppColors.textSecondary.withOpacity(0.05)
                          : selected
                              ? AppColors.accent
                              : AppColors.glassColor,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: selected
                            ? AppColors.accent
                            : (available ? AppColors.glassBorder : Colors.transparent),
                      ),
                    ),
                    child: Text(
                      _timeSlots[index],
                      style: GoogleFonts.outfit(
                        color: !available
                            ? AppColors.textSecondary.withOpacity(0.4)
                            : selected
                                ? Colors.white
                                : AppColors.textPrimary,
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                  ),
                );
              }),
            ),
            const SizedBox(height: 48),

            // Book button
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: _isBooking ? null : _book,
                child: _isBooking
                    ? const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.5,
                          color: Colors.white,
                        ),
                      )
                    : const Text('Confirm Booking'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
