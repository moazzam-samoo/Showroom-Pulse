# Plan: Hybrid UX Pattern for Notifications

This document outlines the implementation plan for replacing the 50+ existing `Get.snackbar` notifications with a Hybrid UX Pattern (Toasts for info/success, Pop-ups for errors/critical alerts), serving as Phase 1 of the orchestration process.

## User Review Required
>
> [!IMPORTANT]
> Please review this plan. This will apply a significant UI overhaul across 18 files.
> Once approved, the Orchestration mode will proceed to Phase 2 (Implementation).

## Proposed Changes

### Core UI Components

#### [NEW] `lib/app/core/widgets/app_toast.dart`

- Create an elegant, top-right floating toast component for Success/Info messages.
- Non-blocking and self-dismissible (3-4 seconds).
- Supports closing on `Esc`.

#### [NEW] `lib/app/core/widgets/app_notification_dialog.dart`

- Create a dedicated dialog component specifically for Errors and Critical alerts.
- Uses `Get.dialog` with `barrierDismissible: true` (closes on click outside).
- Built-in `RawKeyboardListener` for `Enter` and `Esc` to dismiss.
- Highly visible, preventing the user from missing critical failures or validation issues.

### Implementation Areas (Agents: `frontend-specialist`, `backend-specialist`)

The 50+ snackbars across these areas will be categorized and refactored:

#### Sales & Transactions

- **Invoices/Success**: Replace with `AppToast.showSuccess(...)`
- **Missing selections/Failed saves**: Replace with `AppNotificationDialog.showError(...)`

#### Inventory & Procurement

- **Supplier added/updated**: Replace with `AppToast.showSuccess(...)`
- **Validation errors (e.g. Please add a bike)**: Replace with `AppNotificationDialog.showError(...)`

#### Settings & Configuration

- **Profile saved**: Replace with `AppToast.showSuccess(...)`
- **Database backup failed / Logo failed**: Replace with `AppNotificationDialog.showError(...)`

#### Core, Auth & Dashboard

- **Installment warnings**: Replace with `AppNotificationDialog.showWarning(...)` or `showError(...)` depending on severity.
- **Login fails/Data fetch fails**: Replace with `AppNotificationDialog.showError(...)`

## Verification Plan

### Manual Verification

- Execute actions that trigger success messages to verify Toasts appear and vanish without screen blocking.
- Execute actions that trigger error messages to verify Pop-ups dim the screen, and disappear when clicking outside, or pressing `Esc` / `Enter`.
