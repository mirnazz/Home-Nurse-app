import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:nurse_app/Core/theme/api/api_service.dart';
import 'package:nurse_app/Core/theme/app_colors.dart';
import 'service_catalog_item.dart';

class AddServiceScreen extends StatefulWidget {
  const AddServiceScreen({super.key});

  @override
  State<AddServiceScreen> createState() => _AddServiceScreenState();
}

class _AddServiceScreenState extends State<AddServiceScreen> {
  final TextEditingController _priceController = TextEditingController();

  List<ServiceCatalogItem> serviceCatalog = [];
  ServiceCatalogItem? selectedService;

  bool isLoading = false;
  bool isCatalogLoading = true;

  @override
  void initState() {
    super.initState();
    _loadServiceCatalog();
  }

  @override
  void dispose() {
    _priceController.dispose();
    super.dispose();
  }

  Future<void> _loadServiceCatalog() async {
    try {
      final result = await ApiService.getServiceCatalog();

      if (!mounted) return;

      setState(() {
        serviceCatalog = result
            .map<ServiceCatalogItem>((e) => ServiceCatalogItem.fromJson(e))
            .toList();
        isCatalogLoading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        isCatalogLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            e.toString().replaceFirst('Exception: ', ''),
          ),
        ),
      );
    }
  }

  Future<void> _addService() async {
    final l10n = AppLocalizations.of(context)!;
    if (selectedService == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.nurseServiceSelectRequired)),
      );
      return;
    }

    final price = double.tryParse(_priceController.text.trim());
    if (price == null || price <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.nurseServicePriceInvalid)),
      );
      return;
    }

    setState(() => isLoading = true);

    try {
      await ApiService.addNurseService(
        serviceCatalogId: selectedService!.serviceCatalogId,
        price: price,
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.nurseServiceAddedSuccess)),
      );

      Navigator.pop(context, true);
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
        setState(() => isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Colors.white,
          ),
          onPressed: isLoading ? null : () => Navigator.pop(context),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.nurseServiceAddTitle,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w800,
                fontSize: 18,
              ),
            ),
            Text(
              l10n.nurseServiceAddSubtitle,
              style: TextStyle(
                color: Colors.white70,
                fontWeight: FontWeight.w500,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
      body: isCatalogLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildLabel(l10n.nurseServiceSelectLabel),
                  const SizedBox(height: 8),
                  _buildServiceDropdown(),
                  const SizedBox(height: 20),
                  _buildLabel(l10n.nurseServiceDurationLabel),
                  const SizedBox(height: 8),
                  _buildDurationField(),
                  const SizedBox(height: 20),
                  _buildLabel(l10n.nurseServicePriceLabel),
                  const SizedBox(height: 8),
                  _buildPriceField(),
                  const SizedBox(height: 8),
                  Text(
                    l10n.nurseServicePriceHelp,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  const SizedBox(height: 24),
                  _buildNoteCard(l10n),
                  const SizedBox(height: 32),
                  SizedBox(
                    width: double.infinity,
                    height: 54,
                    child: ElevatedButton(
                      onPressed: isLoading ? null : _addService,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: isLoading
                          ? const SizedBox(
                              width: 22,
                              height: 22,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : Text(
                              l10n.nurseServiceAddButton,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w800,
                                color: Colors.white,
                              ),
                            ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w800,
        color: Color(0xFF1D2433),
      ),
    );
  }

  Widget _buildServiceDropdown() {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.borderGrey),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<ServiceCatalogItem>(
          value: selectedService,
          hint: Text(l10n.nurseServiceChooseHint),
          isExpanded: true,
          items: serviceCatalog.map((service) {
            return DropdownMenuItem<ServiceCatalogItem>(
              value: service,
              child: Text(service.name),
            );
          }).toList(),
          onChanged: isLoading
              ? null
              : (value) => setState(() => selectedService = value),
        ),
      ),
    );
  }

  Widget _buildDurationField() {
    final l10n = AppLocalizations.of(context)!;
    final hasSelection = selectedService != null;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.borderGrey),
      ),
      child: Row(
        children: [
          Icon(
            Icons.access_time_rounded,
            size: 20,
            color: hasSelection
                ? AppColors.primary
                : const Color(0xFF9CA3AF),
          ),
          const SizedBox(width: 12),
          Text(
            hasSelection
                ? l10n.nurseServiceMinutes(
                    selectedService!.defaultDurationInMinutes,
                  )
                : l10n.nurseServiceSelectFirst,
            style: TextStyle(
              fontWeight: FontWeight.w700,
              color: hasSelection
                  ? const Color(0xFF1D2433)
                  : const Color(0xFF9CA3AF),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            l10n.nurseServiceFixedDuration,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPriceField() {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.borderGrey),
      ),
      child: Row(
        children: [
          const Icon(Icons.attach_money, color: AppColors.primary),
          const SizedBox(width: 8),
          Expanded(
            child: TextField(
              controller: _priceController,
              enabled: !isLoading,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: InputDecoration(
                hintText: l10n.nurseServicePriceHint,
                border: InputBorder.none,
              ),
            ),
          ),
          Text(
            l10n.nurseServiceCurrencyJod,
            style: TextStyle(
              fontWeight: FontWeight.w700,
              color: Color(0xFF6B7280),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNoteCard(AppLocalizations l10n) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFE8F4F8),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFB8DCE8)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "${l10n.nurseServiceNoteTitle} ",
            style: TextStyle(
              fontWeight: FontWeight.w900,
              color: Color(0xFF1D2433),
              fontSize: 13,
            ),
          ),
          Expanded(
            child: Text(
              l10n.nurseServiceAddNoteBody,
              style: TextStyle(
                fontSize: 12.5,
                fontWeight: FontWeight.w500,
                color: Color(0xFF4B5563),
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
