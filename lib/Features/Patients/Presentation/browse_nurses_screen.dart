import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:nurse_app/Features/Patients/Presentation/patient_nurse_profile_screen.dart';

class BrowseNursesScreen extends StatefulWidget {
  const BrowseNursesScreen({super.key});

  @override
  State<BrowseNursesScreen> createState() => _BrowseNursesScreenState();
}

class _BrowseNursesScreenState extends State<BrowseNursesScreen> {
  static const Color _primary = Color(0xFF2F7F8D);
  static const int _pageSize = 10;

  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  static const List<_ServiceOption> _serviceOptions = [
    _ServiceOption(id: 1,  label: 'IV Therapy'),
    _ServiceOption(id: 2,  label: 'Wound Care and Dressing'),
    _ServiceOption(id: 3,  label: 'Injection or Medication Administration'),
    _ServiceOption(id: 4,  label: 'Post-Surgery Care'),
    _ServiceOption(id: 5,  label: 'Medication Management'),
    _ServiceOption(id: 6,  label: 'Vital Signs Monitoring'),
    _ServiceOption(id: 7,  label: 'Blood Draw or Lab Sample Collection'),
    _ServiceOption(id: 8,  label: 'Catheter Care'),
    _ServiceOption(id: 9,  label: 'Diabetes Monitoring and Insulin Injection'),
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
    'Amman', 'Irbid', 'Zarqa', 'Balqa', 'Madaba',
    'Karak', 'Tafilah', "Ma'an", 'Aqaba', 'Jerash',
    'Ajloun', 'Mafraq',
  ];

  final List<_NurseBrowseItem> _allNurses = _mockNurses;

  int? _selectedServiceCatalogId;
  String? _selectedLocation;
  int _pageNumber = 1;
  bool _isLoadingMore = false;

  int _totalCount = 0;
  int _totalPages = 0;
  bool _hasNextPage = false;

  List<_NurseBrowseItem> _filteredSorted = const [];
  List<_NurseBrowseItem> _visibleItems = const [];

  List<String> get _locations => _allLocations;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() => _applySearchAndFilters(resetPage: true));
    _scrollController.addListener(_handleScroll);
    _applySearchAndFilters(resetPage: true);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _handleScroll() {
    if (!_hasNextPage || _isLoadingMore) return;
    if (!_scrollController.hasClients) return;

    final threshold = _scrollController.position.maxScrollExtent - 180;
    if (_scrollController.position.pixels >= threshold) {
      _loadMore();
    }
  }

  Future<void> _loadMore() async {
    setState(() => _isLoadingMore = true);
    await Future<void>.delayed(const Duration(milliseconds: 250));

    if (!mounted) return;
    setState(() {
      _pageNumber += 1;
      _rebuildVisiblePage();
      _isLoadingMore = false;
    });
  }

  void _applySearchAndFilters({required bool resetPage}) {
    final query = _searchController.text.trim().toLowerCase();

    final filtered =
        _allNurses.where((nurse) {
          final matchesSearch =
              query.isEmpty ||
              nurse.fullName.toLowerCase().contains(query) ||
              nurse.specialization.toLowerCase().contains(query) ||
              nurse.location.toLowerCase().contains(query);

          final matchesService =
              _selectedServiceCatalogId == null ||
              nurse.serviceCatalogIds.contains(_selectedServiceCatalogId);

          final matchesLocation =
              _selectedLocation == null ||
              nurse.location.toLowerCase() == _selectedLocation!.toLowerCase();

          return matchesSearch && matchesService && matchesLocation;
        }).toList();

    filtered.sort((a, b) {
      // Temporary backend alignment:
      // - With location filter: sort by address ascending.
      // - Without location filter: rating desc (fallback to experience desc).
      if (_selectedLocation != null) {
        return a.address.toLowerCase().compareTo(b.address.toLowerCase());
      }

      final ratingCompare = b.rating.compareTo(a.rating);
      if (ratingCompare != 0) return ratingCompare;
      return b.experienceYears.compareTo(a.experienceYears);
    });

    setState(() {
      _filteredSorted = filtered;
      _totalCount = filtered.length;
      _totalPages = (_totalCount / _pageSize).ceil();
      if (resetPage) _pageNumber = 1;
      _rebuildVisiblePage();
    });
  }

  void _rebuildVisiblePage() {
    final visibleCount = math.min(_pageNumber * _pageSize, _filteredSorted.length);
    _visibleItems = _filteredSorted.take(visibleCount).toList();
    _hasNextPage = visibleCount < _filteredSorted.length;
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
      certificateUrl: '',
      servicesOffered: _serviceNamesForIds(nurse.serviceCatalogIds),
    );

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => PatientNurseProfileScreen(profile: profile),
      ),
    );
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
            return DraggableScrollableSheet(
              initialChildSize: 0.75,
              minChildSize: 0.4,
              maxChildSize: 0.93,
              expand: false,
              builder: (_, scrollController) => Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ── drag handle + header (fixed) ──────────────────────
                    Padding(
                      padding: const EdgeInsets.fromLTRB(22, 0, 22, 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Center(
                            child: Padding(
                              padding: const EdgeInsets.only(top: 12, bottom: 18),
                              child: Container(
                                width: 40,
                                height: 4,
                                decoration: BoxDecoration(
                                  color: const Color(0xFFE5E7EB),
                                  borderRadius: BorderRadius.circular(999),
                                ),
                              ),
                            ),
                          ),
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFE7F1F3),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Icon(
                                  Icons.tune_rounded,
                                  color: Color(0xFF2F7F8D),
                                  size: 20,
                                ),
                              ),
                              const SizedBox(width: 10),
                              const Text(
                                'Filter Nurses',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w900,
                                  color: Color(0xFF1F2937),
                                ),
                              ),
                              const Spacer(),
                              if (tempService != null || tempLocation != null)
                                GestureDetector(
                                  onTap: () => setModalState(() {
                                    tempService = null;
                                    tempLocation = null;
                                  }),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 6,
                                    ),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFF3F4F6),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: const Text(
                                      'Reset',
                                      style: TextStyle(
                                        fontSize: 12.5,
                                        fontWeight: FontWeight.w700,
                                        color: Color(0xFF6B7280),
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                          const SizedBox(height: 6),
                        ],
                      ),
                    ),

                    const Divider(height: 1, color: Color(0xFFF3F4F6)),

                    // ── scrollable content ────────────────────────────────
                    Expanded(
                      child: ListView(
                        controller: scrollController,
                        padding: const EdgeInsets.fromLTRB(22, 20, 22, 16),
                        children: [
                          // Service Type
                          _FilterSectionHeader(
                            icon: Icons.medical_services_outlined,
                            label: 'Service Type',
                          ),
                          const SizedBox(height: 10),
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: [
                              _FilterChip(
                                label: 'All Services',
                                selected: tempService == null,
                                onTap: () =>
                                    setModalState(() => tempService = null),
                              ),
                              ..._serviceOptions.map(
                                (s) => _FilterChip(
                                  label: s.label,
                                  selected: tempService == s.id,
                                  onTap: () => setModalState(
                                    () => tempService =
                                        tempService == s.id ? null : s.id,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 26),

                          // Location
                          _FilterSectionHeader(
                            icon: Icons.location_on_outlined,
                            label: 'Governorate',
                          ),
                          const SizedBox(height: 10),
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: [
                              _FilterChip(
                                label: 'All Locations',
                                selected: tempLocation == null,
                                onTap: () =>
                                    setModalState(() => tempLocation = null),
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
                          const SizedBox(height: 8),
                        ],
                      ),
                    ),

                    // ── sticky Apply button ───────────────────────────────
                    Container(
                      padding: EdgeInsets.fromLTRB(
                        22,
                        12,
                        22,
                        MediaQuery.of(context).viewInsets.bottom + 20,
                      ),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        border: Border(
                          top: BorderSide(color: Color(0xFFF3F4F6)),
                        ),
                      ),
                      child: SizedBox(
                        width: double.infinity,
                        height: 52,
                        child: ElevatedButton(
                          onPressed: () {
                            setState(() {
                              _selectedServiceCatalogId = tempService;
                              _selectedLocation = tempLocation;
                            });
                            _applySearchAndFilters(resetPage: true);
                            Navigator.pop(context);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF2F7F8D),
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

  @override
  Widget build(BuildContext context) {
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
                      decoration: _inputDecoration('Search by name or specialty...')
                          .copyWith(prefixIcon: const Icon(Icons.search)),
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
                            _totalPages == 0 ? 'Page 0/0' : 'Page $_pageNumber/$_totalPages',
                            style: const TextStyle(
                              color: Color(0xFF6B7280),
                              fontWeight: FontWeight.w700,
                              fontSize: 12,
                            ),
                          ),
                          const SizedBox(width: 8),
                          if (_selectedServiceCatalogId != null || _selectedLocation != null)
                            const Icon(Icons.tune, size: 18, color: Color(0xFF6B7280)),
                        ],
                      ),
                    ),
                    Expanded(
                      child:
                          _visibleItems.isEmpty
                              ? const Center(
                                child: Text(
                                  'No nurses match your filters.',
                                  style: TextStyle(
                                    color: Color(0xFF6B7280),
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              )
                              : ListView.separated(
                                controller: _scrollController,
                                padding: const EdgeInsets.fromLTRB(16, 0, 16, 18),
                                itemCount: _visibleItems.length + (_hasNextPage ? 1 : 0),
                                separatorBuilder: (_, __) => const SizedBox(height: 10),
                                itemBuilder: (context, index) {
                                  if (index >= _visibleItems.length) {
                                    return const Padding(
                                      padding: EdgeInsets.symmetric(vertical: 10),
                                      child: Center(
                                        child: CircularProgressIndicator(strokeWidth: 2),
                                      ),
                                    );
                                  }
                                  return _NurseCard(
                                    item: _visibleItems[index],
                                    onViewProfile: () => _openNurseProfile(_visibleItems[index]),
                                  );
                                },
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
  const _NurseCard({required this.item, required this.onViewProfile});

  @override
  Widget build(BuildContext context) {
    final available = item.availabilityLabel.toLowerCase().contains('available');
    final initials =
        item.fullName
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
          CircleAvatar(
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
                    const Icon(Icons.star_rounded, color: Color(0xFFF7B500), size: 17),
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
                    const Icon(Icons.schedule, color: Color(0xFF6B7280), size: 15),
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
                    const Icon(Icons.location_on_outlined, size: 15, color: Color(0xFF6B7280)),
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
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: available ? const Color(0xFFE8F8ED) : const Color(0xFFF3F4F6),
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Text(
                        item.availabilityLabel,
                        style: TextStyle(
                          color: available ? const Color(0xFF1F8A4D) : const Color(0xFF6B7280),
                          fontWeight: FontWeight.w700,
                          fontSize: 11.5,
                        ),
                      ),
                    ),
                    const Spacer(),
                    OutlinedButton(
                      onPressed: onViewProfile,
                      style: OutlinedButton.styleFrom(
                        foregroundColor: const Color(0xFF2F7F8D),
                        side: const BorderSide(color: Color(0xFF2F7F8D)),
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
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
  const _FilterSectionHeader({required this.icon, required this.label});

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
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: selected ? const Color(0xFF2F7F8D) : const Color(0xFFF3F4F6),
          borderRadius: BorderRadius.circular(999),
          border: Border.all(
            color: selected ? const Color(0xFF2F7F8D) : const Color(0xFFE5E7EB),
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
  const _ServiceOption({required this.id, required this.label});
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

  // TODO(Abeer): Replace this with API mapping from:
  // GET /api/patient/nurses/browse
  // {
  //   "pageNumber": 1,
  //   "pageSize": 10,
  //   "totalCount": 0,
  //   "totalPages": 0,
  //   "hasNextPage": false,
  //   "items": [...]
  // }
  // ignore: unused_element
  factory _NurseBrowseItem.fromApiJson(Map<String, dynamic> json) {
    return _NurseBrowseItem(
      nurseId: (json['nurseId'] ?? '').toString(),
      fullName: (json['fullName'] ?? '').toString(),
      specialization: (json['specialization'] ?? '').toString(),
      location: (json['location'] ?? '').toString(),
      address: (json['address'] ?? '').toString(),
      experienceYears: (json['experienceYears'] ?? 0) as int,
      profileImageUrl: (json['profileImageUrl'] ?? '').toString(),
      rating: ((json['rating'] ?? 0) as num).toDouble(),
      reviewsCount: (json['reviewsCount'] ?? 0) as int,
      price: ((json['price'] ?? 0) as num).toDouble(),
      availabilityLabel: (json['availabilityLabel'] ?? 'Unavailable').toString(),
      serviceCatalogIds: const [],
    );
  }
}

const List<_NurseBrowseItem> _mockNurses = [
  _NurseBrowseItem(
    nurseId: '1',
    fullName: 'Sarah Hassan',
    specialization: 'IV Therapy & Wound Care',
    location: 'Amman',
    address: 'Abdali',
    experienceYears: 8,
    profileImageUrl: '',
    rating: 4.9,
    reviewsCount: 156,
    price: 25,
    availabilityLabel: 'Available Today',
    serviceCatalogIds: [1, 2],
  ),
  _NurseBrowseItem(
    nurseId: '2',
    fullName: 'Layla Ahmed',
    specialization: 'Post-Surgery Care',
    location: 'Amman',
    address: 'Sweifieh',
    experienceYears: 6,
    profileImageUrl: '',
    rating: 4.8,
    reviewsCount: 142,
    price: 30,
    availabilityLabel: 'Available Tomorrow',
    serviceCatalogIds: [1, 3],
  ),
  _NurseBrowseItem(
    nurseId: '3',
    fullName: 'Noor Ibrahim',
    specialization: 'Elderly Care',
    location: 'Amman',
    address: 'Jabal Amman',
    experienceYears: 12,
    profileImageUrl: '',
    rating: 4.95,
    reviewsCount: 203,
    price: 28,
    availabilityLabel: 'Available This Week',
    serviceCatalogIds: [3],
  ),
  _NurseBrowseItem(
    nurseId: '4',
    fullName: 'Fatima Khaled',
    specialization: 'Medication Management',
    location: 'Amman',
    address: 'Khalda',
    experienceYears: 5,
    profileImageUrl: '',
    rating: 4.7,
    reviewsCount: 98,
    price: 22,
    availabilityLabel: 'Available This Week',
    serviceCatalogIds: [4],
  ),
  _NurseBrowseItem(
    nurseId: '5',
    fullName: 'Rana Adel',
    specialization: 'Critical Care',
    location: 'Irbid',
    address: 'University Street',
    experienceYears: 10,
    profileImageUrl: '',
    rating: 4.6,
    reviewsCount: 77,
    price: 27,
    availabilityLabel: 'Unavailable',
    serviceCatalogIds: [1],
  ),
  _NurseBrowseItem(
    nurseId: '6',
    fullName: 'Haneen Sami',
    specialization: 'Wound Care',
    location: 'Amman',
    address: 'Dabouq',
    experienceYears: 7,
    profileImageUrl: '',
    rating: 4.4,
    reviewsCount: 54,
    price: 24,
    availabilityLabel: 'Available This Week',
    serviceCatalogIds: [2],
  ),
  _NurseBrowseItem(
    nurseId: '7',
    fullName: 'Maya Nasser',
    specialization: 'Elderly Care',
    location: 'Zarqa',
    address: 'Zarqa New',
    experienceYears: 11,
    profileImageUrl: '',
    rating: 4.3,
    reviewsCount: 49,
    price: 21,
    availabilityLabel: 'Unavailable',
    serviceCatalogIds: [3],
  ),
  _NurseBrowseItem(
    nurseId: '8',
    fullName: 'Dina Fares',
    specialization: 'Critical Care',
    location: 'Amman',
    address: 'Tlaa Al Ali',
    experienceYears: 9,
    profileImageUrl: '',
    rating: 4.5,
    reviewsCount: 92,
    price: 29,
    availabilityLabel: 'Available This Week',
    serviceCatalogIds: [1],
  ),
  _NurseBrowseItem(
    nurseId: '9',
    fullName: 'Aya Saeed',
    specialization: 'Medication Management',
    location: 'Aqaba',
    address: 'City Center',
    experienceYears: 4,
    profileImageUrl: '',
    rating: 4.2,
    reviewsCount: 33,
    price: 20,
    availabilityLabel: 'Available This Week',
    serviceCatalogIds: [4],
  ),
  _NurseBrowseItem(
    nurseId: '10',
    fullName: 'Salma Obeid',
    specialization: 'Post-Surgery Care',
    location: 'Amman',
    address: 'Shmeisani',
    experienceYears: 8,
    profileImageUrl: '',
    rating: 4.65,
    reviewsCount: 84,
    price: 26,
    availabilityLabel: 'Available This Week',
    serviceCatalogIds: [1, 2],
  ),
  _NurseBrowseItem(
    nurseId: '11',
    fullName: 'Eman Qadi',
    specialization: 'Wound Care',
    location: 'Irbid',
    address: 'Al Husn',
    experienceYears: 6,
    profileImageUrl: '',
    rating: 4.1,
    reviewsCount: 31,
    price: 19,
    availabilityLabel: 'Unavailable',
    serviceCatalogIds: [2],
  ),
  _NurseBrowseItem(
    nurseId: '12',
    fullName: 'Reem Yousef',
    specialization: 'Critical Care',
    location: 'Amman',
    address: 'Abdoun',
    experienceYears: 13,
    profileImageUrl: '',
    rating: 4.98,
    reviewsCount: 240,
    price: 32,
    availabilityLabel: 'Available This Week',
    serviceCatalogIds: [1],
  ),
];
