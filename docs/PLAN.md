# Orchestration Plan: Add "Clear Filters" Buttons

## Overview

The user requested adding a "Clear All Filters" button on all screens where filters or search properties are used.

## Identified Screens with Filters

1. **Inventory (`inventory_view.dart` / `BikeFilterBar`)**:
   - Already has an `onClearFilters` callback. We need to verify if the UI exposes it as an attractive "Clear Filters" button and add it if missing.
2. **Sales (`sales_view.dart` / `SalesFilterBar`)**:
   - Has a Date Range Filter, Status Filter, and Search. Needs a "Clear Filters" button that resets the controller's states.
3. **Installments (`installments_view.dart`)**:
   - Has "Due This Week" filter and "Status Filter" dropdown. Needs a "Clear Filters" button.
4. **Customers / Procurement**:
   - We will inject a similar filter reset mechanism where search/filter bars exist.

## Execution Strategy

### Phase 2: Implementation (Parallel Agents)

#### Agent 1: `frontend-specialist` (UI Implementation)

- **Task**: Modify the filter widgets (`BikeFilterBar`, `SalesFilterBar`, `installments_view.dart`, `customers_view.dart`) to include a new, aesthetically pleasing "Clear Filters" or "Reset" icon button.
- **Rules**: Adhere to `@[/ui-ux-pro-max]` guidelines. Use standard `LucideIcons.filterX` or `xCircle`. The button should have a hover effect and maybe a distinct color (like a subtle red/orange or just subtle grey) so it's clearly a destructive/reset action but not overwhelming.

#### Agent 2: `backend-specialist` (Controller Logic)

- **Task**: Update the GetX controllers (`SalesController`, `InstallmentsController`, `CustomersController`) to add a `clearFilters()` method that resets all `Rx` observer variables (search text, dropdown selections, date ranges) back to their default `null` or empty states.

#### Agent 3: `test-engineer` (Verification)

- **Task**: Run `flutter analyze` and existing test scripts to ensure the new buttons don't break the build and the controllers compile correctly.

## Verification

- Run `flutter analyze` to ensure no syntax errors.
- Visual verification by running the desktop app (`flutter run -d windows`).
