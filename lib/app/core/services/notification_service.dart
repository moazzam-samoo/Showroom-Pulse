import 'package:flutter/foundation.dart';
import 'dart:async';
import 'package:get/get.dart';
import 'package:local_notifier/local_notifier.dart';
import 'package:tahir_showroom/app/data/models/installment_contract.dart';
import 'package:tahir_showroom/app/data/models/notification_alert.dart';
import 'package:tahir_showroom/app/features/installments/data/repositories/installment_repository.dart';
import 'package:tahir_showroom/app/core/services/isar_service.dart';
import 'package:tahir_showroom/app/core/widgets/app_toast.dart';
import 'package:intl/intl.dart';

class NotificationService extends GetxService {
  final pendingAlerts = <NotificationAlert>[].obs;
  int get alertCount => pendingAlerts.length;

  Timer? _periodicTimer;
  final _currencyFormat = NumberFormat.currency(locale: 'en_PK', symbol: 'Rs ', decimalDigits: 0);

  bool _isInitialized = false;

  Future<void> init() async {
    if (_isInitialized) return;
    try {
      await localNotifier.setup(
        appName: 'AL-AL-TAHIR Showroom',
        shortcutPolicy: ShortcutPolicy.requireCreate,
      );
      _isInitialized = true;
    } catch (e) {
      debugPrint('Failed to initialize local_notifier: $e');
      // If we are on non-desktop platforms or it fails, we just rely on in-app notifications
    }
  }

  void startPeriodicCheck() {
    // Check every 6 hours
    _periodicTimer?.cancel();
    _periodicTimer = Timer.periodic(const Duration(hours: 6), (_) {
      checkAndNotify();
    });
  }

  void stopPeriodicCheck() {
    _periodicTimer?.cancel();
  }

  Future<void> checkAndNotify() async {
    final isarService = Get.find<IsarService>();
    final repository = InstallmentRepository(isarService.isar);

    // Get active and partially paid contracts
    final contracts = await repository.getActiveContracts();
    
    final newAlerts = <NotificationAlert>[];
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    
    int windowsToastCount = 0;

    for (var contract in contracts) {
      if (contract.status == ContractStatusEnum.completed || contract.status == ContractStatusEnum.defaulted) {
        continue;
      }

      final dueDateStr = contract.nextDueDate;
      if (dueDateStr == null) continue;

      final dueDate = DateTime(dueDateStr.year, dueDateStr.month, dueDateStr.day);
      final daysUntilDue = dueDate.difference(today).inDays;
      
      final amountDue = contract.monthlyEMI;

      AlertSeverity? severity;

      if (daysUntilDue < 0) {
        severity = AlertSeverity.critical; // Overdue
      } else if (daysUntilDue == 0) {
        severity = AlertSeverity.critical; // Due Today
      } else if (daysUntilDue <= 3) { // TEMPORARY: Changed from 3 to 30 for testing
        severity = AlertSeverity.warning; // Due in 1-30 days
      }

      if (severity != null) {
        final customer = await repository.getCustomerForContract(contract);
        final bike = await repository.getBikeForContract(contract);

        if (customer != null && bike != null) {
          final alert = NotificationAlert(
            contractId: contract.id,
            customerName: customer.fullName,
            bikeModel: bike.model,
            amountDue: amountDue,
            dueDate: dueDate,
            daysUntilDue: daysUntilDue,
            severity: severity,
          );

          newAlerts.add(alert);

          // Only show up to 3 desktop toasts at a time to avoid spamming the user
          // We will show a toast for every alert if count is small, else rely on in-app
          if (windowsToastCount < 3) {
             _showDesktopToast(alert, bike.brand);
             windowsToastCount++;
          }
        }
      }
    }

    // Sort alerts: critical first (overdue, due today), then warnings (due soon)
    newAlerts.sort((a, b) {
       // Primary sort: severity
       if (a.severity == AlertSeverity.critical && b.severity != AlertSeverity.critical) return -1;
       if (a.severity != AlertSeverity.critical && b.severity == AlertSeverity.critical) return 1;
       
       // Secondary sort: days left
       return a.daysUntilDue.compareTo(b.daysUntilDue);
    });

    pendingAlerts.assignAll(newAlerts);
    
    // In-app snackbar notification if we found alerts
    if (newAlerts.isNotEmpty) {
      int criticalCount = newAlerts.where((a) => a.severity == AlertSeverity.critical).length;
      String msg = 'You have ${newAlerts.length} installment alerts.';
      if (criticalCount > 0) {
        msg = '$criticalCount payments are overdue or due today.';
      }

      AppToast.showInfo(title: 'Installment Alerts', message: msg);
    }
  }

  void _showDesktopToast(NotificationAlert alert, String brand) {
    if (!_isInitialized) return;

    try {
      final title = alert.severity == AlertSeverity.critical && alert.daysUntilDue < 0
          ? '🔴 Installment Overdue'
          : '📅 Installment Due Soon';
      
      final formattedAmount = _currencyFormat.format(alert.amountDue);
      final body = '${alert.customerName} — $formattedAmount ${alert.timeText}';
      final subtitle = '${alert.bikeModel} • $brand';

      final notification = LocalNotification(
        title: title,
        body: body,
        subtitle: subtitle,
      );

      notification.onShow = () {
        debugPrint('Notification onShow');
      };
      
      notification.onClick = () {
        // We could route to /installments when notification is clicked, 
        // but ensuring the app comes to foreground might require windowManager
        Get.toNamed('/installments');
      };

      notification.show();
    } catch (e) {
      debugPrint('Error showing local notification: $e');
    }
  }

  @override
  void onClose() {
    stopPeriodicCheck();
    super.onClose();
  }
}
