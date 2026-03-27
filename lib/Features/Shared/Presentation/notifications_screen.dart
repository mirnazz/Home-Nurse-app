import 'package:flutter/material.dart';
import 'package:nurse_app/Core/theme/app_colors.dart';

enum NotificationAudience { patient, nurse }

enum NotificationType {
  bookingConfirmed,
  requestRejected,
  paymentSuccess,
  newRequest,
  reminder,
}

class NotificationItem {
  final NotificationType type;
  final String title;
  final String description;
  final String timeLabel;
  final IconData icon;
  final Color accentColor;
  final bool unread;

  const NotificationItem({
    required this.type,
    required this.title,
    required this.description,
    required this.timeLabel,
    required this.icon,
    required this.accentColor,
    this.unread = false,
  });
}

class NotificationsScreen extends StatelessWidget {
  final NotificationAudience audience;
  final List<NotificationItem> notifications;
  final void Function(NotificationItem)? onNotificationTap;

  const NotificationsScreen({
    super.key,
    required this.audience,
    required this.notifications,
    this.onNotificationTap,
  });

  String get _screenTitle =>
      audience == NotificationAudience.nurse ? 'Nurse Notifications' : 'Notifications';

  @override
  Widget build(BuildContext context) {
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
      ),
      body: notifications.isEmpty
          ? const Center(
              child: Text(
                'No notifications yet.',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF6B7280),
                ),
              ),
            )
          : ListView.separated(
              padding: const EdgeInsets.fromLTRB(16, 18, 16, 24),
              itemCount: notifications.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final item = notifications[index];
                return _NotificationCard(
                  item: item,
                  onTap: () => onNotificationTap?.call(item),
                );
              },
            ),
    );
  }
}

class _NotificationCard extends StatelessWidget {
  final NotificationItem item;
  final VoidCallback? onTap;

  const _NotificationCard({
    required this.item,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: const Color(0xFFE8ECF2)),
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
                color: item.accentColor.withValues(alpha: 0.14),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(item.icon, color: item.accentColor),
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
                          item.title,
                          style: const TextStyle(
                            fontWeight: FontWeight.w900,
                            fontSize: 15,
                            color: Color(0xFF1D2433),
                          ),
                        ),
                      ),
                      if (item.unread)
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
                    item.description,
                    style: const TextStyle(
                      fontSize: 12.5,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF6B7280),
                      height: 1.3,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    item.timeLabel,
                    style: const TextStyle(
                      fontSize: 11.5,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF9CA3AF),
                    ),
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
