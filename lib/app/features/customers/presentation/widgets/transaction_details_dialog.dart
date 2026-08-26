import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:tahir_showroom/app/core/constants/app_colors.dart';
import 'package:tahir_showroom/app/core/constants/app_radius.dart';
import 'package:tahir_showroom/app/core/constants/app_spacing.dart';
import 'package:tahir_showroom/app/data/models/bike.dart';
import 'package:tahir_showroom/app/features/customers/data/repositories/customer_repository.dart';
import 'package:tahir_showroom/app/core/services/file_service.dart';
import 'package:tahir_showroom/app/core/services/isar_service.dart';
import 'package:tahir_showroom/app/core/widgets/app_dialog.dart';
import 'package:tahir_showroom/app/core/widgets/app_toast.dart';
import 'package:tahir_showroom/app/features/inventory/presentation/controllers/inventory_controller.dart';
import 'package:tahir_showroom/app/core/utils/data_refresher.dart';
import 'package:tahir_showroom/app/features/sales/presentation/controllers/sales_controller.dart';

class TransactionDetailsDialog extends StatefulWidget {
  final TransactionRecord transaction;
  final CustomerWithTransactions customer;

  const TransactionDetailsDialog({
    super.key,
    required this.transaction,
    required this.customer,
  });

  @override
  State<TransactionDetailsDialog> createState() =>
      _TransactionDetailsDialogState();
}

class _TransactionDetailsDialogState extends State<TransactionDetailsDialog> {
  late bool _isPapersDelivered;
  late DateTime? _promisedDate;

  TransactionRecord get transaction => widget.transaction;
  CustomerWithTransactions get customer => widget.customer;

  @override
  void initState() {
    super.initState();
    _isPapersDelivered = transaction.bike.isCustomerPapersDelivered;
    _promisedDate = transaction.bike.customerPapersPromisedDate;
  }

  Future<void> _savePaperStatus() async {
    if (!Get.isRegistered<IsarService>()) return;
    final isar = Get.find<IsarService>().isar;
    final bike = await isar.bikes.get(transaction.bike.id);
    if (bike == null) return;
    bike.isCustomerPapersDelivered = _isPapersDelivered;
    bike.customerPapersPromisedDate = _isPapersDelivered ? null : _promisedDate;
    if (Get.isRegistered<InventoryController>()) {
      await Get.find<InventoryController>().updateBikePaperStatus(bike);
      DataRefresher.refreshAll();
    } else {
      await isar.writeTxn(() async => isar.bikes.put(bike));
    }
    if (Get.isRegistered<SalesController>()) {
      Get.find<SalesController>().loadSales();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = transaction.isInstallment
        ? const Color(0xFFF59E0B)
        : const Color(0xFFEF4444);

    return AppDialog(
      title: transaction.isInstallment
          ? 'Installment Sale Details'
          : 'Cash Sale Details',
      subtitle: 'Invoice #${transaction.sale.id}',
      width: 800,
      actions: [
        TextButton(
          onPressed: () => Get.back(),
          style: TextButton.styleFrom(
            foregroundColor: isDark
                ? AppColors.darkTextSecondary
                : AppColors.lightTextSecondary,
            padding:
                const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
              side: BorderSide(
                  color: isDark
                      ? AppColors.darkBorder
                      : Colors.grey.shade400),
            ),
          ),
          child: const Text('Close'),
        ),
        const SizedBox(width: AppSpacing.md),
        ElevatedButton.icon(
          onPressed: () {
            AppToast.showInfo(
                title: 'Print',
                message: 'Print functionality pending');
          },
          icon: const Icon(LucideIcons.printer, size: 16),
          label: const Text('Print Invoice'),
          style: ElevatedButton.styleFrom(
            backgroundColor: primaryColor,
            foregroundColor: Colors.white,
            padding:
                const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          ),
        ),
      ],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Purchaser + Bike ──────────────────────────────────────
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Left: Purchaser
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSectionHeader(
                        'Purchaser Details', LucideIcons.user, primaryColor),
                    const SizedBox(height: AppSpacing.md),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildImageThumb(
                            customer.customer.profileImageFilename,
                            isDark,
                            primaryColor),
                        const SizedBox(width: AppSpacing.md),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildInfoRow('Name',
                                  customer.customer.fullName, isDark,
                                  isBold: true),
                              _buildInfoRow('Contact',
                                  customer.customer.phoneNumber, isDark),
                              _buildInfoRow('CNIC',
                                  customer.customer.cnicNumber, isDark),
                              _buildInfoRow('Address',
                                  customer.customer.address ?? 'N/A', isDark),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                width: 1,
                height: 150,
                color: isDark ? AppColors.darkBorder : Colors.grey.shade300,
                margin: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.lg),
              ),
              // Right: Bike
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSectionHeader(
                        'Bike Details', LucideIcons.bike, primaryColor),
                    const SizedBox(height: AppSpacing.md),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildImageThumb(
                            transaction.bike.imageFilename,
                            isDark,
                            primaryColor,
                            isBike: true),
                        const SizedBox(width: AppSpacing.md),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildInfoRow(
                                  'Maker', transaction.bike.model, isDark),
                              _buildInfoRow('Model', transaction.bike.model,
                                  isDark,
                                  isBold: true),
                              _buildInfoRow('Year',
                                  transaction.bike.modelYear.toString(),
                                  isDark),
                              _buildInfoRow('Chassis',
                                  transaction.bike.chassisNumber, isDark),
                              _buildInfoRow('Engine',
                                  transaction.bike.engineNumber, isDark),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: AppSpacing.xl),
          Divider(color: isDark ? AppColors.darkBorder : Colors.grey.shade300),
          const SizedBox(height: AppSpacing.xl),

          // ── Witness Details ───────────────────────────────────────
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionHeader(
                  'Witness Details', LucideIcons.users, primaryColor),
              const SizedBox(height: AppSpacing.md),
              if (transaction.witnesses.isNotEmpty)
                IntrinsicHeight(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      for (int i = 0;
                          i < transaction.witnesses.length;
                          i++) ...[
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(bottom: 8.0),
                                child: Text(
                                  'Witness ${i + 1}${transaction.witnesses[i].isPrimary ? " (Primary)" : ""}',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: isDark
                                        ? AppColors.darkTextSecondary
                                        : AppColors.lightTextSecondary,
                                  ),
                                ),
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _buildImageThumb(
                                    transaction.witnesses[i]
                                                .cnicFrontFilename !=
                                            null
                                        ? Get.find<FileService>()
                                            .getWitnessCnicImagePath(
                                                transaction.witnesses[i]
                                                    .cnicFrontFilename!,
                                                customer
                                                    .customer.cnicNumber)
                                        : null,
                                    isDark,
                                    primaryColor,
                                  ),
                                  const SizedBox(width: AppSpacing.md),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        _buildInfoRow(
                                            'Name',
                                            transaction
                                                .witnesses[i].fullName,
                                            isDark,
                                            isBold: true),
                                        _buildInfoRow(
                                            'Contact',
                                            transaction
                                                .witnesses[i].phoneNumber,
                                            isDark),
                                        _buildInfoRow(
                                            'CNIC',
                                            transaction
                                                .witnesses[i].cnicNumber,
                                            isDark),
                                        _buildInfoRow(
                                            'Address',
                                            transaction.witnesses[i]
                                                    .address ??
                                                'N/A',
                                            isDark),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        if (i < transaction.witnesses.length - 1)
                          Container(
                            width: 1,
                            color: isDark
                                ? AppColors.darkBorder
                                : Colors.grey.shade300,
                            margin: const EdgeInsets.symmetric(
                                horizontal: AppSpacing.lg),
                          ),
                      ],
                    ],
                  ),
                )
              else
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildImageThumb(null, isDark, primaryColor),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildInfoRow(
                              'Name',
                              transaction.witnessName ?? 'N/A',
                              isDark,
                              isBold: true),
                          _buildInfoRow('Contact',
                              transaction.witnessPhone ?? 'N/A', isDark),
                          _buildInfoRow('CNIC',
                              transaction.witnessId ?? 'N/A', isDark),
                          _buildInfoRow('Address',
                              transaction.witnessAddress ?? 'N/A', isDark),
                        ],
                      ),
                    ),
                  ],
                ),
            ],
          ),

          const SizedBox(height: AppSpacing.xl),
          Divider(color: isDark ? AppColors.darkBorder : Colors.grey.shade300),
          const SizedBox(height: AppSpacing.lg),

          // ── Vehicle Papers ────────────────────────────────────────
          _buildPaperTrackingSection(isDark, primaryColor),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────
  // Interactive Vehicle Paper Tracking Section
  // ─────────────────────────────────────────────
  Widget _buildPaperTrackingSection(bool isDark, Color primaryColor) {
    final now = DateTime.now();
    final isDatePast =
        _promisedDate != null && _promisedDate!.isBefore(now);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader(
            'Vehicle Papers', LucideIcons.fileText, primaryColor),
        const SizedBox(height: AppSpacing.md),

        // Toggle row
        Container(
          padding:
              const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            color: _isPapersDelivered
                ? Colors.green.withValues(alpha: 0.08)
                : Colors.orange.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: _isPapersDelivered
                  ? Colors.green.withValues(alpha: 0.4)
                  : Colors.orange.withValues(alpha: 0.4),
            ),
          ),
          child: Row(
            children: [
              Transform.scale(
                scale: 0.9,
                child: Checkbox(
                  value: _isPapersDelivered,
                  onChanged: (val) async {
                    setState(() {
                      _isPapersDelivered = val ?? false;
                      if (val == true) _promisedDate = null;
                    });
                    await _savePaperStatus();
                  },
                  activeColor: Colors.green,
                  checkColor: Colors.white,
                  side: BorderSide(
                    color:
                        _isPapersDelivered ? Colors.green : Colors.orange,
                    width: 2,
                  ),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4)),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _isPapersDelivered
                          ? 'Papers delivered to customer'
                          : 'Papers NOT yet delivered',
                      style: GoogleFonts.outfit(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: _isPapersDelivered
                            ? Colors.green
                            : Colors.orange,
                      ),
                    ),
                    if (!_isPapersDelivered && _promisedDate != null)
                      Text(
                        isDatePast
                            ? 'Promised: ${DateFormat('dd MMM yyyy').format(_promisedDate!)} (OVERDUE)'
                            : 'Promised: ${DateFormat('dd MMM yyyy').format(_promisedDate!)}',
                        style: GoogleFonts.outfit(
                          fontSize: 11,
                          color: isDatePast ? Colors.red : Colors.orange,
                        ),
                      ),
                  ],
                ),
              ),
              // Status chip
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: (_isPapersDelivered
                          ? Colors.green
                          : isDatePast
                              ? Colors.red
                              : Colors.orange)
                      .withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: (_isPapersDelivered
                            ? Colors.green
                            : isDatePast
                                ? Colors.red
                                : Colors.orange)
                        .withValues(alpha: 0.4),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      _isPapersDelivered
                          ? LucideIcons.checkCircle
                          : isDatePast
                              ? LucideIcons.alertCircle
                              : LucideIcons.clock,
                      size: 11,
                      color: _isPapersDelivered
                          ? Colors.green
                          : isDatePast
                              ? Colors.red
                              : Colors.orange,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      _isPapersDelivered
                          ? 'Delivered'
                          : isDatePast
                              ? 'OVERDUE'
                              : 'Pending',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: _isPapersDelivered
                            ? Colors.green
                            : isDatePast
                                ? Colors.red
                                : Colors.orange,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        // Date picker (only when not delivered)
        if (!_isPapersDelivered) ...[
          const SizedBox(height: 8),
          if (isDatePast)
            Container(
              margin: const EdgeInsets.only(bottom: 6),
              padding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
              decoration: BoxDecoration(
                color: Colors.red.withValues(alpha: 0.07),
                borderRadius: BorderRadius.circular(8),
                border:
                    Border.all(color: Colors.red.withValues(alpha: 0.3)),
              ),
              child: Row(
                children: [
                  const Icon(LucideIcons.alertTriangle,
                      size: 13, color: Colors.red),
                  const SizedBox(width: 8),
                  Text(
                    'Papers are ${now.difference(_promisedDate!).inDays} day(s) overdue! Update the date.',
                    style: GoogleFonts.outfit(
                        fontSize: 11,
                        color: Colors.red,
                        fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
          InkWell(
            borderRadius: BorderRadius.circular(10),
            onTap: () async {
              final picked = await showDatePicker(
                context: context,
                initialDate: _promisedDate ??
                    DateTime.now().add(const Duration(days: 7)),
                firstDate: DateTime(2020),
                lastDate: DateTime(2030),
              );
              if (picked != null) {
                setState(() => _promisedDate = picked);
                await _savePaperStatus();
              }
            },
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(
                  horizontal: 14, vertical: 11),
              decoration: BoxDecoration(
                color: isDatePast
                    ? Colors.red.withValues(alpha: 0.07)
                    : primaryColor.withValues(alpha: 0.06),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: isDatePast
                      ? Colors.red.withValues(alpha: 0.4)
                      : primaryColor.withValues(alpha: 0.35),
                  width: 1.5,
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    LucideIcons.calendarDays,
                    size: 16,
                    color: isDatePast ? Colors.red : primaryColor,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Promised Delivery Date',
                          style: GoogleFonts.outfit(
                            fontSize: 10,
                            color: isDark
                                ? Colors.white38
                                : Colors.black38,
                          ),
                        ),
                        Text(
                          _promisedDate == null
                              ? 'Tap to set promised date'
                              : DateFormat('EEEE, dd MMM yyyy')
                                  .format(_promisedDate!),
                          style: GoogleFonts.outfit(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: isDatePast
                                ? Colors.red
                                : isDark
                                    ? Colors.white
                                    : Colors.black87,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(LucideIcons.pencil,
                      size: 13,
                      color: isDatePast ? Colors.red : primaryColor),
                ],
              ),
            ),
          ),
        ],
      ],
    );
  }

  // ── Helpers ───────────────────────────────────────────────────────

  Widget _buildSectionHeader(
      String title, IconData icon, Color color) {
    return Row(
      children: [
        Icon(icon, size: 18, color: color),
        const SizedBox(width: 8),
        Text(
          title,
          style: TextStyle(
              color: color, fontWeight: FontWeight.bold, fontSize: 14),
        ),
      ],
    );
  }

  Widget _buildImageThumb(
      String? path, bool isDark, Color primaryColor,
      {bool isBike = false}) {
    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkElevated : Colors.grey[200],
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(
            color:
                isDark ? AppColors.darkBorder : Colors.grey.shade300),
      ),
      child: path != null && File(path).existsSync()
          ? ClipRRect(
              borderRadius: BorderRadius.circular(AppRadius.md),
              child: Image.file(File(path), fit: BoxFit.cover),
            )
          : Icon(
              isBike ? LucideIcons.bike : LucideIcons.user,
              size: 32,
              color: isDark
                  ? AppColors.darkTextMuted
                  : AppColors.lightTextMuted,
            ),
    );
  }

  Widget _buildInfoRow(String label, String value, bool isDark,
      {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 70,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: isDark
                    ? AppColors.darkTextMuted
                    : AppColors.lightTextMuted,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 13,
                fontWeight:
                    isBold ? FontWeight.bold : FontWeight.normal,
                color: isDark
                    ? AppColors.darkTextPrimary
                    : AppColors.lightTextPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
