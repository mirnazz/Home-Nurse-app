import 'package:flutter/material.dart';
import 'package:nurse_app/Features/Patients/Presentation/patient_bottom_nav_bar.dart';
import 'package:nurse_app/Features/Patients/Presentation/patient_request_submitted_screen.dart';
import 'package:nurse_app/Features/Patients/Presentation/patient_service_request_models.dart';

class PatientReviewConfirmScreen extends StatelessWidget {
  final PatientServiceRequestDraft draft;

  const PatientReviewConfirmScreen({super.key, required this.draft});

  @override
  Widget build(BuildContext context) {
    const primary = Color(0xFF2F7F8D);
    final formattedDate =
        '${draft.date.year.toString().padLeft(4, '0')}-'
        '${draft.date.month.toString().padLeft(2, '0')}-'
        '${draft.date.day.toString().padLeft(2, '0')}';

    return Scaffold(
      backgroundColor: const Color(0xFFF6F7F9),
      appBar: AppBar(
        backgroundColor: primary,
        elevation: 0,
        foregroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          'Service Request',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w800,
            fontSize: 18,
          ),
        ),
      ),
      body: Column(
        children: [
          Container(
            color: primary,
            child: const Padding(
              padding: EdgeInsets.fromLTRB(16, 0, 16, 12),
              child: Row(
                children: [
                  Expanded(child: _StepTab(title: 'Service Details', selected: false)),
                  SizedBox(width: 10),
                  Expanded(child: _StepTab(title: 'Review & Confirm', selected: true)),
                ],
              ),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 20),
              child: Column(
                children: [
                  _NurseCard(
                    initials: draft.nurseInitials,
                    name: draft.nurseName,
                    subtitle: draft.nurseSubtitle,
                  ),
                  const SizedBox(height: 12),
                  _BlockCard(
                    title: 'Review Your Request',
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _InfoRow(label: 'Service Type', value: draft.service.title),
                        _InfoRow(label: 'Duration', value: draft.service.durationLabel),
                        Row(
                          children: [
                            Expanded(child: _InfoRow(label: 'Date', value: formattedDate)),
                            const SizedBox(width: 12),
                            Expanded(child: _InfoRow(label: 'Time', value: draft.timeSlot)),
                          ],
                        ),
                        _InfoRow(label: 'Address', value: draft.address),
                        _InfoRow(
                          label: 'Notes',
                          value: draft.notes.trim().isEmpty ? '-' : draft.notes,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  _BlockCard(
                    title: 'Service Cost',
                    child: Column(
                      children: [
                        _CostLine(label: 'Service', value: draft.service.title),
                        _CostLine(label: 'Duration', value: draft.service.durationLabel),
                        const SizedBox(height: 10),
                        const Divider(height: 1),
                        const SizedBox(height: 10),
                        _CostLine(
                          label: 'Total Price',
                          value: '${draft.service.priceJod} JOD',
                          highlighted: true,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 6),
            child: SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => PatientRequestSubmittedScreen(draft: draft),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  textStyle: const TextStyle(fontWeight: FontWeight.w800, fontSize: 15),
                ),
                child: const Text('Submit Request'),
              ),
            ),
          ),
          PatientBottomNavBar(
            currentIndex: 1,
            onTap: (index) {
              if (index == 0) {
                Navigator.of(context).popUntil((route) => route.isFirst);
              } else if (index == 1) {
                Navigator.of(context).popUntil((route) => route.isFirst);
              }
            },
          ),
        ],
      ),
    );
  }
}

class _StepTab extends StatelessWidget {
  final String title;
  final bool selected;
  const _StepTab({required this.title, required this.selected});

  @override
  Widget build(BuildContext context) {
    final color = selected ? Colors.white : Colors.white70;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            color: color,
            fontWeight: selected ? FontWeight.w800 : FontWeight.w600,
            fontSize: 12,
          ),
        ),
        const SizedBox(height: 5),
        Container(
          height: 2.2,
          decoration: BoxDecoration(
            color: selected ? Colors.white : Colors.white24,
            borderRadius: BorderRadius.circular(999),
          ),
        ),
      ],
    );
  }
}

class _NurseCard extends StatelessWidget {
  final String initials;
  final String name;
  final String subtitle;

  const _NurseCard({
    required this.initials,
    required this.name,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE8ECF2)),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 18,
            backgroundColor: const Color(0xFFEAF4F6),
            child: Text(
              initials,
              style: const TextStyle(
                color: Color(0xFF2F7F8D),
                fontWeight: FontWeight.w800,
                fontSize: 12,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    color: Color(0xFF1F2937),
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: const TextStyle(
                    color: Color(0xFF6B7280),
                    fontSize: 12.5,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _BlockCard extends StatelessWidget {
  final String title;
  final Widget child;

  const _BlockCard({
    required this.title,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE8ECF2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Color(0xFF1F2937),
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const _InfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: Color(0xFF6B7280),
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            value,
            style: const TextStyle(
              color: Color(0xFF1F2937),
              fontSize: 13,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _CostLine extends StatelessWidget {
  final String label;
  final String value;
  final bool highlighted;

  const _CostLine({
    required this.label,
    required this.value,
    this.highlighted = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Color(0xFF6B7280),
            fontWeight: FontWeight.w700,
            fontSize: 12.5,
          ),
        ),
        const Spacer(),
        Text(
          value,
          style: TextStyle(
            color: highlighted ? const Color(0xFF2F7F8D) : const Color(0xFF1F2937),
            fontWeight: FontWeight.w800,
            fontSize: 12.5,
          ),
        ),
      ],
    );
  }
}
