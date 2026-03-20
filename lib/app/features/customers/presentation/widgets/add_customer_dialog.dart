import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:get/get.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:tahir_showroom/app/data/models/customer.dart';
import 'package:tahir_showroom/app/core/services/file_service.dart' as tahir_showroom;
import 'package:tahir_showroom/app/core/constants/app_colors.dart';
import 'package:tahir_showroom/app/core/widgets/app_dialog.dart';
import 'package:tahir_showroom/app/core/utils/cnic_input_formatter.dart';
import 'package:tahir_showroom/app/core/utils/phone_number_input_formatter.dart';
import 'package:flutter/services.dart';
import 'package:tahir_showroom/app/core/widgets/blinking_focus_builder.dart';
import 'package:tahir_showroom/app/core/widgets/app_notification_dialog.dart';

class AddCustomerDialog extends StatefulWidget {
  final Customer? customer;
  final Function(Map<String, dynamic>)? onSave;

  const AddCustomerDialog({
    super.key,
    this.customer,
    this.onSave,
  });

  @override
  State<AddCustomerDialog> createState() => _AddCustomerDialogState();
}

class _AddCustomerDialogState extends State<AddCustomerDialog> {
  final _formKey = GlobalKey<FormState>();
  
  // Form controllers
  late final TextEditingController _nameController;
  late final TextEditingController _fatherNameController;
  late final TextEditingController _cnicController;
  late final TextEditingController _phoneController;
  late final TextEditingController _addressController;

  File? _profileImage;
  File? _cnicFrontImage;
  File? _cnicBackImage;

  // Existing images (Files on disk, but path stored)
  String? _existingProfileImage;
  String? _existingCnicFrontImage;
  String? _existingCnicBackImage;

  final _nameFocus = FocusNode();
  final _fatherNameFocus = FocusNode();
  final _cnicFocus = FocusNode();
  final _phoneFocus = FocusNode();
  final _addressFocus = FocusNode();
  final _profilePicFocus = FocusNode();
  final _cnicFrontFocus = FocusNode();
  final _cnicBackFocus = FocusNode();
  final _submitFocus = FocusNode();

  void _handleKeyboardNavigation(KeyEvent event) {
    if (event is KeyDownEvent) {
      if (event.logicalKey == LogicalKeyboardKey.arrowDown || event.logicalKey == LogicalKeyboardKey.enter) {
        if (_nameFocus.hasFocus) {
          _fatherNameFocus.requestFocus();
        } else if (_fatherNameFocus.hasFocus) {
          _cnicFocus.requestFocus();
        } else if (_cnicFocus.hasFocus) {
          _phoneFocus.requestFocus();
        } else if (_phoneFocus.hasFocus) {
          _addressFocus.requestFocus();
        } else if (_addressFocus.hasFocus) {
          _profilePicFocus.requestFocus();
        } else if (_profilePicFocus.hasFocus) {
          if (event.logicalKey == LogicalKeyboardKey.enter) {
            _pickImage('profile');
          } else {
            _cnicFrontFocus.requestFocus();
          }
        } else if (_cnicFrontFocus.hasFocus) {
          if (event.logicalKey == LogicalKeyboardKey.enter) {
            _pickImage('cnic_front');
          } else {
            _cnicBackFocus.requestFocus();
          }
        } else if (_cnicBackFocus.hasFocus) {
          if (event.logicalKey == LogicalKeyboardKey.enter) {
            _pickImage('cnic_back');
          } else {
            _submitFocus.requestFocus();
          }
        }
      } else if (event.logicalKey == LogicalKeyboardKey.arrowUp) {
        if (_submitFocus.hasFocus) {
          _cnicBackFocus.requestFocus();
        } else if (_cnicBackFocus.hasFocus) {
          _cnicFrontFocus.requestFocus();
        } else if (_cnicFrontFocus.hasFocus) {
          _profilePicFocus.requestFocus();
        } else if (_profilePicFocus.hasFocus) {
          _addressFocus.requestFocus();
        } else if (_addressFocus.hasFocus) {
          _phoneFocus.requestFocus();
        } else if (_phoneFocus.hasFocus) {
          _cnicFocus.requestFocus();
        } else if (_cnicFocus.hasFocus) {
          _fatherNameFocus.requestFocus();
        } else if (_fatherNameFocus.hasFocus) {
          _nameFocus.requestFocus();
        }
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.customer?.fullName ?? '');
    _fatherNameController = TextEditingController(text: widget.customer?.fatherName ?? '');
    _cnicController = TextEditingController(text: widget.customer?.cnicNumber ?? '');
    _phoneController = TextEditingController(text: widget.customer?.phoneNumber ?? '');
    _addressController = TextEditingController(text: widget.customer?.address ?? '');

    if (widget.customer != null) {
      _loadExistingImages();
    }
  }

  void _loadExistingImages() {
    final fileService = Get.find<tahir_showroom.FileService>();
    final cnic = widget.customer!.cnicNumber;

    if (widget.customer!.profileImageFilename != null) {
      _existingProfileImage = fileService.getCustomerProfileImagePath(
        widget.customer!.profileImageFilename!, 
        cnic
      );
    }
    if (widget.customer!.cnicFrontFilename != null) {
      _existingCnicFrontImage = fileService.getCustomerProfileImagePath( // Note: getCustomerMediaPath logic is same base, just check if it handles subfolders correctly? 
        // Wait, file_service.dart: getCustomerProfileImagePath uses `p.join(customersMediaPath, sanitizedCnic, filename)`
        // saveCustomerImage uses `p.join(customerPath, filename)`. 
        // So yes, flat structure in specific customer folder.
        widget.customer!.cnicFrontFilename!, 
        cnic
      );
    }
    if (widget.customer!.cnicBackFilename != null) {
      _existingCnicBackImage = fileService.getCustomerProfileImagePath(
        widget.customer!.cnicBackFilename!, 
        cnic
      );
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _fatherNameController.dispose();
    _cnicController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _nameFocus.dispose();
    _fatherNameFocus.dispose();
    _cnicFocus.dispose();
    _phoneFocus.dispose();
    _addressFocus.dispose();
    _profilePicFocus.dispose();
    _cnicFrontFocus.dispose();
    _cnicBackFocus.dispose();
    _submitFocus.dispose();
    super.dispose();
  }

  Future<void> _pickImage(String type) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
    );

    if (result != null && result.files.single.path != null) {
      setState(() {
        final file = File(result.files.single.path!);
        if (type == 'profile') _profileImage = file;
        if (type == 'cnic_front') _cnicFrontImage = file;
        if (type == 'cnic_back') _cnicBackImage = file;
      });
    }
  }

  void _handleSave() {
    if (_formKey.currentState!.validate()) {
      final List<String> missingFields = [];
      if (_nameController.text.trim().isEmpty) missingFields.add('Full Name');
      if (_fatherNameController.text.trim().isEmpty) missingFields.add('Father Name');
      if (_cnicController.text.trim().isEmpty) missingFields.add('CNIC');
      if (_phoneController.text.trim().isEmpty) missingFields.add('Phone');
      if (_addressController.text.trim().isEmpty) missingFields.add('Address');

      if (_profileImage == null && _existingProfileImage == null) missingFields.add('Profile Photo');
      if (_cnicFrontImage == null && _existingCnicFrontImage == null) missingFields.add('CNIC Front Image');
      if (_cnicBackImage == null && _existingCnicBackImage == null) missingFields.add('CNIC Back Image');

      void executeSave() {
        if (widget.onSave != null) {
          widget.onSave!({
            'fullName': _nameController.text.trim(),
            'fatherName': _fatherNameController.text.trim(),
            'cnicNumber': _cnicController.text.trim(),
            'phoneNumber': _phoneController.text.trim(),
            'address': _addressController.text.trim(),
            'profileImage': _profileImage,
            'cnicFrontImage': _cnicFrontImage,
            'cnicBackImage': _cnicBackImage,
            'existingProfileImage': _profileImage == null ? widget.customer?.profileImageFilename : null,
            'existingCnicFrontImage': _cnicFrontImage == null ? widget.customer?.cnicFrontFilename : null,
            'existingCnicBackImage': _cnicBackImage == null ? widget.customer?.cnicBackFilename : null,
          });
          Get.back();
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
    const sectionHeaderText = Colors.white;
    final labelColor = isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary;
    final inputBg = isDark ? AppColors.darkElevated : AppColors.lightBackground;
    final inputBorder = isDark ? AppColors.darkBorderInput : AppColors.lightBorder;

    final isEdit = widget.customer != null;

    return AppDialog(
      title: isEdit ? 'Edit Customer' : 'Add New Customer',
      subtitle: isEdit ? 'Update customer profile' : 'Create a new customer profile',
      onSubmit: _handleSave,
      width: 700,
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
                child: Text(
                  isEdit ? 'Update Customer' : 'Save Customer (Enter)',
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Left Column: Inputs
            Expanded(
              flex: 2,
              child: Column(
                children: [
                   _buildSection(
                    title: 'Personal Information',
                    color: sectionHeaderBg,
                    textColor: sectionHeaderText,
                    children: [
                      _buildInputGroup('Full Name:', _nameController, 'Customer Name', isDark, inputBg, inputBorder, labelColor, _nameFocus, autofocus: !isEdit, isAlpha: true),
                      const SizedBox(height: 12),
                      _buildInputGroup('Father Name:', _fatherNameController, 'Father Name', isDark, inputBg, inputBorder, labelColor, _fatherNameFocus, isAlpha: true),
                       const SizedBox(height: 12),
                      _buildInputGroup('CNIC:', _cnicController, 'XXXXX-XXXXXXX-X', isDark, inputBg, inputBorder, labelColor, _cnicFocus, isCnic: true),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _buildSection(
                    title: 'Contact Details',
                    color: sectionHeaderBg,
                    textColor: sectionHeaderText,
                    children: [
                      _buildInputGroup('Phone:', _phoneController, '03XX-XXXXXXX', isDark, inputBg, inputBorder, labelColor, _phoneFocus, isPhone: true),
                      const SizedBox(height: 12),
                      _buildInputGroup('Address:', _addressController, 'Full Residential Address', isDark, inputBg, inputBorder, labelColor, _addressFocus),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 24),
            
            // Right Column: Images
            Expanded(
              flex: 1,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    _buildImagePicker(
                      'Profile Photo', 
                      _profileImage, 
                      _existingProfileImage,
                      () {
                        _profilePicFocus.requestFocus();
                        _pickImage('profile');
                      }, 
                      () => setState(() { _profileImage = null; }), // Remove NEW selection
                      isDark, inputBg, inputBorder, sectionHeaderBg, sectionHeaderText,
                      _profilePicFocus,
                    ),
                    const SizedBox(height: 16),
                    _buildImagePicker(
                      'CNIC Front', 
                      _cnicFrontImage, 
                      _existingCnicFrontImage,
                      () {
                        _cnicFrontFocus.requestFocus();
                        _pickImage('cnic_front');
                      }, 
                      () => setState(() { _cnicFrontImage = null; }),
                      isDark, inputBg, inputBorder, sectionHeaderBg, sectionHeaderText,
                      _cnicFrontFocus,
                    ),
                    const SizedBox(height: 16),
                    _buildImagePicker(
                      'CNIC Back', 
                      _cnicBackImage, 
                      _existingCnicBackImage,
                      () {
                        _cnicBackFocus.requestFocus();
                        _pickImage('cnic_back');
                      }, 
                      () => setState(() { _cnicBackImage = null; }),
                      isDark, inputBg, inputBorder, sectionHeaderBg, sectionHeaderText,
                      _cnicBackFocus,
                    ),
                  ],
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
    {bool isNumber = false, bool isPhone = false, bool isCnic = false, bool isOptional = false, bool autofocus = false, bool isAlpha = false}
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label.replaceAll(':', ''),
          style: TextStyle(
            color: labelColor,
            fontWeight: FontWeight.w600,
            fontSize: 13,
          ),
        ),
        const SizedBox(height: 6),
        BlinkingFocusBuilder(
          focusNode: focusNode,
          child: TextFormField(
            controller: controller,
            focusNode: focusNode,
            autofocus: autofocus,
            textInputAction: TextInputAction.next,
          keyboardType: (isNumber || isPhone || isCnic) ? TextInputType.number : TextInputType.text,
          inputFormatters: [
            if (isCnic) CnicInputFormatter(),
            if (isPhone) PhoneNumberInputFormatter(),
            if (isAlpha) FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z\s]')),
          ],
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
            if (value == null || value.trim().isEmpty) return null;
            if (isCnic && value.length < 15) return 'Invalid CNIC (13 digits required)';
            if (isPhone && value.length < 12) return 'Invalid Phone (11 digits required)';
            return null;
          },
        ),
        ),
      ],
    );
  }
  Widget _buildImagePicker(
    String title,
    File? newImage,
    String? existingImagePath,
    VoidCallback onPick,
    VoidCallback onRemoveNew,
    bool isDark,
    Color bg,
    Color border,
    Color headerBg,
    Color headerText,
    FocusNode focusNode,
  ) {
    // Determine what to show
    Widget content;
    if (newImage != null) {
      content = ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Image.file(newImage, fit: BoxFit.cover),
      );
    } else if (existingImagePath != null) {
       // Check if file exists to avoid error? Image.file with errorBuilder is safer
       content = ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Image.file(
          File(existingImagePath), 
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return const Center(child: Icon(LucideIcons.imageOff, size: 32, color: Colors.grey));
          },
        ),
      );
    } else {
      content = Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(LucideIcons.camera, size: 32, color: isDark ? Colors.grey[500] : Colors.grey[400]),
          const SizedBox(height: 4),
          Text(
            'Upload',
            style: TextStyle(
              color: isDark ? Colors.grey[400] : Colors.grey[600],
              fontWeight: FontWeight.w500,
              fontSize: 12,
            ),
          ),
        ],
      );
    }

    return _buildSection(
      title: title,
      color: headerBg,
      textColor: headerText,
      children: [
        BlinkingFocusBuilder(
          focusNode: focusNode,
          child: GestureDetector(
            onTap: onPick,
            child: Container(
              height: 140, // Reduced height to fit multiple images
              width: double.infinity,
              decoration: BoxDecoration(
                color: bg,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: border, width: 2),
              ),
              child: content,
            ),
          ),
        ),
        if (newImage != null) ...[
          const SizedBox(height: 4),
          Center(
            child: InkWell(
              onTap: onRemoveNew,
              child: const Padding(
                padding: EdgeInsets.all(4.0),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(LucideIcons.minusCircle, size: 14, color: Colors.orange),
                    SizedBox(width: 4),
                    Text('Undo New Selection', style: TextStyle(color: Colors.orange, fontSize: 12)),
                  ],
                ),
              ),
            ),
          )
        ]
      ],
    );
  }
}
