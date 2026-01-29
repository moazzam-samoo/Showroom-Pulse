# ⌨️ PLAN: Keyboard Shortcuts & Focus Navigation

> **Goal:** Transform the "Click-based" UI into a "Power User" interface using `Enter` (Submit) and `Esc` (Cancel) shortcuts.

## 🧠 Brainstorming: Technical Approach

### Option A: `RawKeyboardListener`
Manual check in `build` method.
*   *Pros:* Simple to understand.
*   *Cons:* Verbose, tricky Focus handling, deprecated in favor of `KeyboardListener` or `Shortcuts`.

### Option B: `TextField.onSubmitted`
Only works when a text field has focus.
*   *Pros:* Built-in.
*   *Cons:* Doesn't work if focus is on a Dropdown or Image Picker.

### Option C: `Shortcuts` + `Actions` (Recommended)
Flutter's robust Intent system.
*   *Pros:* Separates key mapping from logic, works anywhere in the FocusScope hierarchy.
*   *Cons:* Slightly more boilerplate.

## 🛠️ Implementation Strategy (Frontend Specialist)

### 1. **Debug "Add Bike" Button**
*   **Issue:** User reports button not working.
*   **Hypothesis:** Validation failure or Focus trapping.
*   **Action:** Verify `_handleSave` connection and Form validation feedback.

### 2. **Create `AppDialog` Widget**
*   (Completed) Standardized wrapper with Enter/Esc support.

### 3. **Global Rollout (Frontend Specialist)**
Apply `AppDialog` to:
*   [ ] **Inventory:** `AddBikeDialog` (Done) via `AppDialog` wrapper.
*   [ ] **Customers:** `AddPaymentDialog` (if exists).
*   [ ] **Procurement:** `AddStockView` (Batch Entry Dialog).
*   [ ] **Suppliers:** `EditSupplierDialog` (in controller).
*   [ ] **Core:** `DeleteConfirmationDialog` (Reusable).

### 4. **Form Field Optimization**
*   Ensure `textInputAction: TextInputAction.next` on all inputs.
*   Add `autofocus: true` to primary fields.

## 🛤️ Execution Steps
1.  **Core:** Create `AppKeyboardShortcuts` wrapper or `AppDialog`.
2.  **Inventory:** specific refactor of `AddBikeDialog` to use `Intents`.
3.  **Procurement:** Refactor `AddStockView` (if applicable).

## ✅ Verification (Test Engineer)
*   **Test Esc:** Open dialog -> Press Esc -> Dialog closes.
*   **Test Enter:** Fill data -> Press Enter -> Form submits.
*   **Test Focus:** Tab key navigates fields correctly.

## 🤖 Agent Assignments
1.  **`project-planner`**: Plan documentation.
2.  **`frontend-specialist`**: Widget creation & Refactoring.
3.  **`frontend-specialist`**: UX Polish (Focus outlines).
