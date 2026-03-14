import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:nurse_app/Core/theme/app_colors.dart';
import 'package:nurse_app/Features/nurse/models/nurse_service_model.dart';
import 'add_service_screen.dart';

void _agentLogEdit({
  required String runId,
  required String hypothesisId,
  required String location,
  required String message,
  Map<String, Object?> data = const {},
}) {
  try {
    final payload = <String, Object?>{
      'sessionId': 'd86d99',
      'runId': runId,
      'hypothesisId': hypothesisId,
      'location': location,
      'message': message,
      'data': data,
      'timestamp': DateTime.now().millisecondsSinceEpoch,
    };
    final line = '${jsonEncode(payload)}\n';
    File('/Users/mirnabaqi/Desktop/Nurse_Home_app/nurse_app/.cursor/debug-d86d99.log')
        .writeAsStringSync(line, mode: FileMode.append, flush: true);
  } catch (_) {}
}

class EditServiceScreen extends StatefulWidget {
  const EditServiceScreen({super.key, required this.service});

  final NurseServiceItem service;

  @override
  State<EditServiceScreen> createState() => _EditServiceScreenState();
}

class _EditServiceScreenState extends State<EditServiceScreen> {
  late ServiceType selectedService;
  late TextEditingController _priceController;

  @override
  void initState() {
    super.initState();
    final match = serviceTypes.where((s) => s.name == widget.service.name);
    selectedService = match.isEmpty
        ? ServiceType(name: widget.service.name, durationMinutes: widget.service.durationMinutes)
        : match.first;
    _priceController = TextEditingController(text: widget.service.priceJod.toString());
    // #region agent log
    _agentLogEdit(
      runId: 'run2',
      hypothesisId: 'H1',
      location: 'edit_service_screen.dart:initState',
      message: 'Edit screen initialized',
      data: <String, Object?>{
        'incomingServiceName': widget.service.name,
        'matchFound': match.isNotEmpty,
        'serviceTypesCount': serviceTypes.length,
      },
    );
    // #endregion
  }

  @override
  void dispose() {
    _priceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // #region agent log
    _agentLogEdit(
      runId: 'run2',
      hypothesisId: 'H2',
      location: 'edit_service_screen.dart:build',
      message: 'Edit screen build started',
      data: <String, Object?>{
        'selectedServiceName': selectedService.name,
        'selectedExistsByName': serviceTypes.any((s) => s.name == selectedService.name),
      },
    );
    // #endregion
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
            const SizedBox(height: 20),
            _buildServiceSummaryCard(),
            const SizedBox(height: 20),
            _buildNoteCard(),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              height: 54,
              child: ElevatedButton(
                onPressed: () {
                  if (_priceController.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Please enter a price")),
                    );
                    return;
                  }
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Service updated (demo)")),
                  );
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                ),
                child: const Text(
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
        child: DropdownButton<ServiceType>(
          value: selectedService,
          isExpanded: true,
          items: serviceTypes.map((s) {
            return DropdownMenuItem(
              value: s,
              child: Text(s.name),
            );
          }).toList(),
          onChanged: (v) {
            if (v != null) setState(() => selectedService = v);
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
          Icon(Icons.access_time_rounded, size: 20, color: AppColors.primary),
          const SizedBox(width: 12),
          Text(
            "${selectedService.durationMinutes} minutes",
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

  Widget _buildServiceSummaryCard() {
    final price = _priceController.text;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Service: ${selectedService.name}", style: const TextStyle(fontWeight: FontWeight.w600)),
          const SizedBox(height: 6),
          Text("Duration: ${selectedService.durationMinutes} min", style: const TextStyle(fontWeight: FontWeight.w600)),
          const SizedBox(height: 6),
          Row(
            children: [
              const Text("Your Price: ", style: TextStyle(fontWeight: FontWeight.w600)),
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
