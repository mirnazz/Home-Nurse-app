import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

/// At least ~8 digits (local or international).
bool hasCallableAppointmentPhone(String? phone) {
  if (phone == null) return false;
  final d = phone.replaceAll(RegExp(r'\D'), '');
  return d.length >= 8;
}

String _digitsOnly(String phone) => phone.replaceAll(RegExp(r'\D'), '');

/// Visible phone for display / tel: (keeps +, strips spaces).
String displayPhoneClean(String phone) => phone.trim().replaceAll(RegExp(r'\s+'), ' ').trim();

/// Shows the number, then user taps **Call** to open the dialer.
Future<void> showCallWithNumberDialog(
  BuildContext context, {
  required String phone,
  String title = 'Phone number',
}) async {
  if (!hasCallableAppointmentPhone(phone)) {
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No phone number available.')),
      );
    }
    return;
  }

  final shown = displayPhoneClean(phone);
  final forTel = shown.replaceAll(' ', '');

  await showDialog<void>(
    context: context,
    builder: (ctx) => AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w800)),
      content: SelectableText(
        shown,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w800,
          color: Color(0xFF111827),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(ctx),
          child: const Text('Close'),
        ),
        FilledButton(
          onPressed: () async {
            final uri = Uri.parse('tel:${forTel.replaceAll(' ', '')}');
            try {
              if (await canLaunchUrl(uri)) {
                await launchUrl(uri);
              }
            } catch (_) {
              if (ctx.mounted) {
                ScaffoldMessenger.of(ctx).showSnackBar(
                  const SnackBar(content: Text('Could not start the phone app.')),
                );
              }
            }
            if (ctx.mounted) Navigator.pop(ctx);
          },
          child: const Text('Call'),
        ),
      ],
    ),
  );
}

/// Opens WhatsApp chat with [phone] (digits / + allowed; wa.me uses country code).
Future<void> openWhatsAppForPhone(BuildContext context, {required String phone}) async {
  final d = _digitsOnly(phone);
  if (d.length < 8) {
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No phone number for WhatsApp.')),
      );
    }
    return;
  }

  final uri = Uri.parse('https://wa.me/$d');
  try {
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  } catch (_) {
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not open WhatsApp.')),
      );
    }
  }
}

/// Call (shows number first) + WhatsApp — used on patient & nurse appointment details.
class AppointmentCallWhatsAppRow extends StatelessWidget {
  final String phone;
  final Color accentTeal;
  final String callButtonLabel;
  final String numberDialogTitle;
  /// Patient mock: grey filled call button. Nurse: teal filled.
  final bool greyCallStyle;

  /// Right button label (e.g. nurse details: "Message on WhatsApp").
  final String whatsappLabel;

  const AppointmentCallWhatsAppRow({
    super.key,
    required this.phone,
    required this.accentTeal,
    required this.callButtonLabel,
    required this.numberDialogTitle,
    this.greyCallStyle = false,
    this.whatsappLabel = 'WhatsApp',
  });

  @override
  Widget build(BuildContext context) {
    final ok = hasCallableAppointmentPhone(phone);

    final callStyle = greyCallStyle
        ? FilledButton.styleFrom(
            backgroundColor: const Color(0xFFE5E7EB),
            foregroundColor: const Color(0xFF6B7280),
            disabledBackgroundColor: const Color(0xFFF3F4F6),
            disabledForegroundColor: const Color(0xFF9CA3AF),
            padding: const EdgeInsets.symmetric(vertical: 14),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          )
        : FilledButton.styleFrom(
            backgroundColor: accentTeal,
            foregroundColor: Colors.white,
            disabledBackgroundColor: Colors.grey.shade300,
            disabledForegroundColor: Colors.grey.shade600,
            padding: const EdgeInsets.symmetric(vertical: 14),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          );

    return Row(
      children: [
        Expanded(
          child: FilledButton.icon(
            onPressed: ok
                ? () => showCallWithNumberDialog(
                      context,
                      phone: phone,
                      title: numberDialogTitle,
                    )
                : null,
            icon: Icon(Icons.phone_rounded, size: 20, color: greyCallStyle ? null : Colors.white),
            label: Text(callButtonLabel),
            style: callStyle,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: OutlinedButton.icon(
            onPressed: ok ? () => openWhatsAppForPhone(context, phone: phone) : null,
            icon: Icon(Icons.chat_rounded, color: const Color(0xFF25D366), size: 20),
            label: Text(
              whatsappLabel,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontWeight: FontWeight.w800,
                fontSize: whatsappLabel.length > 12 ? 11 : 12.5,
                height: 1.1,
              ),
            ),
            style: OutlinedButton.styleFrom(
              foregroundColor: const Color(0xFF128C7E),
              side: const BorderSide(color: Color(0xFF25D366), width: 1.5),
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            ),
          ),
        ),
      ],
    );
  }
}
