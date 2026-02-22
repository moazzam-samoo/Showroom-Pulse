# Revenue & Reports Screen — Implementation Plan

> **Branch:** `feature/installments` (current)
> **Status:** Planning
> **Created:** 2026-02-20

---

## Goal

Build a complete **Revenue & Reports** screen with:
1. **Reports Section** — Monthly Profit bar chart, Stock Distribution donut chart, Net Profit Summary table
2. **Revenue Section** — Monthly revenue line chart, Expense Tracker (salaries, bills, rent, etc.)
3. **Downloadable PDF** — Full financial report with Salaries, Utilities, Rents, and Hands-On Amount

---

## Concept UI

### Reports Section (Dark Theme)

![Reports Section — Monthly profit bar chart, stock donut chart, KPI cards, net profit table](C:\Users\Moazzam Samoo\.gemini\antigravity\brain\efc80348-efd9-45c7-bd49-640275bef84c\reports_dark_theme_1771608580034.png)

### Revenue & Expense Tracker

![Revenue Section — Line chart, expense tracker table, summary bar with hands-on amount](C:\Users\Moazzam Samoo\.gemini\antigravity\brain\efc80348-efd9-45c7-bd49-640275bef84c\revenue_expenses_section_1771608600192.png)

---

## Data Architecture

### Revenue Formula
```
Revenue per Bike = Bike.cashSalePrice − Bike.purchasePrice
Total Revenue   = Sum of all sold bikes' revenue
```

### New Model: `Expense`
```dart
@collection
class Expense {
  Id id = Isar.autoIncrement;
  late String category;        // "Salaries", "Electricity", "Rent", "Utilities", "Misc"
  late double amount;
  late DateTime date;
  String? description;         // Optional note
}
```

### Key Calculations
| Metric | Formula |
|--------|---------|
| **Total Revenue** | `Σ (cashSalePrice − purchasePrice)` for all sold bikes |
| **Cash Sales Profit** | Revenue from `SaleType.cash` |
| **Installment Markup** | Revenue from `SaleType.installment` (Contract.totalAmount − Bike.cashSalePrice) |
| **Total Expenses** | `Σ Expense.amount` for selected month |
| **Net Profit** | `Total Revenue − Total Expenses` |
| **Hands-On Amount** | Same as Net Profit (revenue minus all deductions) |

---

## Screen Layout

### Tab Structure
Two-tab layout within the Reports screen:
1. **Reports Tab** — Charts + Net Profit Summary (read-only analytics)
2. **Revenue Tab** — Monthly revenue line chart + Expense Tracker (CRUD)

### Reports Tab Layout
```
┌─────────────────────────────────────────────────────────────┐
│ Revenue & Reports            [Reports] [Revenue]  [⬇ PDF]  │
├─────────────────────────────────────────────────────────────┤
│ ┌──────────┐  ┌──────────┐  ┌──────────┐                   │
│ │ Total    │  │ Total    │  │ Net      │                   │
│ │ Revenue  │  │ Expenses │  │ Profit   │                   │
│ │ Rs 1.47M │  │ Rs 320K  │  │ Rs 1.15M │                   │
│ └──────────┘  └──────────┘  └──────────┘                   │
│                                                             │
│ ┌──────── Monthly Profit ────────┐ ┌── Stock by Brand ──┐  │
│ │ ▓▓ ▓▓▓ ▓▓▓ ▓▓▓▓ ▓▓▓▓▓ ▓▓▓▓▓ │ │   ◉ Honda 45%     │  │
│ │ Jan Feb Mar Apr  May   Jun    │ │   ◉ Suzuki 25%    │  │
│ └────────────────────────────────┘ │   ◉ Yamaha 20%    │  │
│                                    └────────────────────┘  │
│ ┌──────── Net Profit Summary ───────────────────────────┐  │
│ │ Category    Cash Sales    Installment    Total Profit  │  │
│ │ Honda       Rs 450,000    Rs 180,000     Rs 630,000   │  │
│ │ Suzuki      Rs 280,000    Rs 112,000     Rs 392,000   │  │
│ │ TOTAL       Rs 1,050,000  Rs 420,000     Rs 1,470,000 │  │
│ └───────────────────────────────────────────────────────┘  │
└─────────────────────────────────────────────────────────────┘
```

### Revenue Tab Layout
```
┌─────────────────────────────────────────────────────────────┐
│ Revenue & Reports            [Reports] [Revenue]  [⬇ PDF]  │
├─────────────────────────────────────────────────────────────┤
│ ┌──────── Monthly Revenue Breakdown ────────────────────┐  │
│ │  📈 Line chart with gradient fill (6 months)          │  │
│ └───────────────────────────────────────────────────────┘  │
│                                                             │
│ ┌──────── Expense Tracker ────────────── [+ Add Expense] ┐  │
│ │ Category       Amount      Date        Actions          │  │
│ │ ● Salaries     Rs 80,000   Feb 2026    [✏️] [🗑]       │  │
│ │ ● Electricity  Rs 15,000   Feb 2026    [✏️] [🗑]       │  │
│ │ ● Rent         Rs 40,000   Feb 2026    [✏️] [🗑]       │  │
│ │ ● Utilities    Rs 8,000    Feb 2026    [✏️] [🗑]       │  │
│ └───────────────────────────────────────────────────────┘  │
│                                                             │
│ ┌──── Summary Bar ──────────────────────────────────────┐  │
│ │ Total Expenses: Rs 155K  Revenue: Rs 450K  Net: Rs 295K│  │
│ └───────────────────────────────────────────────────────┘  │
└─────────────────────────────────────────────────────────────┘
```

---

## PDF Report Structure

The downloadable PDF will contain:

| Section | Content |
|---------|---------|
| **Header** | "Tahir Showroom — Financial Report" + Date |
| **Summary KPIs** | Total Revenue, Expenses, Net Profit |
| **Monthly Profit Chart** | Bar chart data as table |
| **Net Profit by Brand** | Category breakdown table |
| **Expense Breakdown** | Salaries, Utilities, Rent, Misc |
| **Hands-On Amount** | Final net amount after all deductions |

---

## File Structure

```
lib/app/features/reports/
├── data/
│   ├── models/
│   │   └── expense.dart              [NEW] Isar Expense model
│   └── repositories/
│       └── reports_repository.dart    [NEW] Revenue + Expense queries
├── presentation/
│   ├── bindings/
│   │   └── reports_binding.dart       [NEW] GetX binding
│   ├── controllers/
│   │   └── reports_controller.dart    [NEW] State management
│   ├── views/
│   │   └── reports_view.dart          [NEW] Main screen with tabs
│   └── widgets/
│       ├── kpi_summary_cards.dart     [NEW] 3 KPI cards
│       ├── monthly_profit_chart.dart  [NEW] Bar chart (fl_chart)
│       ├── stock_distribution_chart.dart [NEW] Donut chart (fl_chart)
│       ├── profit_summary_table.dart  [NEW] Net profit by brand
│       ├── revenue_line_chart.dart    [NEW] Line chart (fl_chart)
│       └── expense_tracker.dart       [NEW] CRUD expense list
```

**Modified Files:**
- `lib/main.dart` — Register `/reports` route
- `lib/app/core/services/isar_service.dart` — Register `Expense` collection

---

## Task Breakdown

### Phase 1: Data Layer
- [ ] Create `Expense` model + run `build_runner`
- [ ] Register `Expense` in `isar_service.dart`
- [ ] Create `ReportsRepository` with revenue aggregation queries

### Phase 2: Feature Structure
- [ ] Create binding, controller, view files
- [ ] Register `/reports` route in `main.dart`

### Phase 3: Reports Tab UI
- [ ] Build KPI summary cards (Total Revenue, Expenses, Net Profit)
- [ ] Build Monthly Profit bar chart (fl_chart)
- [ ] Build Stock Distribution donut chart (fl_chart)
- [ ] Build Net Profit Summary table

### Phase 4: Revenue Tab UI
- [ ] Build Revenue line chart (fl_chart)
- [ ] Build Expense Tracker with Add/Edit/Delete
- [ ] Build Add Expense dialog
- [ ] Build summary bar (Expenses / Revenue / Net)

### Phase 5: PDF Report
- [ ] Create `ReportPdfService` for PDF generation
- [ ] Build all PDF sections (KPIs, tables, expenses, hands-on)
- [ ] Wire Download PDF button

### Phase 6: Verification
- [ ] `dart analyze` passes
- [ ] Hot restart — Reports tab loads with real data
- [ ] Add expense → appears in list
- [ ] Download PDF → opens with correct data
- [ ] Month filter changes chart data
