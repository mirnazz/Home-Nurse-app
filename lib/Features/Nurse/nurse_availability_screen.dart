import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';
import 'package:nurse_app/Core/theme/api/api_service.dart';
import 'package:nurse_app/Core/theme/app_colors.dart';
import 'package:nurse_app/Core/theme/appointment_ui_colors.dart';

String _nurseAvailDayLabel(AppLocalizations l10n, String apiDay) {
  switch (apiDay) {
    case 'Monday':
      return l10n.nurseAvailWeekdayMonday;
    case 'Tuesday':
      return l10n.nurseAvailWeekdayTuesday;
    case 'Wednesday':
      return l10n.nurseAvailWeekdayWednesday;
    case 'Thursday':
      return l10n.nurseAvailWeekdayThursday;
    case 'Friday':
      return l10n.nurseAvailWeekdayFriday;
    case 'Saturday':
      return l10n.nurseAvailWeekdaySaturday;
    case 'Sunday':
      return l10n.nurseAvailWeekdaySunday;
    default:
      return apiDay;
  }
}

class NurseAvailabilityScreen extends StatefulWidget {
  /// When true, omits outer [Scaffold] so the screen can live inside a parent
  /// tab (e.g. [NurseScheduleScreen]).
  final bool embedded;

  const NurseAvailabilityScreen({super.key, this.embedded = false});

  @override
  State<NurseAvailabilityScreen> createState() =>
      _NurseAvailabilityScreenState();
}

class _NurseAvailabilityScreenState extends State<NurseAvailabilityScreen> {
  DateTime _selectedDate = DateTime.now();
  final Set<String> _blockedDates = {};

  // Only shows days that have slots from API
  Map<String, List<_TimeSlot>> _weeklySlots = {};

  bool _isLoading = true;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _loadAvailability();
  }

  Future<void> _loadAvailability() async {
    if (!mounted) return;
    setState(() => _isLoading = true);

    try {
      final response = await ApiService.getWeeklyAvailability();
      final Map<String, List<_TimeSlot>> mapped = {};

      for (final item in response) {
        final day = (item['dayOfWeek'] ?? '').toString();
        if (day.isEmpty) continue;

        mapped.putIfAbsent(day, () => []);
        mapped[day]!.add(
          _TimeSlot(
            id: item['weeklyAvailabilityId'] is int
                ? item['weeklyAvailabilityId'] as int
                : int.tryParse(item['weeklyAvailabilityId'].toString()),
            start: (item['startTime'] ?? '').toString(),
            end: (item['endTime'] ?? '').toString(),
            isActive: item['isActive'] == true,
          ),
        );
      }

      if (!mounted) return;
      setState(() {
        _weeklySlots = mapped;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString().replaceFirst('Exception: ', ''))),
      );
    }
  }

  Future<void> _saveAvailability() async {
    if (!mounted) return;
    final l10n = AppLocalizations.of(context)!;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(l10n.nurseAvailSaveAutoMessage)),
    );
  }

  Future<void> _openAddTimeSlotSheet() async {
    final result = await showModalBottomSheet<_AddSlotResult>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const _AddTimeSlotSheet(),
    );

    if (result == null || !mounted) return;

    try {
      setState(() => _isSaving = true);
      await ApiService.addWeeklyAvailability(
        dayOfWeek: result.day,
        startTime: '${result.start}:00',
        endTime: '${result.end}:00',
      );
      await _loadAvailability();
      if (!mounted) return;
      final l10n = AppLocalizations.of(context)!;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.nurseAvailTimeSlotAdded)),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString().replaceFirst('Exception: ', ''))),
      );
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  Future<void> _openManageDaySheet(DateTime date) async {
    final weekdayName = _weekdayName(date.weekday);
    final slots = List<_TimeSlot>.from(_weeklySlots[weekdayName] ?? []);
    final dateKey = _dateKey(date);

    // FIX: parse new backend response structure
    // { defaultWorkingHours, dayOverride: { isBlocked, startTime, endTime }, bookedAppointments }
    List<Map<String, String>> daySlots = [];
    bool hasOverride = false;
    bool blocked = _blockedDates.contains(dateKey);

    try {
      final response = await ApiService.getDayAvailability(date: dateKey);

      // FIX: backend returns dayOverride object, not isBlocked at top level
      final dayOverride = response['dayOverride'];
      if (dayOverride != null && dayOverride is Map) {
        blocked = dayOverride['isBlocked'] == true;
        hasOverride = true;

        // If not blocked, show the override hours
        if (!blocked) {
          final start = dayOverride['startTime']?.toString() ?? '';
          final end = dayOverride['endTime']?.toString() ?? '';
          if (start.isNotEmpty && end.isNotEmpty) {
            daySlots = [{'startTime': start, 'endTime': end}];
          }
        }
      } else {
        hasOverride = false;
        blocked = false;

        // FIX: use defaultWorkingHours from backend response
        final defaultHours = response['defaultWorkingHours'];
        if (defaultHours != null && defaultHours is Map) {
          final start = defaultHours['startTime']?.toString() ?? '';
          final end = defaultHours['endTime']?.toString() ?? '';
          if (start.isNotEmpty && end.isNotEmpty) {
            daySlots = [{'startTime': start, 'endTime': end}];
          }
        }
      }

      if (!mounted) return;
      setState(() {
        if (blocked) {
          _blockedDates.add(dateKey);
        } else {
          _blockedDates.remove(dateKey);
        }
      });
    } catch (_) {
      // silently fall back to local state
    }

    if (!mounted) return;

    // Capture navigator and messenger BEFORE sheet opens (safe after async)
    final nav = Navigator.of(context);
    final messenger = ScaffoldMessenger.of(context);
    final l10n = AppLocalizations.of(context)!;

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => _ManageDaySheet(
        date: date,
        slots: slots,
        apiDaySlots: daySlots,
        hasOverride: hasOverride,
        isBlocked: blocked,
        onBlock: () async {
          try {
            await ApiService.blockDayAvailability(date: dateKey);
            nav.pop();
            if (!mounted) return;
            setState(() => _blockedDates.add(dateKey));
            messenger.showSnackBar(
              SnackBar(content: Text(l10n.nurseAvailDayBlocked)),
            );
          } catch (e) {
            nav.pop();
            messenger.showSnackBar(
              SnackBar(
                content: Text(e.toString().replaceFirst('Exception: ', '')),
              ),
            );
          }
        },
        onUnblock: () async {
          try {
            await ApiService.unblockDayAvailability(date: dateKey);
            nav.pop();
            if (!mounted) return;
            setState(() => _blockedDates.remove(dateKey));
            messenger.showSnackBar(
              SnackBar(content: Text(l10n.nurseAvailDayUnblocked)),
            );
          } catch (e) {
            nav.pop();
            messenger.showSnackBar(
              SnackBar(
                content: Text(e.toString().replaceFirst('Exception: ', '')),
              ),
            );
          }
        },
        onOverrideHours: (start, end) async {
          try {
            await ApiService.overrideDayAvailability(
              date: dateKey,
              startTime: start,
              endTime: end,
            );
            nav.pop();
            messenger.showSnackBar(
              SnackBar(
                content: Text(l10n.nurseAvailOverrideSuccess(start, end)),
              ),
            );
          } catch (e) {
            nav.pop();
            messenger.showSnackBar(
              SnackBar(
                content: Text(e.toString().replaceFirst('Exception: ', '')),
              ),
            );
          }
        },
      ),
    );
  }

  Future<void> _disableSlot(String day, int index) async {
    final slot = _weeklySlots[day]?[index];
    if (slot == null || slot.id == null) return;

    try {
      await ApiService.deleteWeeklyAvailability(slot.id!);
      await _loadAvailability();
      if (!mounted) return;
      final l10n = AppLocalizations.of(context)!;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.nurseAvailSlotDeleted)),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString().replaceFirst('Exception: ', ''))),
      );
    }
  }

  Future<void> _toggleSlot(String day, int index) async {
    final slot = _weeklySlots[day]?[index];
    if (slot == null || slot.id == null) return;

    try {
      await ApiService.toggleWeeklyAvailability(slot.id!);
      await _loadAvailability();
      if (!mounted) return;
      final l10n = AppLocalizations.of(context)!;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.nurseAvailSlotStatusUpdated)),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString().replaceFirst('Exception: ', ''))),
      );
    }
  }

  String _dateKey(DateTime d) =>
      '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

  String _weekdayName(int weekday) {
    const names = [
      '', 'Monday', 'Tuesday', 'Wednesday',
      'Thursday', 'Friday', 'Saturday', 'Sunday',
    ];
    return names[weekday];
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final daysWithSlots = _weeklySlots.keys.toList();

    final scrollPadding = widget.embedded
        ? const EdgeInsets.fromLTRB(
            AppointmentUiColors.scheduleListHorizontalPadding,
            12,
            AppointmentUiColors.scheduleListHorizontalPadding,
            16,
          )
        : const EdgeInsets.fromLTRB(16, 18, 16, 110);

    final scrollBody = _isLoading
        ? const Center(child: CircularProgressIndicator())
        : SingleChildScrollView(
                padding: scrollPadding,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (widget.embedded) ...[
                      Text(
                        l10n.nurseAvailEmbeddedTitle,
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w900,
                          color: Color(0xFF1D2433),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        l10n.nurseAvailTapDateHint,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ] else ...[
                      Text(
                        l10n.nurseAvailManageTitle,
                        style: const TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.w900,
                          color: Color(0xFF1D2433),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        l10n.nurseAvailTapDateHint,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF6B7280),
                        ),
                      ),
                    ],
                    const SizedBox(height: 14),
                    _CalendarCard(
                      selectedDate: _selectedDate,
                      blockedDates: _blockedDates,
                      onDateTapped: (date) {
                        setState(() => _selectedDate = date);
                        _openManageDaySheet(date);
                      },
                    ),
                    const SizedBox(height: AppointmentUiColors.scheduleListVerticalGap),
                    Container(
                      padding: AppointmentUiColors.scheduleCardPadding,
                      decoration: AppointmentUiColors.scheduleCardDecoration(),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              l10n.nurseAvailWeeklySchedule,
                              style: const TextStyle(
                                fontWeight: FontWeight.w900,
                                fontSize: 16,
                                color: Color(0xFF1D2433),
                              ),
                            ),
                          ),
                          FilledButton.icon(
                            style: FilledButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            onPressed: _isSaving ? null : _openAddTimeSlotSheet,
                            icon: _isSaving
                                ? const SizedBox(
                                    width: 16,
                                    height: 16,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: Colors.white,
                                    ),
                                  )
                                : const Icon(Icons.add, size: 18),
                            label: Text(l10n.nurseAvailAddTimeSlot),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: AppointmentUiColors.scheduleListVerticalGap),
                    if (daysWithSlots.isEmpty)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 32),
                        child: Center(
                          child: Column(
                            children: [
                              Icon(
                                Icons.calendar_month_outlined,
                                size: 52,
                                color: Colors.grey.shade300,
                              ),
                              const SizedBox(height: 12),
                              Text(
                                l10n.nurseAvailNoScheduleYet,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.grey.shade400,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                l10n.nurseAvailNoScheduleHint,
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.grey.shade400,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      )
                    else
                      ...daysWithSlots.map((day) {
                        final daySlots =
                            _weeklySlots[day] ?? const <_TimeSlot>[];
                        return Padding(
                          padding: const EdgeInsets.only(
                            bottom: AppointmentUiColors.scheduleListVerticalGap,
                          ),
                          child: _DayScheduleCard(
                            l10n: l10n,
                            day: day,
                            slots: daySlots,
                            onDisable: (index) => _disableSlot(day, index),
                            onToggle: (index) => _toggleSlot(day, index),
                          ),
                        );
                      }),
                    const SizedBox(height: 6),
                    _QuickSettingsCard(
                      l10n: l10n,
                      onCopyWeekdays: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(l10n.nurseAvailQuickPlaceholder),
                          ),
                        );
                      },
                      onSetWeekend: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(l10n.nurseAvailQuickPlaceholder),
                          ),
                        );
                      },
                      onBlockDays: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(l10n.nurseAvailQuickBlockHint),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              );

    final saveBar = SafeArea(
      top: false,
      minimum: const EdgeInsets.fromLTRB(16, 0, 16, 12),
      child: SizedBox(
        height: 52,
        child: ElevatedButton.icon(
          onPressed: _saveAvailability,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14)),
          ),
          icon: const Icon(Icons.save_outlined, color: Colors.white),
          label: Text(
            l10n.nurseAvailSave,
            style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w800,
                fontSize: 16),
          ),
        ),
      ),
    );

    if (widget.embedded) {
      return ColoredBox(
        color: AppointmentUiColors.pageBackground,
        child: Column(
          children: [
            Expanded(
              child: SafeArea(
                bottom: false,
                child: scrollBody,
              ),
            ),
            saveBar,
          ],
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: scrollBody,
      ),
      bottomNavigationBar: saveBar,
    );
  }
}

// =========================
// Calendar Card
// =========================

class _CalendarCard extends StatefulWidget {
  final DateTime selectedDate;
  final Set<String> blockedDates;
  final ValueChanged<DateTime> onDateTapped;

  const _CalendarCard({
    required this.selectedDate,
    required this.blockedDates,
    required this.onDateTapped,
  });

  @override
  State<_CalendarCard> createState() => _CalendarCardState();
}

class _CalendarCardState extends State<_CalendarCard> {
  late DateTime _displayMonth;

  @override
  void initState() {
    super.initState();
    _displayMonth =
        DateTime(widget.selectedDate.year, widget.selectedDate.month);
  }

  void _prevMonth() => setState(() {
        _displayMonth =
            DateTime(_displayMonth.year, _displayMonth.month - 1);
      });

  void _nextMonth() => setState(() {
        _displayMonth =
            DateTime(_displayMonth.year, _displayMonth.month + 1);
      });

  @override
  Widget build(BuildContext context) {
    final localeTag = Localizations.localeOf(context).toString();
    final year = _displayMonth.year;
    final month = _displayMonth.month;
    final daysInMonth = DateUtils.getDaysInMonth(year, month);
    final today = DateTime.now();
    final firstWeekday = DateTime(year, month, 1).weekday;
    final startOffset = firstWeekday % 7;

    final dayCells = <Widget>[];
    for (int i = 0; i < startOffset; i++) {
      dayCells.add(const SizedBox.shrink());
    }

    for (int day = 1; day <= daysInMonth; day++) {
      final date = DateTime(year, month, day);
      final isSelected = date.year == widget.selectedDate.year &&
          date.month == widget.selectedDate.month &&
          date.day == widget.selectedDate.day;
      final isToday = date.year == today.year &&
          date.month == today.month &&
          date.day == today.day;
      final dateKey =
          '$year-${month.toString().padLeft(2, '0')}-${day.toString().padLeft(2, '0')}';
      final isBlocked = widget.blockedDates.contains(dateKey);

      dayCells.add(
        GestureDetector(
          onTap: () => widget.onDateTapped(date),
          child: Container(
            margin: const EdgeInsets.all(3),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: isSelected ? AppColors.primary : Colors.transparent,
              shape: BoxShape.circle,
              border: isToday && !isSelected
                  ? Border.all(color: AppColors.primary, width: 1.5)
                  : null,
            ),
            child: Text(
              '$day',
              style: TextStyle(
                color: isBlocked
                    ? const Color(0xFFD1D5DB)
                    : isSelected
                        ? Colors.white
                        : const Color(0xFF374151),
                fontWeight:
                    isSelected || isToday ? FontWeight.w900 : FontWeight.w600,
                fontSize: 13,
                decoration: isBlocked
                    ? TextDecoration.lineThrough
                    : TextDecoration.none,
              ),
            ),
          ),
        ),
      );
    }

    return Container(
      width: double.infinity,
      padding: AppointmentUiColors.scheduleCardPadding,
      decoration: AppointmentUiColors.scheduleCardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                DateFormat.yMMMM(localeTag).format(DateTime(year, month, 1)),
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w900,
                  color: Color(0xFF1D2433),
                ),
              ),
              const Spacer(),
              _NavButton(icon: Icons.chevron_left, onTap: _prevMonth),
              const SizedBox(width: 4),
              _NavButton(icon: Icons.chevron_right, onTap: _nextMonth),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(7, (i) {
              final d = DateTime(2023, 1, 1 + i);
              return _WeekLabel(DateFormat.E(localeTag).format(d));
            }),
          ),
          const SizedBox(height: 6),
          GridView.count(
            crossAxisCount: 7,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            childAspectRatio: 1,
            children: dayCells,
          ),
        ],
      ),
    );
  }
}

class _NavButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _NavButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        width: 32, height: 32,
        alignment: Alignment.center,
        decoration: BoxDecoration(
            color: const Color(0xFFF3F4F6),
            borderRadius: BorderRadius.circular(8)),
        child: Icon(icon, size: 20, color: const Color(0xFF374151)),
      ),
    );
  }
}

class _WeekLabel extends StatelessWidget {
  final String text;
  const _WeekLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 32,
      child: Text(text,
          textAlign: TextAlign.center,
          style: const TextStyle(
              color: Color(0xFF9CA3AF),
              fontWeight: FontWeight.w700,
              fontSize: 12)),
    );
  }
}

// =========================
// Manage Day Sheet
// =========================

enum _SheetMode { normal, override, block }

class _ManageDaySheet extends StatefulWidget {
  final DateTime date;
  final List<_TimeSlot> slots;
  final List<Map<String, String>> apiDaySlots;
  final bool hasOverride;
  final bool isBlocked;
  final VoidCallback onBlock;
  final VoidCallback onUnblock;
  final void Function(String start, String end) onOverrideHours;

  const _ManageDaySheet({
    required this.date,
    required this.slots,
    required this.apiDaySlots,
    required this.hasOverride,
    required this.isBlocked,
    required this.onBlock,
    required this.onUnblock,
    required this.onOverrideHours,
  });

  @override
  State<_ManageDaySheet> createState() => _ManageDaySheetState();
}

class _ManageDaySheetState extends State<_ManageDaySheet> {
  _SheetMode _mode = _SheetMode.normal;
  TimeOfDay _overrideStart = const TimeOfDay(hour: 8, minute: 0);
  TimeOfDay _overrideEnd = const TimeOfDay(hour: 16, minute: 0);

  String _time24(TimeOfDay t) =>
      '${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}';

  Future<void> _pickStart() async {
    final p = await showTimePicker(context: context, initialTime: _overrideStart);
    if (p != null && mounted) setState(() => _overrideStart = p);
  }

  Future<void> _pickEnd() async {
    final p = await showTimePicker(context: context, initialTime: _overrideEnd);
    if (p != null && mounted) setState(() => _overrideEnd = p);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final localeTag = Localizations.localeOf(context).toString();
    final fallbackHours = widget.slots.isNotEmpty
        ? '${widget.slots.first.start} - ${widget.slots.first.end}'
        : null;
    final apiHours = widget.apiDaySlots.isNotEmpty
        ? widget.apiDaySlots.map((e) => '${e['startTime']} - ${e['endTime']}').join('\n')
        : null;
    final defaultHours = apiHours ?? fallbackHours;
    final dateStr = DateFormat.yMMMMEEEEd(localeTag).format(widget.date);

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: EdgeInsets.fromLTRB(20, 18, 20, MediaQuery.of(context).viewInsets.bottom + 28),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 36, height: 4,
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                    color: const Color(0xFFE5E7EB),
                    borderRadius: BorderRadius.circular(99)),
              ),
            ),
            Row(
              children: [
                Container(
                  width: 42, height: 42,
                  decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(12)),
                  child: const Icon(Icons.calendar_today_outlined,
                      color: AppColors.primary, size: 20),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(l10n.nurseAvailManageDayTitle,
                          style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 22, color: Color(0xFF1D2433))),
                      Text(dateStr,
                          style: const TextStyle(color: Color(0xFF6B7280), fontWeight: FontWeight.w600, fontSize: 13)),
                    ],
                  ),
                ),
                IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close, color: Color(0xFF374151))),
              ],
            ),
            const SizedBox(height: 16),
            const Divider(height: 1, color: Color(0xFFEEF0F3)),
            const SizedBox(height: 16),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xFFE6F4F7),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: const Color(0xFFBFDFE8)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(children: [
                    const Icon(Icons.access_time_outlined, color: AppColors.primary, size: 15),
                    const SizedBox(width: 6),
                    Text(l10n.nurseAvailWorkingHours, style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.w700, fontSize: 12.5)),
                  ]),
                  const SizedBox(height: 6),
                  Text(
                    defaultHours ?? l10n.nurseAvailNoHoursThisDay,
                    style: TextStyle(
                        fontWeight: FontWeight.w900,
                        fontSize: defaultHours != null ? 20 : 14,
                        color: const Color(0xFF1D2433)),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    widget.isBlocked
                        ? l10n.nurseAvailDayBlockedShort
                        : widget.hasOverride
                            ? l10n.nurseAvailCustomOverrideApplied
                            : l10n.nurseAvailFromWeeklySchedule,
                    style: TextStyle(
                        color: widget.isBlocked
                            ? const Color(0xFFDC2626)
                            : const Color(0xFF6B7280),
                        fontSize: 12,
                        fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            const Divider(height: 1, color: Color(0xFFEEF0F3)),
            const SizedBox(height: 12),

            if (_mode == _SheetMode.normal) ...[
              _ActionTile(
                icon: Icons.edit_outlined,
                iconColor: AppColors.primary,
                label: l10n.nurseAvailOverrideHoursTitle,
                subtitle: l10n.nurseAvailOverrideHoursSubtitle,
                onTap: () => setState(() => _mode = _SheetMode.override),
              ),
              const SizedBox(height: 8),
              _ActionTile(
                icon: widget.isBlocked ? Icons.check_circle_outline : Icons.block,
                iconColor: widget.isBlocked ? const Color(0xFF059669) : const Color(0xFFDC2626),
                label: widget.isBlocked ? l10n.nurseAvailUnblockDayTitle : l10n.nurseAvailBlockDayTitle,
                subtitle: widget.isBlocked
                    ? l10n.nurseAvailUnblockDaySubtitle
                    : l10n.nurseAvailBlockDaySubtitle,
                onTap: widget.isBlocked
                    ? widget.onUnblock
                    : () => setState(() => _mode = _SheetMode.block),
              ),
            ],

            if (_mode == _SheetMode.override) ...[
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                    color: const Color(0xFFE6F4F7),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: const Color(0xFFBFDFE8))),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(l10n.nurseAvailOverrideHoursForDate(dateStr),
                        style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.w700, fontSize: 13)),
                    const SizedBox(height: 14),
                    Text(l10n.nurseAvailStartTime, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
                    const SizedBox(height: 6),
                    _TimePickerField(value: _overrideStart.format(context), onTap: _pickStart),
                    const SizedBox(height: 12),
                    Text(l10n.nurseAvailEndTime, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
                    const SizedBox(height: 6),
                    _TimePickerField(value: _overrideEnd.format(context), onTap: _pickEnd),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Row(children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => setState(() => _mode = _SheetMode.normal),
                    style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Color(0xFFE5E7EB)),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        padding: const EdgeInsets.symmetric(vertical: 14)),
                    child: Text(l10n.nurseAvailCancel, style: const TextStyle(fontWeight: FontWeight.w700, color: Color(0xFF374151))),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => widget.onOverrideHours(_time24(_overrideStart), _time24(_overrideEnd)),
                    style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        padding: const EdgeInsets.symmetric(vertical: 14)),
                    child: Text(l10n.nurseAvailSaveOverride, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800)),
                  ),
                ),
              ]),
            ],

            if (_mode == _SheetMode.block) ...[
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                    color: const Color(0xFFFEF2F2),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: const Color(0xFFFECACA))),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(l10n.nurseAvailBlockConfirmTitle,
                        style: const TextStyle(color: Color(0xFFDC2626), fontWeight: FontWeight.w800, fontSize: 15)),
                    const SizedBox(height: 6),
                    Text(
                        l10n.nurseAvailBlockConfirmMessage,
                        style: const TextStyle(color: Color(0xFF991B1B), fontSize: 13, fontWeight: FontWeight.w500)),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Row(children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => setState(() => _mode = _SheetMode.normal),
                    style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Color(0xFFE5E7EB)),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        padding: const EdgeInsets.symmetric(vertical: 14)),
                    child: Text(l10n.nurseAvailCancel, style: const TextStyle(fontWeight: FontWeight.w700, color: Color(0xFF374151))),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: widget.onBlock,
                    style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFDC2626),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        padding: const EdgeInsets.symmetric(vertical: 14)),
                    child: Text(l10n.nurseAvailBlockDay, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800)),
                  ),
                ),
              ]),
            ],
          ],
        ),
      ),
    );
  }
}

class _TimePickerField extends StatelessWidget {
  final String value;
  final VoidCallback onTap;
  const _TimePickerField({required this.value, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFDCE3ED))),
        child: Row(children: [
          const Icon(Icons.access_time, color: Color(0xFF94A3B8), size: 18),
          const SizedBox(width: 10),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w700, color: Color(0xFF334155), fontSize: 14)),
        ]),
      ),
    );
  }
}

class _ActionTile extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String label;
  final String subtitle;
  final VoidCallback onTap;

  const _ActionTile({
    required this.icon, required this.iconColor,
    required this.label, required this.subtitle, required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
            color: const Color(0xFFF9FAFB),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: const Color(0xFFE5E7EB))),
        child: Row(children: [
          Icon(icon, color: iconColor, size: 22),
          const SizedBox(width: 14),
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(label, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 15, color: Color(0xFF1D2433))),
              const SizedBox(height: 2),
              Text(subtitle, style: const TextStyle(color: Color(0xFF6B7280), fontSize: 12.5, fontWeight: FontWeight.w500)),
            ]),
          ),
        ]),
      ),
    );
  }
}

class _DayScheduleCard extends StatelessWidget {
  final AppLocalizations l10n;
  final String day;
  final List<_TimeSlot> slots;
  final ValueChanged<int> onDisable;
  final ValueChanged<int> onToggle;

  const _DayScheduleCard({
    required this.l10n,
    required this.day,
    required this.slots,
    required this.onDisable,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: AppointmentUiColors.scheduleCardPadding,
      decoration: AppointmentUiColors.scheduleCardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            Text(_nurseAvailDayLabel(l10n, day), style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: Color(0xFF1D2433))),
            const Spacer(),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(color: const Color(0xFFECFDF5), borderRadius: BorderRadius.circular(99)),
              child: Text(l10n.nurseAvailSlotCount(slots.length),
                  style: const TextStyle(color: Color(0xFF059669), fontWeight: FontWeight.w800, fontSize: 11.5)),
            ),
          ]),
          const SizedBox(height: 10),
          ...slots.asMap().entries.map((entry) {
            final index = entry.key;
            final slot = entry.value;
            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                    color: const Color(0xFFF9FAFB), borderRadius: BorderRadius.circular(12)),
                child: Row(children: [
                  Icon(slot.isActive ? Icons.access_time : Icons.block,
                      size: 16, color: slot.isActive ? AppColors.primary : const Color(0xFF9CA3AF)),
                  const SizedBox(width: 6),
                  Text('${slot.start} - ${slot.end}',
                      style: TextStyle(
                          fontWeight: FontWeight.w800,
                          color: slot.isActive ? const Color(0xFF374151) : const Color(0xFF9CA3AF),
                          decoration: slot.isActive ? TextDecoration.none : TextDecoration.lineThrough)),
                  const Spacer(),
                  Tooltip(
                    message: slot.isActive ? l10n.nurseAvailDeactivateSlot : l10n.nurseAvailActivateSlot,
                    child: IconButton(
                      onPressed: () => onToggle(index),
                      icon: Icon(slot.isActive ? Icons.visibility : Icons.visibility_off,
                          color: slot.isActive ? const Color(0xFF059669) : const Color(0xFF9CA3AF)),
                    ),
                  ),
                  TextButton.icon(
                    onPressed: () => onDisable(index),
                    icon: const Icon(Icons.delete_outline, size: 15),
                    label: Text(l10n.nurseAvailDelete),
                    style: TextButton.styleFrom(
                        foregroundColor: const Color(0xFFDC2626),
                        visualDensity: VisualDensity.compact),
                  ),
                ]),
              ),
            );
          }),
        ],
      ),
    );
  }
}

class _QuickSettingsCard extends StatelessWidget {
  final AppLocalizations l10n;
  final VoidCallback onCopyWeekdays;
  final VoidCallback onSetWeekend;
  final VoidCallback onBlockDays;

  const _QuickSettingsCard({
    required this.l10n,
    required this.onCopyWeekdays,
    required this.onSetWeekend,
    required this.onBlockDays,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: AppointmentUiColors.scheduleCardPadding,
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(AppointmentUiColors.scheduleCardRadius),
        boxShadow: AppointmentUiColors.scheduleCardShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.nurseAvailQuickSettingsTitle,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w900,
              fontSize: 15,
            ),
          ),
          const SizedBox(height: 10),
          _QuickSettingButton(label: l10n.nurseAvailQuickCopyWeekdays, subtitle: l10n.nurseAvailQuickCopyWeekdaysSubtitle, onTap: onCopyWeekdays),
          const SizedBox(height: 8),
          _QuickSettingButton(label: l10n.nurseAvailQuickWeekend, subtitle: l10n.nurseAvailQuickWeekendSubtitle, onTap: onSetWeekend),
          const SizedBox(height: 8),
          _QuickSettingButton(label: l10n.nurseAvailQuickBlockDays, subtitle: l10n.nurseAvailQuickBlockDaysSubtitle, onTap: onBlockDays),
        ],
      ),
    );
  }
}

class _QuickSettingButton extends StatelessWidget {
  final String label;
  final String subtitle;
  final VoidCallback onTap;
  const _QuickSettingButton({required this.label, required this.subtitle, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.14),
            borderRadius: BorderRadius.circular(12)),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(label, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 14)),
          const SizedBox(height: 3),
          Text(subtitle, style: TextStyle(color: Colors.white.withValues(alpha: 0.86), fontWeight: FontWeight.w500, fontSize: 11.5)),
        ]),
      ),
    );
  }
}

class _AddTimeSlotSheet extends StatefulWidget {
  const _AddTimeSlotSheet();
  @override
  State<_AddTimeSlotSheet> createState() => _AddTimeSlotSheetState();
}

class _AddTimeSlotSheetState extends State<_AddTimeSlotSheet> {
  String selectedDay = 'Monday';
  TimeOfDay startTime = const TimeOfDay(hour: 8, minute: 0);
  TimeOfDay endTime = const TimeOfDay(hour: 16, minute: 0);

  Future<void> _pickStartTime() async {
    final picked = await showTimePicker(context: context, initialTime: startTime);
    if (picked != null && mounted) setState(() => startTime = picked);
  }

  Future<void> _pickEndTime() async {
    final picked = await showTimePicker(context: context, initialTime: endTime);
    if (picked != null && mounted) setState(() => endTime = picked);
  }

  String _time24(TimeOfDay t) =>
      '${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}';

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    const days = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];
    final durationMinutes = (endTime.hour * 60 + endTime.minute) - (startTime.hour * 60 + startTime.minute);
    final validDuration = durationMinutes > 0;
    final summaryDuration = validDuration
        ? l10n.nurseAvailDurationHoursMinutes(
            durationMinutes ~/ 60,
            durationMinutes % 60,
          )
        : l10n.nurseAvailInvalidTimeRange;

    return Container(
      decoration: const BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.vertical(top: Radius.circular(26))),
      padding: EdgeInsets.fromLTRB(20, 18, 20, MediaQuery.of(context).viewInsets.bottom + 20),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(child: Container(width: 36, height: 4, margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(color: const Color(0xFFE5E7EB), borderRadius: BorderRadius.circular(99)))),
            Row(children: [
              const Icon(Icons.access_time_rounded, color: AppColors.primary),
              const SizedBox(width: 10),
              Expanded(child: Text(l10n.nurseAvailAddWorkingHoursTitle,
                  style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 22, color: Color(0xFF1F2937)))),
              IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.close)),
            ]),
            Text(l10n.nurseAvailAddWorkingHoursSubtitle,
                style: const TextStyle(color: Color(0xFF6B7280), fontWeight: FontWeight.w600)),
            const SizedBox(height: 18),
            Text('${l10n.nurseAvailSelectDay} *', style: const TextStyle(fontWeight: FontWeight.w800)),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8, runSpacing: 8,
              children: days.map((day) {
                final isSelected = selectedDay == day;
                return ChoiceChip(
                  label: Text(_nurseAvailDayLabel(l10n, day)), selected: isSelected,
                  onSelected: (_) => setState(() => selectedDay = day),
                  selectedColor: AppColors.primary,
                  labelStyle: TextStyle(
                      color: isSelected ? Colors.white : const Color(0xFF4B5563),
                      fontWeight: FontWeight.w700),
                  backgroundColor: const Color(0xFFF8FAFC),
                  side: const BorderSide(color: Color(0xFFE2E8F0)),
                );
              }).toList(),
            ),
            const SizedBox(height: 16),
            _TimeField(label: '${l10n.nurseAvailStartTime} *', value: startTime.format(context), onTap: _pickStartTime),
            const SizedBox(height: 12),
            _TimeField(label: '${l10n.nurseAvailEndTime} *', value: endTime.format(context), onTap: _pickEndTime),
            const SizedBox(height: 14),
            Container(
              width: double.infinity, padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: const Color(0xFFE6F4F7), borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFBFE5EA))),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Row(children: [
                  const Icon(Icons.calendar_today_outlined, color: AppColors.primary, size: 16),
                  const SizedBox(width: 6),
                  Text(l10n.nurseAvailSummary, style: const TextStyle(fontWeight: FontWeight.w900, color: Color(0xFF1F2937))),
                ]),
                const SizedBox(height: 8),
                _SummaryRow(label: '${l10n.nurseAvailSummaryDay}:', value: _nurseAvailDayLabel(l10n, selectedDay)),
                _SummaryRow(label: '${l10n.nurseAvailSummaryHours}:', value: '${startTime.format(context)} - ${endTime.format(context)}'),
                _SummaryRow(label: '${l10n.nurseAvailSummaryDuration}:', value: summaryDuration),
              ]),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(color: const Color(0xFFFFFBEB), borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: const Color(0xFFFDE68A))),
              child: Text(
                l10n.nurseAvailBookingNote,
                style: const TextStyle(color: Color(0xFF92400E), fontSize: 12, fontWeight: FontWeight.w500),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity, height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14))),
                onPressed: () {
                  if (!validDuration) {
                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(l10n.nurseAvailEndAfterStart)));
                    return;
                  }
                  Navigator.pop(context, _AddSlotResult(day: selectedDay, start: _time24(startTime), end: _time24(endTime)));
                },
                child: Text(l10n.nurseAvailAddButton,
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 15)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  final String label;
  final String value;
  const _SummaryRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Color(0xFF6B7280), fontWeight: FontWeight.w600, fontSize: 13)),
          Text(value, style: const TextStyle(color: Color(0xFF1D2433), fontWeight: FontWeight.w800, fontSize: 13)),
        ],
      ),
    );
  }
}

class _TimeField extends StatelessWidget {
  final String label;
  final String value;
  final VoidCallback onTap;
  const _TimeField({required this.label, required this.value, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.w800)),
        const SizedBox(height: 8),
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
            decoration: BoxDecoration(color: const Color(0xFFF8FAFC), borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFDCE3ED))),
            child: Row(children: [
              const Icon(Icons.access_time, color: Color(0xFF94A3B8)),
              const SizedBox(width: 10),
              Text(value, style: const TextStyle(fontWeight: FontWeight.w700, color: Color(0xFF334155))),
            ]),
          ),
        ),
      ],
    );
  }
}

class _TimeSlot {
  final int? id;
  final String start;
  final String end;
  final bool isActive;

  const _TimeSlot({this.id, required this.start, required this.end, this.isActive = true});
}

class _AddSlotResult {
  final String day;
  final String start;
  final String end;
  const _AddSlotResult({required this.day, required this.start, required this.end});
}
