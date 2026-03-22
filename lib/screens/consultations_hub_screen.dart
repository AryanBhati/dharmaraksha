import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../providers/consultation_provider.dart';
import '../services/mock_data.dart';
import '../theme/app_colors.dart';
import '../theme/app_theme.dart';
import '../utils/app_formatters.dart';
import '../utils/transitions.dart';
import '../widgets/app_scaffold.dart';
import 'call_screen.dart';
import 'chat_screen.dart';

class ConsultationsHubScreen extends StatefulWidget {
  const ConsultationsHubScreen({super.key});

  @override
  State<ConsultationsHubScreen> createState() => _ConsultationsHubScreenState();
}

class _ConsultationsHubScreenState extends State<ConsultationsHubScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'Consultations',
      body: Column(
        children: [
          Container(
            color: AppColors.background,
            child: TabBar(
              controller: _tabController,
              indicatorColor: AppColors.accent,
              indicatorWeight: 3,
              labelColor: AppColors.accent,
              unselectedLabelColor: AppColors.textSecondary,
              labelStyle: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 14),
              unselectedLabelStyle: GoogleFonts.outfit(fontWeight: FontWeight.w500, fontSize: 14),
              tabs: const [
                Tab(text: 'Active'),
                Tab(text: 'Booked'),
                Tab(text: 'History'),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _ActiveChatsTab(),
                _AppointmentsTab(),
                _PastConsultationsTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Active Chats ─────────────────────────────────────────────────────────────

class _ActiveChatsTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ConsultationProvider>();
    final chatIds = provider.activeChatLawyerIds;

    if (chatIds.isEmpty) {
      return const _EmptyState(
        icon: Icons.chat_bubble_outline_rounded,
        title: 'No active chats',
        subtitle: 'Start a consultation from the Find Lawyers tab.',
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: chatIds.length,
      itemBuilder: (context, index) {
        final lawyerId = chatIds[index];
        final lastMsg = provider.getLastMessage(lawyerId);
        final unread = provider.getUnreadCount(lawyerId);
        final lawyer = MockDataService.getLawyerById(lawyerId);
        final name = lawyer?.name ?? 'Lawyer';
        final imageUrl = lawyer?.imageUrl ?? 'https://i.pravatar.cc/150?u=$lawyerId';

        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(AppTheme.kCardBorderRadius),
            border: Border.all(color: AppColors.glassBorder),
          ),
          child: InkWell(
            onTap: () {
              if (lawyer != null) {
                Navigator.push(context, slideRoute(ChatScreen(lawyer: lawyer)));
              }
            },
            borderRadius: BorderRadius.circular(AppTheme.kCardBorderRadius),
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Row(
                children: [
                  Stack(
                    children: [
                      Container(
                        width: 52,
                        height: 52,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: AppColors.glassBorder, width: 2),
                        ),
                        clipBehavior: Clip.antiAlias,
                        child: Image.network(
                          imageUrl,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Container(
                            color: AppColors.primary10,
                            alignment: Alignment.center,
                            child: Text(
                              name[0],
                              style: GoogleFonts.philosopher(
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                                color: AppColors.accent,
                              ),
                            ),
                          ),
                        ),
                      ),
                      if (unread > 0)
                        Positioned(
                          right: -2,
                          top: -2,
                          child: Container(
                            padding: const EdgeInsets.all(5),
                            decoration: const BoxDecoration(
                              color: AppColors.accent,
                              shape: BoxShape.circle,
                            ),
                            child: Text(
                              '$unread',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          name,
                          style: GoogleFonts.philosopher(
                            fontWeight: FontWeight.w700,
                            fontSize: 16,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        if (lastMsg != null)
                          Text(
                            lastMsg.content,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.outfit(
                              fontSize: 13,
                              color: unread > 0 ? AppColors.textPrimary : AppColors.textSecondary,
                              fontWeight: unread > 0 ? FontWeight.w600 : FontWeight.normal,
                            ),
                          ),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      if (lastMsg != null)
                        Text(
                          _formatTime(lastMsg.timestamp),
                          style: GoogleFonts.outfit(
                            fontSize: 11,
                            color: AppColors.accent,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.accent.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          'Active',
                          style: GoogleFonts.outfit(
                            color: AppColors.accent,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  String _formatTime(DateTime dt) {
    final now = DateTime.now();
    final diff = now.difference(dt);
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    return DateFormat('MMM d').format(dt);
  }
}

// ─── Appointments ─────────────────────────────────────────────────────────────

class _AppointmentsTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ConsultationProvider>();
    final appointments = provider.upcomingAppointments;

    if (appointments.isEmpty) {
      return const _EmptyState(
        icon: Icons.calendar_today_rounded,
        title: 'No upcoming appointments',
        subtitle: 'Schedule a consultation from a lawyer\'s profile.',
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: appointments.length,
      itemBuilder: (context, index) {
        final apt = appointments[index];
        final isAccepted = apt.status == 'Accepted';

        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(AppTheme.kCardBorderRadius),
            border: Border.all(color: AppColors.glassBorder),
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Container(
                      width: 52,
                      height: 52,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.glassBorder, width: 2),
                      ),
                      clipBehavior: Clip.antiAlias,
                      child: Image.network(
                        apt.lawyerImageUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Container(
                          color: AppColors.primary10,
                          alignment: Alignment.center,
                          child: Text(
                            apt.lawyerName[0],
                            style: GoogleFonts.philosopher(
                                fontSize: 20, fontWeight: FontWeight.w700, color: AppColors.accent),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            apt.lawyerName,
                            style: GoogleFonts.philosopher(
                              fontWeight: FontWeight.w700,
                              fontSize: 16,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            apt.specialization,
                            style: GoogleFonts.outfit(
                              fontSize: 13,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    _StatusBadge(status: apt.status),
                  ],
                ),
              ),
              Container(height: 1, color: AppColors.glassBorder),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _InfoTag(icon: Icons.calendar_month_rounded, text: DateFormat('MMM d, yyyy').format(apt.scheduledAt)),
                        _InfoTag(icon: Icons.access_time_rounded, text: DateFormat('h:mm a').format(apt.scheduledAt)),
                        _InfoTag(icon: apt.type == 'Video' ? Icons.videocam_rounded : Icons.phone_rounded, text: apt.type),
                      ],
                    ),
                    if (isAccepted) ...[
                      const SizedBox(height: 16),
                      ElevatedButton.icon(
                        onPressed: () {
                          final lawyer = MockDataService.getLawyerById(apt.lawyerId);
                          if (lawyer != null) {
                            Navigator.push(context, slideRoute(CallScreen(lawyer: lawyer, isVideo: apt.type == 'Video')));
                          }
                        },
                        icon: const Icon(Icons.video_call_rounded, size: 20),
                        label: const Text('Join Consultation'),
                        style: ElevatedButton.styleFrom(minimumSize: const Size.fromHeight(48)),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final String status;
  const _StatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    Color color;
    switch (status) {
      case 'Accepted': color = AppColors.success; break;
      case 'Pending': color = AppColors.warning; break;
      case 'Completed': color = AppColors.accent; break;
      default: color = AppColors.error;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        status,
        style: GoogleFonts.outfit(
          color: color,
          fontSize: 11,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class _InfoTag extends StatelessWidget {
  final IconData icon;
  final String text;
  const _InfoTag({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 16, color: AppColors.accent),
        const SizedBox(width: 6),
        Text(
          text,
          style: GoogleFonts.outfit(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
      ],
    );
  }
}

// ─── Past Consultations ───────────────────────────────────────────────────────

class _PastConsultationsTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ConsultationProvider>();
    final past = provider.pastConsultations;

    if (past.isEmpty) {
      return const _EmptyState(
        icon: Icons.history_rounded,
        title: 'No history',
        subtitle: 'Your completed consultations will appear here.',
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: past.length,
      itemBuilder: (context, index) {
        final item = past[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(AppTheme.kCardBorderRadius),
            border: Border.all(color: AppColors.glassBorder),
          ),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              children: [
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.glassBorder, width: 2),
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: Image.network(
                    item.lawyerImageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      color: AppColors.primary10,
                      alignment: Alignment.center,
                      child: Text(
                        item.lawyerName[0],
                        style: GoogleFonts.philosopher(
                            fontSize: 20, fontWeight: FontWeight.w700, color: AppColors.accent),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.lawyerName,
                        style: GoogleFonts.philosopher(
                          fontWeight: FontWeight.w700,
                          fontSize: 16,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        item.summary,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.outfit(fontSize: 12, color: AppColors.textSecondary),
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          Icon(Icons.timer_outlined, size: 12, color: AppColors.accent),
                          const SizedBox(width: 4),
                          Text('${item.durationMinutes}m', style: GoogleFonts.outfit(fontSize: 11, fontWeight: FontWeight.bold)),
                          const SizedBox(width: 12),
                          Icon(Icons.payments_outlined, size: 12, color: AppColors.accent),
                          const SizedBox(width: 4),
                          Text(AppFormatters.inr(item.cost), style: GoogleFonts.outfit(fontSize: 11, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ],
                  ),
                ),
                Text(
                  DateFormat('MMM d').format(item.date),
                  style: GoogleFonts.outfit(fontSize: 11, color: AppColors.textSecondary, fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

// ─── Empty State ──────────────────────────────────────────────────────────────

class _EmptyState extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const _EmptyState({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(48),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: AppColors.accent.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.accent.withOpacity(0.2)),
              ),
              alignment: Alignment.center,
              child: Icon(icon, size: 40, color: AppColors.accent),
            ),
            const SizedBox(height: 24),
            Text(
              title,
              textAlign: TextAlign.center,
              style: GoogleFonts.philosopher(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                subtitle,
                textAlign: TextAlign.center,
                style: GoogleFonts.outfit(color: AppColors.textSecondary, fontSize: 14),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
