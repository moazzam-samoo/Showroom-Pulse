import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:lucide_icons/lucide_icons.dart';

import 'package:tahir_showroom/app/core/constants/app_colors.dart';
import 'package:tahir_showroom/app/core/widgets/app_dialog.dart';

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
  final _engineNoController = TextEditingController();
  final _chassisNoController = TextEditingController();
  final _purchasePriceController = TextEditingController();
  final _sellingPriceController = TextEditingController();

  String? _selectedColor;
  final List<String> _colors = ['Red', 'Black', 'Blue', 'Silver', 'White', 'Grey', 'Green', 'Other'];

  File? _selectedImage;

  @override
  void dispose() {
    _modelController.dispose();
    _engineNoController.dispose();
    _chassisNoController.dispose();
    _purchasePriceController.dispose();
    _sellingPriceController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
    );

    if (result != null && result.files.single.path != null) {
      setState(() {
        _selectedImage = File(result.files.single.path!);
      });
    }
  }

  void _handleSave() {
    if (_formKey.currentState!.validate()) {
      if (widget.onSave != null) {
        widget.onSave!({
          'model': _modelController.text,
          'color': _selectedColor,
          'engineNumber': _engineNoController.text,
          'chassisNumber': _chassisNoController.text,
          'purchasePrice': double.tryParse(_purchasePriceController.text) ?? 0.0,
          'sellingPrice': double.tryParse(_sellingPriceController.text) ?? 0.0,
          'imageFile': _selectedImage,
        });
        Navigator.pop(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Theme Colors
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final sectionHeaderBg = isDark ? AppColors.darkPrimary : AppColors.lightPrimary;
    final sectionHeaderText = Colors.white;
    // Updated to use AppColors directly for consistency
    final labelColor = isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary;
    final inputBg = isDark ? AppColors.darkElevated : AppColors.lightBackground;
    final inputBorder = isDark ? AppColors.darkBorderInput : AppColors.lightBorder;

    return AppDialog(
      title: 'Add New Motorcycle',
      subtitle: 'Tahir Showroom Inventory Management',
      onSubmit: _handleSave, // Binds ENTER key to this
      actions: [
        Expanded(
          child: SizedBox(
            height: 50,
            child: ElevatedButton(
              onPressed: _handleSave,
              style: ElevatedButton.styleFrom(
                backgroundColor: sectionHeaderBg,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              child: const Text(
                'Save to Inventory (Enter)',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ),
      ],
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Left Column
                Expanded(
                  flex: 1,
                  child: Column(
                    children: [
                      _buildSection(
                        title: 'Basic Details',
                        color: sectionHeaderBg,
                        textColor: sectionHeaderText,
                        children: [
                          _buildInputGroup('Model:', _modelController, 'e.g. Honda CG125', isDark, inputBg, inputBorder, labelColor, autofocus: true),
                          const SizedBox(height: 16),
                          _buildDropdownGroup('Color:', isDark, inputBg, inputBorder, labelColor),
                        ],
                      ),
                      const SizedBox(height: 24),
                      _buildSection(
                        title: 'Technical Specs',
                        color: sectionHeaderBg,
                        textColor: sectionHeaderText,
                        children: [
                          _buildInputGroup('Engine No.:', _engineNoController, '', isDark, inputBg, inputBorder, labelColor),
                          const SizedBox(height: 16),
                          _buildInputGroup('Chassis No.:', _chassisNoController, '', isDark, inputBg, inputBorder, labelColor),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 24),
                // Right Column
                Expanded(
                  flex: 1,
                  child: Column(
                    children: [
                      _buildSection(
                        title: 'Financials',
                        color: sectionHeaderBg,
                        textColor: sectionHeaderText,
                        children: [
                          _buildInputGroup('Purchase Price:', _purchasePriceController, '0', isDark, inputBg, inputBorder, labelColor, isNumber: true),
                          const SizedBox(height: 16),
                          _buildInputGroup('Selling Price:', _sellingPriceController, '0', isDark, inputBg, inputBorder, labelColor, isNumber: true),
                        ],
                      ),
                      const SizedBox(height: 24),
                      // Image Upload
                      GestureDetector(
                        onTap: _pickImage,
                        child: Container(
                          height: 180,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: inputBg,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: inputBorder, width: 2),
                          ),
                          child: _selectedImage != null
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Image.file(_selectedImage!, fit: BoxFit.cover),
                                )
                              : Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(LucideIcons.camera, size: 48, color: isDark ? Colors.grey[500] : Colors.grey[400]),
                                    const SizedBox(height: 8),
                                    Text(
                                      'Upload Bike Image',
                                      style: TextStyle(
                                        color: isDark ? Colors.grey[400] : Colors.grey[600],
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required Color color,
    required Color textColor,
    required List<Widget> children,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            color: color,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(8),
              topRight: Radius.circular(8),
            ),
          ),
          child: Text(
            title,
            style: TextStyle(
              color: textColor,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0x0DFFFFFF),
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(8),
              bottomRight: Radius.circular(8),
            ),
            border: Border.all(color: const Color(0xFF374151).withOpacity(0.5)),
          ),
          child: Column(children: children),
        ),
      ],
    );
  }

  Widget _buildInputGroup(
    String label,
    TextEditingController controller,
    String hint,
    bool isDark,
    Color bg,
    Color border,
    Color? labelColor,
    {bool isNumber = false, bool autofocus = false}
  ) {
    return Row(
      children: [
        SizedBox(
          width: 80,
          child: Text(
            label.replaceAll(':', ''),
            style: TextStyle(
              color: labelColor,
              fontWeight: FontWeight.w600,
              fontSize: 13,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: TextFormField(
            controller: controller,
            autofocus: autofocus,
            textInputAction: TextInputAction.next, // Important for keyboard nav
            keyboardType: isNumber ? TextInputType.number : TextInputType.text,
            style: TextStyle(color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: TextStyle(color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted),
              filled: true,
              fillColor: bg,
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: border),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: border),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: isDark ? AppColors.darkPrimary : AppColors.lightPrimary, width: 2),
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) return 'Required';
              return null;
            },
          ),
        ),
      ],
    );
  }

  Widget _buildDropdownGroup(
    String label,
    bool isDark,
    Color bg,
    Color border,
    Color? labelColor,
  ) {
    return Row(
      children: [
        SizedBox(
          width: 80,
          child: Text(
            label.replaceAll(':', ''),
            style: TextStyle(
              color: labelColor,
              fontWeight: FontWeight.w600,
              fontSize: 13,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: DropdownButtonFormField<String>(
            value: _selectedColor,
            dropdownColor: bg,
            style: TextStyle(color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary),
            decoration: InputDecoration(
              hintText: 'Select Color',
              hintStyle: TextStyle(color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted),
              filled: true,
              fillColor: bg,
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: border),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: border),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: isDark ? AppColors.darkPrimary : AppColors.lightPrimary, width: 2),
              ),
            ),
            items: _colors.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
            onChanged: (v) => setState(() => _selectedColor = v),
            validator: (v) => v == null ? 'Required' : null,
          ),
        ),
      ],
    );
  }
}
