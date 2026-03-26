## 🎼 Orchestration Plan: Auto-Comma Formatting

### Context
The user requested an audit of text inputs that accept numbers, intending to add automatic comma formatting (e.g., `1,000,000`) where currency is expected, and to remove it from non-currency numeric inputs where it is inappropriate.

### ➕ ADD Auto-Comma Formatting To:
These fields handle monetary values but currently lack the `ThousandsSeparatorInputFormatter`:
1. `d:\Tahir-Showroom\lib\app\features\investment\presentation\widgets\add_investment_dialog.dart` -> **Add Capital / Withdraw Capital Amount** input.
2. `d:\Tahir-Showroom\lib\app\features\reports\presentation\widgets\expense_tracker.dart` -> **Add Expense Amount** input.
3. `d:\Tahir-Showroom\lib\app\features\procurement\presentation\views\supplier_history_view.dart` -> **Record Payment Amount** to supplier.
4. `d:\Tahir-Showroom\lib\app\features\installments\presentation\widgets\record_payment_dialog.dart` -> **Delay Fine Amount** input.

### ➖ REMOVE Auto-Comma Formatting From:
These fields currently have the `ThousandsSeparatorInputFormatter` blindly applied via `if (isNumber)` flag, resulting in inappropriate formatting for years/durations (e.g., "Year 2,024"):
1. `d:\Tahir-Showroom\lib\app\features\inventory\presentation\widgets\add_bike_dialog.dart` -> **Model Year** input.
2. `d:\Tahir-Showroom\lib\app\features\inventory\presentation\widgets\edit_bike_dialog.dart` -> **Model Year** input.
3. `d:\Tahir-Showroom\lib\app\features\sales\presentation\widgets\payment_plan_step.dart` -> **Duration (Months)** and **Advance Installments (Count)** inputs.

### Next Steps
1. The `frontend-specialist` agent will update the inputs in the designated files, either injecting the `ThousandsSeparatorInputFormatter` or stripping it conditionally.
2. The `test-engineer` agent will verify integer parsing (`.replaceAll(',', '')`) does not break state persistence on save for these dynamically changed fields.
