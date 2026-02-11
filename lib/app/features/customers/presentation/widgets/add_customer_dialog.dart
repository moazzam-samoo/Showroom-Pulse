import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:get/get.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:tahir_showroom/app/core/constants/app_colors.dart';
import 'package:tahir_showroom/app/core/widgets/app_dialog.dart';
import 'package:tahir_showroom/app/core/utils/cnic_input_formatter.dart';
import 'package:tahir_showroom/app/core/utils/phone_number_input_formatter.dart';

class AddCustomerDialog extends StatefulWidget {
  final Function(Map<String, dynamic>)? onSave;

  const AddCustomerDialog({
    super.key,
    this.onSave,
  });

  @override
  State<AddCustomerDialog> createState() => _AddCustomerDialogState();
}

class _AddCustomerDialogState extends State<AddCustomerDialog> {
  final _formKey = GlobalKey<FormState>();
  
  // Form controllers
  final _nameController = TextEditingController();
  final _fatherNameController = TextEditingController();
  final _cnicController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();

  File? _profileImage;
  File? _cnicFrontImage;
  File? _cnicBackImage;

  @override
  void dispose() {
    _nameController.dispose();
    _fatherNameController.dispose();
    _cnicController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
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
      if (widget.onSave != null) {
        widget.onSave!({
          'fullName': _nameController.text,
          'fatherName': _fatherNameController.text,
          'cnicNumber': _cnicController.text,
          'phoneNumber': _phoneController.text,
          'phoneNumber': _phoneController.text,
          'address': _addressController.text,
          'profileImage': _profileImage,
          'cnicFrontImage': _cnicFrontImage,
          'cnicBackImage': _cnicBackImage,
        });
        Get.back();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Theme Colors
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final sectionHeaderBg = isDark ? AppColors.darkPrimary : AppColors.lightPrimary;
    final sectionHeaderText = Colors.white;
    final labelColor = isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary;
    final inputBg = isDark ? AppColors.darkElevated : AppColors.lightBackground;
    final inputBorder = isDark ? AppColors.darkBorderInput : AppColors.lightBorder;

    return AppDialog(
      title: 'Add New Customer',
      subtitle: 'Create a new customer profile',
      onSubmit: _handleSave,
      width: 700,
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
                'Save Customer (Enter)',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ),
      ],
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
                      _buildInputGroup('Full Name:', _nameController, 'e.g. John Doe', isDark, inputBg, inputBorder, labelColor, autofocus: true),
                      const SizedBox(height: 12),
                      _buildInputGroup('Father Name:', _fatherNameController, 'e.g. Richard Doe', isDark, inputBg, inputBorder, labelColor),
                       const SizedBox(height: 12),
                      _buildInputGroup('CNIC:', _cnicController, 'XXXXX-XXXXXXX-X', isDark, inputBg, inputBorder, labelColor, isCnic: true),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _buildSection(
                    title: 'Contact Details',
                    color: sectionHeaderBg,
                    textColor: sectionHeaderText,
                    children: [
                      _buildInputGroup('Phone:', _phoneController, '03XX-XXXXXXX', isDark, inputBg, inputBorder, labelColor, isPhone: true),
                      const SizedBox(height: 12),
                      _buildInputGroup('Address:', _addressController, 'Full Residential Address', isDark, inputBg, inputBorder, labelColor),
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
                      () => _pickImage('profile'), 
                      () => setState(() => _profileImage = null),
                      isDark, inputBg, inputBorder, sectionHeaderBg, sectionHeaderText
                    ),
                    const SizedBox(height: 16),
                    _buildImagePicker(
                      'CNIC Front', 
                      _cnicFrontImage, 
                      () => _pickImage('cnic_front'), 
                      () => setState(() => _cnicFrontImage = null),
                      isDark, inputBg, inputBorder, sectionHeaderBg, sectionHeaderText
                    ),
                    const SizedBox(height: 16),
                    _buildImagePicker(
                      'CNIC Back', 
                      _cnicBackImage, 
                      () => _pickImage('cnic_back'), 
                      () => setState(() => _cnicBackImage = null),
                      isDark, inputBg, inputBorder, sectionHeaderBg, sectionHeaderText
                    ),
                  ],
                ),
              ),
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
    {bool isNumber = false, bool isPhone = false, bool isCnic = false, bool isOptional = false, bool autofocus = false}
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
        TextFormField(
          controller: controller,
          autofocus: autofocus,
          textInputAction: TextInputAction.next,
          keyboardType: (isNumber || isPhone || isCnic) ? TextInputType.number : TextInputType.text,
          inputFormatters: [
            if (isCnic) CnicInputFormatter(),
            if (isPhone) PhoneNumberInputFormatter(),
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
            if (isOptional && (value == null || value.isEmpty)) return null;
            if (value == null || value.isEmpty) return 'Required';
            if (isCnic && value.length < 15) return 'Invalid CNIC'; // 13 digits + 2 hyphens
            if (isPhone && value.length < 12) return 'Invalid Phone'; // 11 digits + 1 hyphen
            return null;
          },
        ),
      ],
    );
  }
  Widget _buildImagePicker(
    String title,
    File? image,
    VoidCallback onPick,
    VoidCallback onRemove,
    bool isDark,
    Color bg,
    Color border,
    Color headerBg,
    Color headerText,
  ) {
    return _buildSection(
      title: title,
      color: headerBg,
      textColor: headerText,
      children: [
        GestureDetector(
          onTap: onPick,
          child: Container(
            height: 140, // Reduced height to fit multiple images
            width: double.infinity,
            decoration: BoxDecoration(
              color: bg,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: border, width: 2),
            ),
            child: image != null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.file(image, fit: BoxFit.cover),
                  )
                : Column(
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
                  ),
          ),
        ),
        if (image != null) ...[
          const SizedBox(height: 4),
          Center(
            child: InkWell(
              onTap: onRemove,
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Icon(LucideIcons.trash2, size: 14, color: Colors.red),
                    SizedBox(width: 4),
                    Text('Remove', style: TextStyle(color: Colors.red, fontSize: 12)),
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
