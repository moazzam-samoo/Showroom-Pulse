# PLAN: Keyboard Form Navigation

## Overview

Implement complete keyboard-only navigation across all data entry forms in the Tahir Showroom app, allowing users to rapidly input data without using a mouse.

## Core Features

1. **Auto-Focus First Field**: The primary input field will automatically gain focus when a form/dialog opens.
2. **Next Field Navigation**: Pressing `Enter` or the `Down Arrow` key moves focus to the next logical input field.
3. **Previous Field Navigation**: For consistency, `Up Arrow` should logically traverse backwards.
4. **Image Selection Trigger**: Pressing `Enter` when an image selection container (e.g., Profile Picture, CNIC Image) is focused will trigger the file picker.
5. **Form Submission**: Pressing `Enter` on the final field or the submit button saves the data.
6. **Universal Application**: Apply this to all relevant input forms (Suppliers, Customers, Inventory/Bikes, Sales, Procurement, and Installment Payments).

## Affected Components (Target Scope)

- `AddSupplierDialog` & `EditSupplierDialog`
- `AddBikeDialog` & `EditBikeDialog`
- `AddCustomerDialog` & `EditCustomerDialog`
- `NewSaleView`
- `AddStockView`
- `RecordPaymentDialog`

## Technical Implementation (Frontend Specialist)

- **FocusNodes**: Define explicit `FocusNode` objects for all input fields and interactive containers (like image pickers).
- **Keyboard Listeners**: Intercept `LogicalKeyboardKey.arrowDown` and `LogicalKeyboardKey.enter` events.
- **TextInputAction**: Set `textInputAction: TextInputAction.next` on text fields to leverage native OS next-field behaviors where applicable.
- **Accessibility/Focusable Widgets**: Wrap image picker containers in a `Focus` widget and use `onKey` or `onKeyEvent` to detect `Enter` presses.

## Potential Edge Cases (Socratic Gate)

Before proceeding to Phase 2 (Implementation), please clarify the following:

1. **Multiline Fields**: For "Notes" or "Description" fields, should `Enter` still go to the next field, or should it behave normally (insert a new line)? (Suggestion: Use `Tab` or `Down Arrow` to escape multiline fields, keeping `Enter` for new lines).
2. **Date Pickers / Dropdowns**: Should pressing `Enter` on a focused dropdown open the list or immediately jump to the next layout field? (Standard is opening the list).

---
*Created by `@project-planner` and `@orchestrator`*
