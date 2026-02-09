# Plan: Track Installments Feature

> **Goal:** Create a comprehensive installment tracking system with payment ledger, reminders, and customer management.

---

## 📋 Confirmed Decisions

| Question | Choice |
|----------|--------|
| Payment Tracking | **Detailed** - Full Payment Ledger (Date, Amount, Method, Collector, Notes) |
| Reminder System | **Both** - Windows Notifications + Visual Badges |
| Contract Statuses | **Extended** - Active, PartiallyPaid, Overdue, Completed, Defaulted |
| Navigation | **New Sidebar Tab** - "Installments" as top-level item |
| Customer View | **Both** - Accordion preview + Detail page |

---

## 🗄️ Database Schema (Isar)

### New Collection: `PaymentEntry`

```dart
@collection
class PaymentEntry {
  Id id = Isar.autoIncrement;
  
  late DateTime paymentDate;
  late double amount;
  
  @enumerated
  late PaymentMethod method; // Cash, BankTransfer, JazzCash, EasyPaisa
  
  String? collectorName;
  String? notes;
  String? receiptImagePath; // Optional receipt photo
  
  // Relationship
  final contract = IsarLink<InstallmentContract>();
}

enum PaymentMethod { cash, bankTransfer, jazzCash, easyPaisa }
```

### Updated Collection: `InstallmentContract`

```dart
@collection
class InstallmentContract {
  // ... existing fields ...
  
  // NEW FIELDS
  late int dayOfMonth;  // e.g., 15 = payment due on 15th of each month
  
  @enumerated
  late ContractStatus status; // Active, PartiallyPaid, Overdue, Completed, Defaulted
  
  DateTime? lastPaymentDate;
  DateTime? nextDueDate;  // Computed or stored for quick queries
  
  // Relationships
  final payments = IsarLinks<PaymentEntry>();
}

enum ContractStatus { active, partiallyPaid, overdue, completed, defaulted }
```

### File System Addition

```
TahirShowroom/
├── Media/
│   └── Customers/
│       └── {CNIC}/
│           └── Receipts/          # NEW: Payment receipt images
│               └── receipt_2024-02-09.jpg
```

---

## 📁 Feature Structure

```
lib/app/features/installments/
├── data/
│   └── repositories/
│       └── installment_repository.dart
├── domain/
│   └── services/
│       ├── payment_service.dart
│       └── reminder_service.dart
├── presentation/
│   ├── controllers/
│   │   ├── installments_controller.dart
│   │   └── customer_ledger_controller.dart
│   ├── views/
│   │   ├── installments_view.dart        # Main split-view screen
│   │   └── customer_ledger_view.dart     # Full detail page
│   └── widgets/
│       ├── customer_card.dart            # List item with progress
│       ├── payment_summary_cards.dart    # KPI grid
│       ├── payment_timeline.dart         # History table
│       └── record_payment_dialog.dart    # Add payment modal
```

---

## 🖥️ UI Components

### 1. Installments View (Split Layout)

| Section | Component | Description |
|---------|-----------|-------------|
| Left Panel | Customer List | Scrollable cards with search/filter |
| Right Panel | Customer Detail | Summary + Payment Timeline |
| Top Bar | Search + Filters | Status filter, "Due This Week" quick filter |

### 2. Customer Card (List Item)

- Avatar with initials
- Name + CNIC
- Bike model tag
- Circular progress (e.g., 7/12 payments)
- Status chip: Active (cyan), Overdue (red), Completed (green)

### 3. Payment Summary Cards (KPI Grid)

| Card | Color | Data |
|------|-------|------|
| Total Amount | Cyan | Contract grand total |
| Paid | Green | Sum of all payments |
| Remaining | Orange | Total - Paid |
| Next Due | Blue | Date + Days countdown |

### 4. Payment Timeline (Table)

| Column | Width |
|--------|-------|
| Date | 120px |
| Amount | 100px |
| Method | 100px |
| Collector | 150px |
| Notes | Flex |
| Receipt | 50px (icon) |

### 5. Record Payment Dialog

Fields:
- Amount (required, with comma formatting)
- Payment Date (default: today)
- Method (dropdown)
- Collector Name (optional)
- Notes (optional)
- Receipt Image (optional upload)

---

## 🔔 Reminder System

### Visual Badges (In-App)

| Status | Badge | Trigger |
|--------|-------|---------|
| Due Soon | Yellow | 3 days before due date |
| Overdue | Red | After due date |
| Partially Paid | Blue | Has payments but not complete |

### Windows Notifications

**Package:** `local_notifier` (Windows-native notifications)

**Trigger Logic:**
1. On app startup: Check all active contracts
2. For each contract where `nextDueDate - today <= 3 days`
3. Show Windows toast notification with customer name + amount due

**Background Service (Optional Advanced):**
- Use Windows Task Scheduler to run a Dart script daily
- Or use `windows_single_instance` to keep reminder service running

---

## 📊 Implementation Phases

### Phase 1: Database & Models (Day 1)
- [ ] Create `PaymentEntry` Isar model
- [ ] Update `InstallmentContract` with new fields
- [ ] Run Isar code generator
- [ ] Create `InstallmentRepository`

### Phase 2: Core UI (Day 2-3)
- [ ] Add "Installments" to sidebar navigation
- [ ] Create `InstallmentsView` with split layout
- [ ] Build `CustomerCard` widget
- [ ] Build `PaymentSummaryCards` widget
- [ ] Build `PaymentTimeline` table

### Phase 3: Payment Recording (Day 3-4)
- [ ] Create `RecordPaymentDialog`
- [ ] Implement `PaymentService.recordPayment()`
- [ ] Update contract status on payment
- [ ] Recalculate remaining amount

### Phase 4: Detail View (Day 4)
- [ ] Create `CustomerLedgerView` (full page)
- [ ] Show contract details + bike info
- [ ] Complete payment history
- [ ] Edit/Delete payment capability

### Phase 5: Reminders (Day 5)
- [ ] Integrate `local_notifier` package
- [ ] Create `ReminderService`
- [ ] Implement startup check logic
- [ ] Add visual badge indicators

### Phase 6: Polish & Testing (Day 6)
- [ ] Search and filter functionality
- [ ] "Due This Week" quick filter
- [ ] Export to Excel option
- [ ] Edge case testing

---

## ✅ Verification Checklist

- [ ] Customer list displays all installment contracts
- [ ] Payment progress shows correctly (X/Y months)
- [ ] Recording payment updates remaining amount
- [ ] Overdue contracts show red badge
- [ ] Windows notification fires 3 days before due
- [ ] Detail view shows complete payment history
- [ ] Search by name/CNIC works
- [ ] Dark theme matches app design system

---

## 🎨 Design Tokens (From REMEMBERING.md)

| Element | Light | Dark |
|---------|-------|------|
| Background | #F3F3F3 | #0a0e17 |
| Card | #FFFFFF | #0f172a |
| Primary | #0078D4 | #06b6d4 |
| Success | #16A34A | #10b981 |
| Warning | #F97316 | #f59e0b |
| Error | #DC2626 | #ef4444 |

---

## 📦 Dependencies to Add

```yaml
dependencies:
  local_notifier: ^0.1.6  # Windows notifications
  intl: ^0.18.0          # Date formatting (if not present)
```

---

*Plan created by AI Agent following /plan workflow*
