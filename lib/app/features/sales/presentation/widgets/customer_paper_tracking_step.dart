import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:intl/intl.dart';
import 'package:tahir_showroom/app/core/constants/app_colors.dart';
import 'package:tahir_showroom/app/features/sales/presentation/controllers/new_sale_controller.dart';

class CustomerPaperTrackingStep extends StatelessWidget {
  const CustomerPaperTrackingStep({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<NewSaleController>();
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primary = isDark ? AppColors.darkPrimary : AppColors.lightPrimary;

    return Obx(() {
      final isDelivered = controller.isCustomerPapersDelivered.value;
      final promisedDate = controller.customerPapersPromisedDate.value;
      final now = DateTime.now();
      final isDatePast = promisedDate != null && promisedDate.isBefore(now);
      final needsDate = !isDelivered && promisedDate == null;

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header label
          Row(
            children: [
              Icon(LucideIcons.fileText, size: 16,
                  color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary),
              const SizedBox(width: 8),
              Text(
                'Customer Vehicle Papers',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                  color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Toggle row
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: isDelivered
                  ? Colors.green.withValues(alpha: 0.08)
                  : Colors.orange.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: isDelivered
                    ? Colors.green.withValues(alpha: 0.35)
                    : Colors.orange.withValues(alpha: 0.35),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  isDelivered ? LucideIcons.checkCircle : LucideIcons.clock,
                  size: 18,
                  color: isDelivered ? Colors.green : Colors.orange,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    isDelivered
                        ? 'Papers delivered to customer'
                        : 'Papers NOT yet delivered',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: isDelivered ? Colors.green : Colors.orange,
                    ),
                  ),
                ),
                Switch(
                  value: isDelivered,
                  onChanged: (val) {
                    controller.isCustomerPapersDelivered.value = val;
                    if (val) controller.customerPapersPromisedDate.value = null;
                  },
                  activeColor: Colors.green,
                ),
              ],
            ),
          ),

          // Date picker (shown only when NOT delivered)
          if (!isDelivered) ...[
            const SizedBox(height: 10),

            // Warning banner: no date set
            if (needsDate)
              _buildWarningBanner(
                icon: LucideIcons.alertTriangle,
                message: 'Set a promised delivery date so the customer knows when to expect papers.',
                color: Colors.orange,
              ),

            // Warning banner: date is in the past
            if (isDatePast)
              _buildWarningBanner(
                icon: LucideIcons.alertCircle,
                message: 'Promised date is already past! Please update it.',
                color: Colors.red,
              ),

            const SizedBox(height: 8),

            // Date picker button
            InkWell(
              borderRadius: BorderRadius.circular(10),
              onTap: () async {
                final picked = await showDatePicker(
                  context: context,
                  initialDate: promisedDate ?? DateTime.now().add(const Duration(days: 7)),
                  firstDate: DateTime(2020),
                  lastDate: DateTime(2030),
                );
                if (picked != null) {
                  controller.customerPapersPromisedDate.value = picked;
                }
              },
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                decoration: BoxDecoration(
                  color: isDatePast
                      ? Colors.red.withValues(alpha: 0.07)
                      : needsDate
                          ? Colors.orange.withValues(alpha: 0.07)
                          : primary.withValues(alpha: 0.07),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: isDatePast
                        ? Colors.red.withValues(alpha: 0.5)
                        : needsDate
                            ? Colors.orange.withValues(alpha: 0.5)
                            : primary.withValues(alpha: 0.4),
                    width: 1.5,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      LucideIcons.calendarDays,
                      size: 18,
                      color: isDatePast
                          ? Colors.red
                          : needsDate
                              ? Colors.orange
                              : primary,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Promised Delivery Date',
                            style: TextStyle(
                              fontSize: 11,
                              color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            promisedDate == null
                                ? 'Tap to select a date'
                                : DateFormat('EEEE, dd MMM yyyy').format(promisedDate),
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: isDatePast
                                  ? Colors.red
                                  : promisedDate == null
                                      ? Colors.orange
                                      : isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Icon(
                      LucideIcons.pencil,
                      size: 14,
                      color: isDatePast ? Colors.red : needsDate ? Colors.orange : primary,
                    ),
                  ],
                ),
              ),
            ),

            // Days remaining chip
            if (promisedDate != null && !isDatePast) ...[
              const SizedBox(height: 8),
              _buildDaysChip(promisedDate, now, primary),
            ],
          ],

          // Success state
          if (isDelivered) ...[
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.green.withValues(alpha: 0.06),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  const Icon(LucideIcons.checkCheck, size: 14, color: Colors.green),
                  const SizedBox(width: 8),
                  Text(
                    'Papers will be marked as delivered in this sale.',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.green.shade700,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      );
    });
  }

  Widget _buildWarningBanner({
    required IconData icon,
    required String message,
    required Color color,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 6),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              message,
              style: TextStyle(
                fontSize: 12,
                color: color,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDaysChip(DateTime promisedDate, DateTime now, Color primary) {
    final days = promisedDate.difference(now).inDays + 1;
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: primary.withValues(alpha: 0.3)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(LucideIcons.clock, size: 12, color: primary),
              const SizedBox(width: 4),
              Text(
                '$days day${days == 1 ? '' : 's'} from today',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: primary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
