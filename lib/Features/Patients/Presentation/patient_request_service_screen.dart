import 'package:flutter/material.dart';
import 'package:nurse_app/l10n/app_localizations.dart';
import 'package:nurse_app/Core/theme/api/api_service.dart';
import 'package:nurse_app/Features/Patients/Presentation/patient_bottom_nav_bar.dart';
import 'package:nurse_app/Features/Patients/Presentation/patient_review_confirm_screen.dart';
import 'package:nurse_app/Features/Patients/Presentation/patient_service_request_models.dart';

class PatientRequestServiceScreen extends StatefulWidget {
  final String nurseId;
  final String nurseName;
  final String nurseSubtitle;
  final String nurseInitials;
  final DateTime? initialDate;
  final String? initialAddress;
  final String? initialNotes;

  const PatientRequestServiceScreen({
    super.key,
    required this.nurseId,
    required this.nurseName,
    required this.nurseSubtitle,
    required this.nurseInitials,
    this.initialDate,
    this.initialAddress,
    this.initialNotes,
  });

  @override
  State<PatientRequestServiceScreen> createState() =>
      _PatientRequestServiceScreenState();
}

class _PatientRequestServiceScreenState
    extends State<PatientRequestServiceScreen> {
  static const _primary = Color(0xFF2F7F8D);

  PatientServiceOption? _selectedService;
  DateTime? _selectedDate;
  String? _selectedTimeSlot;

  late final TextEditingController _addressController;
  late final TextEditingController _notesController;

  bool _isLoading = true;
  bool _isLoadingSlots = false;
  String? _errorMessage;

  List<PatientServiceOption> _serviceOptions = [];
  List<DateTime> _availableDates = [];
  List<String> _availableTimeSlots = [];
@override
void initState() {
  super.initState();

  _selectedDate = widget.initialDate;
  _addressController = TextEditingController(text: widget.initialAddress ?? '');
  _notesController = TextEditingController(text: widget.initialNotes ?? '');

  WidgetsBinding.instance.addPostFrameCallback((_) {
    if (mounted) {
      _loadInitialData();
    }
  });
} 
  @override
  void dispose() {
    _addressController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _loadInitialData() async {
    final l10n = AppLocalizations.of(context)!;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      debugPrint("LOADING REQUEST SCREEN");
      debugPrint("NURSE ID => ${widget.nurseId}");

      final results = await Future.wait([
        ApiService.getPatientNurseServices(nurseId: widget.nurseId),
        ApiService.getPatientAvailableDates(
          nurseId: widget.nurseId,
          daysAhead: 14,
        ),
      ]);

      final servicesJson = results[0];
      final datesJson = results[1];

      debugPrint("SERVICES RESPONSE => $servicesJson");
      debugPrint("DATES RESPONSE => $datesJson");

      final services =
          servicesJson.map((item) {
            final map = item as Map<String, dynamic>;

            final int serviceId =
                ((map['serviceId'] ?? map['id'] ?? 0) as num).toInt();
            final String serviceName =
                (map['serviceName'] ?? map['name'] ?? map['title'] ?? '')
                    .toString();
            final int duration =
                ((map['durationInMinutes'] ?? map['duration'] ?? 0) as num)
                    .toInt();
            final double price = ((map['price'] ?? 0) as num).toDouble();

            return PatientServiceOption(
              id: serviceId.toString(),
              title: serviceName,
              durationLabel: l10n.patientAppointmentMinutes(duration),
              priceJod: price,
            );
          }).toList();

      final dates =
          datesJson
              .map((e) => DateTime.tryParse(e.toString()))
              .whereType<DateTime>()
              .map((d) => DateTime(d.year, d.month, d.day))
              .toList();

      DateTime? selectedDate = _selectedDate;

      if (selectedDate != null) {
        final normalized = DateTime(
          selectedDate.year,
          selectedDate.month,
          selectedDate.day,
        );

        final exists = dates.any((d) => _isSameDate(d, normalized));

        if (!exists) {
          selectedDate = null;
        }
      }

      final autoSelectedService = services.isNotEmpty ? services.first : null;

      if (!mounted) return;

      setState(() {
        _serviceOptions = services;
        _availableDates = dates;
        _selectedDate = selectedDate ?? (dates.isNotEmpty ? dates.first : null);
        _selectedService = autoSelectedService;
      });

      if (_selectedService != null && _selectedDate != null) {
        await _loadAvailableSlots();
      }
    } catch (e) {
      debugPrint("REQUEST SCREEN ERROR => $e");

      if (!mounted) return;

      setState(() {
        _errorMessage = e.toString().replaceFirst('Exception: ', '');
      });
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _loadAvailableSlots() async {
    if (_selectedService == null || _selectedDate == null) {
      setState(() {
        _availableTimeSlots = [];
        _selectedTimeSlot = null;
      });
      return;
    }

    setState(() {
      _isLoadingSlots = true;
      _availableTimeSlots = [];
      _selectedTimeSlot = null;
    });

    try {
      final slots = await ApiService.getPatientAvailableSlots(
        nurseId: widget.nurseId,
        serviceId: int.parse(_selectedService!.id),
        date: _formatDate(_selectedDate!),
      );

      if (!mounted) return;

      setState(() {
        _availableTimeSlots = slots;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _availableTimeSlots = [];
        _errorMessage = e.toString().replaceFirst('Exception: ', '');
      });
    } finally {
      if (mounted) {
        setState(() => _isLoadingSlots = false);
      }
    }
  }

  void _onSelectService(PatientServiceOption service) async {
    setState(() {
      _selectedService = service;
      _selectedTimeSlot = null;
    });

    await _loadAvailableSlots();
  }

  void _onSelectDate(DateTime date) async {
    setState(() {
      _selectedDate = date;
      _selectedTimeSlot = null;
    });

    await _loadAvailableSlots();
  }

  void _goToReview() {
    final l10n = AppLocalizations.of(context)!;
    if (_selectedService == null ||
        _selectedDate == null ||
        _selectedTimeSlot == null ||
        _addressController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.patientRequestRequiredFields)),
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

  String _formatDate(DateTime date) {
    return '${date.year.toString().padLeft(4, '0')}-'
        '${date.month.toString().padLeft(2, '0')}-'
        '${date.day.toString().padLeft(2, '0')}';
  }

  bool _isSameDate(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: const Color(0xFFF6F7F9),
      appBar: AppBar(
        backgroundColor: _primary,
        elevation: 0,
        foregroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(
          l10n.patientRequestServiceTitle,
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
            child: Padding(
              padding: EdgeInsets.fromLTRB(16, 0, 16, 12),
              child: Row(
                children: [
                  Expanded(
                    child: _StepTab(
                      title: l10n.patientRequestStepServiceDetails,
                      selected: true,
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: _StepTab(
                      title: l10n.patientRequestStepReviewConfirm,
                      selected: false,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child:
                _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : _errorMessage != null &&
                        _serviceOptions.isEmpty &&
                        _availableDates.isEmpty
                    ? Center(
                      child: Padding(
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              _errorMessage!,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: Color(0xFFB91C1C),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 12),
                            ElevatedButton(
                              onPressed: _loadInitialData,
                              child: Text(l10n.patientRetry),
                            ),
                          ],
                        ),
                      ),
                    )
                    : SingleChildScrollView(
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

                          _InputLabel(
                            '${l10n.patientRequestSelectServiceType} *',
                          ),
                          const SizedBox(height: 8),
                          if (_serviceOptions.isEmpty)
                            _EmptyState(
                              text: l10n.patientRequestNoServicesForNurse,
                            )
                          else
                            ..._serviceOptions.map(
                              (service) => Padding(
                                padding: const EdgeInsets.only(bottom: 10),
                                child: _ServiceTile(
                                  service: service,
                                  selected: _selectedService?.id == service.id,
                                  onTap: () => _onSelectService(service),
                                ),
                              ),
                            ),

                          const SizedBox(height: 8),

                          _InputLabel('${l10n.patientRequestSelectDate} *'),
                          const SizedBox(height: 8),
                          if (_availableDates.isEmpty)
                            _EmptyState(
                              text: l10n.patientRequestNoAvailableDates,
                            )
                          else
                            Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children:
                                  _availableDates.map((date) {
                                    final selected =
                                        _selectedDate != null &&
                                        _isSameDate(_selectedDate!, date);
                                    return _DateChip(
                                      text: _formatDate(date),
                                      selected: selected,
                                      onTap: () => _onSelectDate(date),
                                    );
                                  }).toList(),
                            ),

                          const SizedBox(height: 14),

                          _InputLabel('${l10n.patientRequestSelectTimeSlot} *'),
                          const SizedBox(height: 8),
                          if (_selectedService == null || _selectedDate == null)
                            _EmptyState(
                              text: l10n.patientRequestSelectServiceDateFirst,
                            )
                          else if (_isLoadingSlots)
                            const Padding(
                              padding: EdgeInsets.symmetric(vertical: 16),
                              child: Center(child: CircularProgressIndicator()),
                            )
                          else if (_availableTimeSlots.isEmpty)
                            _EmptyState(
                              text: l10n.patientRequestNoAvailableTimeSlots,
                            )
                          else
                            Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children:
                                  _availableTimeSlots
                                      .map(
                                        (slot) => _TimeChip(
                                          text: slot,
                                          selected: _selectedTimeSlot == slot,
                                          onTap:
                                              () => setState(
                                                () => _selectedTimeSlot = slot,
                                              ),
                                        ),
                                      )
                                      .toList(),
                            ),

                          const SizedBox(height: 14),

                          _InputLabel('${l10n.patientRequestServiceAddress} *'),
                          const SizedBox(height: 8),
                          TextField(
                            controller: _addressController,
                            decoration: _inputDecoration(
                              l10n.patientRequestAddressHint,
                            ).copyWith(
                              prefixIcon: const Icon(
                                Icons.location_on_outlined,
                              ),
                            ),
                          ),

                          const SizedBox(height: 14),

                          _InputLabel(
                            l10n.patientRequestAdditionalNotesOptional,
                          ),
                          const SizedBox(height: 8),
                          TextField(
                            controller: _notesController,
                            maxLines: 4,
                            decoration: _inputDecoration(
                              l10n.patientRequestNotesHint,
                            ).copyWith(
                              prefixIcon: const Icon(Icons.note_alt_outlined),
                            ),
                          ),

                          if (_errorMessage != null) ...[
                            const SizedBox(height: 14),
                            Text(
                              _errorMessage!,
                              style: const TextStyle(
                                color: Color(0xFFB91C1C),
                                fontWeight: FontWeight.w600,
                                fontSize: 12.5,
                              ),
                            ),
                          ],
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
                onPressed: _isLoading ? null : _goToReview,
                style: ElevatedButton.styleFrom(
                  backgroundColor: _primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  textStyle: const TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 15,
                  ),
                ),
                child: Text(l10n.patientRequestReviewAndConfirm),
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
          border: Border.all(
            color: selected ? primary : const Color(0xFFE5E7EB),
          ),
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
                      color:
                          selected ? Colors.white70 : const Color(0xFF6B7280),
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

class _DateChip extends StatelessWidget {
  final String text;
  final bool selected;
  final VoidCallback onTap;

  const _DateChip({
    required this.text,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    const primary = Color(0xFF2F7F8D);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: selected ? primary : Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: selected ? primary : const Color(0xFFE5E7EB),
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
