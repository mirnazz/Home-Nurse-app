import 'package:flutter/material.dart';
import 'package:nurse_app/Features/Patients/Presentation/patient_bottom_nav_bar.dart';
import 'package:nurse_app/Features/Patients/Presentation/patient_review_confirm_screen.dart';
import 'package:nurse_app/Features/Patients/Presentation/patient_service_request_models.dart';

class PatientRequestServiceScreen extends StatefulWidget {
  final String nurseId;
  final String nurseName;
  final String nurseSubtitle;
  final String nurseInitials;
  final List<PatientServiceOption> serviceOptions;
  final List<String> availableTimeSlots;
  final DateTime? initialDate;
  final String? initialAddress;
  final String? initialNotes;

  const PatientRequestServiceScreen({
    super.key,
    required this.nurseId,
    required this.nurseName,
    required this.nurseSubtitle,
    required this.nurseInitials,
    required this.serviceOptions,
    required this.availableTimeSlots,
    this.initialDate,
    this.initialAddress,
    this.initialNotes,
  });

  @override
  State<PatientRequestServiceScreen> createState() =>
      _PatientRequestServiceScreenState();
}

class _PatientRequestServiceScreenState extends State<PatientRequestServiceScreen> {
  static const _primary = Color(0xFF2F7F8D);

  PatientServiceOption? _selectedService;
  DateTime? _selectedDate;
  String? _selectedTimeSlot;

  late final TextEditingController _addressController;
  late final TextEditingController _notesController;

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.initialDate;
    _addressController = TextEditingController(text: widget.initialAddress ?? '');
    _notesController = TextEditingController(text: widget.initialNotes ?? '');
  }

  @override
  void dispose() {
    _addressController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final initial = _selectedDate ?? now;
    final selected = await showDatePicker(
      context: context,
      initialDate: initial.isBefore(now) ? now : initial,
      firstDate: DateTime(now.year, now.month, now.day),
      lastDate: DateTime(now.year + 2),
    );
    if (selected == null) return;
    setState(() => _selectedDate = selected);
  }

  void _goToReview() {
    if (_selectedService == null ||
        _selectedDate == null ||
        _selectedTimeSlot == null ||
        _addressController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please complete all required fields.')),
      );
      return;
    }

    final payload = PatientServiceRequestDraft(
      nurseId: widget.nurseId,
      nurseName: widget.nurseName,
      nurseSubtitle: widget.nurseSubtitle,
      nurseInitials: widget.nurseInitials,
      service: _selectedService!,
      date: _selectedDate!,
      timeSlot: _selectedTimeSlot!,
      address: _addressController.text.trim(),
      notes: _notesController.text.trim(),
    );

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => PatientReviewConfirmScreen(draft: payload),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F7F9),
      appBar: AppBar(
        backgroundColor: _primary,
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
            color: _primary,
            child: const Padding(
              padding: EdgeInsets.fromLTRB(16, 0, 16, 12),
              child: Row(
                children: [
                  Expanded(child: _StepTab(title: 'Service Details', selected: true)),
                  SizedBox(width: 10),
                  Expanded(child: _StepTab(title: 'Review & Confirm', selected: false)),
                ],
              ),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _NurseCard(
                    initials: widget.nurseInitials,
                    name: widget.nurseName,
                    subtitle: widget.nurseSubtitle,
                  ),
                  const SizedBox(height: 16),
                  const _InputLabel('Select Service Type *'),
                  const SizedBox(height: 8),
                  if (widget.serviceOptions.isEmpty)
                    const _EmptyState(text: 'Services will appear here after API integration.')
                  else
                    ...widget.serviceOptions.map(
                      (service) => Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: _ServiceTile(
                          service: service,
                          selected: _selectedService?.id == service.id,
                          onTap: () => setState(() => _selectedService = service),
                        ),
                      ),
                    ),
                  const SizedBox(height: 8),
                  const _InputLabel('Select Date *'),
                  const SizedBox(height: 8),
                  _DateInput(
                    text: _selectedDate == null
                        ? ''
                        : '${_selectedDate!.year.toString().padLeft(4, '0')}-'
                            '${_selectedDate!.month.toString().padLeft(2, '0')}-'
                            '${_selectedDate!.day.toString().padLeft(2, '0')}',
                    onTap: _pickDate,
                  ),
                  const SizedBox(height: 14),
                  const _InputLabel('Select Available Time Slot *'),
                  const SizedBox(height: 8),
                  if (widget.availableTimeSlots.isEmpty)
                    const _EmptyState(text: 'Available slots will appear here after API integration.')
                  else
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: widget.availableTimeSlots
                          .map(
                            (slot) => _TimeChip(
                              text: slot,
                              selected: _selectedTimeSlot == slot,
                              onTap: () => setState(() => _selectedTimeSlot = slot),
                            ),
                          )
                          .toList(),
                    ),
                  const SizedBox(height: 14),
                  const _InputLabel('Service Address *'),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _addressController,
                    decoration: _inputDecoration('Enter your complete address')
                        .copyWith(prefixIcon: const Icon(Icons.location_on_outlined)),
                  ),
                  const SizedBox(height: 14),
                  const _InputLabel('Additional Notes (Optional)'),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _notesController,
                    maxLines: 4,
                    decoration: _inputDecoration(
                      'Any special instructions or medical information...',
                    ).copyWith(prefixIcon: const Icon(Icons.note_alt_outlined)),
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
                onPressed: _goToReview,
                style: ElevatedButton.styleFrom(
                  backgroundColor: _primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  textStyle: const TextStyle(fontWeight: FontWeight.w800, fontSize: 15),
                ),
                child: const Text('Review and Confirm'),
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

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: _primary),
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

class _ServiceTile extends StatelessWidget {
  final PatientServiceOption service;
  final bool selected;
  final VoidCallback onTap;

  const _ServiceTile({
    required this.service,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    const primary = Color(0xFF2F7F8D);
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.fromLTRB(12, 12, 12, 10),
        decoration: BoxDecoration(
          color: selected ? primary : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: selected ? primary : const Color(0xFFE5E7EB)),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    service.title,
                    style: TextStyle(
                      color: selected ? Colors.white : const Color(0xFF1F2937),
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    service.durationLabel,
                    style: TextStyle(
                      color: selected ? Colors.white70 : const Color(0xFF6B7280),
                      fontWeight: FontWeight.w600,
                      fontSize: 12.5,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            Text(
              '${service.priceJod} JOD',
              style: TextStyle(
                color: selected ? Colors.white : primary,
                fontWeight: FontWeight.w900,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InputLabel extends StatelessWidget {
  final String text;
  const _InputLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        color: Color(0xFF374151),
        fontWeight: FontWeight.w700,
        fontSize: 13,
      ),
    );
  }
}

class _DateInput extends StatelessWidget {
  final String text;
  final VoidCallback onTap;
  const _DateInput({required this.text, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 13),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFE5E7EB)),
        ),
        child: Row(
          children: [
            const Icon(Icons.calendar_today_outlined, size: 18, color: Color(0xFF6B7280)),
            const SizedBox(width: 10),
            Text(
              text.isEmpty ? 'Select date' : text,
              style: TextStyle(
                color: text.isEmpty ? const Color(0xFF9CA3AF) : const Color(0xFF1F2937),
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TimeChip extends StatelessWidget {
  final String text;
  final bool selected;
  final VoidCallback onTap;
  const _TimeChip({
    required this.text,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        width: 64,
        padding: const EdgeInsets.symmetric(vertical: 9),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: selected ? const Color(0xFF2F7F8D) : Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: selected ? const Color(0xFF2F7F8D) : const Color(0xFFE5E7EB),
          ),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: selected ? Colors.white : const Color(0xFF374151),
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final String text;
  const _EmptyState({required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Color(0xFF6B7280),
          fontWeight: FontWeight.w600,
          fontSize: 12.5,
        ),
      ),
    );
  }
}
