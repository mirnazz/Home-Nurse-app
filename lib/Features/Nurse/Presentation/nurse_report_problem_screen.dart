import 'package:flutter/material.dart';
import 'package:nurse_app/Core/theme/app_colors.dart';
import 'package:nurse_app/Core/theme/api/api_service.dart';
import 'package:nurse_app/Features/Patients/Presentation/patient_report_issue_screen.dart';
import 'package:nurse_app/l10n/app_localizations.dart';

class NurseReportProblemScreen extends StatefulWidget {
  const NurseReportProblemScreen({super.key});

  @override
  State<NurseReportProblemScreen> createState() =>
      _NurseReportProblemScreenState();
}

class _NurseReportProblemScreenState extends State<NurseReportProblemScreen> {
  static const _red = Color(0xFFD32F2F);
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

  @override
  void initState() {
    super.initState();
    _descController.addListener(() {
      if (!mounted) return;
      setState(() => _descLength = _descController.text.length);
    });
  }

  @override
  void dispose() {
    _subjectController.dispose();
    _descController.dispose();
    super.dispose();
  }

  List<String> _categories(AppLocalizations l10n) => [
    l10n.nurseReportCatPayment,
    l10n.nurseReportCatTechnical,
    l10n.nurseReportCatPatient,
    l10n.nurseReportCatSafety,
    l10n.nurseReportCatBug,
    l10n.nurseReportCatAccount,
    l10n.nurseReportCatScheduling,
    l10n.nurseReportCatOther,
  ];

  String _backendCategory(AppLocalizations l10n, String uiCategory) {
    if (uiCategory == l10n.nurseReportCatPayment) return "Payment";
    if (uiCategory == l10n.nurseReportCatTechnical) return "Technical";
    if (uiCategory == l10n.nurseReportCatAccount) return "Account";
    if (uiCategory == l10n.nurseReportCatOther) return "Other";

    if (uiCategory == l10n.nurseReportCatPatient ||
        uiCategory == l10n.nurseReportCatSafety ||
        uiCategory == l10n.nurseReportCatBug ||
        uiCategory == l10n.nurseReportCatScheduling) {
      return "Service Issue";
    }

    return "Other";
  }

  Future<void> _submit(AppLocalizations l10n) async {
    if (_isSubmitting) return;

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
      await ApiService.submitProblem(
        category: _backendCategory(l10n, _selectedCategory!),
        subject: _subjectController.text.trim(),
        description: _descController.text.trim(),
        isUrgent: _isUrgent,
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Problem report submitted successfully.")),
      );

      Navigator.of(context).pop(true);
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString().replaceFirst("Exception: ", ""))),
      );
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final categories = _categories(l10n);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: _red,
        foregroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Text(
          l10n.nurseReportTitle,
          style: const TextStyle(fontWeight: FontWeight.w800),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.close_rounded),
            onPressed: () {
              if (_isSubmitting) return;
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ReportDropdownField(
              label: l10n.nurseReportCategoryLabel,
              hint: l10n.nurseReportCategoryHint,
              value: _selectedCategory,
              errorText:
                  _showCategoryError ? l10n.nurseReportCategoryRequired : null,
              items:
                  categories
                      .map(
                        (c) => DropdownMenuItem<String>(
                          value: c,
                          child: Text(
                            c,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF1C1C1C),
                            ),
                          ),
                        ),
                      )
                      .toList(),
              onChanged: (val) {
                if (_isSubmitting) return;

                setState(() {
                  _selectedCategory = val;
                  if (val != null) _showCategoryError = false;
                });
              },
            ),
            const SizedBox(height: 20),
            ReportTextField(
              label: l10n.nurseReportSubjectLabel,
              hint: l10n.nurseReportSubjectHint,
              controller: _subjectController,
              errorText:
                  _showSubjectError ? l10n.nurseReportFieldRequired : null,
            ),
            const SizedBox(height: 20),
            ReportTextField(
              label: l10n.nurseReportDescriptionLabel,
              hint: l10n.nurseReportDescriptionHint,
              controller: _descController,
              maxLines: 6,
              maxLength: _descMaxLength,
              currentLength: _descLength,
              errorText: _showDescError ? l10n.nurseReportFieldRequired : null,
            ),
            const SizedBox(height: 20),
            ReportCheckbox(
              title: l10n.nurseReportMarkUrgent,
              subtitle: l10n.nurseReportUrgentSubtitle,
              value: _isUrgent,
              onChanged: (val) {
                if (_isSubmitting) return;

                setState(() => _isUrgent = val ?? false);
              },
            ),
            const SizedBox(height: 24),
            _NurseImportantNotice(
              title: l10n.nurseReportNoticeTitle,
              body: l10n.nurseReportNoticeBody,
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () => _submit(l10n),
              style: ElevatedButton.styleFrom(
                backgroundColor: _red,
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 52),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                elevation: 0,
              ),
              child:
                  _isSubmitting
                      ? const SizedBox(
                        width: 22,
                        height: 22,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2.4,
                        ),
                      )
                      : Text(
                        l10n.nurseReportSubmit,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
            ),
            const SizedBox(height: 12),
            OutlinedButton(
              onPressed: () {
                if (_isSubmitting) return;
                Navigator.of(context).pop();
              },
              style: OutlinedButton.styleFrom(
                foregroundColor: const Color(0xFF6B7280),
                minimumSize: const Size(double.infinity, 52),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                side: const BorderSide(color: Color(0xFFE0E0E0), width: 1.5),
              ),
              child: Text(
                l10n.nurseReportCancel,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}

class _NurseImportantNotice extends StatelessWidget {
  final String title;
  final String body;

  const _NurseImportantNotice({required this.title, required this.body});

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
          const Padding(
            padding: EdgeInsets.only(top: 2),
            child: Icon(
              Icons.warning_amber_rounded,
              color: Color(0xFFF59E0B),
              size: 22,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF92400E),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  body,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF92400E),
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
