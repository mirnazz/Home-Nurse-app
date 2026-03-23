import 'dart:async';
import 'package:flutter/material.dart';
import 'package:nurse_app/Core/theme/api/api_service.dart';
import 'package:nurse_app/Features/Patients/Presentation/patient_nurse_profile_screen.dart';

class BrowseNursesScreen extends StatefulWidget {
  final String? initialSearch;
  final int? initialServiceCatalogId;
  final String? initialLocation;

  const BrowseNursesScreen({
    super.key,
    this.initialSearch,
    this.initialServiceCatalogId,
    this.initialLocation,
  });

  @override
  State<BrowseNursesScreen> createState() => _BrowseNursesScreenState();
}

class _BrowseNursesScreenState extends State<BrowseNursesScreen> {
  static const Color _primary = Color(0xFF2F7F8D);
  static const int _pageSize = 10;

  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  Timer? _debounce;

  static const List<_ServiceOption> _serviceOptions = [
    _ServiceOption(id: 1, label: 'IV Therapy'),
    _ServiceOption(id: 2, label: 'Wound Care and Dressing'),
    _ServiceOption(id: 3, label: 'Injection or Medication Administration'),
    _ServiceOption(id: 4, label: 'Post-Surgery Care'),
    _ServiceOption(id: 5, label: 'Medication Management'),
    _ServiceOption(id: 6, label: 'Vital Signs Monitoring'),
    _ServiceOption(id: 7, label: 'Blood Draw or Lab Sample Collection'),
    _ServiceOption(id: 8, label: 'Catheter Care'),
    _ServiceOption(id: 9, label: 'Diabetes Monitoring and Insulin Injection'),
    _ServiceOption(id: 10, label: 'Elderly Home Care Visit'),
    _ServiceOption(id: 11, label: 'Oxygen Therapy Setup'),
    _ServiceOption(id: 12, label: 'Nebulizer Therapy Session'),
    _ServiceOption(id: 13, label: 'Stitches Removal'),
    _ServiceOption(id: 14, label: 'Pressure Ulcer Care'),
    _ServiceOption(id: 15, label: 'General Nursing Home Visit'),
    _ServiceOption(id: 16, label: 'Blood Pressure Check'),
    _ServiceOption(id: 17, label: 'Short Care Shift (4 hours)'),
    _ServiceOption(id: 18, label: 'Half-Day Home Care (6 hours)'),
    _ServiceOption(id: 19, label: 'Full-Day Home Care (12 hours)'),
  ];

  static const List<String> _allLocations = [
    'Amman',
    'Irbid',
    'Zarqa',
    'Balqa',
    'Madaba',
    'Karak',
    'Tafilah',
    "Ma'an",
    'Aqaba',
    'Jerash',
    'Ajloun',
    'Mafraq',
  ];

  int? _selectedServiceCatalogId;
  String? _selectedLocation;

  int _pageNumber = 1;
  int _totalCount = 0;
  int _totalPages = 0;
  bool _hasNextPage = false;

  bool _isInitialLoading = true;
  bool _isLoadingMore = false;
  String? _errorMessage;

  List<_NurseBrowseItem> _visibleItems = [];

  List<String> get _locations => _allLocations;

  @override
  void initState() {
    super.initState();

    _searchController.text = widget.initialSearch ?? '';
    _selectedServiceCatalogId = widget.initialServiceCatalogId;
    _selectedLocation = widget.initialLocation;

    _searchController.addListener(_onSearchChanged);
    _scrollController.addListener(_handleScroll);
    _fetchNurses(reset: true);
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      _fetchNurses(reset: true);
    });
  }

  void _handleScroll() {
    if (!_hasNextPage || _isLoadingMore || _isInitialLoading) return;
    if (!_scrollController.hasClients) return;

    final threshold = _scrollController.position.maxScrollExtent - 180;
    if (_scrollController.position.pixels >= threshold) {
      _fetchNurses(reset: false);
    }
  }

  Future<void> _fetchNurses({required bool reset}) async {
    try {
      if (reset) {
        setState(() {
          _isInitialLoading = true;
          _errorMessage = null;
          _pageNumber = 1;
          _visibleItems = [];
        });
      } else {
        setState(() {
          _isLoadingMore = true;
          _errorMessage = null;
        });
      }

      final result = await ApiService.browseNurses(
        search: _searchController.text.trim().isEmpty
            ? null
            : _searchController.text.trim(),
        serviceCatalogId: _selectedServiceCatalogId,
        location: _selectedLocation,
        pageNumber: reset ? 1 : _pageNumber + 1,
        pageSize: _pageSize,
      );

      final itemsJson = (result['items'] as List? ?? []);
      final newItems = itemsJson
          .map((e) => _NurseBrowseItem.fromApiJson(e as Map<String, dynamic>))
          .toList();

      if (!mounted) return;

      setState(() {
        _pageNumber = (result['pageNumber'] ?? 1) as int;
        _totalCount = (result['totalCount'] ?? 0) as int;
        _totalPages = (result['totalPages'] ?? 0) as int;
        _hasNextPage = (result['hasNextPage'] ?? false) as bool;

        if (reset) {
          _visibleItems = newItems;
        } else {
          _visibleItems.addAll(newItems);
        }

        _isInitialLoading = false;
        _isLoadingMore = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _errorMessage = e.toString().replaceFirst('Exception: ', '');
        _isInitialLoading = false;
        _isLoadingMore = false;
      });
    }
  }

  String? get _selectedServiceLabel {
    final match = _serviceOptions.where((s) => s.id == _selectedServiceCatalogId);
    if (match.isEmpty) return null;
    return match.first.label;
  }

  List<String> _serviceNamesForIds(List<int> serviceIds) {
    final map = {for (final s in _serviceOptions) s.id: s.label};
    return serviceIds.map((id) => map[id]).whereType<String>().toList();
  }

  void _openNurseProfile(_NurseBrowseItem nurse) {
 final profile = PatientNurseProfileData(
  nurseId: nurse.nurseId,
  fullName: nurse.fullName,
  profileImageUrl: nurse.profileImageUrl,
  headline: nurse.specialization,
  rating: nurse.rating,
  reviewsCount: nurse.reviewsCount,
  experienceYears: nurse.experienceYears,
  location: nurse.location,
  address: nurse.address,
  availabilityLabel: nurse.availabilityLabel,
);

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => PatientNurseProfileScreen(profile: profile),
      ),
    );
  }

  void _clearAllFilters() {
    setState(() {
      _selectedServiceCatalogId = null;
      _selectedLocation = null;
      _searchController.clear();
    });
    _fetchNurses(reset: true);
  }

  void _openFiltersSheet() {
    int? tempService = _selectedServiceCatalogId;
    String? tempLocation = _selectedLocation;

    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            final selectedServiceLabel = _serviceOptions
                .where((s) => s.id == tempService)
                .map((e) => e.label)
                .cast<String?>()
                .firstOrNull;

            return DraggableScrollableSheet(
              initialChildSize: 0.68,
              minChildSize: 0.45,
              maxChildSize: 0.9,
              expand: false,
              builder: (_, scrollController) => Container(
                decoration: const BoxDecoration(
                  color: Color(0xFFF9FAFB),
                  borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(22, 12, 22, 12),
                      child: Column(
                        children: [
                          Container(
                            width: 42,
                            height: 4,
                            decoration: BoxDecoration(
                              color: const Color(0xFFD1D5DB),
                              borderRadius: BorderRadius.circular(999),
                            ),
                          ),
                          const SizedBox(height: 18),
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(9),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFE7F1F3),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Icon(
                                  Icons.tune_rounded,
                                  color: _primary,
                                  size: 20,
                                ),
                              ),
                              const SizedBox(width: 10),
                              const Expanded(
                                child: Text(
                                  'Filter Nurses',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w900,
                                    color: Color(0xFF1F2937),
                                  ),
                                ),
                              ),
                              TextButton(
                                onPressed: () => setModalState(() {
                                  tempService = null;
                                  tempLocation = null;
                                }),
                                child: const Text(
                                  'Reset',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w800,
                                    color: Color(0xFF6B7280),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const Divider(height: 1, color: Color(0xFFE5E7EB)),
                    Expanded(
                      child: ListView(
                        controller: scrollController,
                        padding: const EdgeInsets.fromLTRB(22, 20, 22, 18),
                        children: [
                          const _FilterSectionHeader(
                            icon: Icons.medical_services_outlined,
                            label: 'Service Type',
                          ),
                          const SizedBox(height: 10),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 14),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: const Color(0xFFE5E7EB)),
                            ),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<int?>(
                                value: tempService,
                                isExpanded: true,
                                borderRadius: BorderRadius.circular(16),
                                dropdownColor: Colors.white,
                                icon: const Icon(Icons.keyboard_arrow_down_rounded),
                                hint: const Text(
                                  'Choose a service',
                                  style: TextStyle(
                                    color: Color(0xFF9CA3AF),
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                items: [
                                  const DropdownMenuItem<int?>(
                                    value: null,
                                    child: Text('All Services'),
                                  ),
                                  ..._serviceOptions.map(
                                    (service) => DropdownMenuItem<int?>(
                                      value: service.id,
                                      child: Text(
                                        service.label,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ),
                                ],
                                onChanged: (value) {
                                  setModalState(() {
                                    tempService = value;
                                  });
                                },
                              ),
                            ),
                          ),
                          if (selectedServiceLabel != null) ...[
                            const SizedBox(height: 10),
                            _ActivePreviewChip(
                              label: selectedServiceLabel,
                              onRemove: () => setModalState(() {
                                tempService = null;
                              }),
                            ),
                          ],
                          const SizedBox(height: 28),
                          const _FilterSectionHeader(
                            icon: Icons.location_on_outlined,
                            label: 'Governorate',
                          ),
                          const SizedBox(height: 12),
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: [
                              _FilterChip(
                                label: 'All Locations',
                                selected: tempLocation == null,
                                onTap: () => setModalState(() => tempLocation = null),
                              ),
                              ..._locations.map(
                                (loc) => _FilterChip(
                                  label: loc,
                                  selected: tempLocation == loc,
                                  onTap: () => setModalState(
                                    () => tempLocation =
                                        tempLocation == loc ? null : loc,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.fromLTRB(
                        22,
                        14,
                        22,
                        MediaQuery.of(context).viewInsets.bottom + 20,
                      ),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        border: Border(
                          top: BorderSide(color: Color(0xFFE5E7EB)),
                        ),
                      ),
                      child: SizedBox(
                        width: double.infinity,
                        height: 54,
                        child: ElevatedButton(
                          onPressed: () {
                            setState(() {
                              _selectedServiceCatalogId = tempService;
                              _selectedLocation = tempLocation;
                            });
                            Navigator.pop(context);
                            _fetchNurses(reset: true);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _primary,
                            foregroundColor: Colors.white,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            textStyle: const TextStyle(
                              fontWeight: FontWeight.w800,
                              fontSize: 15,
                            ),
                          ),
                          child: const Text('Apply Filters'),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Future<void> _refresh() async {
    await _fetchNurses(reset: true);
  }

  @override
  Widget build(BuildContext context) {
    final hasActiveFilters = _selectedServiceCatalogId != null ||
        _selectedLocation != null ||
        _searchController.text.trim().isNotEmpty;

    return Container(
      color: _primary,
      child: SafeArea(
        bottom: false,
        child: Column(
          children: [
            const SizedBox(height: 18),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 18),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Browse Nurses',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 21,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      decoration: _inputDecoration(
                        'Search by name or specialty...',
                      ).copyWith(
                        prefixIcon: const Icon(Icons.search),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton.icon(
                    onPressed: _openFiltersSheet,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white.withOpacity(0.15),
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    icon: const Icon(Icons.filter_alt_outlined),
                    label: const Text('Filters'),
                  ),
                ],
              ),
            ),
            if (hasActiveFilters) ...[
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      if (_searchController.text.trim().isNotEmpty)
                        _TopFilterChip(
                          label: _searchController.text.trim(),
                          onRemove: () {
                            _searchController.clear();
                            _fetchNurses(reset: true);
                          },
                        ),
                      if (_searchController.text.trim().isNotEmpty &&
                          (_selectedServiceLabel != null || _selectedLocation != null))
                        const SizedBox(width: 8),
                      if (_selectedServiceLabel != null)
                        _TopFilterChip(
                          label: _selectedServiceLabel!,
                          onRemove: () {
                            setState(() {
                              _selectedServiceCatalogId = null;
                            });
                            _fetchNurses(reset: true);
                          },
                        ),
                      if (_selectedServiceLabel != null && _selectedLocation != null)
                        const SizedBox(width: 8),
                      if (_selectedLocation != null)
                        _TopFilterChip(
                          label: _selectedLocation!,
                          onRemove: () {
                            setState(() {
                              _selectedLocation = null;
                            });
                            _fetchNurses(reset: true);
                          },
                        ),
                      const SizedBox(width: 8),
                      GestureDetector(
                        onTap: _clearAllFilters,
                        child: const Text(
                          'Clear all',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
            const SizedBox(height: 14),
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                  color: Color(0xFFF4F6F8),
                  borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(18, 16, 18, 10),
                      child: Row(
                        children: [
                          Text(
                            'Found $_totalCount nurses',
                            style: const TextStyle(
                              color: Color(0xFF374151),
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const Spacer(),
                          Text(
                            _totalPages == 0
                                ? 'Page 0/0'
                                : 'Page $_pageNumber/$_totalPages',
                            style: const TextStyle(
                              color: Color(0xFF6B7280),
                              fontWeight: FontWeight.w700,
                              fontSize: 12,
                            ),
                          ),
                          const SizedBox(width: 8),
                          if (hasActiveFilters)
                            const Icon(
                              Icons.tune,
                              size: 18,
                              color: Color(0xFF6B7280),
                            ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: _isInitialLoading
                          ? const Center(child: CircularProgressIndicator())
                          : _errorMessage != null
                              ? Center(
                                  child: Padding(
                                    padding: const EdgeInsets.all(24),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        const Icon(
                                          Icons.error_outline,
                                          size: 38,
                                          color: Colors.redAccent,
                                        ),
                                        const SizedBox(height: 10),
                                        Text(
                                          _errorMessage!,
                                          textAlign: TextAlign.center,
                                          style: const TextStyle(
                                            color: Color(0xFF6B7280),
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        const SizedBox(height: 14),
                                        ElevatedButton(
                                          onPressed: () => _fetchNurses(reset: true),
                                          child: const Text('Retry'),
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                              : _visibleItems.isEmpty
                                  ? const Center(
                                      child: Text(
                                        'No nurses match your filters.',
                                        style: TextStyle(
                                          color: Color(0xFF6B7280),
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    )
                                  : RefreshIndicator(
                                      onRefresh: _refresh,
                                      child: ListView.separated(
                                        controller: _scrollController,
                                        padding: const EdgeInsets.fromLTRB(
                                          16,
                                          0,
                                          16,
                                          18,
                                        ),
                                        itemCount:
                                            _visibleItems.length + (_isLoadingMore ? 1 : 0),
                                        separatorBuilder: (_, __) =>
                                            const SizedBox(height: 10),
                                        itemBuilder: (context, index) {
                                          if (index >= _visibleItems.length) {
                                            return const Padding(
                                              padding: EdgeInsets.symmetric(vertical: 10),
                                              child: Center(
                                                child: CircularProgressIndicator(
                                                  strokeWidth: 2,
                                                ),
                                              ),
                                            );
                                          }

                                          return _NurseCard(
                                            item: _visibleItems[index],
                                            onViewProfile: () =>
                                                _openNurseProfile(_visibleItems[index]),
                                          );
                                        },
                                      ),
                                    ),
                    ),
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

class _NurseCard extends StatelessWidget {
  final _NurseBrowseItem item;
  final VoidCallback onViewProfile;

  const _NurseCard({
    required this.item,
    required this.onViewProfile,
  });

  @override
  Widget build(BuildContext context) {
    final available =
        item.availabilityLabel.toLowerCase().contains('available');

    final initials = item.fullName
        .split(' ')
        .where((e) => e.isNotEmpty)
        .map((e) => e[0])
        .take(2)
        .join()
        .toUpperCase();

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          item.profileImageUrl.isNotEmpty
              ? CircleAvatar(
                  radius: 23,
                  backgroundImage: NetworkImage(item.profileImageUrl),
                )
              : CircleAvatar(
                  radius: 23,
                  backgroundColor: const Color(0xFFE7F1F3),
                  child: Text(
                    initials,
                    style: const TextStyle(
                      color: Color(0xFF2F7F8D),
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.fullName,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF1F2937),
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  item.specialization,
                  style: const TextStyle(
                    color: Color(0xFF6B7280),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(
                      Icons.star_rounded,
                      color: Color(0xFFF7B500),
                      size: 17,
                    ),
                    const SizedBox(width: 2),
                    Text(
                      '${item.rating.toStringAsFixed(1)} (${item.reviewsCount})',
                      style: const TextStyle(
                        color: Color(0xFF374151),
                        fontWeight: FontWeight.w700,
                        fontSize: 12.5,
                      ),
                    ),
                    const SizedBox(width: 10),
                    const Icon(
                      Icons.schedule,
                      color: Color(0xFF6B7280),
                      size: 15,
                    ),
                    const SizedBox(width: 2),
                    Text(
                      '${item.experienceYears} years',
                      style: const TextStyle(
                        color: Color(0xFF6B7280),
                        fontWeight: FontWeight.w600,
                        fontSize: 12.5,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    const Icon(
                      Icons.location_on_outlined,
                      size: 15,
                      color: Color(0xFF6B7280),
                    ),
                    const SizedBox(width: 2),
                    Expanded(
                      child: Text(
                        '${item.address}, ${item.location}',
                        style: const TextStyle(
                          color: Color(0xFF6B7280),
                          fontWeight: FontWeight.w600,
                          fontSize: 12.5,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: available
                            ? const Color(0xFFE8F8ED)
                            : const Color(0xFFF3F4F6),
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Text(
                        item.availabilityLabel,
                        style: TextStyle(
                          color: available
                              ? const Color(0xFF1F8A4D)
                              : const Color(0xFF6B7280),
                          fontWeight: FontWeight.w700,
                          fontSize: 11.5,
                        ),
                      ),
                    ),
                    const Spacer(),
                    if (item.price > 0)
                      Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: Text(
                          '${item.price.toStringAsFixed(0)} JD',
                          style: const TextStyle(
                            color: Color(0xFF2F7F8D),
                            fontWeight: FontWeight.w800,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    OutlinedButton(
                      onPressed: onViewProfile,
                      style: OutlinedButton.styleFrom(
                        foregroundColor: const Color(0xFF2F7F8D),
                        side: const BorderSide(color: Color(0xFF2F7F8D)),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        textStyle: const TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: 12.5,
                        ),
                      ),
                      child: const Text('View Profile'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _FilterSectionHeader extends StatelessWidget {
  final IconData icon;
  final String label;

  const _FilterSectionHeader({
    required this.icon,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 16, color: const Color(0xFF2F7F8D)),
        const SizedBox(width: 6),
        Text(
          label.toUpperCase(),
          style: const TextStyle(
            fontSize: 11.5,
            fontWeight: FontWeight.w900,
            color: Color(0xFF374151),
            letterSpacing: 0.8,
          ),
        ),
      ],
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
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 160),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
        decoration: BoxDecoration(
          color: selected ? const Color(0xFF2F7F8D) : const Color(0xFFF3F4F6),
          borderRadius: BorderRadius.circular(999),
          border: Border.all(
            color: selected
                ? const Color(0xFF2F7F8D)
                : const Color(0xFFE5E7EB),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: selected ? Colors.white : const Color(0xFF374151),
          ),
        ),
      ),
    );
  }
}

class _TopFilterChip extends StatelessWidget {
  final String label;
  final VoidCallback onRemove;

  const _TopFilterChip({
    required this.label,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 8, 8, 8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.16),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: Colors.white.withOpacity(0.18)),
      ),
      child: Row(
        children: [
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w700,
              fontSize: 12.5,
            ),
          ),
          const SizedBox(width: 6),
          GestureDetector(
            onTap: onRemove,
            child: const Icon(
              Icons.close,
              color: Colors.white,
              size: 16,
            ),
          ),
        ],
      ),
    );
  }
}

class _ActivePreviewChip extends StatelessWidget {
  final String label;
  final VoidCallback onRemove;

  const _ActivePreviewChip({
    required this.label,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 8, 8, 8),
      decoration: BoxDecoration(
        color: const Color(0xFFE7F1F3),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: Color(0xFF2F7F8D),
              fontWeight: FontWeight.w700,
              fontSize: 12.5,
            ),
          ),
          const SizedBox(width: 6),
          GestureDetector(
            onTap: onRemove,
            child: const Icon(
              Icons.close,
              color: Color(0xFF2F7F8D),
              size: 16,
            ),
          ),
        ],
      ),
    );
  }
}

InputDecoration _inputDecoration(String hint) {
  return InputDecoration(
    hintText: hint,
    filled: true,
    fillColor: Colors.white,
    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide.none,
    ),
  );
}

class _ServiceOption {
  final int id;
  final String label;

  const _ServiceOption({
    required this.id,
    required this.label,
  });
}

class _NurseBrowseItem {
  final String nurseId;
  final String fullName;
  final String specialization;
  final String location;
  final String address;
  final int experienceYears;
  final String profileImageUrl;
  final double rating;
  final int reviewsCount;
  final double price;
  final String availabilityLabel;
  final List<int> serviceCatalogIds;

  const _NurseBrowseItem({
    required this.nurseId,
    required this.fullName,
    required this.specialization,
    required this.location,
    required this.address,
    required this.experienceYears,
    required this.profileImageUrl,
    required this.rating,
    required this.reviewsCount,
    required this.price,
    required this.availabilityLabel,
    required this.serviceCatalogIds,
  });

  factory _NurseBrowseItem.fromApiJson(Map<String, dynamic> json) {
  debugPrint('NURSE JSON: $json');

  return _NurseBrowseItem(
    nurseId: (json['nurseId'] ?? '').toString(),
    fullName: (json['fullName'] ?? '').toString(),
    specialization: (json['specialization'] ?? '').toString(),
    location: (json['location'] ?? '').toString(),
    address: (json['address'] ?? '').toString(),
    experienceYears: ((json['experienceYears'] ?? 0) as num).toInt(),
    profileImageUrl: (json['profileImageUrl'] ?? '').toString(),
    rating: ((json['rating'] ?? 0) as num).toDouble(),
    reviewsCount: ((json['reviewsCount'] ?? 0) as num).toInt(),
    price: ((json['price'] ?? 0) as num).toDouble(),
    availabilityLabel:
        (json['availabilityLabel'] ?? 'Unavailable').toString(),
    serviceCatalogIds: (json['serviceCatalogIds'] as List? ?? [])
        .map((e) => (e as num).toInt())
        .toList(),
  );
}
}

extension _FirstOrNullExtension<E> on Iterable<E> {
  E? get firstOrNull => isEmpty ? null : first;
}
