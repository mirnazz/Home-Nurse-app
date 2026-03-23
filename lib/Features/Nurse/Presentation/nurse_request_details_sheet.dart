import 'package:flutter/material.dart';
import 'package:nurse_app/Core/theme/app_colors.dart';
import 'package:nurse_app/Features/Nurse/Presentation/nurse_service_request_models.dart';

class NurseRequestDetailsSheet extends StatelessWidget {
  final NurseServiceRequestItem request;
  final bool isActionLoading;
  final Future<void> Function()? onAccept;
  final Future<void> Function()? onDecline;

  const NurseRequestDetailsSheet({
    super.key,
    required this.request,
    required this.isActionLoading,
    this.onAccept,
    this.onDecline,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.white,
      insetPadding: const EdgeInsets.symmetric(horizontal: 26, vertical: 30),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 390),
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 18, 20, 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Expanded(
                    child: Text(
                      'Request Details',
                      style: TextStyle(
                        fontSize: 31,
                        fontWeight: FontWeight.w900,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                  IconButton(
                    constraints: const BoxConstraints(),
                    padding: EdgeInsets.zero,
                    onPressed: isActionLoading ? null : () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.close_rounded, color: Color(0xFF6B7280)),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              _DetailItem(label: 'Patient Name', value: request.patientName),
              _DetailItem(label: 'Service Type', value: request.serviceName, highlight: true),
              const SizedBox(height: 6),
              Row(
                children: [
                  Expanded(
                    child: _DetailItem(
                      label: 'Date',
                      value:
                          '${request.dateTime.year.toString().padLeft(4, '0')}-'
                          '${request.dateTime.month.toString().padLeft(2, '0')}-'
                          '${request.dateTime.day.toString().padLeft(2, '0')}',
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _DetailItem(
                      label: 'Time',
                      value:
                          '${request.dateTime.hour.toString().padLeft(2, '0')}:'
                          '${request.dateTime.minute.toString().padLeft(2, '0')}',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              _DetailItem(label: 'Location', value: request.address),
              _DetailItem(label: 'Contact', value: request.phone),
              const SizedBox(height: 6),
              Row(
                children: [
                  Expanded(
                    child: _DetailItem(
                      label: 'Duration',
                      value: '${request.durationMinutes} minutes',
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _DetailItem(
                      label: 'Payment',
                      value: '${request.priceJod} JOD',
                      highlight: true,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              const Text(
                'Additional Notes',
                style: TextStyle(
                  color: Color(0xFF6B7280),
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 7),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFF3F4F6),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  request.notes.isEmpty ? '-' : request.notes,
                  style: const TextStyle(
                    color: Color(0xFF4B5563),
                    fontSize: 13.5,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              if (request.status == NurseServiceRequestStatus.pending)
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: isActionLoading ? null : () => onDecline?.call(),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: const Color(0xFFEF4444),
                          side: const BorderSide(color: Color(0xFFFCA5A5)),
                          padding: const EdgeInsets.symmetric(vertical: 13),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        child: const Text(
                          'Decline',
                          style: TextStyle(fontWeight: FontWeight.w800, fontSize: 18),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: isActionLoading ? null : () => onAccept?.call(),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 13),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        child: isActionLoading
                            ? const SizedBox(
                                width: 18,
                                height: 18,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : const Text(
                                'Accept Request',
                                style: TextStyle(fontWeight: FontWeight.w800, fontSize: 18),
                              ),
                      ),
                    ),
                  ],
                )
              else
                _StatusPill(status: request.status),
            ],
          ),
        ),
      ),
    );
  }
}

class _DetailItem extends StatelessWidget {
  final String label;
  final String value;
  final bool highlight;

  const _DetailItem({
    required this.label,
    required this.value,
    this.highlight = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: Color(0xFF6B7280),
              fontSize: 14,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            value,
            style: TextStyle(
              color: highlight ? AppColors.primary : const Color(0xFF111827),
              fontSize: 16,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}

class _StatusPill extends StatelessWidget {
  final NurseServiceRequestStatus status;
  const _StatusPill({required this.status});

  @override
  Widget build(BuildContext context) {
    final (bg, fg, label) = switch (status) {
      NurseServiceRequestStatus.accepted => (
          const Color(0xFFEAFBF0),
          const Color(0xFF22C55E),
          'Accepted'
        ),
      NurseServiceRequestStatus.declined => (
          const Color(0xFFFEE2E2),
          const Color(0xFFDC2626),
          'Declined'
        ),
      NurseServiceRequestStatus.pending => (
          const Color(0xFFFFF7ED),
          const Color(0xFFF59E0B),
          'Pending'
        ),
    };

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 11),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: fg,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}

