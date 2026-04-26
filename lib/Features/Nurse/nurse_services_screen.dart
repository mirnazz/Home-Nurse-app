import 'package:flutter/material.dart';
import 'package:nurse_app/l10n/app_localizations.dart';
import 'package:nurse_app/Core/theme/api/api_service.dart';
import 'package:nurse_app/Core/theme/app_colors.dart';
import 'package:nurse_app/Core/theme/catalog_name_helper.dart';
import 'nurse_service_model.dart';
import 'add_service_screen.dart';
import 'edit_service_screen.dart';

class NurseServicesScreen extends StatefulWidget {
  const NurseServicesScreen({super.key});

  @override
  State<NurseServicesScreen> createState() => _NurseServicesScreenState();
}

class _NurseServicesScreenState extends State<NurseServicesScreen> {
  List<NurseServiceItem> _services = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadServices();
  }

  Future<void> _loadServices() async {
    setState(() => _isLoading = true);
    try {
      final response = await ApiService.getNurseServices();
      if (!mounted) return;
      setState(() {
        _services = response
            .map<NurseServiceItem>((e) => NurseServiceItem.fromJson(e))
            .toList();
      });
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString().replaceFirst('Exception: ', ''))),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _openAddService() async {
    final result = await Navigator.push<bool>(
      context,
      MaterialPageRoute(builder: (_) => const AddServiceScreen()),
    );
    if (result == true) await _loadServices();
  }

  Future<void> _openEditService(NurseServiceItem service) async {
    final result = await Navigator.push<bool>(
      context,
      MaterialPageRoute(builder: (_) => EditServiceScreen(service: service)),
    );
    if (result == true) await _loadServices();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'My Services',
          style: TextStyle(fontWeight: FontWeight.w800),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: ElevatedButton.icon(
              onPressed: _openAddService,
              icon: const Icon(Icons.add, size: 18, color: AppColors.primary),
              label: Text(
                l10n.nurseServiceAddButton,
                style: const TextStyle(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w800,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                elevation: 0,
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _loadServices,
              child: _services.isEmpty
                  ? ListView(
                      children: [
                        const SizedBox(height: 80),
                        Center(
                          child: Column(
                            children: [
                              Icon(
                                Icons.medical_services_outlined,
                                size: 64,
                                color: Colors.grey.shade300,
                              ),
                              const SizedBox(height: 16),
                              Text(
                                l10n.nursePersonalNoServicesFound,
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.grey.shade500,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Tap "+ Add" above to add your first service',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.grey.shade400,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    )
                  : ListView.separated(
                      padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
                      itemCount: _services.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        final service = _services[index];
                        return _ServiceTile(
                          service: service,
                          l10n: l10n,
                          onEdit: () => _openEditService(service),
                        );
                      },
                    ),
            ),
    );
  }
}

class _ServiceTile extends StatelessWidget {
  final NurseServiceItem service;
  final AppLocalizations l10n;
  final VoidCallback onEdit;

  const _ServiceTile({
    required this.service,
    required this.l10n,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            height: 44,
            width: 44,
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.10),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.medical_services_outlined,
              color: AppColors.primary,
              size: 22,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  localizedCatalogName(service.serviceCatalogId, l10n),
                  style: const TextStyle(
                    fontWeight: FontWeight.w900,
                    fontSize: 15,
                    color: Color(0xFF1D2433),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${l10n.nurseServiceMinutes(service.durationInMinutes)} • ${l10n.nurseServiceSummaryPriceValue(service.price.toString())}',
                  style: const TextStyle(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF6B7280),
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: onEdit,
            icon: const Icon(
              Icons.edit_outlined,
              color: AppColors.primary,
              size: 22,
            ),
          ),
        ],
      ),
    );
  }
}
