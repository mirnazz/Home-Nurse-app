import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:nurse_app/Core/models/appointment.dart';
import 'package:nurse_app/Core/theme/api/api_service.dart';
import 'package:nurse_app/Core/theme/app_colors.dart';
import 'package:nurse_app/Core/theme/appointment_ui_colors.dart';
import 'package:nurse_app/Core/widgets/appointment_list_card.dart';
import 'package:nurse_app/Features/Nurse/Presentation/nurse_appointment_details_screen.dart';

class NurseAppointmentsScreen extends StatefulWidget {
  final List<Appointment>? appointments;

  /// When true, used inside another screen without an extra Scaffold.
  final bool embedded;

  const NurseAppointmentsScreen({
    super.key,
    this.appointments,
    this.embedded = false,
  });

  @override
  State<NurseAppointmentsScreen> createState() => _NurseAppointmentsScreenState();
}

class _NurseAppointmentsScreenState extends State<NurseAppointmentsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _appointmentsTabController;

  List<Appointment> _todayAppointments = [];
  List<Appointment> _upcomingAppointments = [];
  List<Appointment> _pastAppointments = [];

  bool _isLoading = true;
  bool _isOpeningDetails = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _appointmentsTabController = TabController(length: 3, vsync: this);
    _appointmentsTabController.addListener(() {
      if (mounted) setState(() {});
    });

    _loadAppointments();
  }

  @override
  void dispose() {
    _appointmentsTabController.dispose();
    super.dispose();
  }

  Future<void> _loadAppointments() async {
    if (widget.appointments != null) {
      final provided = List<Appointment>.from(widget.appointments!);

      if (!mounted) return;
      setState(() {
        _todayAppointments = provided;
        _upcomingAppointments = provided;
        _pastAppointments = const [];
        _isLoading = false;
        _error = null;
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final results = await Future.wait<List<Appointment>>([
        ApiService.getNurseAppointments(tab: 'today'),
        ApiService.getNurseAppointments(tab: 'upcoming'),
        ApiService.getNurseAppointments(tab: 'past'),
      ]);

      if (!mounted) return;

      setState(() {
        _todayAppointments = results[0];
        _upcomingAppointments = results[1];
        _pastAppointments = results[2];
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _error = e.toString().replaceFirst('Exception: ', '');
        _isLoading = false;
      });
    }
  }

  Future<void> _openDetails(Appointment appointment) async {
    if (_isOpeningDetails) return;

    setState(() {
      _isOpeningDetails = true;
    });

    try {
      final details = await ApiService.getNurseAppointmentDetails(
        bookingId: appointment.id,
      );

      if (!mounted) return;

      await Navigator.of(context).push<void>(
        MaterialPageRoute<void>(
          builder: (_) => NurseAppointmentDetailsScreen(appointment: details),
        ),
      );

      if (!mounted) return;
      await _loadAppointments();
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            e.toString().replaceFirst('Exception: ', ''),
          ),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isOpeningDetails = false;
        });
      }
    }
  }

  Widget _buildEmptyState(String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Text(
          message,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.grey.shade600,
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
        ),
      ),
    );
  }

  Widget _buildListView(List<Appointment> list, String emptyMessage) {
    final listBottomPad = widget.embedded ? 16.0 : 100.0;

    if (list.isEmpty) {
      return _buildEmptyState(emptyMessage);
    }

    return RefreshIndicator(
      onRefresh: _loadAppointments,
      child: ListView.separated(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.fromLTRB(
          AppointmentUiColors.scheduleListHorizontalPadding,
          AppointmentUiColors.scheduleListVerticalGap,
          AppointmentUiColors.scheduleListHorizontalPadding,
          listBottomPad,
        ),
        itemCount: list.length,
        separatorBuilder: (_, __) =>
            const SizedBox(height: AppointmentUiColors.scheduleListVerticalGap),
        itemBuilder: (context, index) {
          final apt = list[index];
          return AppointmentListCard(
            appointment: apt,
            isNurseView: true,
            onTap: () => _openDetails(apt),
          );
        },
      ),
    );
  }

  Widget _buildErrorState() {
    final l10n = AppLocalizations.of(context)!;
    final errorText = (_error != null && _error!.toLowerCase().contains('user not logged in'))
        ? l10n.nurseLoginRequiredShort
        : (_error ?? l10n.nurseAppointmentsErrorGeneric);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              errorText,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.grey.shade700,
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 14),
            ElevatedButton(
              onPressed: _loadAppointments,
              child: Text(l10n.nurseRetry),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBody() {
    final l10n = AppLocalizations.of(context)!;
    final today = _todayAppointments;
    final upcoming = _upcomingAppointments;
    final past = _pastAppointments;

    final primary = AppointmentUiColors.tealHeader;
    final todayCount = today.length;
    final upcomingCount = upcoming.length;
    final pastCount = past.length;

    final header = Container(
      padding: const EdgeInsets.fromLTRB(18, 16, 18, 14),
      decoration: BoxDecoration(
        color: primary,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.nurseAppointmentsTitle,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w900,
              fontSize: 20,
              height: 1.2,
            ),
          ),
          const SizedBox(height: 14),
          Material(
            color: primary,
            child: TabBar(
              controller: _appointmentsTabController,
              labelColor: Colors.white,
              unselectedLabelColor: const Color(0x80FFFFFF),
              indicatorColor: Colors.white,
              indicatorWeight: 3,
              indicatorSize: TabBarIndicatorSize.tab,
              labelStyle: const TextStyle(
                fontWeight: FontWeight.w900,
                fontSize: 13,
              ),
              unselectedLabelStyle: const TextStyle(
                fontWeight: FontWeight.w800,
                fontSize: 13,
              ),
              tabs: [
                Tab(text: l10n.nurseAppointmentsTabToday(todayCount)),
                Tab(text: l10n.nurseAppointmentsTabUpcoming(upcomingCount)),
                Tab(text: l10n.nurseAppointmentsTabPast(pastCount)),
              ],
            ),
          ),
        ],
      ),
    );

    Widget content;
    if (_isLoading) {
      content = const Center(child: CircularProgressIndicator());
    } else if (_error != null) {
      content = _buildErrorState();
    } else {
      content = TabBarView(
        controller: _appointmentsTabController,
        children: [
          _buildListView(today, l10n.nurseAppointmentsEmpty),
          _buildListView(upcoming, l10n.nurseAppointmentsEmpty),
          _buildListView(past, l10n.nurseAppointmentsEmpty),
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        header,
        Expanded(child: content),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final body = _buildBody();

    if (widget.embedded) {
      return ColoredBox(
        color: AppColors.background,
        child: body,
      );
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      body: body,
    );
  }
}
