# Customers Screen Implementation Plan

> **Branch:** `feature/customers`  
> **Created:** 2026-02-09  
> **Status:** ✅ Implementation Complete

---

## Goal

Create a comprehensive **Customers** screen that displays:
- All customer data and purchase history
- Transaction details (witness, customer, vehicle info)
- Both **Cash** and **Installment** purchases
- Installment status (remaining vs. paid)

### Sorting Requirements
1. **Primary:** Date (newest first)
2. **Secondary:** Vehicle price (highest first)

---

## 🎨 UI Layout Options (Select One)

### Option A: **Master-Detail Split View**

```
┌─────────────────────────────────────────────────────────────────────┐
│ 🔍 Search: [_______________]  [📅 Date ▼] [💰 Price ▼] [🏷️ All ▼] │
├─────────────────────────┬───────────────────────────────────────────┤
│   CUSTOMER LIST (30%)   │         TRANSACTION HISTORY (70%)         │
├─────────────────────────┼───────────────────────────────────────────┤
│ ┌─────────────────────┐ │  👤 Muhammad Ali                          │
│ │ 🟦 MA  Muhammad Ali │ │  CNIC: 42101-xxxxxx-7  📞 0300-1234567    │
│ │      3 Purchases    │ │  Father: Abdul Rashid                      │
│ │      ₨ 8,50,000     │ │  ────────────────────────────────────────  │
│ └─────────────────────┘ │                                            │
│ ┌─────────────────────┐ │  ┌────────────────────────────────────┐   │
│ │ 🟩 BT  Bilal Tariq  │ │  │ 📅 2026-01-15  ₨ 3,20,000          │   │
│ │      2 Purchases    │ │  │ 🏍️ Honda CD-70 (2025)              │   │
│ │      ₨ 4,75,000     │ │  │ [💵 CASH]                          │   │
│ └─────────────────────┘ │  │ 👁️ Witness: Usman Khan             │   │
│ ┌─────────────────────┐ │  └────────────────────────────────────┘   │
│ │ 🟧 AH  Ahmed Hassan │ │  ┌────────────────────────────────────┐   │
│ │      1 Purchases    │ │  │ 📅 2025-11-20  ₨ 2,80,000          │   │
│ │      ₨ 2,80,000     │ │  │ 🏍️ Yamaha YBR-125 (2024)          │   │
│ └─────────────────────┘ │  │ [📆 INSTALLMENT] 7/12 Paid          │   │
│                         │  │ Progress: ▓▓▓▓▓▓▓░░░░░ 58%         │   │
│  [Load More...]         │  │ 👁️ Witness: Hassan Malik            │   │
│                         │  │ [📋 View Timeline]                  │   │
│                         │  └────────────────────────────────────┘   │
└─────────────────────────┴───────────────────────────────────────────┘
```

**Pros:**
- ✅ Quick customer selection without navigation
- ✅ Transaction details always visible
- ✅ Familiar CRM-style layout

**Cons:**
- ❌ Limited space for many transactions
- ❌ Requires horizontal scrolling on smaller screens

---

### Option B: **Expandable Card Grid**

```
┌─────────────────────────────────────────────────────────────────────┐
│ 🔍 Search: [_______________]  [📅 Date ▼] [💰 Price ▼] [🏷️ All ▼] │
├─────────────────────────────────────────────────────────────────────┤
│                                                                     │
│  ┌─────────────────────────────────────────────────────────────┐   │
│  │ 🟦 MA │ Muhammad Ali          │ 3 Vehicles │ ₨ 8,50,000   [▼]│   │
│  ├───────┴──────────────────────────────────────────────────────┤   │
│  │ (EXPANDED)                                                   │   │
│  │  ┌──────────────────────┐  ┌──────────────────────┐          │   │
│  │  │ Honda CD-70 (2025)   │  │ Yamaha YBR-125       │          │   │
│  │  │ 📅 2026-01-15        │  │ 📅 2025-11-20        │          │   │
│  │  │ ₨ 3,20,000           │  │ ₨ 2,80,000           │          │   │
│  │  │ [💵 CASH]            │  │ [📆 7/12] ▓▓▓▓░░     │          │   │
│  │  └──────────────────────┘  └──────────────────────┘          │   │
│  └──────────────────────────────────────────────────────────────┘   │
│                                                                     │
│  ┌─────────────────────────────────────────────────────────────┐   │
│  │ 🟩 BT │ Bilal Tariq           │ 2 Vehicles │ ₨ 4,75,000  [▶]│   │
│  └─────────────────────────────────────────────────────────────┘   │
│                                                                     │
│  ┌─────────────────────────────────────────────────────────────┐   │
│  │ 🟧 AH │ Ahmed Hassan          │ 1 Vehicles │ ₨ 2,80,000  [▶]│   │
│  └─────────────────────────────────────────────────────────────┘   │
│                                                                     │
└─────────────────────────────────────────────────────────────────────┘
```

**Pros:**
- ✅ Full width for each customer
- ✅ Vehicles as horizontal cards inside
- ✅ Cleaner mobile responsive design

**Cons:**
- ❌ More clicks to see all details
- ❌ Expansion animation needed

---

### Option C: **Full-Page Customer Profile (Route-Based)**

```
CUSTOMERS LIST PAGE (/customers)
┌─────────────────────────────────────────────────────────────────────┐
│ 🔍 Search: [_______________]  [📅 Date ▼] [💰 Price ▼] [🏷️ All ▼] │
├─────────────────────────────────────────────────────────────────────┤
│  ┌───────────────────────────────────────────────────────────────┐  │
│  │ 🟦 MA │ Muhammad Ali │ 📞 0300-1234567 │ 3 Vehicles │ ₨8.5L [→]│  │
│  └───────────────────────────────────────────────────────────────┘  │
│  ┌───────────────────────────────────────────────────────────────┐  │
│  │ 🟩 BT │ Bilal Tariq  │ 📞 0312-5551234 │ 2 Vehicles │ ₨4.7L [→]│  │
│  └───────────────────────────────────────────────────────────────┘  │
└─────────────────────────────────────────────────────────────────────┘

CUSTOMER DETAIL PAGE (/customers/:id)
┌─────────────────────────────────────────────────────────────────────┐
│ [← Back]                  Muhammad Ali                              │
├─────────────────────────────────────────────────────────────────────┤
│  ┌─────────────────────────────────────────────────────────────┐    │
│  │ 📷    │ Name: Muhammad Ali              CNIC: 42101-xxxxx-7 │    │
│  │ Avatar│ Father: Abdul Rashid           📞 0300-1234567      │    │
│  │       │ Address: Street 5, Block C, Karachi                 │    │
│  └───────┴─────────────────────────────────────────────────────┘    │
│                                                                     │
│  ── PURCHASE HISTORY ────────────────────────────────────────────   │
│                                                                     │
│  TRANSACTION 1                                         📅 2026-01-15│
│  ┌─────────────────────────────────────────────────────────────┐   │
│  │ Vehicle: Honda CD-70 (2025)  │  Chassis: xxxxxx  Engine: xxx│   │
│  │ Price: ₨ 3,20,000            │  [💵 CASH - PAID]           │   │
│  │ Witness: Usman Khan (CNIC: 42101-xxxxx-8)                   │   │
│  └─────────────────────────────────────────────────────────────┘   │
│                                                                     │
│  TRANSACTION 2                                         📅 2025-11-20│
│  ┌─────────────────────────────────────────────────────────────┐   │
│  │ Vehicle: Yamaha YBR-125 (2024)│ Chassis: xxxxxx Engine: xxx │   │
│  │ Price: ₨ 2,80,000             │ [📆 INSTALLMENT]           │   │
│  │ Down Payment: ₨ 80,000        │ Monthly: ₨ 18,333          │   │
│  │ Progress: ▓▓▓▓▓▓▓░░░░░ 7/12 (58%)   Remaining: ₨ 92,500    │   │
│  │ Witness: Hassan Malik (CNIC: 42101-xxxxx-9)                 │   │
│  │ [📋 View Payment Timeline]                                  │   │
│  └─────────────────────────────────────────────────────────────┘   │
└─────────────────────────────────────────────────────────────────────┘
```

**Pros:**
- ✅ Maximum detail visibility
- ✅ Dedicated space for full transaction history
- ✅ Can show witness CNIC images
- ✅ Matches Installments page pattern

**Cons:**
- ❌ Requires navigation between pages
- ❌ More route setup

---

## 📊 Data Flow Analysis

### Existing Models to Use

| Model | Fields Needed |
|-------|---------------|
| `Customer` | id, fullName, fatherName, cnicNumber, phoneNumber, address, profileImageFilename |
| `Sale` | id, saleDate, saleType, bikeId, customerId, totalAmount, receivedAmount, installmentContractId |
| `Bike` | id, model, year, chassisNumber, engineNumber, registrationNumber |
| `InstallmentContract` | id, totalAmount, remainingAmount, months, paymentsMade, status |

### New Model Required: `Witness`

```dart
@collection
class Witness {
  Id id = Isar.autoIncrement;
  
  late int saleId;           // Link to Sale
  late String fullName;
  late String cnicNumber;
  String? phoneNumber;
  String? cnicFrontFilename;
  String? cnicBackFilename;
}
```

> **Question:** Does witness data already exist somewhere else, or should we create this new model?

---

## 🗂️ Proposed File Structure

```
lib/app/features/customers/
├── data/
│   └── repositories/
│       └── customer_repository.dart       # Query customers + sales + contracts
├── presentation/
│   ├── bindings/
│   │   └── customers_binding.dart
│   ├── controllers/
│   │   └── customers_controller.dart      # State management
│   ├── views/
│   │   ├── customers_view.dart            # Main list view
│   │   └── customer_detail_view.dart      # Full profile (if Option C)
│   └── widgets/
│       ├── customer_card.dart             # List item
│       ├── transaction_card.dart          # Purchase record
│       └── installment_progress.dart      # Progress indicator
```

---

## 📋 Task Breakdown

### Phase 1: Data Layer
- [ ] Create `Witness` model (if needed)
- [ ] Create `CustomerRepository` with aggregation queries
- [ ] Implement sorting (date + price)

### Phase 2: Feature Structure
- [ ] Create feature folder structure
- [ ] Set up binding and controller
- [ ] Add route to `main.dart`
- [ ] Update sidebar navigation (index 5)

### Phase 3: UI Implementation
- [ ] Build main customers list view (selected layout)
- [ ] Build transaction card widget
- [ ] Build installment progress widget
- [ ] Implement search and filters

### Phase 4: Detail View (if Option C)
- [ ] Create customer detail view
- [ ] Show full transaction history
- [ ] Add witness information section

### Phase 5: Testing & Polish
- [ ] Test with real data
- [ ] Test sorting functionality
- [ ] Verify theme compliance (REMEMBERING.md)

---

## 🎯 Decision Required

**Please select your preferred UI layout:**

| Option | Layout Style | Best For |
|--------|--------------|----------|
| **A** | Master-Detail Split | Desktop-focused, quick browsing |
| **B** | Expandable Cards | Compact view, mobile-friendly |
| **C** | Full-Page Profile | Maximum detail, matches Installments |

---

## Theme Compliance Checklist

- [x] Using Cyan (`#06b6d4`) primary for dark theme
- [x] Using Navy (`#0a0e17`) background
- [x] Customer cards: Avatar initials + progress bar
- [x] Border radius: 12px for cards
- [x] Icons: Lucide library
- [x] Typography: Segoe UI, 14px body

---

*Plan Created by: Antigravity Agent (Project Planner)*
