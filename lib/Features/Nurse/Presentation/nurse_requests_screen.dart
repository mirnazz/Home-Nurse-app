import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nurse_app/Core/theme/api/api_service.dart';
import 'package:nurse_app/Core/theme/app_colors.dart';
import 'package:nurse_app/Features/Nurse/Presentation/nurse_appointment_details_screen.dart';
import 'package:nurse_app/Features/Nurse/Presentation/nurse_service_request_models.dart';

class NurseRequestsScreen extends StatefulWidget {
  const NurseRequestsScreen({super.key});

  @override
  State<NurseRequestsScreen> createState() => _NurseRequestsScreenState();
}

class _NurseRequestsScreenState extends State<NurseRequestsScreen>
    with SingleTickerProviderStateMixin {
  NurseRequestsFilter _activeFilter = NurseRequestsFilter.pending;

  bool _isLoading = true;
  bool _hasError = false;

  List<NurseServiceRequestItem> _pendingRequests = const [];
  List<NurseServiceRequestItem> _rejectedRequests = const [];

  final Set<String> _updatingRequestIds = <String>{};

  late TabController _filterTabController;

  @override
  void initState() {
    super.initState();
    _filterTabController = TabController(
      length: 2,
      vsync: this,
      initialIndex: _activeFilter == NurseRequestsFilter.pending ? 0 : 1,
    );

    _filterTabController.addListener(() {
      if (_filterTabController.indexIsChanging) return;

      final next = _filterTabController.index == 0
          ? NurseRequestsFilter.pending
          : NurseRequestsFilter.rejected;

      if (next != _activeFilter) {
        setState(() => _activeFilter = next);
      }
    });

    _loadRequests();
  }

  @override
  void dispose() {
    _filterTabController.dispose();
    super.dispose();
  }

  Future<List<NurseServiceRequestItem>> _fetchRequestsByStatus(
    String status,
  ) async {
    final loadedJson = await ApiService.getNurseRequests(status: status);

    return loadedJson
        .map(
          (e) => NurseServiceRequestItem.fromApiJson(
            e as Map<String, dynamic>,
          ),
        )
        .toList();
  }

  Future<void> _loadRequests() async {
    setState(() {
      _isLoading = true;
      _hasError = false;
    });

    try {
      final results = await Future.wait<List<NurseServiceRequestItem>>([
        _fetchRequestsByStatus('Pending'),
        _fetchRequestsByStatus('Rejected'),
      ]);

      if (!mounted) return;

      setState(() {
        _pendingRequests = results[0];
        _rejectedRequests = results[1];
        _isLoading = false;
      });
    } catch (e) {
      debugPrint('ERROR loading nurse requests: $e');

      if (!mounted) return;
      setState(() {
        _hasError = true;
        _isLoading = false;
      });
    }
  }

  Future<void> _openRequestDetails(NurseServiceRequestItem request) async {
    try {
      final details = await ApiService.getNurseAppointmentDetails(
        bookingId: request.requestId,
      );

      if (!mounted) return;

      await Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => NurseAppointmentDetailsScreen(
            appointment: details,
          ),
        ),
      );

      if (!mounted) return;
      await _loadRequests();
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            e.toString().replaceFirst('Exception: ', ''),
          ),
        ),
      );
    }
  }

  List<NurseServiceRequestItem> get _filteredRequests {
    switch (_activeFilter) {
      case NurseRequestsFilter.pending:
        return _pendingRequests;
      case NurseRequestsFilter.rejected:
        return _rejectedRequests;
    }
  }

  Future<bool?> _showRejectDialog() {
    return showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Reject Request'),
          content: const Text(
            'Are you sure you want to reject this request?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('No'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFDC2626),
                foregroundColor: Colors.white,
              ),
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Reject'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _applyStatus({
    required NurseServiceRequestItem request,
    required NurseServiceRequestStatus status,
  }) async {
    if (_updatingRequestIds.contains(request.requestId)) return;

    if (status == NurseServiceRequestStatus.declined) {
      final confirmed = await _showRejectDialog();
      if (confirmed != true) return;
    }

    setState(() => _updatingRequestIds.add(request.requestId));

    try {
      final bookingId = int.parse(request.requestId);

      if (status == NurseServiceRequestStatus.accepted) {
        await ApiService.acceptNurseRequest(bookingId: bookingId);
      } else if (status == NurseServiceRequestStatus.declined) {
        await ApiService.declineNurseRequest(bookingId: bookingId);
      }

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            status == NurseServiceRequestStatus.accepted
                ? 'Request accepted successfully.'
                : 'Request rejected successfully.',
          ),
        ),
      );

      await _loadRequests();
    } catch (e) {
      debugPrint('ERROR updating request status: $e');

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
        setState(() => _updatingRequestIds.remove(request.requestId));
      }
    }
  }

  String get _headerSubtitle {
    switch (_activeFilter) {
      case NurseRequestsFilter.pending:
        return '${_pendingRequests.length} pending requests';
      case NurseRequestsFilter.rejected:
        return '${_rejectedRequests.length} rejected requests';
    }
  }

  String get _emptyTitle {
    switch (_activeFilter) {
      case NurseRequestsFilter.pending:
        return 'No pending requests';
      case NurseRequestsFilter.rejected:
        return 'No rejected requests';
    }
  }

  String get _emptySubtitle {
    switch (_activeFilter) {
      case NurseRequestsFilter.pending:
        return 'New service requests will appear here.';
      case NurseRequestsFilter.rejected:
        return 'Rejected requests will appear here for reference.';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          decoration: const BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(24),
            ),
          ),
          padding: const EdgeInsets.fromLTRB(18, 12, 18, 12),
          child: SafeArea(
            bottom: false,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Service Requests',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 19,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  _headerSubtitle,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.85),
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 10),
                Material(
                  color: Colors.transparent,
                  child: TabBar(
                    controller: _filterTabController,
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
                      Tab(text: 'Pending (${_pendingRequests.length})'),
                      Tab(text: 'Rejected (${_rejectedRequests.length})'),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        Expanded(
          child: RefreshIndicator(
            onRefresh: _loadRequests,
            child: _buildBody(),
          ),
        ),
      ],
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_hasError) {
      return LayoutBuilder(
        builder: (context, constraints) {
          return ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(16, 10, 16, 100),
            children: [
              ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: Center(
                  child: _InfoStateCard(
                    icon: Icons.wifi_off_rounded,
                    title: 'Failed to load requests',
                    subtitle: 'Please check your connection and try again.',
                    actionText: 'Retry',
                    onTap: _loadRequests,
                  ),
                ),
              ),
            ],
          );
        },
      );
    }

    final visible = _filteredRequests;

    if (visible.isEmpty) {
      return LayoutBuilder(
        builder: (context, constraints) {
          return ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(16, 10, 16, 100),
            children: [
              ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: Center(
                  child: _InfoStateCard(
                    icon: Icons.inbox_outlined,
                    title: _emptyTitle,
                    subtitle: _emptySubtitle,
                  ),
                ),
              ),
            ],
          );
        },
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 100),
      itemBuilder: (context, index) {
        final request = visible[index];

        return _RequestCard(
          request: request,
          isActionLoading: _updatingRequestIds.contains(request.requestId),
          onTap: () => _openRequestDetails(request),
          onAccept: () => _applyStatus(
            request: request,
            status: NurseServiceRequestStatus.accepted,
          ),
          onReject: () => _applyStatus(
            request: request,
            status: NurseServiceRequestStatus.declined,
          ),
        );
      },
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemCount: visible.length,
    );
  }
}

class _RequestCard extends StatelessWidget {
  final NurseServiceRequestItem request;
  final bool isActionLoading;
  final VoidCallback onTap;
  final VoidCallback onAccept;
  final VoidCallback onReject;

  const _RequestCard({
    required this.request,
    required this.isActionLoading,
    required this.onTap,
    required this.onAccept,
    required this.onReject,
  });

  @override
  Widget build(BuildContext context) {
    final isPending = request.status == NurseServiceRequestStatus.pending;
    final dateStr = DateFormat('EEE, MMM d').format(request.dateTime);
    final timeStr = DateFormat.jm().format(request.dateTime);
    final accentBar = isPending
        ? const Color(0xFFE53935)
        : const Color(0xFFBDBDBD);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(18),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: const Color(0xFFE5E7EB)),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(width: 4, color: accentBar),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(12, 14, 14, 14),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    request.patientName,
                                    style: const TextStyle(
                                      color: Color(0xFF111827),
                                      fontWeight: FontWeight.w900,
                                      fontSize: 16,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    request.serviceName,
                                    style: const TextStyle(
                                      color: AppColors.primary,
                                      fontWeight: FontWeight.w800,
                                      fontSize: 13,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  '${request.priceJod} JOD',
                                  style: const TextStyle(
                                    color: Color(0xFF111827),
                                    fontWeight: FontWeight.w900,
                                    fontSize: 15,
                                  ),
                                ),
                                Text(
                                  '${request.durationMinutes} min',
                                  style: const TextStyle(
                                    color: Color(0xFF6B7280),
                                    fontWeight: FontWeight.w700,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Wrap(
                          spacing: 10,
                          runSpacing: 8,
                          children: [
                            _MetaText(
                              icon: Icons.calendar_today_outlined,
                              text: dateStr,
                            ),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Text(
                                  '•',
                                  style: TextStyle(
                                    color: Color(0xFF9CA3AF),
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                const SizedBox(width: 6),
                                _MetaText(
                                  icon: Icons.access_time_rounded,
                                  text: timeStr,
                                ),
                              ],
                            ),
                            _MetaText(
                              icon: Icons.location_on_outlined,
                              text: request.address,
                            ),
                            _MetaText(
                              icon: Icons.call_outlined,
                              text: request.phone,
                            ),
                          ],
                        ),
                        if (request.notes.trim().isNotEmpty) ...[
                          const SizedBox(height: 12),
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: const Color(0xFFE8EEF2),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Icon(
                                  Icons.chat_bubble_outline_rounded,
                                  size: 18,
                                  color: Color(0xFF5C7A8A),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    request.notes.trim(),
                                    style: const TextStyle(
                                      color: Color(0xFF37474F),
                                      fontWeight: FontWeight.w600,
                                      fontSize: 13,
                                      height: 1.35,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                        const SizedBox(height: 12),
                        if (!isPending)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFEE2E2),
                              borderRadius: BorderRadius.circular(999),
                            ),
                            child: const Text(
                              'Rejected',
                              style: TextStyle(
                                color: Color(0xFFDC2626),
                                fontWeight: FontWeight.w900,
                                fontSize: 11.5,
                              ),
                            ),
                          ),
                        if (isPending) ...[
                          Row(
                            children: [
                              Expanded(
                                child: OutlinedButton(
                                  onPressed: isActionLoading ? null : onReject,
                                  style: OutlinedButton.styleFrom(
                                    foregroundColor: const Color(0xFFDC2626),
                                    side: const BorderSide(
                                      color: Color(0xFFDC2626),
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  child: const Text(
                                    'Reject',
                                    style:
                                        TextStyle(fontWeight: FontWeight.w800),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: isActionLoading ? null : onAccept,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF22C55E),
                                    foregroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  child: isActionLoading
                                      ? const SizedBox(
                                          width: 17,
                                          height: 17,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                            color: Colors.white,
                                          ),
                                        )
                                      : const Text(
                                          'Accept',
                                          style: TextStyle(
                                            fontWeight: FontWeight.w800,
                                          ),
                                        ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _MetaText extends StatelessWidget {
  final IconData icon;
  final String text;

  const _MetaText({
    required this.icon,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: const Color(0xFF6B7280)),
        const SizedBox(width: 4),
        Flexible(
          child: Text(
            text,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: Color(0xFF6B7280),
              fontWeight: FontWeight.w700,
              fontSize: 11.5,
            ),
          ),
        ),
      ],
    );
  }
}

class _InfoStateCard extends StatelessWidget {
  final IconData? icon;
  final String title;
  final String subtitle;
  final String? actionText;
  final VoidCallback? onTap;

  const _InfoStateCard({
    this.icon,
    required this.title,
    required this.subtitle,
    this.actionText,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (icon != null) ...[
            Center(
              child: Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(
                  icon,
                  color: AppColors.primary,
                  size: 22,
                ),
              ),
            ),
            const SizedBox(height: 12),
          ],
          Text(
            title,
            style: const TextStyle(
              color: Color(0xFF111827),
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            subtitle,
            style: const TextStyle(
              color: Color(0xFF6B7280),
              fontWeight: FontWeight.w600,
            ),
          ),
          if (actionText != null && onTap != null) ...[
            const SizedBox(height: 14),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: onTap,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                child: Text(
                  actionText!,
                  style: const TextStyle(
                    fontWeight: FontWeight.w900,
                    fontSize: 13,
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

