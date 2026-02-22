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
          'address': _addressController.text,
          'profileImage': _profileImage,
          'cnicFrontImage': _cnicFrontImage,
          'cnicBackImage': _cnicBackImage,
          'existingProfileImage': _existingProfileImage != null && _profileImage == null ? widget.customer?.profileImageFilename : null, // Logic handled in controller? Controller expects filenames or files.
          // Controller logic: "if data['profileImage'] != null ... save ... else if existing? "
          // Controller _updateCustomer logic:
          // String? profileImageFilename = data['existingProfileImage']; ...
          // if (data['profileImage'] != null) ...
          
          // So I need to pass the existing filenames if they are kept.
          // If a new image is picked (_profileImage != null), controller uses that.
          // If no new image, controller needs to know if we keep the old one.
          // The controller implementation I wrote: `String? profileImageFilename = data['existingProfileImage'];`
          // So I should pass the filename here if I want to keep it.
           'existingProfileImage': _profileImage == null ? widget.customer?.profileImageFilename : null,
           'existingCnicFrontImage': _cnicFrontImage == null ? widget.customer?.cnicFrontFilename : null,
           'existingCnicBackImage': _cnicBackImage == null ? widget.customer?.cnicBackFilename : null,
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
            child: ElevatedButton(
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
                      _buildInputGroup('Full Name:', _nameController, 'e.g. John Doe', isDark, inputBg, inputBorder, labelColor, autofocus: !isEdit),
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
                      _existingProfileImage,
                      () => _pickImage('profile'), 
                      () => setState(() { _profileImage = null; }), // Remove NEW selection
                      isDark, inputBg, inputBorder, sectionHeaderBg, sectionHeaderText
                    ),
                    const SizedBox(height: 16),
                    _buildImagePicker(
                      'CNIC Front', 
                      _cnicFrontImage, 
                      _existingCnicFrontImage,
                      () => _pickImage('cnic_front'), 
                      () => setState(() { _cnicFrontImage = null; }),
                      isDark, inputBg, inputBorder, sectionHeaderBg, sectionHeaderText
                    ),
                    const SizedBox(height: 16),
                    _buildImagePicker(
                      'CNIC Back', 
                      _cnicBackImage, 
                      _existingCnicBackImage,
                      () => _pickImage('cnic_back'), 
                      () => setState(() { _cnicBackImage = null; }),
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
            if (isCnic && value.length < 15) return 'Invalid CNIC (13 digits required)';
            if (isPhone && value.length < 12) return 'Invalid Phone (11 digits required)';
            return null;
          },
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
            return Center(child: Icon(LucideIcons.imageOff, size: 32, color: Colors.grey));
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
            child: content,
          ),
        ),
        if (newImage != null) ...[
          const SizedBox(height: 4),
          Center(
            child: InkWell(
              onTap: onRemoveNew,
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
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
