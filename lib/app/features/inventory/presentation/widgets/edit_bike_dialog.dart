import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:intl/intl.dart';

import 'package:tahir_showroom/app/core/constants/app_colors.dart';
import 'package:tahir_showroom/app/core/widgets/app_dialog.dart';
import 'package:tahir_showroom/app/core/widgets/color_skin_selector.dart';
import 'package:tahir_showroom/app/data/models/bike.dart';
import 'package:flutter/services.dart';
import 'package:tahir_showroom/app/core/widgets/blinking_focus_builder.dart';
import 'package:tahir_showroom/app/core/utils/thousands_separator_input_formatter.dart';
import 'package:get/get.dart';
import 'package:tahir_showroom/app/features/settings/presentation/controllers/settings_controller.dart';
import 'package:tahir_showroom/app/core/utils/phone_number_input_formatter.dart';
import 'package:tahir_showroom/app/core/utils/cnic_input_formatter.dart';
import 'package:tahir_showroom/app/core/widgets/app_toast.dart';

class EditBikeDialog extends StatefulWidget {
  final Bike bike;
  final Function(Map<String, dynamic>)? onSave;

  const EditBikeDialog({
    super.key,
    required this.bike,
    this.onSave,
  });

  @override
  State<EditBikeDialog> createState() => _EditBikeDialogState();
}

class _EditBikeDialogState extends State<EditBikeDialog> {
  final _formKey = GlobalKey<FormState>();
  
  // Form controllers
  late final TextEditingController _makerController;
  late final TextEditingController _hpController;
  late final TextEditingController _engineNoController;
  late final TextEditingController _chassisNoController;
  late final TextEditingController _purchasePriceController;
  late final TextEditingController _sellingPriceController;
  late final TextEditingController _purchaserNameController;
  late final TextEditingController _purchaserPhoneController;
  late final TextEditingController _purchaserCnicController;
  late final TextEditingController _modelYearController;
  late final TextEditingController _regNumberController;

  String? _selectedColor;
  BikeConditionEnum _selectedCondition = BikeConditionEnum.newBike;

  File? _selectedImage;
  String? _existingImagePath;

  final _makerFocus = FocusNode();
  final _hpFocus = FocusNode();
  final _conditionFocus = FocusNode();
  final _colorFocus = FocusNode();
  final _engineFocus = FocusNode();
  final _chassisFocus = FocusNode();
  final _purchaseFocus = FocusNode();
  final _sellingFocus = FocusNode();
  final _purchaserNameFocus = FocusNode();
  final _purchaserPhoneFocus = FocusNode();
  final _purchaserCnicFocus = FocusNode();
  final _imageFocus = FocusNode();
  final _modelYearFocus = FocusNode();
  final _regNumberFocus = FocusNode();
  final _submitFocus = FocusNode();

  void _handleKeyboardNavigation(KeyEvent event) {
    if (event is KeyDownEvent) {
      if (event.logicalKey == LogicalKeyboardKey.arrowDown || event.logicalKey == LogicalKeyboardKey.enter) {
        if (_makerFocus.hasFocus) {
          _hpFocus.requestFocus();
        } else if (_hpFocus.hasFocus) {
          _modelYearFocus.requestFocus();
        } else if (_modelYearFocus.hasFocus) {
          _conditionFocus.requestFocus();
        } else if (_conditionFocus.hasFocus) {
          if (_selectedCondition == BikeConditionEnum.usedBike) {
            _regNumberFocus.requestFocus();
          } else {
            _colorFocus.requestFocus();
          }
        } else if (_regNumberFocus.hasFocus) {
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
          _purchaserNameFocus.requestFocus();
        } else if (_purchaserNameFocus.hasFocus) {
          _purchaserPhoneFocus.requestFocus();
        } else if (_purchaserPhoneFocus.hasFocus) {
          _purchaserCnicFocus.requestFocus();
        } else if (_purchaserCnicFocus.hasFocus) {
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
          _purchaserCnicFocus.requestFocus();
        } else if (_purchaserCnicFocus.hasFocus) {
          _purchaserPhoneFocus.requestFocus();
        } else if (_purchaserPhoneFocus.hasFocus) {
          _purchaserNameFocus.requestFocus();
        } else if (_purchaserNameFocus.hasFocus) {
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
        } else if (_colorFocus.hasFocus) {
          if (_selectedCondition == BikeConditionEnum.usedBike) {
            _regNumberFocus.requestFocus();
          } else {
            _conditionFocus.requestFocus();
          }
        } else if (_regNumberFocus.hasFocus) {
          _conditionFocus.requestFocus();
        }
      }
    }
  }

  @override
  void initState() {
    super.initState();
    // Pre-fill controllers with existing bike data
    _makerController = TextEditingController(text: widget.bike.model);
    _hpController = TextEditingController(text: widget.bike.brand);
    _engineNoController = TextEditingController(text: widget.bike.engineNumber);
    _chassisNoController = TextEditingController(text: widget.bike.chassisNumber);
    
    // Format prices with commas on initial load
    final NumberFormat numberFormat = NumberFormat('#,###', 'en_US');
    _purchasePriceController = TextEditingController(
      text: widget.bike.purchasePrice > 0 ? numberFormat.format(widget.bike.purchasePrice) : ''
    );
    _sellingPriceController = TextEditingController(
      text: widget.bike.cashSalePrice > 0 ? numberFormat.format(widget.bike.cashSalePrice) : ''
    );
    _purchaserNameController = TextEditingController(text: widget.bike.purchaserName ?? '');
    _purchaserPhoneController = TextEditingController(text: widget.bike.purchaserPhone ?? '');
    _purchaserCnicController = TextEditingController(text: widget.bike.purchaserCnic ?? '');
    _modelYearController = TextEditingController(text: widget.bike.modelYear.toString());
    _regNumberController = TextEditingController(text: widget.bike.registrationNumber ?? '');
    
    _selectedColor = widget.bike.color;
    _selectedCondition = widget.bike.condition;
    _existingImagePath = widget.bike.imageFilename;
  }

  @override
  void dispose() {
    _makerController.dispose();
    _hpController.dispose();
    _engineNoController.dispose();
    _chassisNoController.dispose();
    _purchasePriceController.dispose();
    _sellingPriceController.dispose();
    _purchaserNameController.dispose();
    _purchaserPhoneController.dispose();
    _purchaserCnicController.dispose();
    _modelYearController.dispose();
    _regNumberController.dispose();
    _makerFocus.dispose();
    _hpFocus.dispose();
    _conditionFocus.dispose();
    _colorFocus.dispose();
    _engineFocus.dispose();
    _chassisFocus.dispose();
    _purchaseFocus.dispose();
    _sellingFocus.dispose();
    _purchaserNameFocus.dispose();
    _purchaserPhoneFocus.dispose();
    _purchaserCnicFocus.dispose();
    _imageFocus.dispose();
    _modelYearFocus.dispose();
    _regNumberFocus.dispose();
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
      bool missingPurchaserDetails = _purchaserNameController.text.trim().isEmpty || 
                                     _purchaserPhoneController.text.trim().isEmpty || 
                                     _purchaserCnicController.text.trim().isEmpty;
      if (missingPurchaserDetails) {
        AppToast.showInfo(
          title: 'Purchaser Details Missing',
          message: 'Bike information saved, but some purchaser details were omitted.',
        );
      }

      if (widget.onSave != null) {
        widget.onSave!({
          'maker': _makerController.text,
          'horsePower': _hpController.text,
          'condition': _selectedCondition == BikeConditionEnum.newBike ? 'New' : 'Used',
          'color': _selectedColor,
          'engineNumber': _engineNoController.text,
          'chassisNumber': _chassisNoController.text,
          'purchasePrice': double.tryParse(_purchasePriceController.text.replaceAll(',', '')) ?? 0.0,
          'sellingPrice': double.tryParse(_sellingPriceController.text.replaceAll(',', '')) ?? 0.0,
          'imageFile': _selectedImage, // null if no new image selected
          'purchaserName': _purchaserNameController.text.trim(),
          'purchaserPhone': _purchaserPhoneController.text.trim(),
          'purchaserCnic': _purchaserCnicController.text.trim(),
          'modelYear': int.tryParse(_modelYearController.text) ?? widget.bike.modelYear,
          'registrationNumber': _selectedCondition == BikeConditionEnum.usedBike ? _regNumberController.text.trim() : null,
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
    const sectionHeaderText = Colors.white;
    final labelColor = isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary;
    final inputBg = isDark ? AppColors.darkElevated : AppColors.lightBackground;
    final inputBorder = isDark ? AppColors.darkBorderInput : AppColors.lightBorder;

    return AppDialog(
      title: 'Edit Motorcycle',
      subtitle: 'Update ${widget.bike.model} Details',
      onSubmit: _handleSave,
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
                  'Save Changes (Enter)',
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
                            getOptions: () => Get.isRegistered<SettingsController>()
                                ? Get.find<SettingsController>().getBikeBrandsList()
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
                            getOptions: () => Get.isRegistered<SettingsController>()
                                ? Get.find<SettingsController>().getBikeModelsList()
                                : [],
                          ),
                          const SizedBox(height: 16),
                          _buildAutocompleteGroup(
                            label: 'Model (Year):',
                            controller: _modelYearController,
                            hint: 'e.g. 2024',
                            isDark: isDark,
                            bg: inputBg,
                            border: inputBorder,
                            labelColor: labelColor,
                            focusNode: _modelYearFocus,
                            getOptions: () => Get.isRegistered<SettingsController>()
                                ? Get.find<SettingsController>().getBikeYearsList()
                                : [],
                          ),
                          const SizedBox(height: 16),
                          _buildConditionGroup(
                              'Condition:', 
                              labelColor, 
                              inputBg, 
                              inputBorder, 
                              _conditionFocus, 
                              isDark,
                              onChanged: (val) {
                                setState(() {
                                  _selectedCondition = val;
                                });
                              },
                          ),
                          if (_selectedCondition == BikeConditionEnum.usedBike) ...[
                            const SizedBox(height: 16),
                            _buildInputGroup('Reg #:', _regNumberController, 'Enter registration number', isDark, inputBg, inputBorder, labelColor, _regNumberFocus),
                          ],
                          const SizedBox(height: 16),
                          _buildColorSkinGroup('Color:', labelColor, _colorFocus),
                        ],
                      ),
                      const SizedBox(height: 24),
                      _buildSection(
                        title: 'Technical Specs',
                        color: sectionHeaderBg,
                        textColor: sectionHeaderText,
                        children: [
                          _buildInputGroup('Engine No.:', _engineNoController, '', isDark, inputBg, inputBorder, labelColor, _engineFocus, maxLength: 17),
                          const SizedBox(height: 16),
                          _buildInputGroup('Chassis No.:', _chassisNoController, '', isDark, inputBg, inputBorder, labelColor, _chassisFocus, maxLength: 17),
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
                          _buildInputGroup('Purchase Price:', _purchasePriceController, '0', isDark, inputBg, inputBorder, labelColor, _purchaseFocus, isNumber: true),
                          const SizedBox(height: 16),
                          _buildInputGroup('Selling Price:', _sellingPriceController, '0', isDark, inputBg, inputBorder, labelColor, _sellingFocus, isNumber: true),
                        ],
                      ),
                      const SizedBox(height: 24),
                      _buildSection(
                        title: 'Purchaser Details (Optional)',
                        color: sectionHeaderBg,
                        textColor: sectionHeaderText,
                        children: [
                          _buildInputGroup('Name:', _purchaserNameController, 'Enter name', isDark, inputBg, inputBorder, labelColor, _purchaserNameFocus, isOptional: true),
                          const SizedBox(height: 16),
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
                            isOptional: true,
                          ),
                          const SizedBox(height: 16),
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
                            isOptional: true,
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      // Image Upload
                      BlinkingFocusBuilder(
                        focusNode: _imageFocus,
                        child: GestureDetector(
                          onTap: () {
                            _imageFocus.requestFocus();
                            _pickImage();
                          },
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
                              : _existingImagePath != null && _existingImagePath!.isNotEmpty
                                  ? ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: Image.file(
                                        File(_existingImagePath!),
                                        fit: BoxFit.cover,
                                        errorBuilder: (_, __, ___) => _buildImagePlaceholder(isDark),
                                      ),
                                    )
                                  : _buildImagePlaceholder(isDark),
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

  Widget _buildImagePlaceholder(bool isDark) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(LucideIcons.camera, size: 48, color: isDark ? Colors.grey[500] : Colors.grey[400]),
        const SizedBox(height: 8),
        Text(
          'Tap to Update Image',
          style: TextStyle(
            color: isDark ? Colors.grey[400] : Colors.grey[600],
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
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
    FocusNode focusNode,
    {bool isNumber = false, bool autofocus = false, int? maxLength, List<TextInputFormatter>? inputFormatters, bool isOptional = false}
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
          child: BlinkingFocusBuilder(
            focusNode: focusNode,
            child: TextFormField(
              controller: controller,
              focusNode: focusNode,
              autofocus: autofocus,
              maxLength: maxLength,
              textInputAction: TextInputAction.next,
              keyboardType: isNumber ? TextInputType.number : TextInputType.text,
              inputFormatters: [
                if (isNumber) FilteringTextInputFormatter.digitsOnly,
                if (isNumber && !label.contains('Year')) ThousandsSeparatorInputFormatter(),
                if (maxLength != null) LengthLimitingTextInputFormatter(maxLength),
                if (inputFormatters != null) ...inputFormatters,
              ],
              style: TextStyle(color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary),
              decoration: InputDecoration(
              counterText: '', // Hide default counter
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
                if (!isOptional && (value == null || value.isEmpty)) return 'Required';
                return null;
              },
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
        const SizedBox(width: 12),
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
                  return option.toLowerCase().contains(textEditingValue.text.toLowerCase());
                });
              },
              onSelected: (String selection) {
                controller.text = selection;
              },
              fieldViewBuilder: (BuildContext context, TextEditingController fieldTextEditingController, FocusNode fieldFocusNode, VoidCallback onFieldSubmitted) {
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
                  style: TextStyle(color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary),
                  decoration: InputDecoration(
                    counterText: '', // Hide default counter
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
                    suffixIcon: Icon(Icons.arrow_drop_down, color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted),
                    suffixIconConstraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) return 'Required';
                    return null;
                  },
                );
              },
              optionsViewBuilder: (BuildContext context, AutocompleteOnSelected<String> onSelected, Iterable<String> options) {
                return Align(
                  alignment: Alignment.topLeft,
                  child: Material(
                    elevation: 4.0,
                    borderRadius: BorderRadius.circular(8),
                    color: isDark ? AppColors.darkElevated : AppColors.lightSurface,
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
                                  color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
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
        const SizedBox(width: 12),
        Expanded(
          child: BlinkingFocusBuilder(
            focusNode: focusNode,
            child: Focus(
              focusNode: focusNode,
              child: ColorSkinSelector(
                initialValue: _selectedColor,
                onChanged: (value) => setState(() => _selectedColor = value),
                validator: (v) => v == null ? 'Required' : null,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildConditionGroup(
    String label,
    Color? labelColor,
    Color bg,
    Color border,
    FocusNode focusNode,
    bool isDark, {
    Function(BikeConditionEnum)? onChanged,
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
        const SizedBox(width: 12),
        Expanded(
          child: BlinkingFocusBuilder(
            focusNode: focusNode,
            child: Focus(
              focusNode: focusNode,
              child: DropdownButtonFormField<BikeConditionEnum>(
                value: _selectedCondition,
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  filled: true,
                  fillColor: bg,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: border),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: border),
                  ),
                ),
                dropdownColor: isDark ? AppColors.darkElevated : AppColors.lightSurface,
                style: TextStyle(color: isDark ? Colors.white : Colors.black, fontSize: 13),
                items: const [
                  DropdownMenuItem(value: BikeConditionEnum.newBike, child: Text('New')),
                  DropdownMenuItem(value: BikeConditionEnum.usedBike, child: Text('Used')),
                ],
                onChanged: (val) {
                  if (val != null) {
                    setState(() => _selectedCondition = val);
                    if (onChanged != null) onChanged(val);
                  }
                },
              ),
            ),
          ),
        ),
      ],
    );
  }
}
