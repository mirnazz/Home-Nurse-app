import 'package:flutter/material.dart';
import 'package:nurse_app/Core/theme/api/api_service.dart';
import 'package:nurse_app/Core/theme/app_colors.dart';
import 'package:nurse_app/Features/Nurse/Presentation/nurse_service_request_models.dart';

class NurseRequestsScreen extends StatefulWidget {
  const NurseRequestsScreen({super.key});

  @override
  State<NurseRequestsScreen> createState() => _NurseRequestsScreenState();
}

class _NurseRequestsScreenState extends State<NurseRequestsScreen> {
  NurseRequestsFilter _activeFilter = NurseRequestsFilter.all;
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

    case NurseRequestsFilter.accepted:
      return _requests
          .where((r) => r.status == NurseServiceRequestStatus.accepted)
          .toList();

    case NurseRequestsFilter.declined:
      return _requests
          .where((r) => r.status == NurseServiceRequestStatus.declined)
          .toList();

    case NurseRequestsFilter.all:
      return _requests;
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

  void _openDetails(NurseServiceRequestItem request) {
    showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (dialogContext) {
        final isActionLoading = _updatingRequestIds.contains(request.requestId);

        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          titlePadding: const EdgeInsets.fromLTRB(20, 18, 20, 8),
          contentPadding: const EdgeInsets.fromLTRB(20, 8, 20, 8),
          actionsPadding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
          title: const Text(
            'Request Details',
            style: TextStyle(
              fontWeight: FontWeight.w900,
              fontSize: 18,
              color: Color(0xFF111827),
            ),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _DetailLine(label: 'Patient', value: request.patientName),
                _DetailLine(label: 'Phone', value: request.phone),
                _DetailLine(label: 'Service', value: request.serviceName),
                _DetailLine(
                  label: 'Duration',
                  value: '${request.durationMinutes} min',
                ),
                _DetailLine(
                  label: 'Price',
                  value: '${request.priceJod} JOD',
                ),
                _DetailLine(
                  label: 'Date',
                  value:
                      '${request.dateTime.year.toString().padLeft(4, '0')}-'
                      '${request.dateTime.month.toString().padLeft(2, '0')}-'
                      '${request.dateTime.day.toString().padLeft(2, '0')}',
                ),
                _DetailLine(
                  label: 'Time',
                  value:
                      '${request.dateTime.hour.toString().padLeft(2, '0')}:'
                      '${request.dateTime.minute.toString().padLeft(2, '0')}',
                ),
                _DetailLine(label: 'Address', value: request.address),
                _DetailLine(
                  label: 'Notes',
                  value: request.notes.trim().isEmpty ? '-' : request.notes,
                  isLast: true,
                ),
              ],
            ),
          ),
          actions: [
            if (request.status == NurseServiceRequestStatus.pending) ...[
              Expanded(
                child: OutlinedButton(
                  onPressed: isActionLoading
                      ? null
                      : () async {
                          await _applyStatus(
                            request: request,
                            status: NurseServiceRequestStatus.declined,
                          );
                          if (mounted && dialogContext.mounted) {
                            Navigator.of(dialogContext).pop();
                          }
                        },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFFDC2626),
                    side: const BorderSide(color: Color(0xFFDC2626)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Decline',
                    style: TextStyle(fontWeight: FontWeight.w800),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: ElevatedButton(
                  onPressed: isActionLoading
                      ? null
                      : () async {
                          await _applyStatus(
                            request: request,
                            status: NurseServiceRequestStatus.accepted,
                          );
                          if (mounted && dialogContext.mounted) {
                            Navigator.of(dialogContext).pop();
                          }
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
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
                          style: TextStyle(fontWeight: FontWeight.w800),
                        ),
                ),
              ),
            ] else
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.of(dialogContext).pop(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Close',
                    style: TextStyle(fontWeight: FontWeight.w800),
                  ),
                ),
              ),
          ],
          actionsAlignment: MainAxisAlignment.center,
        );
      },
    );
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
          onViewDetails: () => _openDetails(request),
          onAccept: () => _applyStatus(
            request: request,
            status: NurseServiceRequestStatus.accepted,
          ),
          onDecline: () => _applyStatus(
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
            label: 'All',
            selected: activeFilter == NurseRequestsFilter.all,
            onTap: () => onChanged(NurseRequestsFilter.all),
          ),
          const SizedBox(width: 8),
          _FilterChip(
            label: 'Pending',
            selected: activeFilter == NurseRequestsFilter.pending,
            onTap: () => onChanged(NurseRequestsFilter.pending),
          ),
          const SizedBox(width: 8),
          _FilterChip(
            label: 'Accepted',
            selected: activeFilter == NurseRequestsFilter.accepted,
            onTap: () => onChanged(NurseRequestsFilter.accepted),
          ),
          const SizedBox(width: 8),
          _FilterChip(
            label: 'Declined',
            selected: activeFilter == NurseRequestsFilter.declined,
            onTap: () => onChanged(NurseRequestsFilter.declined),
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
  final VoidCallback onViewDetails;
  final VoidCallback onAccept;
  final VoidCallback onDecline;

  const _RequestCard({
    required this.request,
    required this.isActionLoading,
    required this.onViewDetails,
    required this.onAccept,
    required this.onDecline,
  });

  @override
  Widget build(BuildContext context) {
    final statusData = switch (request.status) {
      NurseServiceRequestStatus.pending => (
          const Color(0xFFFFF7ED),
          const Color(0xFFF59E0B),
          'Pending'
        ),
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
    };

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  request.patientName,
                  style: const TextStyle(
                    color: Color(0xFF111827),
                    fontWeight: FontWeight.w900,
                    fontSize: 15,
                  ),
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFEAF4F6),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  '${request.priceJod} JOD',
                  style: const TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w900,
                    fontSize: 11.5,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 5),
          Text(
            request.serviceName,
            style: const TextStyle(
              color: Color(0xFF6B7280),
              fontWeight: FontWeight.w700,
              fontSize: 12.5,
            ),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 10,
            runSpacing: 6,
            children: [
              _MetaText(
                icon: Icons.calendar_today_outlined,
                text:
                    '${request.dateTime.year.toString().padLeft(4, '0')}-'
                    '${request.dateTime.month.toString().padLeft(2, '0')}-'
                    '${request.dateTime.day.toString().padLeft(2, '0')}',
              ),
              _MetaText(
                icon: Icons.access_time_rounded,
                text:
                    '${request.dateTime.hour.toString().padLeft(2, '0')}:'
                    '${request.dateTime.minute.toString().padLeft(2, '0')}',
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
          const SizedBox(height: 10),
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: statusData.$1,
              borderRadius: BorderRadius.circular(999),
            ),
            child: Text(
              statusData.$3,
              style: TextStyle(
                color: statusData.$2,
                fontWeight: FontWeight.w900,
                fontSize: 11.5,
              ),
            ),
          ),
  const SizedBox(height: 12),

if (request.status == NurseServiceRequestStatus.pending) ...[
  Row(
    children: [
      Expanded(
        child: OutlinedButton(
          onPressed: isActionLoading ? null : onDecline,
          style: OutlinedButton.styleFrom(
            foregroundColor: const Color(0xFFDC2626),
            side: const BorderSide(color: Color(0xFFDC2626)),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: const Text(
            'Decline',
            style: TextStyle(fontWeight: FontWeight.w800),
          ),
        ),
      ),
      const SizedBox(width: 8),
      Expanded(
        child: ElevatedButton(
          onPressed: isActionLoading ? null : onAccept,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
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
                  style: TextStyle(fontWeight: FontWeight.w800),
                ),
        ),
      ),
    ],
  ),
  const SizedBox(height: 10),
],

SizedBox(
  width: double.infinity,
  child: ElevatedButton(
    onPressed: onViewDetails,
    style: ElevatedButton.styleFrom(
      backgroundColor: const Color(0xFFF3F4F6),
      foregroundColor: AppColors.primary,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    ),
    child: const Text(
      'View Full Details',
      style: TextStyle(fontWeight: FontWeight.w800),
    ),
  ),
),
        ],
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

class _DetailLine extends StatelessWidget {
  final String label;
  final String value;
  final bool isLast;

  const _DetailLine({
    required this.label,
    required this.value,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: isLast ? 0 : 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: Color(0xFF6B7280),
              fontWeight: FontWeight.w700,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            value,
            style: const TextStyle(
              color: Color(0xFF111827),
              fontWeight: FontWeight.w800,
              fontSize: 13.5,
            ),
          ),
        ],
      ),
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

