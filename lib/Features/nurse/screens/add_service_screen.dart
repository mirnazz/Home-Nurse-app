import 'package:flutter/material.dart';
import 'package:nurse_app/Core/theme/app_colors.dart';

/// Predefined service types with fixed durations.
const List<ServiceType> serviceTypes = [
  ServiceType(name: "IV Therapy", durationMinutes: 60),
  ServiceType(name: "Wound Care", durationMinutes: 45),
  ServiceType(name: "Medication Management", durationMinutes: 30),
  ServiceType(name: "Post-Surgery Care", durationMinutes: 90),
  ServiceType(name: "Elderly Care", durationMinutes: 60),
  ServiceType(name: "Palliative Care", durationMinutes: 90),
];

class ServiceType {
  final String name;
  final int durationMinutes;

  const ServiceType({required this.name, required this.durationMinutes});
}

class AddServiceScreen extends StatefulWidget {
  const AddServiceScreen({super.key});

  @override
  State<AddServiceScreen> createState() => _AddServiceScreenState();
}

class _AddServiceScreenState extends State<AddServiceScreen> {
  ServiceType? selectedService;
  final TextEditingController _priceController = TextEditingController(text: "");

  @override
  void dispose() {
    _priceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Add Service",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w800,
                fontSize: 18,
              ),
            ),
            Text(
              "Add a service you provide",
              style: TextStyle(
                color: Colors.white70,
                fontWeight: FontWeight.w500,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
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
            const SizedBox(height: 24),
            _buildNoteCard(),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              height: 54,
              child: ElevatedButton(
                onPressed: () {
                  if (selectedService == null || _priceController.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Please fill all required fields")),
                    );
                    return;
                  }
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Service added (demo)")),
                  );
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                ),
                child: const Text(
                  "Add Service",
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
        child: DropdownButton<ServiceType>(
          value: selectedService,
          hint: const Text("Choose a service..."),
          isExpanded: true,
          items: serviceTypes.map((s) {
            return DropdownMenuItem(
              value: s,
              child: Text(s.name),
            );
          }).toList(),
          onChanged: (v) => setState(() => selectedService = v),
        ),
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
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                hintText: "Enter your price",
                border: InputBorder.none,
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.keyboard_arrow_up),
            onPressed: () {
              final n = int.tryParse(_priceController.text) ?? 0;
              _priceController.text = (n + 1).toString();
            },
          ),
          IconButton(
            icon: const Icon(Icons.keyboard_arrow_down),
            onPressed: () {
              final n = int.tryParse(_priceController.text) ?? 0;
              if (n > 0) _priceController.text = (n - 1).toString();
            },
          ),
          const Text("JOD", style: TextStyle(fontWeight: FontWeight.w700, color: Color(0xFF6B7280))),
        ],
      ),
    );
  }

  Widget _buildDurationField() {
    final hasSelectedService = selectedService != null;

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
            color: hasSelectedService ? AppColors.primary : const Color(0xFF9CA3AF),
          ),
          const SizedBox(width: 12),
          Text(
            hasSelectedService
                ? "${selectedService!.durationMinutes} minutes"
                : "Select a service first",
            style: TextStyle(
              fontWeight: FontWeight.w700,
              color: hasSelectedService ? const Color(0xFF1D2433) : const Color(0xFF9CA3AF),
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
              "Service duration is predefined based on typical time required. You can set your own competitive price for each service you offer.",
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
