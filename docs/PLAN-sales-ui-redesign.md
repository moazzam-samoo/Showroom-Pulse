# Plan: Sales UI Redesign (Prices Section)

> **Goal:** Redesign the "Prices" (Calculation Summary) section in `PaymentPlanStep` to match a modern "Pro Max" aesthetic without modifying input logic.

## 1. Context Analysis
-   **Current State:** Simple vertical list of `_summaryRow` items inside a container.
-   **Target State:**
    -   **Container:** Clean white card (soft shadow, rounded corners 12-16px).
    -   **Header:** Muted teal/slate header bar for section title ("Payment Breakdown" or similar).
    -   **Layout:** Multi-column grid for price details (Base Price, Discount, Total Markup, etc.).
    -   **Typography:** Clear, top-aligned labels with subtle grey backgrounds or distinct visual hierarchy.
    -   **Constraint:** **DO NOT TOUCH INPUTS**. Only the "Display details" (Summary) section changes.

## 2. Implementation Strategy

### Phase 1: Component Extraction
-   [ ] Extract the `_summaryRow` logic into a standalone widget `PriceSummaryCard`.
-   [ ] Ensure it accepts `CalculationResult` as a parameter.

### Phase 2: Visual Overhaul (`PriceSummaryCard`)
-   [ ] **Container**: usage of `Container` with `BoxDecoration` (white bg, `AppRadius.lg`, `BoxShadow`).
-   [ ] **Header**: Add a colored container strip at the top (Teal/Slate) with White Text ("Transaction Summary").
-   [ ] **Grid Layout**:
    -   Use `Row` with `Expanded` children for key metrics.
    -   **Columns**:
        1.  Gross Price (was "Base Price")
        2.  Discount (New Label, value = 0 for now)
        3.  Net Price (Gross - Discount)
    -   **Second Row**:
        1.  Total Markup
        2.  **Grand Total** (Prominent)
    -   **Footer**: Loan Amount & Monthly Installment (highlighted).

### Phase 3: Styling (Pro Max)
-   [ ] **Labels**: Uppercase small, `Colors.grey[600]`.
-   [ ] **Values**: Large, specific font weights (Bold for Grand Total).
-   [ ] **Theme Awareness**: Ensure Dark Mode readability (use `AppColors.darkSurface` vs White).

## 3. Verification
-   [ ] Check Dark/Light mode contrast.
-   [ ] Verify "Discount" shows Rs 0 (placeholder).
-   [ ] Verify Grand Total matches calculator logic.
-   [ ] Confirm Inputs (Markup/Down Payment) remain untouched and functional.
