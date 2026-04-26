import 'package:flutter/material.dart';
import 'package:nurse_app/Core/theme/api/api_service.dart';
import 'package:nurse_app/l10n/app_localizations.dart';

class ReportDropdownField extends StatelessWidget {
  final String label;
  final String hint;
  final String? value;
  final List<DropdownMenuItem<String>> items;
  final ValueChanged<String?> onChanged;
  final String? errorText;

  const ReportDropdownField({
    super.key,
    required this.label,
    required this.hint,
    required this.value,
    required this.items,
    required this.onChanged,
    this.errorText,
  });

  @override
  Widget build(BuildContext context) {
    final hasError = errorText != null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700)),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: hasError ? const Color(0xFFD32F2F) : const Color(0xFFE0E0E0),
              width: 1.5,
            ),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: value,
              hint: Padding(
                padding: const EdgeInsetsDirectional.only(start: 14),
                child: Text(hint, style: const TextStyle(color: Color(0xFF9CA3AF))),
              ),
              isExpanded: true,
              borderRadius: BorderRadius.circular(12),
              padding: const EdgeInsetsDirectional.only(start: 14, end: 8),
              icon: const Icon(Icons.keyboard_arrow_down_rounded),
              items: items,
              onChanged: onChanged,
            ),
          ),
        ),
        if (hasError) ...[
          const SizedBox(height: 4),
          Text(errorText!, style: const TextStyle(fontSize: 12, color: Color(0xFFD32F2F))),
        ],
      ],
    );
  }
}

class ReportTextField extends StatelessWidget {
  final String label;
  final String hint;
  final TextEditingController controller;
  final int maxLines;
  final int? maxLength;
  final String? errorText;
  final int? currentLength;

  const ReportTextField({
    super.key,
    required this.label,
    required this.hint,
    required this.controller,
    this.maxLines = 1,
    this.maxLength,
    this.errorText,
    this.currentLength,
  });

  @override
  Widget build(BuildContext context) {
    final hasError = errorText != null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700)),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          maxLines: maxLines,
          minLines: maxLines > 1 ? maxLines : null,
          maxLength: maxLength,
          buildCounter: (_, {required currentLength, required isFocused, required maxLength}) => null,
          decoration: InputDecoration(
            hintText: hint,
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: hasError ? const Color(0xFFD32F2F) : const Color(0xFFE0E0E0),
                width: 1.5,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFFD32F2F), width: 1.5),
            ),
          ),
        ),
        if (maxLength != null && currentLength != null)
          Align(
            alignment: AlignmentDirectional.centerEnd,
            child: Text(
              '$currentLength/$maxLength',
              style: TextStyle(
                fontSize: 12,
                color: currentLength! >= maxLength!
                    ? const Color(0xFFD32F2F)
                    : const Color(0xFF9CA3AF),
                fontWeight: currentLength! >= maxLength! ? FontWeight.w700 : FontWeight.normal,
              ),
            ),
          ),
        if (hasError) ...[
          const SizedBox(height: 4),
          Text(errorText!, style: const TextStyle(fontSize: 12, color: Color(0xFFD32F2F))),
        ],
      ],
    );
  }
}

class ReportCheckbox extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool?> onChanged;

  const ReportCheckbox({
    super.key,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onChanged(!value),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFE0E0E0), width: 1.5),
        ),
        child: Row(
          children: [
            Checkbox(
              value: value,
              onChanged: onChanged,
              activeColor: const Color(0xFFD32F2F),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontWeight: FontWeight.w700)),
                  Text(subtitle, style: const TextStyle(fontSize: 13, color: Color(0xFF6B7280))),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PatientReportIssueScreen extends StatefulWidget {
  const PatientReportIssueScreen({super.key});

  @override
  State<PatientReportIssueScreen> createState() => _PatientReportIssueScreenState();
}

class _PatientReportIssueScreenState extends State<PatientReportIssueScreen> {
  static const _red = Color(0xFFD32F2F);
  static const _bg = Color(0xFFF6F7F9);
  static const int _descMaxLength = 1000;

  String? _selectedCategory;
  final _subjectController = TextEditingController();
  final _descController = TextEditingController();

  bool _isUrgent = false;
  bool _isSubmitting = false;
  int _descLength = 0;

  bool _showCategoryError = false;
  bool _showSubjectError = false;
  bool _showDescError = false;

  final List<String> _categories = const [
    "Technical",
    "Payment",
    "Service Issue",
    "Account",
    "Other",
  ];

  @override
  void initState() {
    super.initState();
    _descController.addListener(() {
      setState(() => _descLength = _descController.text.length);
    });
  }

  @override
  void dispose() {
    _subjectController.dispose();
    _descController.dispose();
    super.dispose();
  }

  Future<void> _submit(AppLocalizations l10n) async {
    final categoryEmpty = _selectedCategory == null;
    final subjectEmpty = _subjectController.text.trim().isEmpty;
    final descEmpty = _descController.text.trim().isEmpty;

    setState(() {
      _showCategoryError = categoryEmpty;
      _showSubjectError = subjectEmpty;
      _showDescError = descEmpty;
    });

    if (categoryEmpty || subjectEmpty || descEmpty) return;

    setState(() => _isSubmitting = true);

    try {
      await ApiService.submitPatientIssue(
        category: _selectedCategory!,
        subject: _subjectController.text.trim(),
        description: _descController.text.trim(),
        isUrgent: _isUrgent,
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Issue submitted successfully")),
      );

      Navigator.of(context).pop(true);
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString().replaceFirst("Exception: ", ""))),
      );
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: _bg,
      appBar: AppBar(
        backgroundColor: _red,
        foregroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Text(l10n.reportIssueTitle, style: const TextStyle(fontWeight: FontWeight.w800)),
        actions: [
          IconButton(
            icon: const Icon(Icons.close_rounded),
            onPressed: _isSubmitting ? null : () => Navigator.of(context).pop(),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ReportDropdownField(
              label: l10n.reportIssueCategoryLabel,
              hint: l10n.reportIssueCategoryHint,
              value: _selectedCategory,
              errorText: _showCategoryError ? l10n.reportIssueCategoryRequired : null,
              items: _categories
                  .map(
                    (c) => DropdownMenuItem(
                      value: c,
                      child: Text(c, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
                    ),
                  )
                  .toList(),
              onChanged: _isSubmitting
                  ? (_) {}
                  : (val) => setState(() {
                        _selectedCategory = val;
                        if (val != null) _showCategoryError = false;
                      }),
            ),
            const SizedBox(height: 20),

            ReportTextField(
              label: l10n.reportIssueSubjectLabel,
              hint: l10n.reportIssueSubjectHint,
              controller: _subjectController,
              errorText: _showSubjectError ? l10n.reportIssueFieldRequired : null,
            ),
            const SizedBox(height: 20),

            ReportTextField(
              label: l10n.reportIssueDescriptionLabel,
              hint: l10n.reportIssueDescriptionHint,
              controller: _descController,
              maxLines: 6,
              maxLength: _descMaxLength,
              currentLength: _descLength,
              errorText: _showDescError ? l10n.reportIssueFieldRequired : null,
            ),
            const SizedBox(height: 20),

            ReportCheckbox(
              title: l10n.reportIssueMarkUrgent,
              subtitle: l10n.reportIssueUrgentSubtitle,
              value: _isUrgent,
              onChanged: _isSubmitting ? (_) {} : (val) => setState(() => _isUrgent = val ?? false),
            ),
            const SizedBox(height: 24),

            _ImportantNotice(
              title: l10n.reportIssueNoticeTitle,
              body: l10n.reportIssueNoticeBody,
            ),
            const SizedBox(height: 32),

            ElevatedButton(
              onPressed: _isSubmitting ? null : () => _submit(l10n),
              style: ElevatedButton.styleFrom(
                backgroundColor: _red,
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 52),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                elevation: 0,
              ),
              child: _isSubmitting
                  ? const SizedBox(
                      height: 22,
                      width: 22,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2.2,
                      ),
                    )
                  : Text(
                      l10n.reportIssueSubmit,
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
                    ),
            ),
            const SizedBox(height: 12),

            OutlinedButton(
              onPressed: _isSubmitting ? null : () => Navigator.of(context).pop(),
              style: OutlinedButton.styleFrom(
                foregroundColor: const Color(0xFF6B7280),
                minimumSize: const Size(double.infinity, 52),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                side: const BorderSide(color: Color(0xFFE0E0E0), width: 1.5),
              ),
              child: Text(
                l10n.reportIssueCancel,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ImportantNotice extends StatelessWidget {
  final String title;
  final String body;

  const _ImportantNotice({required this.title, required this.body});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFFFBEB),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFF59E0B), width: 1.5),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.warning_amber_rounded, color: Color(0xFFF59E0B), size: 22),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: Color(0xFF92400E))),
                const SizedBox(height: 4),
                Text(body, style: const TextStyle(fontSize: 13, color: Color(0xFF92400E), height: 1.4)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
