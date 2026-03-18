import 'package:flutter/material.dart';
import 'package:nurse_app/Core/theme/app_colors.dart';

class NurseAvailabilityScreen extends StatefulWidget {
  const NurseAvailabilityScreen({super.key});

  @override
  State<NurseAvailabilityScreen> createState() =>
      _NurseAvailabilityScreenState();
}

class _NurseAvailabilityScreenState extends State<NurseAvailabilityScreen> {
  DateTime _selectedDate = DateTime.now();
  final Set<String> _blockedDates = {};

  final Map<String, List<_TimeSlot>> _weeklySlots = {
    'Monday': [const _TimeSlot(start: '08:00', end: '16:00')],
    'Tuesday': [const _TimeSlot(start: '08:00', end: '16:00')],
    'Wednesday': [],
    'Thursday': [],
    'Friday': [],
    'Saturday': [],
    'Sunday': [],
  };

  @override
  void initState() {
    super.initState();
    _loadAvailability();
  }

  Future<void> _loadAvailability() async {
    // TODO(Abeer): replace mock data with a real backend call.
    // Suggested flow:
    //   final response = await ApiService.getNurseAvailability();
    //   setState(() {
    //     _weeklySlots = mapResponseToWeeklySlots(response['weeklySlots']);
    //     _blockedDates = Set<String>.from(response['blockedDates'] ?? []);
    //   });
  }

  Future<void> _saveAvailability() async {
    // TODO(Abeer): push availability payload to backend.
    // Suggested flow:
    //   await ApiService.updateNurseAvailability(
    //     weeklySlots: mapWeeklySlotsToPayload(_weeklySlots),
    //     blockedDates: _blockedDates.toList(),
    //   );
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Availability saved successfully')),
    );
  }

  Future<void> _openAddTimeSlotSheet() async {
    final result = await showModalBottomSheet<_AddSlotResult>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const _AddTimeSlotSheet(),
    );
    if (result == null) return;
    setState(() {
      _weeklySlots[result.day] = [
        ...(_weeklySlots[result.day] ?? []),
        _TimeSlot(start: result.start, end: result.end),
      ];
    });
  }

  Future<void> _openManageDaySheet(DateTime date) async {
    final weekdayName = _weekdayName(date.weekday);
    final slots = List<_TimeSlot>.from(_weeklySlots[weekdayName] ?? []);
    final dateKey = _dateKey(date);
    final isBlocked = _blockedDates.contains(dateKey);

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => _ManageDaySheet(
        date: date,
        slots: slots,
        isBlocked: isBlocked,
        onBlock: () {
          setState(() => _blockedDates.add(dateKey));
          Navigator.pop(ctx);
        },
        onUnblock: () {
          setState(() => _blockedDates.remove(dateKey));
          Navigator.pop(ctx);
        },
        onOverrideHours: (start, end) {
          // TODO(Abeer): persist date-specific override to backend.
          // ApiService.setDateOverride(date: date, start: start, end: end);
          Navigator.pop(ctx);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Working hours overridden: $start – $end for this date',
              ),
            ),
          );
        },
      ),
    );
  }

  void _disableSlot(String day, int index) {
    setState(() => _weeklySlots[day]?.removeAt(index));
  }

  String _dateKey(DateTime d) =>
      '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

  String _weekdayName(int weekday) {
    const names = [
      '',
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday',
    ];
    return names[weekday];
  }

  @override
  Widget build(BuildContext context) {
    const days = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday',
    ];

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 18, 16, 110),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Manage Availability',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w900,
                  color: Color(0xFF1D2433),
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'Tap any date to manage or block it',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF6B7280),
                ),
              ),
              const SizedBox(height: 14),
              _CalendarCard(
                selectedDate: _selectedDate,
                blockedDates: _blockedDates,
                onDateTapped: (date) {
                  setState(() => _selectedDate = date);
                  _openManageDaySheet(date);
                },
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x12000000),
                      blurRadius: 12,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    const Expanded(
                      child: Text(
                        'Weekly Schedule',
                        style: TextStyle(
                          fontWeight: FontWeight.w900,
                          fontSize: 18,
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
                      onPressed: _openAddTimeSlotSheet,
                      icon: const Icon(Icons.add, size: 18),
                      label: const Text('Add Time Slot'),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),
              ...days.map((day) {
                final daySlots = _weeklySlots[day] ?? const <_TimeSlot>[];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: _DayScheduleCard(
                    day: day,
                    slots: daySlots,
                    onDisable: (index) => _disableSlot(day, index),
                  ),
                );
              }),
              const SizedBox(height: 6),
              _QuickSettingsCard(
                onCopyWeekdays: () {
                  setState(() {
                    const t = _TimeSlot(start: '08:00', end: '16:00');
                    _weeklySlots['Monday'] = [t];
                    _weeklySlots['Tuesday'] = [t];
                    _weeklySlots['Wednesday'] = [t];
                    _weeklySlots['Thursday'] = [t];
                    _weeklySlots['Friday'] = [t];
                  });
                },
                onSetWeekend: () {
                  setState(() {
                    const t = _TimeSlot(start: '10:00', end: '14:00');
                    _weeklySlots['Saturday'] = [t];
                    _weeklySlots['Sunday'] = [t];
                  });
                },
                onBlockDays: () {
                  setState(() {
                    _weeklySlots['Friday'] = [];
                    _weeklySlots['Saturday'] = [];
                  });
                },
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        minimum: const EdgeInsets.fromLTRB(16, 0, 16, 12),
        child: SizedBox(
          height: 52,
          child: ElevatedButton.icon(
            onPressed: _saveAvailability,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            icon: const Icon(Icons.save_outlined, color: Colors.white),
            label: const Text(
              'Save Availability',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w800,
                fontSize: 16,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ─── Improved Calendar Card ───────────────────────────────────────────────────

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
    _displayMonth = DateTime(widget.selectedDate.year, widget.selectedDate.month);
  }

  void _prevMonth() => setState(() {
        _displayMonth = DateTime(_displayMonth.year, _displayMonth.month - 1);
      });

  void _nextMonth() => setState(() {
        _displayMonth = DateTime(_displayMonth.year, _displayMonth.month + 1);
      });

  @override
  Widget build(BuildContext context) {
    final year = _displayMonth.year;
    final month = _displayMonth.month;
    final daysInMonth = DateUtils.getDaysInMonth(year, month);
    final today = DateTime.now();

    // Flutter weekday: Mon=1 … Sun=7. Convert to Sunday-first offset (Sun=0 … Sat=6)
    final rawWeekday = DateTime(year, month, 1).weekday; // 1-7
    final startOffset = rawWeekday % 7; // Mon→1, Tue→2, … Sat→6, Sun→0

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
                decoration:
                    isBlocked ? TextDecoration.lineThrough : TextDecoration.none,
              ),
            ),
          ),
        ),
      );
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: const [
          BoxShadow(
            color: Color(0x12000000),
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                '${_monthName(month)} $year',
                style: const TextStyle(
                  fontSize: 20,
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
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _WeekLabel('S'),
              _WeekLabel('M'),
              _WeekLabel('T'),
              _WeekLabel('W'),
              _WeekLabel('T'),
              _WeekLabel('F'),
              _WeekLabel('S'),
            ],
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

  String _monthName(int m) {
    const months = [
      '',
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];
    return months[m];
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
        width: 32,
        height: 32,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: const Color(0xFFF3F4F6),
          borderRadius: BorderRadius.circular(8),
        ),
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
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: const TextStyle(
          color: Color(0xFF9CA3AF),
          fontWeight: FontWeight.w700,
          fontSize: 12,
        ),
      ),
    );
  }
}

// ─── Manage Day Bottom Sheet ──────────────────────────────────────────────────

enum _SheetMode { normal, override, block }

class _ManageDaySheet extends StatefulWidget {
  final DateTime date;
  final List<_TimeSlot> slots;
  final bool isBlocked;
  final VoidCallback onBlock;
  final VoidCallback onUnblock;
  final void Function(String start, String end) onOverrideHours;

  // TODO(Abeer): replace mockAppointments with real data from the API.
  // Call: ApiService.getAppointmentsForDate(date: date)
  // Expected response: List<Map> with keys: 'time', 'service', 'patient'
  static const List<Map<String, String>> mockAppointments = [
    {'time': '10:00 AM', 'service': 'IV Therapy', 'patient': 'Ahmad M.'},
    {'time': '02:00 PM', 'service': 'Wound Care', 'patient': 'Layla K.'},
  ];

  const _ManageDaySheet({
    required this.date,
    required this.slots,
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

  static String _formatDate(DateTime d) {
    const weekdays = [
      '',
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday',
    ];
    const months = [
      '',
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];
    return '${weekdays[d.weekday]}, ${months[d.month]} ${d.day}, ${d.year}';
  }

  String _time24(TimeOfDay t) =>
      '${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}';

  Future<void> _pickStart() async {
    final p = await showTimePicker(context: context, initialTime: _overrideStart);
    if (p != null) setState(() => _overrideStart = p);
  }

  Future<void> _pickEnd() async {
    final p = await showTimePicker(context: context, initialTime: _overrideEnd);
    if (p != null) setState(() => _overrideEnd = p);
  }

  @override
  Widget build(BuildContext context) {
    final defaultHours = widget.slots.isNotEmpty
        ? '${widget.slots.first.start} - ${widget.slots.first.end}'
        : null;
    final dateStr = _formatDate(widget.date);
    final apptCount = _ManageDaySheet.mockAppointments.length;

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: EdgeInsets.fromLTRB(
        20,
        18,
        20,
        MediaQuery.of(context).viewInsets.bottom + 28,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Drag handle
            Center(
              child: Container(
                width: 36,
                height: 4,
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: const Color(0xFFE5E7EB),
                  borderRadius: BorderRadius.circular(99),
                ),
              ),
            ),

            // Title row
            Row(
              children: [
                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.calendar_today_outlined,
                    color: AppColors.primary,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Manage Day',
                        style: TextStyle(
                          fontWeight: FontWeight.w900,
                          fontSize: 22,
                          color: Color(0xFF1D2433),
                        ),
                      ),
                      Text(
                        dateStr,
                        style: const TextStyle(
                          color: Color(0xFF6B7280),
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close, color: Color(0xFF374151)),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Divider(height: 1, color: Color(0xFFEEF0F3)),
            const SizedBox(height: 16),

            // Default working hours card
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
                  Row(
                    children: const [
                      Icon(Icons.access_time_outlined, color: AppColors.primary, size: 15),
                      SizedBox(width: 6),
                      Text(
                        'Default Working Hours',
                        style: TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w700,
                          fontSize: 12.5,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    defaultHours ?? 'No scheduled hours for this day',
                    style: TextStyle(
                      fontWeight: FontWeight.w900,
                      fontSize: defaultHours != null ? 22 : 14,
                      color: const Color(0xFF1D2433),
                    ),
                  ),
                  const SizedBox(height: 2),
                  const Text(
                    'From your weekly schedule',
                    style: TextStyle(
                      color: Color(0xFF6B7280),
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Booked appointments
            Row(
              children: [
                const Icon(Icons.remove_red_eye_outlined, color: Color(0xFF374151), size: 17),
                const SizedBox(width: 6),
                Text(
                  'Booked Appointments ($apptCount)',
                  style: const TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 15,
                    color: Color(0xFF1D2433),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            ..._ManageDaySheet.mockAppointments.map(
              (appt) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            appt['time']!,
                            style: const TextStyle(
                              fontWeight: FontWeight.w800,
                              color: Color(0xFF374151),
                              fontSize: 14,
                            ),
                          ),
                          Text(
                            appt['service']!,
                            style: const TextStyle(
                              color: Color(0xFF6B7280),
                              fontSize: 12.5,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      appt['patient']!,
                      style: const TextStyle(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 8),
            const Divider(height: 1, color: Color(0xFFEEF0F3)),
            const SizedBox(height: 12),

            // ── Normal mode: action tiles ────────────────────────────────────
            if (_mode == _SheetMode.normal) ...[
              _ActionTile(
                icon: Icons.edit_outlined,
                iconColor: AppColors.primary,
                label: 'Override Working Hours',
                subtitle: 'Set custom hours for this date only',
                onTap: () => setState(() => _mode = _SheetMode.override),
              ),
              const SizedBox(height: 8),
              _ActionTile(
                icon: widget.isBlocked ? Icons.check_circle_outline : Icons.block,
                iconColor: widget.isBlocked
                    ? const Color(0xFF059669)
                    : const Color(0xFFDC2626),
                label: widget.isBlocked ? 'Unblock This Day' : 'Block This Day',
                subtitle: widget.isBlocked
                    ? 'Make this day available again'
                    : 'Mark as unavailable (vacation, day off)',
                onTap: widget.isBlocked
                    ? widget.onUnblock
                    : () => setState(() => _mode = _SheetMode.block),
              ),
            ],

            // ── Override mode: inline time pickers ───────────────────────────
            if (_mode == _SheetMode.override) ...[
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
                    Text(
                      'Set custom working hours for $dateStr',
                      style: const TextStyle(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w700,
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(height: 14),
                    const Text(
                      'Start Time',
                      style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
                    ),
                    const SizedBox(height: 6),
                    _TimePickerField(
                      value: _overrideStart.format(context),
                      onTap: _pickStart,
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'End Time',
                      style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
                    ),
                    const SizedBox(height: 6),
                    _TimePickerField(
                      value: _overrideEnd.format(context),
                      onTap: _pickEnd,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => setState(() => _mode = _SheetMode.normal),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Color(0xFFE5E7EB)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: const Text(
                        'Cancel',
                        style: TextStyle(fontWeight: FontWeight.w700, color: Color(0xFF374151)),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => widget.onOverrideHours(
                        _time24(_overrideStart),
                        _time24(_overrideEnd),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: const Text(
                        'Save Override',
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800),
                      ),
                    ),
                  ),
                ],
              ),
            ],

            // ── Block mode: confirmation ─────────────────────────────────────
            if (_mode == _SheetMode.block) ...[
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: const Color(0xFFFEF2F2),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: const Color(0xFFFECACA)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Block $dateStr?',
                      style: const TextStyle(
                        color: Color(0xFFDC2626),
                        fontWeight: FontWeight.w800,
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      'This day will be marked as unavailable. Patients will not be able to book appointments.',
                      style: TextStyle(
                        color: Color(0xFF991B1B),
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('⚠️ ', style: TextStyle(fontSize: 13)),
                        Expanded(
                          child: Text(
                            'This will cancel $apptCount existing appointment(s)!',
                            style: const TextStyle(
                              color: Color(0xFF991B1B),
                              fontWeight: FontWeight.w800,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => setState(() => _mode = _SheetMode.normal),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Color(0xFFE5E7EB)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: const Text(
                        'Cancel',
                        style: TextStyle(fontWeight: FontWeight.w700, color: Color(0xFF374151)),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: widget.onBlock,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFDC2626),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: const Text(
                        'Block Day',
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800),
                      ),
                    ),
                  ),
                ],
              ),
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
          border: Border.all(color: const Color(0xFFDCE3ED)),
        ),
        child: Row(
          children: [
            const Icon(Icons.access_time, color: Color(0xFF94A3B8), size: 18),
            const SizedBox(width: 10),
            Text(
              value,
              style: const TextStyle(
                fontWeight: FontWeight.w700,
                color: Color(0xFF334155),
                fontSize: 14,
              ),
            ),
          ],
        ),
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
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.subtitle,
    required this.onTap,
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
          border: Border.all(color: const Color(0xFFE5E7EB)),
        ),
        child: Row(
          children: [
            Icon(icon, color: iconColor, size: 22),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: const TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 15,
                      color: Color(0xFF1D2433),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      color: Color(0xFF6B7280),
                      fontSize: 12.5,
                      fontWeight: FontWeight.w500,
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

// ─── Day Schedule Card ────────────────────────────────────────────────────────

class _DayScheduleCard extends StatelessWidget {
  final String day;
  final List<_TimeSlot> slots;
  final ValueChanged<int> onDisable;

  const _DayScheduleCard({
    required this.day,
    required this.slots,
    required this.onDisable,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                day,
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w900,
                  color: Color(0xFF1D2433),
                ),
              ),
              const Spacer(),
              if (slots.isNotEmpty)
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: const Color(0xFFECFDF5),
                    borderRadius: BorderRadius.circular(99),
                  ),
                  child: Text(
                    '${slots.length} slot${slots.length == 1 ? '' : 's'}',
                    style: const TextStyle(
                      color: Color(0xFF059669),
                      fontWeight: FontWeight.w800,
                      fontSize: 11.5,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 10),
          if (slots.isEmpty)
            const Text(
              'No time slots set for this day',
              style: TextStyle(
                color: Color(0xFF9CA3AF),
                fontWeight: FontWeight.w600,
                fontSize: 13,
              ),
            )
          else
            ...slots.asMap().entries.map((entry) {
              final index = entry.key;
              final slot = entry.value;
              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF9FAFB),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.access_time,
                        size: 16,
                        color: AppColors.primary,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        '${slot.start} - ${slot.end}',
                        style: const TextStyle(
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF374151),
                        ),
                      ),
                      const Spacer(),
                      TextButton.icon(
                        onPressed: () => onDisable(index),
                        icon: const Icon(Icons.block, size: 15),
                        label: const Text('Disable'),
                        style: TextButton.styleFrom(
                          foregroundColor: const Color(0xFFDC2626),
                          visualDensity: VisualDensity.compact,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
        ],
      ),
    );
  }
}

// ─── Quick Settings ───────────────────────────────────────────────────────────

class _QuickSettingsCard extends StatelessWidget {
  final VoidCallback onCopyWeekdays;
  final VoidCallback onSetWeekend;
  final VoidCallback onBlockDays;

  const _QuickSettingsCard({
    required this.onCopyWeekdays,
    required this.onSetWeekend,
    required this.onBlockDays,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Quick Settings',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w900,
              fontSize: 15,
            ),
          ),
          const SizedBox(height: 10),
          _QuickSettingButton(
            label: 'Copy to All Weekdays',
            subtitle: 'Apply Monday schedule to Tue–Fri',
            onTap: onCopyWeekdays,
          ),
          const SizedBox(height: 8),
          _QuickSettingButton(
            label: 'Set Weekend Availability',
            subtitle: 'Configure Saturday & Sunday hours',
            onTap: onSetWeekend,
          ),
          const SizedBox(height: 8),
          _QuickSettingButton(
            label: 'Block Specific Days',
            subtitle: 'Mark days when you\'re unavailable',
            onTap: onBlockDays,
          ),
        ],
      ),
    );
  }
}

class _QuickSettingButton extends StatelessWidget {
  final String label;
  final String subtitle;
  final VoidCallback onTap;

  const _QuickSettingButton({
    required this.label,
    required this.subtitle,
    required this.onTap,
  });

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
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w800,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 3),
            Text(
              subtitle,
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.86),
                fontWeight: FontWeight.w500,
                fontSize: 11.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Add Time Slot Sheet ──────────────────────────────────────────────────────

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
    final picked =
        await showTimePicker(context: context, initialTime: startTime);
    if (picked != null) setState(() => startTime = picked);
  }

  Future<void> _pickEndTime() async {
    final picked = await showTimePicker(context: context, initialTime: endTime);
    if (picked != null) setState(() => endTime = picked);
  }

  String _time24(TimeOfDay t) =>
      '${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}';

  @override
  Widget build(BuildContext context) {
    const days = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday',
    ];

    final durationMinutes = (endTime.hour * 60 + endTime.minute) -
        (startTime.hour * 60 + startTime.minute);
    final validDuration = durationMinutes > 0;
    final summaryDuration =
        validDuration ? '${durationMinutes ~/ 60} hours' : 'Invalid range';

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(26)),
      ),
      padding: EdgeInsets.fromLTRB(
        20,
        18,
        20,
        MediaQuery.of(context).viewInsets.bottom + 20,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 36,
                height: 4,
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: const Color(0xFFE5E7EB),
                  borderRadius: BorderRadius.circular(99),
                ),
              ),
            ),
            Row(
              children: [
                const Icon(
                  Icons.access_time_rounded,
                  color: AppColors.primary,
                ),
                const SizedBox(width: 10),
                const Expanded(
                  child: Text(
                    'Add Working Hours',
                    style: TextStyle(
                      fontWeight: FontWeight.w900,
                      fontSize: 22,
                      color: Color(0xFF1F2937),
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
            const Text(
              'Set your weekly schedule',
              style: TextStyle(
                color: Color(0xFF6B7280),
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 18),
            const Text(
              'Select Day *',
              style: TextStyle(fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: days.map((day) {
                final isSelected = selectedDay == day;
                return ChoiceChip(
                  label: Text(day),
                  selected: isSelected,
                  onSelected: (_) => setState(() => selectedDay = day),
                  selectedColor: AppColors.primary,
                  labelStyle: TextStyle(
                    color: isSelected ? Colors.white : const Color(0xFF4B5563),
                    fontWeight: FontWeight.w700,
                  ),
                  backgroundColor: const Color(0xFFF8FAFC),
                  side: const BorderSide(color: Color(0xFFE2E8F0)),
                );
              }).toList(),
            ),
            const SizedBox(height: 16),
            _TimeField(
              label: 'Start Time *',
              value: startTime.format(context),
              onTap: _pickStartTime,
            ),
            const SizedBox(height: 12),
            _TimeField(
              label: 'End Time *',
              value: endTime.format(context),
              onTap: _pickEndTime,
            ),
            const SizedBox(height: 14),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFE6F4F7),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFBFE5EA)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(
                        Icons.calendar_today_outlined,
                        color: AppColors.primary,
                        size: 16,
                      ),
                      SizedBox(width: 6),
                      Text(
                        'Summary',
                        style: TextStyle(
                          fontWeight: FontWeight.w900,
                          color: Color(0xFF1F2937),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  _SummaryRow(label: 'Day:', value: selectedDay),
                  _SummaryRow(
                    label: 'Hours:',
                    value:
                        '${startTime.format(context)} - ${endTime.format(context)}',
                  ),
                  _SummaryRow(label: 'Duration:', value: summaryDuration),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: const Color(0xFFFFFBEB),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: const Color(0xFFFDE68A)),
              ),
              child: const Text(
                'Note: The system will automatically generate available booking slots based on your working hours and service durations.',
                style: TextStyle(
                  color: Color(0xFF92400E),
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                onPressed: () {
                  if (!validDuration) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('End time must be after start time'),
                      ),
                    );
                    return;
                  }
                  Navigator.pop(
                    context,
                    _AddSlotResult(
                      day: selectedDay,
                      start: _time24(startTime),
                      end: _time24(endTime),
                    ),
                  );
                },
                child: const Text(
                  'Add Working Hours',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                    fontSize: 15,
                  ),
                ),
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
          Text(
            label,
            style: const TextStyle(
              color: Color(0xFF6B7280),
              fontWeight: FontWeight.w600,
              fontSize: 13,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              color: Color(0xFF1D2433),
              fontWeight: FontWeight.w800,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }
}

class _TimeField extends StatelessWidget {
  final String label;
  final String value;
  final VoidCallback onTap;

  const _TimeField({
    required this.label,
    required this.value,
    required this.onTap,
  });

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
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFDCE3ED)),
            ),
            child: Row(
              children: [
                const Icon(Icons.access_time, color: Color(0xFF94A3B8)),
                const SizedBox(width: 10),
                Text(
                  value,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF334155),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

// ─── Models ───────────────────────────────────────────────────────────────────

class _TimeSlot {
  final String start;
  final String end;

  const _TimeSlot({required this.start, required this.end});
}

class _AddSlotResult {
  final String day;
  final String start;
  final String end;

  const _AddSlotResult({required this.day, required this.start, required this.end});
}
