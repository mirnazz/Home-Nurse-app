import 'package:flutter/material.dart';
import 'package:nurse_app/Core/theme/api/api_service.dart';
import 'package:nurse_app/Core/theme/app_colors.dart';
import 'nurse_service_model.dart';
import 'service_catalog_item.dart';

class EditServiceScreen extends StatefulWidget {
  const EditServiceScreen({super.key, required this.service});

  final NurseServiceItem service;

  @override
  State<EditServiceScreen> createState() => _EditServiceScreenState();
}

class _EditServiceScreenState extends State<EditServiceScreen> {
  final TextEditingController _priceController = TextEditingController();

  List<ServiceCatalogItem> serviceCatalog = [];
  ServiceCatalogItem? selectedService;

  bool isLoading = false;
  bool isCatalogLoading = true;

  @override
  void initState() {
    super.initState();
    _priceController.text = widget.service.price.toString();
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

      final catalogItems = result
          .map<ServiceCatalogItem>((e) => ServiceCatalogItem.fromJson(e))
          .toList();

      ServiceCatalogItem? initialValue;
      try {
        initialValue = catalogItems.firstWhere(
          (item) => item.serviceCatalogId == widget.service.serviceCatalogId,
        );
      } catch (_) {
        initialValue = null;
      }

      setState(() {
        serviceCatalog = catalogItems;
        selectedService = initialValue;
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

  Future<void> _updateService() async {
    if (selectedService == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select a service")),
      );
      return;
    }

    final price = double.tryParse(_priceController.text.trim());

    if (price == null || price <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter a valid price")),
      );
      return;
    }

    setState(() => isLoading = true);

    try {
      await ApiService.updateNurseService(
        id: widget.service.serviceId,
        serviceCatalogId: selectedService!.serviceCatalogId,
        price: price,
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Service updated successfully")),
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

  Future<void> _deleteService() async {
    setState(() => isLoading = true);

    try {
      await ApiService.deleteNurseService(widget.service.serviceId);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Service deleted successfully")),
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

  Future<void> _confirmDelete() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: const Text("Delete Service"),
          content: const Text("Are you sure you want to delete this service?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text(
                "Delete",
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );

    if (confirm == true) {
      await _deleteService();
    }
  }

  @override
  Widget build(BuildContext context) {
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
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Edit Service",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w800,
                fontSize: 18,
              ),
            ),
            Text(
              "Update your service pricing",
              style: TextStyle(
                color: Colors.white70,
                fontWeight: FontWeight.w500,
                fontSize: 12,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: isLoading ? null : _confirmDelete,
            icon: const Icon(Icons.delete_outline, color: Colors.white),
          ),
        ],
      ),
      body: isCatalogLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildLabel("Select Service *"),
                  const SizedBox(height: 8),
                  _buildServiceDropdown(),
                  const SizedBox(height: 20),
                  _buildLabel("Service Duration"),
                  const SizedBox(height: 8),
                  _buildDurationField(),
                  const SizedBox(height: 20),
                  _buildLabel("Your Price *"),
                  const SizedBox(height: 8),
                  _buildPriceField(),
                  const SizedBox(height: 8),
                  Text(
                    "Set your price for this service",
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  const SizedBox(height: 20),
                  _buildServiceSummaryCard(),
                  const SizedBox(height: 20),
                  _buildNoteCard(),
                  const SizedBox(height: 32),
                  SizedBox(
                    width: double.infinity,
                    height: 54,
                    child: ElevatedButton(
                      onPressed: isLoading ? null : _updateService,
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
                          : const Text(
                              "Update Service",
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
          hint: const Text("Choose a service..."),
          isExpanded: true,
          items: serviceCatalog.map((service) {
            return DropdownMenuItem<ServiceCatalogItem>(
              value: service,
              child: Text(service.name),
            );
          }).toList(),
          onChanged: isLoading
              ? null
              : (value) {
                  setState(() => selectedService = value);
                },
        ),
      ),
    );
  }

  Widget _buildDurationField() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.borderGrey),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.access_time_rounded,
            size: 20,
            color: AppColors.primary,
          ),
          const SizedBox(width: 12),
          Text(
            selectedService != null
                ? "${selectedService!.defaultDurationInMinutes} minutes"
                : "Select a service first",
            style: const TextStyle(
              fontWeight: FontWeight.w700,
              color: Color(0xFF1D2433),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            "(Fixed duration)",
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
              decoration: const InputDecoration(
                hintText: "Enter your price",
                border: InputBorder.none,
              ),
              onChanged: (_) => setState(() {}),
            ),
          ),
          const Text(
            "JOD",
            style: TextStyle(
              fontWeight: FontWeight.w700,
              color: Color(0xFF6B7280),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildServiceSummaryCard() {
    final price = _priceController.text;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.08),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.primary.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Service: ${selectedService?.name ?? widget.service.serviceName}",
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 6),
          Text(
            "Duration: ${selectedService?.defaultDurationInMinutes ?? widget.service.durationInMinutes} min",
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              const Text(
                "Your Price: ",
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              Text(
                "${price.isEmpty ? "0" : price} JOD",
                style: const TextStyle(
                  fontWeight: FontWeight.w900,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildNoteCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFE8F4F8),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFB8DCE8)),
      ),
      child: const Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Note: ",
            style: TextStyle(
              fontWeight: FontWeight.w900,
              color: Color(0xFF1D2433),
              fontSize: 13,
            ),
          ),
          Expanded(
            child: Text(
              "Service duration comes from the backend catalog. You can update the selected service and price only.",
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