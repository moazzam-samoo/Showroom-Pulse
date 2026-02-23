import 'package:flutter/material.dart';

enum AlertSeverity { info, warning, critical }

class NotificationAlert {
  final int contractId;
  final String customerName;
  final String bikeModel;
  final double amountDue;
  final DateTime dueDate;
  final int daysUntilDue; // Negative = overdue
  final AlertSeverity severity;

  NotificationAlert({
    required this.contractId,
    required this.customerName,
    required this.bikeModel,
    required this.amountDue,
    required this.dueDate,
    required this.daysUntilDue,
    required this.severity,
  });

  Color get color {
    switch (severity) {
      case AlertSeverity.critical:
        return Colors.red.shade600;
      case AlertSeverity.warning:
        return Colors.orange.shade600;
      case AlertSeverity.info:
        return Colors.blue.shade600;
    }
  }

  String get severityLabel {
    switch (severity) {
      case AlertSeverity.critical:
        return daysUntilDue < 0 ? 'OVERDUE' : 'DUE TODAY';
      case AlertSeverity.warning:
        return 'DUE SOON';
      case AlertSeverity.info:
        return 'INFO';
    }
  }

  String get timeText {
    if (daysUntilDue < 0) {
      return '${daysUntilDue.abs()} days ago';
    } else if (daysUntilDue == 0) {
      return 'today';
    } else {
      return 'in $daysUntilDue days';
    }
  }
}
