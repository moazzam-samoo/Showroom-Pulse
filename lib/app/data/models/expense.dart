import 'package:isar/isar.dart';

part 'expense.g.dart';

/// Expense Collection — Tracks business expenses (salaries, bills, rent, etc.)
@collection
class Expense {
  Id id = Isar.autoIncrement;

  /// Custom category name (e.g. "Salaries", "Electricity Bill", "Rent")
  @Index()
  late String category;

  /// Amount in PKR
  late double amount;

  /// Date of expense (used for month/year filtering)
  @Index()
  late DateTime date;

  /// Optional description/note
  String? description;
}
