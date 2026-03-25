import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nurse_app/Core/theme/api/api_service.dart';
import 'package:nurse_app/Core/theme/app_colors.dart';
import 'package:nurse_app/Features/Nurse/Presentation/nurse_service_request_models.dart';

class NurseRequestsScreen extends StatefulWidget {
  const NurseRequestsScreen({super.key});

  @override
  State<NurseRequestsScreen> createState() => _NurseRequestsScreenState();
}

class _NurseRequestsScreenState extends State<NurseRequestsScreen> {
  NurseRequestsFilter _activeFilter = NurseRequestsFilter.pending;
  bool _isLoading = true;
  bool _hasError = false;
  List<NurseServiceRequestItem> _requests = const [];
  final Set<String> _updatingRequestIds = <String>{};

  @override
  void initState() {
    super.initState();
    _loadRequests();
  }

  Future<void> _loadRequests() async {
    setState(() {
      _isLoading = true;
      _hasError = false;
    });

    try {
      final loadedJson = await ApiService.getNurseRequests();

      final loaded = loadedJson
          .map(
            (e) => NurseServiceRequestItem.fromApiJson(
              e as Map<String, dynamic>,
            ),
          )
          .toList();

      if (!mounted) return;

      setState(() {
        _requests = loaded;
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

  List<NurseServiceRequestItem> get _filteredRequests {
    switch (_activeFilter) {
      case NurseRequestsFilter.pending:
        return _requests
            .where((r) => r.status == NurseServiceRequestStatus.pending)
            .toList();

      case NurseRequestsFilter.rejected:
        return _requests
            .where((r) => r.status == NurseServiceRequestStatus.declined)
            .toList();
    }
  }

  Future<void> _applyStatus({
    required NurseServiceRequestItem request,
    required NurseServiceRequestStatus status,
  }) async {
    setState(() => _updatingRequestIds.add(request.requestId));

    try {
      final bookingId = int.parse(request.requestId);

      if (status == NurseServiceRequestStatus.accepted) {
        await ApiService.acceptNurseRequest(bookingId: bookingId);
      } else if (status == NurseServiceRequestStatus.declined) {
        await ApiService.declineNurseRequest(bookingId: bookingId);
      }

      if (!mounted) return;

      setState(() {
        _requests = _requests
            .map(
              (item) => item.requestId == request.requestId
                  ? item.copyWith(
                      status: status,
                      updatedAt: DateTime.now(),
                    )
                  : item,
            )
            .toList();
      });
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

  @override
  Widget build(BuildContext context) {
    final pendingCount = _requests
        .where((item) => item.status == NurseServiceRequestStatus.pending)
        .length;

    return Column(
      children: [
        Container(
          decoration: const BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(24),
            ),
          ),
          padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
          child: SafeArea(
            bottom: false,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Service Requests',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 21,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '$pendingCount pending requests',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.85),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 12),
                _FilterRow(
                  activeFilter: _activeFilter,
                  onChanged: (value) => setState(() => _activeFilter = value),
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
      return ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16),
        children: [
          _InfoStateCard(
            title: 'Failed to load requests',
            subtitle: 'Please check your connection and try again.',
            actionText: 'Retry',
            onTap: _loadRequests,
          ),
        ],
      );
    }

    final visible = _filteredRequests;

    if (visible.isEmpty) {
      return ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16),
        children: const [
          _InfoStateCard(
            title: 'No requests found',
            subtitle: 'Requests in this filter will appear here.',
          ),
        ],
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 100),
      itemBuilder: (context, index) {
        final request = visible[index];

        return _RequestCard(
          request: request,
          isActionLoading: _updatingRequestIds.contains(request.requestId),
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

class _FilterRow extends StatelessWidget {
  final NurseRequestsFilter activeFilter;
  final ValueChanged<NurseRequestsFilter> onChanged;

  const _FilterRow({
    required this.activeFilter,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _FilterChip(
            label: 'Pending',
            selected: activeFilter == NurseRequestsFilter.pending,
            onTap: () => onChanged(NurseRequestsFilter.pending),
          ),
          const SizedBox(width: 8),
          _FilterChip(
            label: 'Rejected',
            selected: activeFilter == NurseRequestsFilter.rejected,
            onTap: () => onChanged(NurseRequestsFilter.rejected),
          ),
        ],
      ),
    );
  }
}


class _FilterChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _FilterChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(999),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: selected ? Colors.white : Colors.white.withOpacity(0.25),
          borderRadius: BorderRadius.circular(999),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: selected ? AppColors.primary : Colors.white,
            fontWeight: FontWeight.w800,
            fontSize: 12,
          ),
        ),
      ),
    );
  }
}

class _RequestCard extends StatelessWidget {
  final NurseServiceRequestItem request;
  final bool isActionLoading;
  final VoidCallback onAccept;
  final VoidCallback onReject;

  const _RequestCard({
    required this.request,
    required this.isActionLoading,
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

    return ClipRRect(
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
                    if (!isPending) ...[
                      const SizedBox(height: 12),
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
                    ],
                    if (isPending) ...[
                      const SizedBox(height: 14),
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
                                style: TextStyle(fontWeight: FontWeight.w800),
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
        Text(
          text,
          style: const TextStyle(
            color: Color(0xFF6B7280),
            fontWeight: FontWeight.w700,
            fontSize: 11.5,
          ),
        ),
      ],
    );
  }
}

class _InfoStateCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String? actionText;
  final VoidCallback? onTap;

  const _InfoStateCard({
    required this.title,
    required this.subtitle,
    this.actionText,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
            const SizedBox(height: 10),
            TextButton(
              onPressed: onTap,
              child: Text(
                actionText!,
                style: const TextStyle(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

