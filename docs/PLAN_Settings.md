# Plan: Profile & Settings Refinements

## 1. Context

The user wants to prevent editing the owner profile name directly from the dashboard. Instead, profile editing should only be accessible from the Settings page. Additionally, any changes made in the Settings (Address, Name, Financials, etc.) currently lack visual feedback. The user requested notifications when changes are successfully saved.

## 2. Proposed Changes

### [MODIFY] `lib/app/features/dashboard/presentation/views/dashboard_view.dart`

- Remove the `InkWell` wrapping the user avatar in the header.
- Delete the `_showProfileDialog` method completely.
- The dashboard avatar will now only be for display purposes.

### [MODIFY] `lib/app/features/settings/presentation/widgets/profile_settings_view.dart`

- Import `app_toast.dart`.
- Trigger `AppToast.showSuccess(title: 'Success', message: 'Profile updated')` when the owner name is saved.
- Trigger `AppToast.showSuccess(title: 'Success', message: 'Profile picture updated')` when the uploaded image is successfully saved.

### [MODIFY] `lib/app/features/settings/presentation/widgets/general_settings_view.dart`

- Import `app_toast.dart`.
- Trigger `AppToast.showSuccess` when:
  - Showroom Name is updated.
  - Showroom Address is updated.
  - Showroom Phone is updated.
  - Currency Symbol is changed.
  - Theme is toggled.
  - Showroom Logo is uploaded.

### [MODIFY] `lib/app/features/settings/presentation/widgets/financial_settings_view.dart`

- Import `app_toast.dart`.
- Trigger `AppToast.showSuccess` when:
  - Default Installment Markup changes.
  - EMI Rounding Function changes.
  - Automatic Late Fee is toggled.
  - Late Fee Percentage changes.
  - Default Expense Categories are updated.

## 3. Brainstorm & Recommendations

- **Notifications Type:** I am recommending "Toasts" (Snackbars that appear at the top/bottom and disappear automatically) rather than interactive Pop-ups. Pop-ups require the user to explicitly click "OK", which becomes annoying when making multiple minor settings changes.
- **Profile Additions:** Currently, the profile only holds "Owner Name" and "Profile Picture". The rest of the showroom details (Address, Phone, Logo) are in General Settings. This is a solid, professional categorization. No extra fields are strictly necessary right now, as the current layout covers all functional invoice/dashboard needs.

## 4. Verification Plan

- **Manual Verification:**
  1. Click the avatar on the dashboard (it should no longer open a dialog).
  2. Go to Settings -> Profile and change the name (a green success toast should appear).
  3. Go to Settings -> General and toggle the Dark Theme (a green success toast should appear).
