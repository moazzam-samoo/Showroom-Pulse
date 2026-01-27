import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:lucide_icons/lucide_icons.dart';

import 'package:tahir_showroom/app/core/constants/app_colors.dart';
import 'package:tahir_showroom/app/core/constants/app_spacing.dart';
import 'package:tahir_showroom/app/core/constants/app_radius.dart';

/// Add New Bike Dialog
/// 
/// Analyzed from: Dark Theme UI/Add New Bike Page.png
/// Layout:
/// - Modal dialog (centered)
/// - Title: "Add New Motorcycle"  
/// - 3 sections with cyan headers:
///   1. Basic Details (Model, Color, Stock)
///   2. Technical Specs (Engine No, Chassis No)
///   3. Financials (Purchase Price, Selling Price)
/// - Upload Bike Image area
/// - "Save to Inventory" button
class AddBikeDialog extends StatefulWidget {
  final Function(Map<String, dynamic>)? onSave;

  const AddBikeDialog({
    super.key,
    this.onSave,
  });

  @override
  State<AddBikeDialog> createState() => _AddBikeDialogState();
}

class _AddBikeDialogState extends State<AddBikeDialog> {
  final _formKey = GlobalKey<FormState>();
  
  // Form controllers
  final _modelController = TextEditingController();
  final _colorController = TextEditingController();
  final _stockController = TextEditingController(text: '1');
  final _engineNoController = TextEditingController();
  final _chassisNoController = TextEditingController();
  final _purchasePriceController = TextEditingController();
  final _sellingPriceController = TextEditingController();

  File? _selectedImage;

  @override
  void dispose() {
    _modelController.dispose();
    _colorController.dispose();
    _stockController.dispose();
    _engineNoController.dispose();
    _chassisNoController.dispose();
    _purchasePriceController.dispose();
    _sellingPriceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = isDark ? AppColors.darkPrimary : AppColors.lightPrimary;

    return Dialog(
      backgroundColor: isDark ? AppColors.darkSurface : Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.lg),
      ),
      child: Container(
        width: 500,
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(
                        LucideIcons.bike,
                        color: primaryColor,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Tahir Showroom Inventory Management',
                        style: TextStyle(
                          color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                  IconButton(
                    icon: Icon(
                      LucideIcons.x,
                      color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                    ),
                    onPressed: () => Navigator.of(context).pop(),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.base),
              // Title
              Text(
                'Add New Motorcycle',
                style: TextStyle(
                  color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              // Form Content - Two columns
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Left Column - Basic Details + Technical Specs
                  Expanded(
                    child: Column(
                      children: [
                        // Basic Details Section
                        _buildSection(
                          title: 'Basic Details',
                          isDark: isDark,
                          primaryColor: primaryColor,
                          children: [
                            _buildTextField(
                              label: 'Model:',
                              controller: _modelController,
                              hint: 'Honda CG125',
                              isDark: isDark,
                              validator: (v) => v?.isEmpty == true ? 'Required' : null,
                            ),
                            const SizedBox(height: AppSpacing.sm),
                            _buildTextField(
                              label: 'Color:',
                              controller: _colorController,
                              hint: 'Red',
                              isDark: isDark,
                            ),
                            const SizedBox(height: AppSpacing.sm),
                            _buildTextField(
                              label: 'Stock:',
                              controller: _stockController,
                              hint: '1',
                              isDark: isDark,
                              keyboardType: TextInputType.number,
                            ),
                          ],
                        ),
                        const SizedBox(height: AppSpacing.base),
                        // Technical Specs Section
                        _buildSection(
                          title: 'Technical Specs',
                          isDark: isDark,
                          primaryColor: primaryColor,
                          children: [
                            _buildTextField(
                              label: 'Engine\nNo.:',
                              controller: _engineNoController,
                              hint: 'HCG125E-987654321',
                              isDark: isDark,
                              validator: (v) => v?.isEmpty == true ? 'Required' : null,
                            ),
                            const SizedBox(height: AppSpacing.sm),
                            _buildTextField(
                              label: 'Chassis\nNo.:',
                              controller: _chassisNoController,
                              hint: 'HCG125F-123456789',
                              isDark: isDark,
                              validator: (v) => v?.isEmpty == true ? 'Required' : null,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: AppSpacing.base),
                  // Right Column - Financials + Image
                  Expanded(
                    child: Column(
                      children: [
                        // Financials Section
                        _buildSection(
                          title: 'Financials',
                          isDark: isDark,
                          primaryColor: primaryColor,
                          children: [
                            _buildTextField(
                              label: 'Purchase\nPrice:',
                              controller: _purchasePriceController,
                              hint: 'Rs 250,000',
                              isDark: isDark,
                              keyboardType: TextInputType.number,
                              validator: (v) => v?.isEmpty == true ? 'Required' : null,
                            ),
                            const SizedBox(height: AppSpacing.sm),
                            _buildTextField(
                              label: 'Selling\nPrice:',
                              controller: _sellingPriceController,
                              hint: 'Rs 280,000',
                              isDark: isDark,
                              keyboardType: TextInputType.number,
                              validator: (v) => v?.isEmpty == true ? 'Required' : null,
                            ),
                          ],
                        ),
                        const SizedBox(height: AppSpacing.base),
                        // Image Upload
                        _buildImageUpload(isDark, primaryColor),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.lg),
              // Save Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _handleSave,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppRadius.md),
                    ),
                  ),
                  child: const Text(
                    'Save to Inventory',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required bool isDark,
    required Color primaryColor,
    required List<Widget> children,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkElevated : Colors.grey.shade50,
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section Header
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.base,
              vertical: AppSpacing.sm,
            ),
            decoration: BoxDecoration(
              color: primaryColor,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(AppRadius.md),
                topRight: Radius.circular(AppRadius.md),
              ),
            ),
            child: Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          // Section Content
          Padding(
            padding: const EdgeInsets.all(AppSpacing.base),
            child: Column(children: children),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    required String hint,
    required bool isDark,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          width: 60,
          child: Text(
            label,
            style: TextStyle(
              color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
              fontSize: 12,
            ),
          ),
        ),
        Expanded(
          child: Container(
            height: 36,
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkSurface : Colors.white,
              borderRadius: BorderRadius.circular(AppRadius.sm),
              border: Border.all(
                color: isDark ? AppColors.darkBorder : Colors.grey.shade300,
              ),
            ),
            child: TextFormField(
              controller: controller,
              keyboardType: keyboardType,
              validator: validator,
              style: TextStyle(
                color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                fontSize: 13,
              ),
              decoration: InputDecoration(
                hintText: hint,
                hintStyle: TextStyle(
                  color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                  fontSize: 13,
                ),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                isDense: true,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildImageUpload(bool isDark, Color primaryColor) {
    return Container(
      height: 140,
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkElevated : Colors.grey.shade50,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : Colors.grey.shade300,
          style: BorderStyle.solid,
        ),
      ),
      child: InkWell(
        onTap: _pickImage,
        borderRadius: BorderRadius.circular(AppRadius.md),
        child: _selectedImage != null
            ? ClipRRect(
                borderRadius: BorderRadius.circular(AppRadius.md),
                child: Image.file(
                  _selectedImage!,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: double.infinity,
                ),
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    LucideIcons.camera,
                    size: 32,
                    color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Upload Bike Image',
                    style: TextStyle(
                      color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  Future<void> _pickImage() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.image,
      );

      if (result != null && result.files.single.path != null) {
        setState(() {
          _selectedImage = File(result.files.single.path!);
        });
      }
    } catch (e) {
      debugPrint('Error picking image: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to pick image')),
      );
    }
  }

  void _handleSave() {
    if (_formKey.currentState?.validate() == true) {
      final data = {
        'model': _modelController.text,
        'color': _colorController.text,
        'stock': int.tryParse(_stockController.text) ?? 1,
        'engineNumber': _engineNoController.text,
        'chassisNumber': _chassisNoController.text,
        'purchasePrice': double.tryParse(_purchasePriceController.text.replaceAll(RegExp(r'[^\d.]'), '')) ?? 0,
        'sellingPrice': double.tryParse(_sellingPriceController.text.replaceAll(RegExp(r'[^\d.]'), '')) ?? 0,
        'imageFile': _selectedImage,
      };
      widget.onSave?.call(data);
      Navigator.of(context).pop(data);
    }
  }
}

// Authored by: Moazzam Samoo
