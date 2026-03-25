# PLAN.md: UI Enhancement & Bug Fixes

## Context
The user has requested to address three specific UI/UX issues related to the newly minted `Investment Management` system:
1. **Missing Sidebar Navigation:** The `InvestmentView` lacks the global `SidebarNavigation` component, making it impossible to navigate out of the view.
2. **Sidebar Pixel Overflow Error:** The addition of the "Investment" tab to `SidebarNavigation` caused a bottom overflow constraint failure ("pixels render issue occurred") on screens with lower height since it uses `Expanded` with a non-scrollable `Column`.
3. **Amount Formatting:** The "Add Capital" input field does not place automatic comma formatting grouping (e.g., 500,000 instead of 500000).

## Execution Plan (Phase 2 Orchestration)

### Target Domains & Agents
- UI/UX Structural (Navigation Layout) → `frontend-specialist`
- Interaction & Fields (Text Formats) → `frontend-specialist`
- QA/Testing → `test-engineer`

### Task Breakdown

#### Part 1: Fix Sidebar Missing in InvestmentView
- **Target:** `lib/app/features/investment/presentation/views/investment_view.dart`
- **Action:** Refactor the top-level `Scaffold` return into a `Row` containing the `SidebarNavigation` on the left and an `Expanded(child: Scaffold(...))` on the right, matching the architecture of other main views like `DashboardView`.

#### Part 2: Fix Sidebar Overflow on Smaller Screens
- **Target:** `lib/app/core/widgets/sidebar_navigation.dart`
- **Action:** Convert the strict `Expanded(child: Column(...))` covering the navigation items into a `Expanded(child: SingleChildScrollView(child: Column(...)))` configuration. This resolves bottom bounds overflows when screen height shrinks. 
- Ensure visual padding and focus/hover indicator sizes remain intact.

#### Part 3: Add Auto-Formatting to Input Field
- **Target:** `lib/app/features/investment/presentation/widgets/add_investment_dialog.dart` (or wherever the specific text field lives).
- **Action:** Implement a `TextInputFormatter` that parses incoming characters on-the-fly, strips old commas, and re-inserts fresh thousands separators. Update `amountController.text` cleanly upon user input without losing caret focus.
- Validate that the existing controller `double.tryParse` logic in `investment_controller.dart` handles inputs containing commas properly. (Pre-verified: the controller does an `.replaceAll(',', '')` strip).

---
*Created by `@project-planner`. Awaiting user approval to commence Phase 2 parallel implementation.*
