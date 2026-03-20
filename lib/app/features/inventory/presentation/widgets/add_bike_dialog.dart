import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:lucide_icons/lucide_icons.dart';

import 'package:tahir_showroom/app/core/constants/app_colors.dart';
import 'package:tahir_showroom/app/core/widgets/app_dialog.dart';
import 'package:tahir_showroom/app/core/widgets/color_skin_selector.dart';
import 'package:tahir_showroom/app/core/utils/thousands_separator_input_formatter.dart';
import 'package:flutter/services.dart';
import 'package:tahir_showroom/app/core/widgets/blinking_focus_builder.dart';
import 'package:tahir_showroom/app/core/widgets/app_notification_dialog.dart';

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
  final _brandController = TextEditingController();
  final _modelController = TextEditingController();
  final _engineNoController = TextEditingController();
  final _chassisNoController = TextEditingController();
  final _purchasePriceController = TextEditingController();
  final _sellingPriceController = TextEditingController();

  String? _selectedColor;
  String _selectedCondition = 'New';
  File? _selectedImage;

  final _brandFocus = FocusNode();
  final _modelFocus = FocusNode();
  final _conditionFocus = FocusNode();
  final _colorFocus = FocusNode();
  final _engineFocus = FocusNode();
  final _chassisFocus = FocusNode();
  final _purchaseFocus = FocusNode();
  final _sellingFocus = FocusNode();
  final _imageFocus = FocusNode();
  final _submitFocus = FocusNode();

  void _handleKeyboardNavigation(KeyEvent event) {
    if (event is KeyDownEvent) {
      if (event.logicalKey == LogicalKeyboardKey.arrowDown || event.logicalKey == LogicalKeyboardKey.enter) {
        if (_brandFocus.hasFocus) {
          _modelFocus.requestFocus();
        } else if (_modelFocus.hasFocus) {
          _conditionFocus.requestFocus();
        } else if (_conditionFocus.hasFocus) {
          _colorFocus.requestFocus();
        } else if (_colorFocus.hasFocus) {
          _engineFocus.requestFocus();
        } else if (_engineFocus.hasFocus) {
          _chassisFocus.requestFocus();
        } else if (_chassisFocus.hasFocus) {
          _purchaseFocus.requestFocus();
        } else if (_purchaseFocus.hasFocus) {
          _sellingFocus.requestFocus();
        } else if (_sellingFocus.hasFocus) {
          _imageFocus.requestFocus();
        } else if (_imageFocus.hasFocus) {
          if (event.logicalKey == LogicalKeyboardKey.enter) {
            _pickImage();
          } else {
            _submitFocus.requestFocus();
          }
        }
      } else if (event.logicalKey == LogicalKeyboardKey.arrowUp) {
        if (_submitFocus.hasFocus) {
          _imageFocus.requestFocus();
        } else if (_imageFocus.hasFocus) {
          _sellingFocus.requestFocus();
        } else if (_sellingFocus.hasFocus) {
          _purchaseFocus.requestFocus();
        } else if (_purchaseFocus.hasFocus) {
          _chassisFocus.requestFocus();
        } else if (_chassisFocus.hasFocus) {
          _engineFocus.requestFocus();
        } else if (_engineFocus.hasFocus) {
          _colorFocus.requestFocus();
        } else if (_colorFocus.hasFocus) {
          _conditionFocus.requestFocus();
        } else if (_conditionFocus.hasFocus) {
          _modelFocus.requestFocus();
        } else if (_modelFocus.hasFocus) {
          _brandFocus.requestFocus();
        }
      }
    }
  }

  @override
  void dispose() {
    _brandController.dispose();
    _modelController.dispose();
    _engineNoController.dispose();
    _chassisNoController.dispose();
    _purchasePriceController.dispose();
    _sellingPriceController.dispose();
    _brandFocus.dispose();
    _modelFocus.dispose();
    _conditionFocus.dispose();
    _colorFocus.dispose();
    _engineFocus.dispose();
    _chassisFocus.dispose();
    _purchaseFocus.dispose();
    _sellingFocus.dispose();
    _imageFocus.dispose();
    _submitFocus.dispose();
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
      final List<String> missingFields = [];
      if (_brandController.text.trim().isEmpty) missingFields.add('Brand');
      if (_modelController.text.trim().isEmpty) missingFields.add('Model');
      if (_selectedColor == null) missingFields.add('Color');
      
      final purchase = double.tryParse(_purchasePriceController.text.replaceAll(',', '')) ?? 0.0;
      final selling = double.tryParse(_sellingPriceController.text.replaceAll(',', '')) ?? 0.0;
      
      if (purchase <= 0) missingFields.add('Purchase Price');
      if (selling <= 0) missingFields.add('Selling Price');
      if (_selectedImage == null) missingFields.add('Bike Image');

      void executeSave() {
        if (widget.onSave != null) {
          widget.onSave!({
            'brand': _brandController.text,
            'model': _modelController.text,
            'condition': _selectedCondition,
            'color': _selectedColor,
            'engineNumber': _engineNoController.text,
            'chassisNumber': _chassisNoController.text,
            'purchasePrice': purchase,
            'sellingPrice': selling,
            'imageFile': _selectedImage,
          });
          Navigator.pop(context);
        }
      }

      if (missingFields.isNotEmpty) {
        AppNotificationDialog.showOptionalFieldsWarning(
          missingFields: missingFields,
          onProceed: executeSave,
        );
      } else {
        executeSave();
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
            child: BlinkingFocusBuilder(
              focusNode: _submitFocus,
              child: ElevatedButton(
                focusNode: _submitFocus,
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
        ),
      ],
      child: KeyboardListener(
        focusNode: FocusNode(), // Container focus node
        onKeyEvent: _handleKeyboardNavigation,
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
                          _buildInputGroup('Brand:', _brandController, 'e.g. Honda', isDark, inputBg, inputBorder, labelColor, _brandFocus, autofocus: true),
                          const SizedBox(height: 16),
                          _buildInputGroup('Model:', _modelController, 'e.g. CG125', isDark, inputBg, inputBorder, labelColor, _modelFocus),
                          const SizedBox(height: 10),
                          _buildConditionGroup('Condition:', isDark, inputBg, inputBorder, labelColor, _conditionFocus),
                          const SizedBox(height: 10),
                          _buildColorSkinGroup('Color:', labelColor, _colorFocus),
                        ],
                      ),
                      const SizedBox(height: 12),
                      _buildSection(
                        title: 'Technical Specs',
                        color: sectionHeaderBg,
                        textColor: sectionHeaderText,
                        children: [
                          _buildInputGroup('Engine No.:', _engineNoController, '', isDark, inputBg, inputBorder, labelColor, _engineFocus, maxLength: 17, isRequired: true),
                          const SizedBox(height: 10),
                          _buildInputGroup('Chassis No.:', _chassisNoController, '', isDark, inputBg, inputBorder, labelColor, _chassisFocus, maxLength: 17, isRequired: true),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
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
                          _buildInputGroup('Purchase Price:', _purchasePriceController, '0', isDark, inputBg, inputBorder, labelColor, _purchaseFocus, isNumber: true),
                          const SizedBox(height: 10),
                          _buildInputGroup('Selling Price:', _sellingPriceController, '0', isDark, inputBg, inputBorder, labelColor, _sellingFocus, isNumber: true),
                        ],
                      ),
                      const SizedBox(height: 12),
                      // Image Upload
                      BlinkingFocusBuilder(
                        focusNode: _imageFocus,
                        child: GestureDetector(
                          onTap: () {
                            _imageFocus.requestFocus();
                            _pickImage();
                          },
                          child: Container(
                            height: 140, // Reduced from 180 to fit content without scroll
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
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
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
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8), // Reduced vertical padding
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
              fontSize: 13,
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.all(12), // Reduced from 16
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
    FocusNode focusNode,
    {bool isNumber = false, bool autofocus = false, int? maxLength, bool isRequired = false}
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
        const SizedBox(width: 8),
        Expanded(
          child: BlinkingFocusBuilder(
            focusNode: focusNode,
            child: TextFormField(
              controller: controller,
              focusNode: focusNode,
              autofocus: autofocus,
              maxLength: maxLength,
              textInputAction: TextInputAction.next, // Important for keyboard nav
              keyboardType: isNumber ? TextInputType.number : TextInputType.text,
              inputFormatters: [
                if (isNumber) ThousandsSeparatorInputFormatter(),
                if (maxLength != null) LengthLimitingTextInputFormatter(maxLength),
              ],
            style: TextStyle(color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary, fontSize: 13),
            decoration: InputDecoration(
              isDense: true,
              counterText: '', // Hide default counter
              hintText: hint,
              hintStyle: TextStyle(color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted, fontSize: 13),
              filled: true,
              fillColor: bg,
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
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
              validator: isRequired ? (value) {
                if (value == null || value.trim().isEmpty) return 'Required';
                return null;
              } : null,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildColorSkinGroup(
    String label,
    Color? labelColor,
    FocusNode focusNode,
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
        const SizedBox(width: 8),
        Expanded(
          child: BlinkingFocusBuilder(
            focusNode: focusNode,
            child: Focus(
              focusNode: focusNode,
              child: ColorSkinSelector(
                initialValue: _selectedColor,
                onChanged: (value) => setState(() => _selectedColor = value),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildConditionGroup(
    String label,
    bool isDark,
    Color bg,
    Color border,
    Color? labelColor,
    FocusNode focusNode,
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
        const SizedBox(width: 8),
        Expanded(
          child: BlinkingFocusBuilder(
            focusNode: focusNode,
            child: DropdownButtonFormField<String>(
              focusNode: focusNode,
              value: _selectedCondition,
              decoration: InputDecoration(
                isDense: true,
                filled: true,
                fillColor: bg,
                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
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
              dropdownColor: isDark ? AppColors.darkElevated : AppColors.lightSurface,
              style: TextStyle(color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary, fontSize: 13),
              items: ['New', 'Used'].map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (newValue) {
                if (newValue != null) {
                  setState(() => _selectedCondition = newValue);
                }
              },
            ),
          ),
        ),
      ],
    );
  }
}
