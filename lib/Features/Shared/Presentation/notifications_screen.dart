import 'package:flutter/material.dart';
import 'package:nurse_app/l10n/app_localizations.dart';
import 'package:nurse_app/Core/models/notification_model.dart';
import 'package:nurse_app/Core/theme/api/api_service.dart';
import 'package:nurse_app/Core/theme/app_colors.dart';
import 'package:nurse_app/Features/Patients/Presentation/patient_appointment_details_screen.dart';
import 'package:nurse_app/Features/Nurse/Presentation/nurse_appointment_details_screen.dart';


enum NotificationAudience { patient, nurse }

class NotificationsScreen extends StatefulWidget {
  final NotificationAudience audience;
  final void Function(NotificationModel notification)? onNotificationTap;

  const NotificationsScreen({
    super.key,
    required this.audience,
    this.onNotificationTap,
  });

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  List<NotificationModel> _notifications = [];
  bool _isLoading = true;
  bool _isMarkingAll = false;

  String get _screenTitle =>
      widget.audience == NotificationAudience.nurse
          ? AppLocalizations.of(context)!.notificationsNurseTitle
          : AppLocalizations.of(context)!.notificationsTitle;

  @override
  void initState() {
    super.initState();
    _loadNotifications();
  }

  Future<void> _loadNotifications() async {
    try {
      final data = await ApiService.getNotifications();

      if (!mounted) return;

      setState(() {
        _notifications = data;
        _isLoading = false;
      });
    } catch (_) {
      if (!mounted) return;

      setState(() {
        _notifications = [];
        _isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)!.notificationsLoadFailed),
        ),
      );
    }
  }

  Future<void> _markOneAsRead(NotificationModel notification) async {
    if (notification.isRead) return;

    try {
      await ApiService.markNotificationAsRead(notification.id);

      if (!mounted) return;

      setState(() {
        _notifications = _notifications.map((item) {
          if (item.id == notification.id) {
            return NotificationModel(
              id: item.id,
              title: item.title,
              message: item.message,
              type: item.type,
              bookingId: item.bookingId,
              isRead: true,
              createdAt: item.createdAt,
              targetScreen: item.targetScreen,
            );
          }
          return item;
        }).toList();
      });
    } catch (_) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            AppLocalizations.of(context)!.notificationsMarkOneFailed,
          ),
        ),
      );
    }
  }

  Future<void> _markAllAsRead() async {
    if (_isMarkingAll || _notifications.every((n) => n.isRead)) return;

    setState(() => _isMarkingAll = true);

    try {
      await ApiService.markAllNotificationsAsRead();

      if (!mounted) return;

      setState(() {
        _notifications = _notifications.map((item) {
          return NotificationModel(
            id: item.id,
            title: item.title,
            message: item.message,
            type: item.type,
            bookingId: item.bookingId,
            isRead: true,
            createdAt: item.createdAt,
            targetScreen: item.targetScreen,
          );
        }).toList();
      });
    } catch (_) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            AppLocalizations.of(context)!.notificationsMarkAllFailed,
          ),
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _isMarkingAll = false);
      }
    }
  }

  Future<void> _handleNotificationTap(NotificationModel notification) async {
    await _markOneAsRead(notification);

    if (!mounted) return;

    if (widget.onNotificationTap != null) {
      widget.onNotificationTap!(notification);
      return;
    }

    final target = notification.targetScreen?.trim();

    if (target == null || target.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            AppLocalizations.of(context)!.notificationsNoLinkedScreen,
          ),
        ),
      );
      return;
    }

    switch (target) {
      case 'RequestDetails':
        if (notification.bookingId != null) {
          Navigator.pushNamed(
            context,
            '/nurse-request-details',
            arguments: notification.bookingId,
          );
        } else {
          Navigator.pushNamed(context, '/nurse-requests');
        }
        break;

case 'AppointmentDetails':
  if (notification.bookingId == null) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(AppLocalizations.of(context)!.notificationsNoBookingLinked),
      ),
    );
    return;
  }

  try {
    if (widget.audience == NotificationAudience.nurse) {
      final appointment = await ApiService.getNurseAppointmentDetails(
        bookingId: notification.bookingId.toString(),
      );

      if (!mounted) return;

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => NurseAppointmentDetailsScreen(
            appointment: appointment,
          ),
        ),
      );
    } else {
      final appointment = await ApiService.getPatientAppointmentDetails(
        bookingId: notification.bookingId.toString(),
      );

      if (!mounted) return;

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => PatientAppointmentDetailsScreen(
            appointment: appointment,
          ),
        ),
      );
    }
  } catch (_) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          AppLocalizations.of(context)!.notificationsOpenDetailsFailed,
        ),
      ),
    );
  }
  break;

      default:
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              AppLocalizations.of(context)!.notificationsUnhandledTarget(target),
            ),
          ),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final unreadCount = _notifications.where((n) => !n.isRead).length;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
        title: Text(
          _screenTitle,
          style: const TextStyle(
            fontWeight: FontWeight.w800,
            color: Colors.white,
          ),
        ),
        actions: [
          if (_notifications.isNotEmpty)
            TextButton(
              onPressed: _isMarkingAll ? null : _markAllAsRead,
              child: _isMarkingAll
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : Text(
                      l10n.notificationsReadAll,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
            ),
        ],
      ),
      body: Column(
        children: [
          if (!_isLoading && _notifications.isNotEmpty)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 10),
              child: Text(
                unreadCount > 0
                    ? l10n.notificationsUnreadCount(unreadCount)
                    : l10n.notificationsAllRead,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF6B7280),
                ),
              ),
            ),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _notifications.isEmpty
                    ? RefreshIndicator(
                        onRefresh: _loadNotifications,
                        child: ListView(
                          physics: const AlwaysScrollableScrollPhysics(),
                          children: [
                            SizedBox(height: 140),
                            Center(
                              child: Text(
                                l10n.notificationsEmpty,
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xFF6B7280),
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    : RefreshIndicator(
                        onRefresh: _loadNotifications,
                        child: ListView.separated(
                          padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                          itemCount: _notifications.length,
                          separatorBuilder: (_, __) => const SizedBox(height: 12),
                          itemBuilder: (context, index) {
                            final item = _notifications[index];
                            return _NotificationCard(
                              title: item.title,
                              description: item.message,
                              timeLabel: _timeAgo(item.createdAt, l10n),
                              icon: _iconForType(item.type),
                              accentColor: _colorForType(item.type),
                              unread: !item.isRead,
                              onTap: () => _handleNotificationTap(item),
                              onMarkAsRead: !item.isRead
                                  ? () => _markOneAsRead(item)
                                  : null,
                            );
                          },
                        ),
                      ),
          ),
        ],
      ),
    );
  }

  IconData _iconForType(String type) {
    switch (type.toLowerCase()) {
      case 'request':
        return Icons.assignment_outlined;
      case 'payment':
        return Icons.payments_outlined;
      case 'booking':
        return Icons.calendar_today_outlined;
      case 'account':
        return Icons.verified_user_outlined;
      default:
        return Icons.notifications_outlined;
    }
  }

  Color _colorForType(String type) {
    switch (type.toLowerCase()) {
      case 'request':
        return const Color(0xFFF59E0B);
      case 'payment':
        return const Color(0xFF16A34A);
      case 'booking':
        return AppColors.primary;
      case 'account':
        return const Color(0xFF7C3AED);
      default:
        return AppColors.primary;
    }
  }

  String _timeAgo(DateTime date, AppLocalizations l10n) {
    final diff = DateTime.now().difference(date);

    if (diff.inSeconds < 60) return l10n.notificationsJustNow;
    if (diff.inMinutes < 60) return l10n.notificationsMinAgo(diff.inMinutes);
    if (diff.inHours < 24) return l10n.notificationsHoursAgo(diff.inHours);
    if (diff.inDays < 7) return l10n.notificationsDaysAgo(diff.inDays);
    return '${date.day}/${date.month}/${date.year}';
  }
}

class _NotificationCard extends StatelessWidget {
  final String title;
  final String description;
  final String timeLabel;
  final IconData icon;
  final Color accentColor;
  final bool unread;
  final VoidCallback? onTap;
  final VoidCallback? onMarkAsRead;

  const _NotificationCard({
    required this.title,
    required this.description,
    required this.timeLabel,
    required this.icon,
    required this.accentColor,
    required this.unread,
    this.onTap,
    this.onMarkAsRead,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: unread ? accentColor.withOpacity(0.18) : const Color(0xFFE8ECF2),
            width: unread ? 1.2 : 1,
          ),
          boxShadow: const [
            BoxShadow(
              color: Color(0x12000000),
              blurRadius: 12,
              offset: Offset(0, 8),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 44,
              width: 44,
              decoration: BoxDecoration(
                color: accentColor.withOpacity(0.14),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(icon, color: accentColor),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          title,
                          style: const TextStyle(
                            fontWeight: FontWeight.w900,
                            fontSize: 15,
                            color: Color(0xFF1D2433),
                          ),
                        ),
                      ),
                      if (unread)
                        Container(
                          height: 8,
                          width: 8,
                          decoration: const BoxDecoration(
                            color: Color(0xFFFF4D4D),
                            shape: BoxShape.circle,
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: const TextStyle(
                      fontSize: 12.5,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF6B7280),
                      height: 1.3,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Text(
                        timeLabel,
                        style: const TextStyle(
                          fontSize: 11.5,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF9CA3AF),
                        ),
                      ),
                      const Spacer(),
                      if (unread)
                        TextButton(
                          onPressed: onMarkAsRead,
                          style: TextButton.styleFrom(
                            minimumSize: Size.zero,
                            padding: EdgeInsets.zero,
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                          child: Text(
                            l10n.notificationsMarkAsRead,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w800,
                              color: accentColor,
                            ),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}


