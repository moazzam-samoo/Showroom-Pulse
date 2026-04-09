import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:intl/intl.dart';
import 'package:tahir_showroom/app/data/models/bike.dart';
import 'package:tahir_showroom/app/core/constants/app_colors.dart';
import 'package:tahir_showroom/app/core/constants/app_spacing.dart';
import 'package:tahir_showroom/app/core/constants/app_radius.dart';
import 'package:tahir_showroom/app/features/inventory/presentation/controllers/inventory_controller.dart';
import 'package:tahir_showroom/app/core/utils/data_refresher.dart';

class BikeDetailDialog extends StatefulWidget {
  final Bike bike;
  final dynamic sale;
  final dynamic customer;
  final dynamic supplier;

  const BikeDetailDialog({
    super.key,
    required this.bike,
    this.sale,
    this.customer,
    this.supplier,
  });

  @override
  State<BikeDetailDialog> createState() => _BikeDetailDialogState();
}

class _BikeDetailDialogState extends State<BikeDetailDialog> {
  // Local mutable paper state (initialized from bike in initState)
  late bool _isDealerPapersCollected;
  late DateTime? _dealerPapersPromisedDate;
  late bool _isCustomerPapersDelivered;
  late DateTime? _customerPapersPromisedDate;

  // Getter shorthand
  Bike get bike => widget.bike;

  @override
  void initState() {
    super.initState();
    _isDealerPapersCollected = bike.isDealerPapersCollected;
    _dealerPapersPromisedDate = bike.dealerPapersPromisedDate;
    _isCustomerPapersDelivered = bike.isCustomerPapersDelivered;
    _customerPapersPromisedDate = bike.customerPapersPromisedDate;
  }

  Future<void> _saveDealerPaperStatus() async {
    if (!Get.isRegistered<InventoryController>()) return;
    final ctrl = Get.find<InventoryController>();
    if (_isDealerPapersCollected) {
      await ctrl.markDealerPapersCollected(bike);
      DataRefresher.refreshAll();
    } else {
      // Update with new promised date
      bike.isDealerPapersCollected = false;
      bike.dealerPapersPromisedDate = _dealerPapersPromisedDate;
      await ctrl.updateBikePaperStatus(bike);
      DataRefresher.refreshAll();
    }
  }

  Future<void> _saveCustomerPaperStatus() async {
    if (!Get.isRegistered<InventoryController>()) return;
    final ctrl = Get.find<InventoryController>();
    if (_isCustomerPapersDelivered) {
      await ctrl.markCustomerPapersDelivered(bike);
      DataRefresher.refreshAll();
    } else {
      bike.isCustomerPapersDelivered = false;
      bike.customerPapersPromisedDate = _customerPapersPromisedDate;
      await ctrl.updateBikePaperStatus(bike);
      DataRefresher.refreshAll();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final surfaceColor = isDark ? AppColors.darkSurface : Colors.white;
    final headerColor =
        isDark ? const Color(0xFF1e293b) : AppColors.lightPrimary;

    return Dialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.xl)),
      backgroundColor: surfaceColor,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 800, maxHeight: 700),
        child: Column(
          children: [
            _buildHeader(headerColor, isDark),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(AppSpacing.xl),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 4,
                          child: _buildBikeImage(isDark),
                        ),
                        const SizedBox(width: AppSpacing.xl),
                        Expanded(
                          flex: 5,
                          child: _buildAttributes(isDark),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.xl),
                    const Divider(),
                    const SizedBox(height: AppSpacing.xl),

                    if (bike.status == BikeStatusEnum.available)
                      _buildUnifiedPurchaseInfo(isDark)
                    else
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(child: _buildPurchaseInfo(isDark)),
                          const SizedBox(width: AppSpacing.xl),
                          Expanded(child: _buildSaleInfo(isDark)),
                        ],
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

  Widget _buildHeader(Color headerColor, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: headerColor,
        borderRadius:
            const BorderRadius.vertical(top: Radius.circular(AppRadius.xl)),
      ),
      child: Row(
        children: [
          const Icon(LucideIcons.bike, color: Colors.white, size: 28),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Text(
              '${bike.model} ${bike.brand}',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          IconButton(
            onPressed: () => Get.back(),
            icon: const Icon(LucideIcons.x, color: Colors.white),
          ),
        ],
      ),
    );
  }

  Widget _buildBikeImage(bool isDark) {
    return Container(
      height: 250,
      decoration: BoxDecoration(
        color: isDark ? Colors.grey[900] : Colors.grey[100],
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border:
            Border.all(color: isDark ? Colors.grey[800]! : Colors.grey[300]!),
      ),
      child: bike.imageFilename != null && bike.imageFilename!.isNotEmpty
          ? ClipRRect(
              borderRadius: BorderRadius.circular(AppRadius.lg - 1),
              child: Image.file(
                File(bike.imageFilename!),
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => _buildPlaceholderImage(isDark),
              ),
            )
          : _buildPlaceholderImage(isDark),
    );
  }

  Widget _buildPlaceholderImage(bool isDark) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            LucideIcons.cameraOff,
            size: 48,
            color: isDark ? Colors.grey[700] : Colors.grey[400],
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'No Image Available',
            style: TextStyle(
              color: isDark ? Colors.grey[600] : Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAttributes(bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildDetailRow('Maker:', bike.brand, isDark),
        _buildDetailRow('Model:', bike.model, isDark),
        _buildDetailRow('Model (Year):', bike.modelYear.toString(), isDark),
        _buildDetailRow('Engine No:', bike.engineNumber, isDark, isBold: true),
        _buildDetailRow('Chassis No:', bike.chassisNumber, isDark,
            isBold: true),
        _buildDetailRow('Color:', bike.color, isDark),
        _buildDetailRow('Condition:',
            bike.condition.toString().split('.').last.capitalizeFirst!, isDark),
        if (bike.condition == BikeConditionEnum.usedBike)
          _buildDetailRow('Reg Number:',
              (bike.registrationNumber != null && bike.registrationNumber!.isNotEmpty)
                  ? bike.registrationNumber!
                  : 'N/A',
              isDark,
              isBold: true),
        const SizedBox(height: AppSpacing.md),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: _getStatusColor(bike.status).withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(AppRadius.full),
            border: Border.all(
                color: _getStatusColor(bike.status).withValues(alpha: 0.3)),
          ),
          child: Text(
            bike.status.toString().split('.').last.toUpperCase(),
            style: TextStyle(
              color: _getStatusColor(bike.status),
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPurchaseInfo(bool isDark) {
    return _buildInfoSection(
      title: 'Purchase Details',
      icon: LucideIcons.shoppingBag,
      isDark: isDark,
      children: [
        _buildDetailRow('Dealer/Supplier:', widget.supplier?.name ?? 'N/A', isDark),
        _buildDetailRow('Purchase Date:',
            DateFormat('dd MMM yyyy').format(bike.dateAdded), isDark),
        _buildDetailRow('Purchase Price:',
            'Rs. ${NumberFormat('#,###').format(bike.purchasePrice)}', isDark,
            textColor: Colors.redAccent),
        const SizedBox(height: AppSpacing.sm),
        _buildInteractivePaperRow(isDark, isDealer: true),
      ],
    );
  }

  Widget _buildUnifiedPurchaseInfo(bool isDark) {
    return _buildInfoSection(
      title: 'Purchase Details',
      icon: LucideIcons.shoppingBag,
      isDark: isDark,
      children: [
        if (bike.purchaserName != null && bike.purchaserName!.isNotEmpty)
          _buildDetailRow('Dealer Name:', bike.purchaserName!, isDark),
        if (bike.purchaserPhone != null && bike.purchaserPhone!.isNotEmpty)
          _buildDetailRow('Phone:', bike.purchaserPhone!, isDark),
        if (bike.purchaserCnic != null && bike.purchaserCnic!.isNotEmpty)
          _buildDetailRow('CNIC:', bike.purchaserCnic!, isDark),
        if (widget.supplier != null)
          _buildDetailRow('Supplier:', widget.supplier?.name ?? 'N/A', isDark),

        const Divider(height: 16),
        _buildDetailRow('Purchase Date:',
            DateFormat('dd MMM yyyy').format(bike.dateAdded), isDark),
        _buildDetailRow('Purchase Price:',
            'Rs. ${NumberFormat('#,###').format(bike.purchasePrice)}', isDark,
            textColor: Colors.redAccent),
        _buildDetailRow('Expected Price:',
            'Rs. ${NumberFormat('#,###').format(bike.cashSalePrice)}', isDark),

        const SizedBox(height: AppSpacing.md),
        _buildInteractivePaperRow(isDark, isDealer: true),

        const SizedBox(height: AppSpacing.md),
        if (bike.purchaserCnicFrontFilename != null ||
            bike.purchaserCnicBackFilename != null)
          _buildCnicThumbnails(isDark),
      ],
    );
  }

  Widget _buildSaleInfo(bool isDark) {
    final bool isAvailable = bike.status == BikeStatusEnum.available;
    final String title = isAvailable ? 'Dealer / Source Details' : 'Sale Details';
    final IconData icon = isAvailable ? LucideIcons.truck : LucideIcons.userCheck;
    final String labelPrefix = isAvailable ? 'Dealer' : 'Purchaser';

    final String? pName = isAvailable
        ? bike.purchaserName
        : (widget.customer?.fullName ?? bike.purchaserName);
    final String? pPhone = isAvailable
        ? bike.purchaserPhone
        : (widget.customer?.phoneNumber ?? bike.purchaserPhone);
    final String? pCnic = isAvailable
        ? bike.purchaserCnic
        : (widget.customer?.cnicNumber ?? bike.purchaserCnic);

    return _buildInfoSection(
      title: title,
      icon: icon,
      isDark: isDark,
      children: [
        if (pName != null || pPhone != null || pCnic != null) ...[
          _buildDetailRow('$labelPrefix Name:', pName ?? 'N/A', isDark),
          _buildDetailRow('Phone:', pPhone ?? 'N/A', isDark),
          _buildDetailRow('CNIC:', pCnic ?? 'N/A', isDark),
          _buildDetailRow(
              isAvailable ? 'Expected Price:' : 'Selling Price:',
              'Rs. ${NumberFormat('#,###').format(bike.cashSalePrice)}',
              isDark,
              textColor: isAvailable ? null : Colors.green),
          const SizedBox(height: AppSpacing.md),
          if (bike.purchaserCnicFrontFilename != null ||
              bike.purchaserCnicBackFilename != null)
            _buildCnicThumbnails(isDark),
        ] else
          Text(
            isAvailable
                ? 'No dealer information provided.'
                : 'Not sold yet or information missing.',
            style: TextStyle(
                color: isDark ? Colors.grey[500] : Colors.grey[600],
                fontStyle: FontStyle.italic),
          ),
        if (!isAvailable) ...[
          const SizedBox(height: AppSpacing.md),
          _buildInteractivePaperRow(isDark, isDealer: false),
        ],
      ],
    );
  }

  // ─────────────────────────────────────────────────────
  // Interactive Paper Row: Checkbox + Status chip + Date picker
  // ─────────────────────────────────────────────────────
  Widget _buildInteractivePaperRow(bool isDark, {required bool isDealer}) {
    final bool isCollected = isDealer ? _isDealerPapersCollected : _isCustomerPapersDelivered;
    final DateTime? promisedDate = isDealer ? _dealerPapersPromisedDate : _customerPapersPromisedDate;
    final String label = isDealer ? 'Dealer Papers' : 'Customer Docs';

    final now = DateTime.now();
    Color statusColor;
    String statusText;
    IconData statusIcon;

    if (isCollected) {
      statusColor = Colors.green;
      statusText = 'Collected';
      statusIcon = LucideIcons.checkCircle;
    } else if (promisedDate != null && promisedDate.isBefore(now)) {
      statusColor = Colors.red;
      statusText = 'OVERDUE';
      statusIcon = LucideIcons.alertCircle;
    } else if (promisedDate != null) {
      statusColor = Colors.orange;
      statusText = 'Due ${DateFormat('dd MMM').format(promisedDate)}';
      statusIcon = LucideIcons.clock;
    } else {
      statusColor = Colors.orange;
      statusText = 'Pending';
      statusIcon = LucideIcons.fileWarning;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Row 1: Label + Checkbox + Status chip
        Row(
          children: [
            Icon(LucideIcons.fileText, size: 16,
                color: isDark ? Colors.grey[400] : Colors.grey[600]),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 13,
                color: isDark ? Colors.grey[400] : Colors.grey[600],
                fontWeight: FontWeight.w600,
              ),
            ),
            const Spacer(),
            // Checkbox
            Transform.scale(
              scale: 0.9,
              child: Checkbox(
                value: isCollected,
                onChanged: (val) async {
                  setState(() {
                    if (isDealer) {
                      _isDealerPapersCollected = val ?? false;
                      if (val == true) _dealerPapersPromisedDate = null;
                    } else {
                      _isCustomerPapersDelivered = val ?? false;
                      if (val == true) _customerPapersPromisedDate = null;
                    }
                  });
                  if (isDealer) {
                    await _saveDealerPaperStatus();
                  } else {
                    await _saveCustomerPaperStatus();
                  }
                },
                activeColor: Colors.green,
                checkColor: Colors.white,
                side: BorderSide(
                  color: isCollected ? Colors.green : statusColor,
                  width: 2,
                ),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4)),
              ),
            ),
            const SizedBox(width: 4),
            // Status Chip
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: statusColor.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: statusColor.withValues(alpha: 0.4)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(statusIcon, size: 12, color: statusColor),
                  const SizedBox(width: 4),
                  Text(
                    statusText,
                    style: TextStyle(
                      color: statusColor,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),

        // Row 2: Date picker button (only when unchecked)
        if (!isCollected) ...[
          const SizedBox(height: 6),
          InkWell(
            borderRadius: BorderRadius.circular(8),
            onTap: () async {
              final picked = await showDatePicker(
                context: context,
                initialDate: promisedDate ?? DateTime.now().add(const Duration(days: 7)),
                firstDate: DateTime(2020),
                lastDate: DateTime(2030),
              );
              if (picked != null) {
                setState(() {
                  if (isDealer) {
                    _dealerPapersPromisedDate = picked;
                  } else {
                    _customerPapersPromisedDate = picked;
                  }
                });
                if (isDealer) {
                  await _saveDealerPaperStatus();
                } else {
                  await _saveCustomerPaperStatus();
                }
              }
            },
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: (promisedDate != null && promisedDate.isBefore(DateTime.now()))
                    ? Colors.red.withValues(alpha: 0.08)
                    : Colors.orange.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: (promisedDate != null && promisedDate.isBefore(DateTime.now()))
                      ? Colors.red.withValues(alpha: 0.4)
                      : Colors.orange.withValues(alpha: 0.4),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    LucideIcons.calendarDays,
                    size: 14,
                    color: (promisedDate != null && promisedDate.isBefore(DateTime.now()))
                        ? Colors.red
                        : Colors.orange,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    promisedDate == null
                        ? 'Tap to set promised date'
                        : 'Promised: ${DateFormat('dd MMM yyyy').format(promisedDate)}',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: (promisedDate != null && promisedDate.isBefore(DateTime.now()))
                          ? Colors.red
                          : Colors.orange,
                    ),
                  ),
                  const Spacer(),
                  Icon(LucideIcons.pencil, size: 12,
                      color: (promisedDate != null && promisedDate.isBefore(DateTime.now()))
                          ? Colors.red
                          : Colors.orange),
                ],
              ),
            ),
          ),

          // Overdue warning banner
          if (promisedDate != null && promisedDate.isBefore(DateTime.now())) ...[
            const SizedBox(height: 4),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.red.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Row(
                children: [
                  const Icon(LucideIcons.alertTriangle, size: 12, color: Colors.red),
                  const SizedBox(width: 6),
                  Text(
                    'Papers are ${DateTime.now().difference(promisedDate).inDays} day(s) overdue!',
                    style: const TextStyle(
                      fontSize: 11,
                      color: Colors.red,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ],
    );
  }

  Widget _buildCnicThumbnails(bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('CNIC Pictures:',
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Row(
          children: [
            if (bike.purchaserCnicFrontFilename != null)
              _buildImageThumb(
                  bike.purchaserCnicFrontFilename!, 'Front', isDark),
            const SizedBox(width: 8),
            if (bike.purchaserCnicBackFilename != null)
              _buildImageThumb(bike.purchaserCnicBackFilename!, 'Back', isDark),
          ],
        ),
      ],
    );
  }

  Widget _buildImageThumb(String path, String label, bool isDark) {
    return Column(
      children: [
        Container(
          width: 80,
          height: 50,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            border: Border.all(
                color: isDark ? Colors.grey[800]! : Colors.grey[300]!),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: Image.file(
              File(path),
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => const Icon(LucideIcons.image, size: 16),
            ),
          ),
        ),
        const SizedBox(height: 2),
        Text(label, style: const TextStyle(fontSize: 10)),
      ],
    );
  }

  Widget _buildInfoSection({
    required String title,
    required IconData icon,
    required List<Widget> children,
    required bool isDark,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon,
                size: 18,
                color: isDark ? AppColors.darkPrimary : AppColors.lightPrimary),
            const SizedBox(width: AppSpacing.sm),
            Text(
              title,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.md),
        ...children,
      ],
    );
  }

  Widget _buildDetailRow(String label, String value, bool isDark,
      {bool isBold = false, Color? textColor}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: TextStyle(
                color: isDark ? Colors.grey[500] : Colors.grey[600],
                fontSize: 13,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                color: textColor ?? (isDark ? Colors.white : Colors.black87),
                fontSize: 13,
                fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(BikeStatusEnum status) {
    switch (status) {
      case BikeStatusEnum.available:
        return Colors.green;
      case BikeStatusEnum.sold:
        return Colors.blue;
      case BikeStatusEnum.installment:
        return Colors.orange;
    }
  }
}
