# Installment Section Enhancements Plan

> **Goal:** Fix critical bugs, add missing features, and improve UX across the Installment tracking system.

---

## 🔍 Issues Identified from Screenshot & Requirements

| # | Issue | Root Cause | Priority |
|---|-------|-----------|----------|
| 1 | **Next Due shows "N/A"** | `nextDueDate` never set during contract creation in `NewSaleController.finalizeSale` | 🔴 Critical |
| 2 | **Missing summary boxes** | Only 4 cards (Total, Paid, Remaining, Next Due). Need Down Payment + Monthly EMI | 🟡 High |
| 3 | **Payment History shows creation date** | Virtual Down Payment record injected with contract date. Should only show real recorded payments | 🟡 High |
| 4 | **CNIC not shown in detail header** | `_buildCustomerHeader` only displays name + phone | 🟢 Medium |
| 5 | **No Sales ↔ Installment sync** | Sales installment cards don't reflect completion status | 🟡 High |
| 6 | **No Download Statement** | No PDF generation capability exists | 🟡 High |
| 7 | **Record Payment not auto-filled** | `RecordPaymentDialog` doesn't receive `monthlyEMI` | 🟢 Medium |

---

## Proposed Changes

### Phase 1: Fix Next Due Date (Critical Bug)

#### [MODIFY] [new_sale_controller.dart](file:///c:/Users/Moazzam Samoo/Desktop/Tahir Showroom/lib/app/features/sales/presentation/controllers/new_sale_controller.dart)

In `finalizeSale` (line ~421-433), set `nextDueDate` and `dayOfMonth` when creating the contract:

```diff
 final contract = InstallmentContract()
   ..bikeId = bike.id
   ..customerId = customer.id
   ..cashPrice = bike.cashSalePrice
   ..markupType = markupType.value
   ...
   ..firstDueDate = DateTime.now().add(const Duration(days: 30))
+  ..nextDueDate = DateTime.now().add(const Duration(days: 30))
+  ..dayOfMonth = DateTime.now().add(const Duration(days: 30)).day
   ..status = ContractStatusEnum.active;
```

**Also** add fallback logic in `InstallmentsController.loadContracts` — if a contract has `nextDueDate == null` and is not completed, auto-compute it from `firstDueDate` or `contractDate + 30 days`.

---

### Phase 2: Add Down Payment & Monthly EMI Summary Boxes

#### [MODIFY] [payment_summary_cards.dart](file:///c:/Users/Moazzam Samoo/Desktop/Tahir Showroom/lib/app/features/installments/presentation/widgets/payment_summary_cards.dart)

- Add `downPayment` and `monthlyEMI` parameters
- Change from 2×2 grid → 3×2 grid (6 cards total):

| Row 1 | Total Amount | Paid | Down Payment |
|-------|-------------|------|-------------|
| Row 2 | Remaining | Next Due | Monthly EMI |

#### [MODIFY] [installments_view.dart](file:///c:/Users/Moazzam Samoo/Desktop/Tahir Showroom/lib/app/features/installments/presentation/views/installments_view.dart)

Pass `downPayment` and `monthlyEMI` from `selected.contract` to `PaymentSummaryCards`.

---

### Phase 3: Fix Payment History Display

#### [MODIFY] [installments_controller.dart](file:///c:/Users/Moazzam Samoo/Desktop/Tahir Showroom/lib/app/features/installments/presentation/controllers/installments_controller.dart)

**Remove** the virtual Down Payment injection logic (lines 101-118). The Down Payment is now shown in its own dedicated summary card, so there's no need to inject it into the payment list. Payment History should only show **actual recorded payments**.

---

### Phase 4: Add CNIC to Detail Header

#### [MODIFY] [installments_view.dart](file:///c:/Users/Moazzam Samoo/Desktop/Tahir Showroom/lib/app/features/installments/presentation/views/installments_view.dart)

In `_buildCustomerHeader` (line ~340), add CNIC row after phone:

```diff
 Row(children: [
   Icon(LucideIcons.phone, ...),
   Text(data.customer.phoneNumber, ...),
 ]),
+const SizedBox(height: 4),
+Row(children: [
+  Icon(LucideIcons.creditCard, ...),
+  Text('CNIC: ${data.customer.cnicNumber}', ...),
+]),
```

---

### Phase 5: Auto-fill Record Payment Dialog

#### [MODIFY] [record_payment_dialog.dart](file:///c:/Users/Moazzam Samoo/Desktop/Tahir Showroom/lib/app/features/installments/presentation/widgets/record_payment_dialog.dart)

- Add `defaultAmount` parameter to constructor
- Pre-fill `_amountController.text` with the monthly EMI value in `initState`
- User can still edit the amount if needed

#### [MODIFY] [installments_view.dart](file:///c:/Users/Moazzam Samoo/Desktop/Tahir Showroom/lib/app/features/installments/presentation/views/installments_view.dart)

In `_showRecordPaymentDialog`, pass `selected.contract.monthlyEMI` to dialog.

---

### Phase 6: Sales ↔ Installment Sync

#### [MODIFY] [installment_repository.dart](file:///c:/Users/Moazzam Samoo/Desktop/Tahir Showroom/lib/app/features/installments/data/repositories/installment_repository.dart)

In `recordPayment` method (line ~137), when contract status becomes `completed`:
- Update the related `Sale` record's status
- Mark bike as "sold-completed" (no pending installments)

#### [MODIFY] [sales_controller.dart](file:///c:/Users/Moazzam Samoo/Desktop/Tahir Showroom/lib/app/features/sales/presentation/controllers/sales_controller.dart)

- Refresh sales list on navigation to reflect updated installment status
- Filter out completed installment cards or mark them visually

> [!IMPORTANT]
> Need clarification: When installment is completed, should the sale card **disappear entirely** from the Sales view, or should it show a "Completed" badge? Disappearing might confuse the user if they're looking for historical records.

---

### Phase 7: Download Statement (PDF Generation)

#### [NEW] Add `pdf` dependency to `pubspec.yaml`

```yaml
dependencies:
  pdf: ^3.11.1
  printing: ^5.13.3  # For print/save dialog
```

#### [NEW] [statement_service.dart](file:///c:/Users/Moazzam Samoo/Desktop/Tahir Showroom/lib/app/core/services/statement_service.dart)

Create PDF generation service with:
- **Single Customer Statement**: Customer info + contract details + payment history table
- **Global Statement**: All customers summary with individual contract details
- Header: Tahir Showroom branding
- Footer: Generated date, page numbers

#### [MODIFY] [installments_view.dart](file:///c:/Users/Moazzam Samoo/Desktop/Tahir Showroom/lib/app/features/installments/presentation/views/installments_view.dart)

- Add **"Download Statement"** button in customer detail header (per-customer)
- Add **"Export All"** button in the top header bar (global download)

#### [MODIFY] [installments_controller.dart](file:///c:/Users/Moazzam Samoo/Desktop/Tahir Showroom/lib/app/features/installments/presentation/controllers/installments_controller.dart)

- Add `downloadStatement(int contractId)` method
- Add `downloadAllStatements()` method

---

## Questions Before Implementation

> [!WARNING]
> Please answer these before I start:

1. **Sales Completion Behavior**: When an installment is fully paid, should the sale card **disappear** from the Sales screen, or should it show as **"Completed"** with a green badge?

2. **PDF Statement Content**: Should the statement include witness information, or just customer + bike + payment history?

3. **PDF Language**: Should the statement be in **English** or **Urdu/Roman Urdu**?

4. **Download Location**: Should the PDF be saved to a specific folder (e.g., `Documents/Tahir Showroom/Statements/`) or show a "Save As" dialog?

5. **Global Statement Format**: Should it be one big PDF with all customers, or a **ZIP file** with individual PDFs per customer?

---

## Verification Plan

### Automated
- `flutter analyze` — no errors
- Hot restart and verify:
  - Next Due Date shows correctly for new + existing contracts
  - 6 summary cards displayed
  - Payment History only shows recorded payments (not contract creation)
  - CNIC visible in detail header
  - Record Payment dialog pre-fills amount
  - PDF downloads successfully

### Manual
- Create new installment → verify Next Due = contractDate + 30 days
- Record payment → verify Next Due updates
- Complete all payments → verify Sales card behavior
- Download individual + global statements
