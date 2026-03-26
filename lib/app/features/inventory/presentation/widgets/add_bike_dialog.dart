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
import 'package:get/get.dart';
import 'package:tahir_showroom/app/features/settings/presentation/controllers/settings_controller.dart';
import 'package:tahir_showroom/app/core/widgets/app_notification_dialog.dart';
import 'package:tahir_showroom/app/core/utils/phone_number_input_formatter.dart';
import 'package:tahir_showroom/app/core/utils/cnic_input_formatter.dart';

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
  final _makerController = TextEditingController();
  final _hpController = TextEditingController();
  final _modelYearController = TextEditingController();
  final _engineNoController = TextEditingController();
  final _chassisNoController = TextEditingController();
  final _purchasePriceController = TextEditingController();
  final _sellingPriceController = TextEditingController();
  final _investmentPriceController = TextEditingController();
  final _purchaserNameController = TextEditingController();
  final _purchaserPhoneController = TextEditingController();
  final _purchaserCnicController = TextEditingController();

  String? _selectedColor;
  String _selectedCondition = 'New';
  File? _selectedImage;
  File? _purchaserCnicFrontImage;
  File? _purchaserCnicBackImage;

  // Auto-fill: mirrors Purchase Price into Investment field
  bool _useFullInvestment = false;

  @override
  void initState() {
    super.initState();
    _purchasePriceController.addListener(_syncInvestmentIfChecked);
  }

  void _syncInvestmentIfChecked() {
    if (_useFullInvestment) {
      _investmentPriceController.text = _purchasePriceController.text;
    }
  }

  final _makerFocus = FocusNode();
  final _hpFocus = FocusNode();
  final _modelYearFocus = FocusNode();
  final _conditionFocus = FocusNode();
  final _colorFocus = FocusNode();
  final _engineFocus = FocusNode();
  final _chassisFocus = FocusNode();
  final _purchaseFocus = FocusNode();
  final _sellingFocus = FocusNode();
  final _investmentFocus = FocusNode();
  final _imageFocus = FocusNode();
  final _purchaserNameFocus = FocusNode();
  final _purchaserPhoneFocus = FocusNode();
  final _purchaserCnicFocus = FocusNode();
  final _cnicFrontFocus = FocusNode();
  final _cnicBackFocus = FocusNode();
  final _submitFocus = FocusNode();

  void _handleKeyboardNavigation(KeyEvent event) {
    if (event is KeyDownEvent) {
      if (event.logicalKey == LogicalKeyboardKey.arrowDown ||
          event.logicalKey == LogicalKeyboardKey.enter) {
        if (_makerFocus.hasFocus) {
          _hpFocus.requestFocus();
        } else if (_hpFocus.hasFocus) {
          _modelYearFocus.requestFocus();
        } else if (_modelYearFocus.hasFocus) {
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
          _investmentFocus.requestFocus();
        } else if (_investmentFocus.hasFocus) {
          _imageFocus.requestFocus();
        } else if (_imageFocus.hasFocus) {
          _purchaserNameFocus.requestFocus();
        } else if (_purchaserNameFocus.hasFocus) {
          _purchaserPhoneFocus.requestFocus();
        } else if (_purchaserPhoneFocus.hasFocus) {
          _purchaserCnicFocus.requestFocus();
        } else if (_purchaserCnicFocus.hasFocus) {
          _cnicFrontFocus.requestFocus();
        } else if (_cnicFrontFocus.hasFocus) {
          _cnicBackFocus.requestFocus();
        } else if (_cnicBackFocus.hasFocus) {
          _submitFocus.requestFocus();
        }
      } else if (event.logicalKey == LogicalKeyboardKey.arrowUp) {
        if (_submitFocus.hasFocus) {
          _cnicBackFocus.requestFocus();
        } else if (_cnicBackFocus.hasFocus) {
          _cnicFrontFocus.requestFocus();
        } else if (_cnicFrontFocus.hasFocus) {
          _purchaserCnicFocus.requestFocus();
        } else if (_purchaserCnicFocus.hasFocus) {
          _purchaserPhoneFocus.requestFocus();
        } else if (_purchaserPhoneFocus.hasFocus) {
          _purchaserNameFocus.requestFocus();
        } else if (_purchaserNameFocus.hasFocus) {
          _imageFocus.requestFocus();
        } else if (_imageFocus.hasFocus) {
          _investmentFocus.requestFocus();
        } else if (_investmentFocus.hasFocus) {
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
          _modelYearFocus.requestFocus();
        } else if (_modelYearFocus.hasFocus) {
          _hpFocus.requestFocus();
        } else if (_hpFocus.hasFocus) {
          _makerFocus.requestFocus();
        }
      }
    }
  }

  @override
  void dispose() {
    _makerController.dispose();
    _hpController.dispose();
    _modelYearController.dispose();
    _engineNoController.dispose();
    _chassisNoController.dispose();
    _purchasePriceController.dispose();
    _sellingPriceController.dispose();
    _investmentPriceController.dispose();
    _purchaserNameController.dispose();
    _purchaserPhoneController.dispose();
    _purchaserCnicController.dispose();
    _makerFocus.dispose();
    _hpFocus.dispose();
    _modelYearFocus.dispose();
    _conditionFocus.dispose();
    _colorFocus.dispose();
    _engineFocus.dispose();
    _chassisFocus.dispose();
    _purchaseFocus.dispose();
    _sellingFocus.dispose();
    _investmentFocus.dispose();
    _imageFocus.dispose();
    _purchaserNameFocus.dispose();
    _purchaserPhoneFocus.dispose();
    _purchaserCnicFocus.dispose();
    _cnicFrontFocus.dispose();
    _cnicBackFocus.dispose();
    _submitFocus.dispose();
    super.dispose();
  }

  Future<void> _pickImage(
      {bool forCnicFront = false, bool forCnicBack = false}) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
    );

    if (result != null && result.files.single.path != null) {
      setState(() {
        if (forCnicFront) {
          _purchaserCnicFrontImage = File(result.files.single.path!);
        } else if (forCnicBack) {
          _purchaserCnicBackImage = File(result.files.single.path!);
        } else {
          _selectedImage = File(result.files.single.path!);
        }
      });
    }
  }

  void _handleSave() {
    if (_formKey.currentState!.validate()) {
      final List<String> missingFields = [];
      if (_makerController.text.trim().isEmpty) missingFields.add('Maker');
      if (_hpController.text.trim().isEmpty) missingFields.add('Horse Power');
      if (_modelYearController.text.trim().isEmpty)
        missingFields.add('Model (Year)');
      if (_selectedColor == null) missingFields.add('Color');

      final purchase =
          double.tryParse(_purchasePriceController.text.replaceAll(',', '')) ??
              0.0;
      final selling =
          double.tryParse(_sellingPriceController.text.replaceAll(',', '')) ??
              0.0;
      final investment =
          double.tryParse(_investmentPriceController.text.replaceAll(',', '')) ??
              0.0;

      if (purchase <= 0) missingFields.add('Purchase Price');
      if (selling <= 0) missingFields.add('Selling Price');
      if (_selectedImage == null) missingFields.add('Bike Image');

      void executeSave() {
        if (widget.onSave != null) {
          widget.onSave!({
            'maker': _makerController.text,
            'horsePower': _hpController.text,
            'modelYear':
                int.tryParse(_modelYearController.text) ?? DateTime.now().year,
            'condition': _selectedCondition,
            'color': _selectedColor,
            'engineNumber': _engineNoController.text,
            'chassisNumber': _chassisNoController.text,
            'purchasePrice': purchase,
            'sellingPrice': selling,
            'investmentAmount': investment,
            'imageFile': _selectedImage,
            'purchaserName': _purchaserNameController.text.trim(),
            'purchaserPhone': _purchaserPhoneController.text.trim(),
            'purchaserCnic': _purchaserCnicController.text.trim(),
            'purchaserCnicFront': _purchaserCnicFrontImage,
            'purchaserCnicBack': _purchaserCnicBackImage,
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
    final sectionHeaderBg =
        isDark ? AppColors.darkPrimary : AppColors.lightPrimary;
    const sectionHeaderText = Colors.white;
    // Updated to use AppColors directly for consistency
    final labelColor =
        isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary;
    final inputBg = isDark ? AppColors.darkElevated : AppColors.lightBackground;
    final inputBorder =
        isDark ? AppColors.darkBorderInput : AppColors.lightBorder;

    return AppDialog(
      title: 'Add New Motorcycle',
      subtitle: 'AL-AL-TAHIR Showroom Inventory Management',
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
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
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
                            _buildAutocompleteGroup(
                              label: 'Maker:',
                              controller: _makerController,
                              hint: 'e.g. Honda',
                              isDark: isDark,
                              bg: inputBg,
                              border: inputBorder,
                              labelColor: labelColor,
                              focusNode: _makerFocus,
                              autofocus: true,
                              getOptions: () =>
                                  Get.isRegistered<SettingsController>()
                                      ? Get.find<SettingsController>()
                                          .getBikeBrandsList()
                                      : [],
                            ),
                            const SizedBox(height: 16),
                            _buildAutocompleteGroup(
                              label: 'Horse Power:',
                              controller: _hpController,
                              hint: 'e.g. CG125',
                              isDark: isDark,
                              bg: inputBg,
                              border: inputBorder,
                              labelColor: labelColor,
                              focusNode: _hpFocus,
                              getOptions: () =>
                                  Get.isRegistered<SettingsController>()
                                      ? Get.find<SettingsController>()
                                          .getBikeModelsList()
                                      : [],
                            ),
                            const SizedBox(height: 16),
                            _buildInputGroup(
                                'Model (Year):',
                                _modelYearController,
                                'e.g. 2024',
                                isDark,
                                inputBg,
                                inputBorder,
                                labelColor,
                                _modelYearFocus,
                                isNumber: true,
                                useGrouping: false),
                            const SizedBox(height: 10),
                            _buildConditionGroup('Condition:', isDark, inputBg,
                                inputBorder, labelColor, _conditionFocus),
                            const SizedBox(height: 10),
                            _buildColorSkinGroup(
                                'Color:', labelColor, _colorFocus),
                          ],
                        ),
                        const SizedBox(height: 12),
                        _buildSection(
                          title: 'Technical Specs',
                          color: sectionHeaderBg,
                          textColor: sectionHeaderText,
                          children: [
                            _buildInputGroup(
                                'Engine No.:',
                                _engineNoController,
                                '',
                                isDark,
                                inputBg,
                                inputBorder,
                                labelColor,
                                _engineFocus,
                                maxLength: 17,
                                isRequired: true),
                            const SizedBox(height: 10),
                            _buildInputGroup(
                                'Chassis No.:',
                                _chassisNoController,
                                '',
                                isDark,
                                inputBg,
                                inputBorder,
                                labelColor,
                                _chassisFocus,
                                maxLength: 17,
                                isRequired: true),
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
                            _buildInputGroup(
                                'Purchase Price:',
                                _purchasePriceController,
                                '0',
                                isDark,
                                inputBg,
                                inputBorder,
                                labelColor,
                                _purchaseFocus,
                                isNumber: true),
                            const SizedBox(height: 10),
                            _buildInputGroup(
                                'Selling Price:',
                                _sellingPriceController,
                                '0',
                                isDark,
                                inputBg,
                                inputBorder,
                                labelColor,
                                _sellingFocus,
                                isNumber: true),
                            const SizedBox(height: 10),
                            // Investment field with auto-fill checkbox
                            _buildInvestmentRow(isDark, inputBg, inputBorder, labelColor),
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
                              height: 140,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: inputBg,
                                borderRadius: BorderRadius.circular(12),
                                border:
                                    Border.all(color: inputBorder, width: 2),
                              ),
                              child: _selectedImage != null
                                  ? ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: Image.file(_selectedImage!,
                                          fit: BoxFit.cover),
                                    )
                                  : Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(LucideIcons.camera,
                                            size: 48,
                                            color: isDark
                                                ? Colors.grey[500]
                                                : Colors.grey[400]),
                                        const SizedBox(height: 8),
                                        Text(
                                          'Upload Bike Image',
                                          style: TextStyle(
                                            color: isDark
                                                ? Colors.grey[400]
                                                : Colors.grey[600],
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        _buildSection(
                          title: 'Purchaser Details (Optional)',
                          color: sectionHeaderBg,
                          textColor: sectionHeaderText,
                          children: [
                            _buildInputGroup(
                              'Name:',
                              _purchaserNameController,
                              'Enter name',
                              isDark,
                              inputBg,
                              inputBorder,
                              labelColor,
                              _purchaserNameFocus,
                            ),
                            const SizedBox(height: 10),
                            _buildInputGroup(
                              'Phone:',
                              _purchaserPhoneController,
                              '03xx-xxxxxxx',
                              isDark,
                              inputBg,
                              inputBorder,
                              labelColor,
                              _purchaserPhoneFocus,
                              inputFormatters: [PhoneNumberInputFormatter()],
                            ),
                            const SizedBox(height: 10),
                            _buildInputGroup(
                              'CNIC:',
                              _purchaserCnicController,
                              'xxxxx-xxxxxxx-x',
                              isDark,
                              inputBg,
                              inputBorder,
                              labelColor,
                              _purchaserCnicFocus,
                              inputFormatters: [CnicInputFormatter()],
                            ),
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                Expanded(
                                  child: _buildCnicImagePicker(
                                    label: 'CNIC Front',
                                    image: _purchaserCnicFrontImage,
                                    isDark: isDark,
                                    inputBg: inputBg,
                                    inputBorder: inputBorder,
                                    focusNode: _cnicFrontFocus,
                                    onTap: () => _pickImage(forCnicFront: true),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: _buildCnicImagePicker(
                                    label: 'CNIC Back',
                                    image: _purchaserCnicBackImage,
                                    isDark: isDark,
                                    inputBg: inputBg,
                                    inputBorder: inputBorder,
                                    focusNode: _cnicBackFocus,
                                    onTap: () => _pickImage(forCnicBack: true),
                                  ),
                                ),
                              ],
                            ),
                          ],
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

  Widget _buildCnicImagePicker({
    required String label,
    required File? image,
    required bool isDark,
    required Color inputBg,
    required Color inputBorder,
    required FocusNode focusNode,
    required VoidCallback onTap,
  }) {
    return BlinkingFocusBuilder(
      focusNode: focusNode,
      child: GestureDetector(
        onTap: () {
          focusNode.requestFocus();
          onTap();
        },
        child: Container(
          height: 80,
          decoration: BoxDecoration(
            color: inputBg,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: inputBorder, width: 2),
          ),
          child: image != null
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: Image.file(image, fit: BoxFit.cover),
                )
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(LucideIcons.image,
                        size: 24,
                        color: isDark ? Colors.grey[500] : Colors.grey[400]),
                    const SizedBox(height: 4),
                    Text(
                      label,
                      style: TextStyle(
                        fontSize: 11,
                        color: isDark ? Colors.grey[400] : Colors.grey[600],
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
    required Color color,
    required Color textColor,
    required List<Widget> children,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(
              horizontal: 16, vertical: 8), // Reduced vertical padding
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
      {bool isNumber = false,
      bool useGrouping = true,
      bool autofocus = false,
      int? maxLength,
      bool isRequired = false,
      List<TextInputFormatter>? inputFormatters}) {
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
              textInputAction:
                  TextInputAction.next, // Important for keyboard nav
              keyboardType:
                  isNumber ? TextInputType.number : TextInputType.text,
              inputFormatters: [
                if (isNumber && useGrouping) ThousandsSeparatorInputFormatter(),
                if (maxLength != null)
                  LengthLimitingTextInputFormatter(maxLength),
                if (inputFormatters != null) ...inputFormatters,
              ],
              style: TextStyle(
                  color: isDark
                      ? AppColors.darkTextPrimary
                      : AppColors.lightTextPrimary,
                  fontSize: 13),
              decoration: InputDecoration(
                isDense: true,
                counterText: '', // Hide default counter
                hintText: hint,
                hintStyle: TextStyle(
                    color: isDark
                        ? AppColors.darkTextMuted
                        : AppColors.lightTextMuted,
                    fontSize: 13),
                filled: true,
                fillColor: bg,
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
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
                  borderSide: BorderSide(
                      color: isDark
                          ? AppColors.darkPrimary
                          : AppColors.lightPrimary,
                      width: 2),
                ),
              ),
              validator: isRequired
                  ? (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Required';
                      }
                      return null;
                    }
                  : null,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAutocompleteGroup({
    required String label,
    required TextEditingController controller,
    required String hint,
    required bool isDark,
    required Color bg,
    required Color border,
    required Color? labelColor,
    required FocusNode focusNode,
    required Iterable<String> Function() getOptions,
    bool autofocus = false,
  }) {
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
            child: Autocomplete<String>(
              optionsBuilder: (TextEditingValue textEditingValue) {
                final currentOptions = getOptions();
                if (textEditingValue.text.isEmpty) {
                  return currentOptions;
                }
                return currentOptions.where((String option) {
                  return option
                      .toLowerCase()
                      .contains(textEditingValue.text.toLowerCase());
                });
              },
              onSelected: (String selection) {
                controller.text = selection;
              },
              fieldViewBuilder: (BuildContext context,
                  TextEditingController fieldTextEditingController,
                  FocusNode fieldFocusNode,
                  VoidCallback onFieldSubmitted) {
                // Keep the internal text controller synced with our external one
                fieldTextEditingController.text = controller.text;
                fieldTextEditingController.addListener(() {
                  controller.text = fieldTextEditingController.text;
                });

                // Keep the focus node synced
                focusNode.addListener(() {
                  if (focusNode.hasFocus && !fieldFocusNode.hasFocus) {
                    fieldFocusNode.requestFocus();
                  }
                });
                fieldFocusNode.addListener(() {
                  if (fieldFocusNode.hasFocus && !focusNode.hasFocus) {
                    focusNode.requestFocus();
                  }
                });

                return TextFormField(
                  controller: fieldTextEditingController,
                  focusNode: fieldFocusNode,
                  autofocus: autofocus,
                  textInputAction: TextInputAction.next,
                  style: TextStyle(
                      color: isDark
                          ? AppColors.darkTextPrimary
                          : AppColors.lightTextPrimary,
                      fontSize: 13),
                  decoration: InputDecoration(
                    isDense: true,
                    hintText: hint,
                    hintStyle: TextStyle(
                        color: isDark
                            ? AppColors.darkTextMuted
                            : AppColors.lightTextMuted,
                        fontSize: 13),
                    filled: true,
                    fillColor: bg,
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
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
                      borderSide: BorderSide(
                          color: isDark
                              ? AppColors.darkPrimary
                              : AppColors.lightPrimary,
                          width: 2),
                    ),
                    suffixIcon: Icon(Icons.arrow_drop_down,
                        color: isDark
                            ? AppColors.darkTextMuted
                            : AppColors.lightTextMuted),
                    suffixIconConstraints:
                        const BoxConstraints(minWidth: 32, minHeight: 32),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) return 'Required';
                    return null;
                  },
                );
              },
              optionsViewBuilder: (BuildContext context,
                  AutocompleteOnSelected<String> onSelected,
                  Iterable<String> options) {
                return Align(
                  alignment: Alignment.topLeft,
                  child: Material(
                    elevation: 4.0,
                    borderRadius: BorderRadius.circular(8),
                    color: isDark
                        ? AppColors.darkElevated
                        : AppColors.lightSurface,
                    child: Container(
                      width: 200, // Approximate width of the input field
                      constraints: const BoxConstraints(maxHeight: 200),
                      child: ListView.builder(
                        padding: EdgeInsets.zero,
                        shrinkWrap: true,
                        itemCount: options.length,
                        itemBuilder: (BuildContext context, int index) {
                          final String option = options.elementAt(index);
                          return InkWell(
                            onTap: () {
                              onSelected(option);
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Text(
                                option,
                                style: TextStyle(
                                  color: isDark
                                      ? AppColors.darkTextPrimary
                                      : AppColors.lightTextPrimary,
                                  fontSize: 13,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                );
              },
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
              initialValue: _selectedCondition,
              decoration: InputDecoration(
                isDense: true,
                filled: true,
                fillColor: bg,
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
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
                  borderSide: BorderSide(
                      color: isDark
                          ? AppColors.darkPrimary
                          : AppColors.lightPrimary,
                      width: 2),
                ),
              ),
              dropdownColor:
                  isDark ? AppColors.darkElevated : AppColors.lightSurface,
              style: TextStyle(
                  color: isDark
                      ? AppColors.darkTextPrimary
                      : AppColors.lightTextPrimary,
                  fontSize: 13),
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

  Widget _buildInvestmentRow(
    bool isDark,
    Color inputBg,
    Color inputBorder,
    Color labelColor,
  ) {
    final primaryColor =
        isDark ? AppColors.darkPrimary : AppColors.lightPrimary;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label row with checkbox
        Row(
          children: [
            Text(
              'Investment:',
              style: TextStyle(fontSize: 13, color: labelColor),
            ),
            const Spacer(),
            // Checkbox
            InkWell(
              onTap: () {
                setState(() {
                  _useFullInvestment = !_useFullInvestment;
                  if (_useFullInvestment) {
                    _investmentPriceController.text =
                        _purchasePriceController.text;
                  }
                });
              },
              borderRadius: BorderRadius.circular(4),
              child: Row(
                children: [
                  SizedBox(
                    width: 18,
                    height: 18,
                    child: Checkbox(
                      value: _useFullInvestment,
                      activeColor: primaryColor,
                      side: BorderSide(color: primaryColor.withOpacity(0.5)),
                      onChanged: (val) {
                        setState(() {
                          _useFullInvestment = val ?? false;
                          if (_useFullInvestment) {
                            _investmentPriceController.text =
                                _purchasePriceController.text;
                          }
                        });
                      },
                    ),
                  ),
                  const SizedBox(width: 5),
                  Text(
                    'Full from Capital',
                    style: TextStyle(
                      fontSize: 11,
                      color: _useFullInvestment
                          ? primaryColor
                          : labelColor.withOpacity(0.7),
                      fontWeight: _useFullInvestment
                          ? FontWeight.w600
                          : FontWeight.normal,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        // Investment input (read-only when checkbox is checked)
        BlinkingFocusBuilder(
          focusNode: _investmentFocus,
          child: TextFormField(
            controller: _investmentPriceController,
            focusNode: _investmentFocus,
            readOnly: _useFullInvestment,
            keyboardType:
                const TextInputType.numberWithOptions(decimal: true),
            inputFormatters: [ThousandsSeparatorInputFormatter()],
            decoration: InputDecoration(
              hintText: '0',
              hintStyle: TextStyle(
                  color: isDark ? Colors.grey[500] : Colors.grey[400]),
              filled: true,
              fillColor: _useFullInvestment
                  ? (isDark
                      ? primaryColor.withOpacity(0.08)
                      : primaryColor.withOpacity(0.05))
                  : inputBg,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: inputBorder),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(
                  color: _useFullInvestment
                      ? primaryColor.withOpacity(0.4)
                      : inputBorder,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: primaryColor, width: 2),
              ),
              suffixIcon: _useFullInvestment
                  ? Tooltip(
                      message: 'Auto-filled from Purchase Price',
                      child: Icon(Icons.link,
                          size: 16, color: primaryColor.withOpacity(0.7)),
                    )
                  : null,
            ),
            style: TextStyle(
              color: _useFullInvestment
                  ? primaryColor
                  : (isDark ? Colors.white : Colors.black),
              fontSize: 13,
              fontWeight: _useFullInvestment
                  ? FontWeight.w600
                  : FontWeight.normal,
            ),
          ),
        ),
      ],
    );
  }
}
