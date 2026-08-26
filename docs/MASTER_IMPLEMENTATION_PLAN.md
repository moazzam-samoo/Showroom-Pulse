# Showroom Pulse ERP - Master Technical Documentation & Implementation Plan

**Version:** 3.0 (Consolidated & Enhanced)
**Date:** February 2026
**Platform:** Windows Desktop (Flutter + GetX + Isar)
**Philosophy:** Offline-First, Portable Data, Feature-Vertical Architecture.

---

## 📂 1. Data Saving Folder Structure (Critical)
The system relies on a portable "Document-Based" architecture. All data lives in the user's `Documents` folder, making backup as simple as copying one folder.

**Root Path:** `C:\Users\[User]\Documents\ShowroomPulse\`

### 1.1 Folder Hierarchy Map
```text
ShowroomPulse/
│
├── Database/                  # 🟢 CRITICAL: Isar NoSQL DB files
│   ├── default.isar           # Main database file
│   └── default.isar.lock      # Lock file (active usage)
│
└── Media/                     # 🟡 ASSETS: External images/docs
    │
    ├── Bikes/                 # Inventory Images
    │   ├── ENG-998877.jpg     # Naming: [EngineNumber].jpg
    │   └── ENG-112233.jpg
    │
    ├── Suppliers/             # Procurement Data
    │   ├── AhmedAutos/        # Folder Name: [SupplierName]
    │       ├── profile.jpg
    │       └── Invoices/
    │           └── batch_501.jpg
    │
    └── Customers/             # Sales Data
        ├── 42101-1234567-1/   # Folder Name: [CNIC]
            ├── profile.jpg    # Customer Photo
            ├── cnic_front.jpg # Customer CNIC
            │
            └── Witness/       # Guarantor Documents
                ├── w1_front.jpg  # Witness 1 CNIC Front
                ├── w1_back.jpg   # Witness 1 CNIC Back (Optional)
                ├── w2_front.jpg  # Witness 2 CNIC Front
                └── w2_back.jpg   # Witness 2 CNIC Back
```

---

## 🏗️ 2. Core Architecture & Data Layer
**Status:** ✅ Complete

### 2.1 Technical Foundation
-   **Window Configuration:** `bitsdojo_window` for custom title bar and 1280x720 min size.
-   **Dependency Injection:** `Get.put()` used for singleton services (`IsarService`, `FileService`).
-   **Theming:** `ThemeService` managing Dark/Light modes with `GoogleFonts.outfit`.

### 2.2 Data Persistence (Isar NoSQL)
**Logic:** Offline-first NoSQL database.

#### Core Collections (Schema)
**1. Bike (The Asset)**
```dart
@collection
class Bike {
  Id id = Isar.autoIncrement;
  @Index(unique: true) late String engineNumber;
  @Index(unique: true) late String chassisNumber;
  late String model;      // e.g., "Honda CD 70"
  late String brand;
  late String color;
  late int modelYear;
  late double purchasePrice; // Cost basis (from Batch)
  late double cashSalePrice; // List price
  @enumerated BikeStatusEnum status; // available, sold, installment
  final batch = IsarLink<PurchaseBatch>();
}
```

**2. Customer (The Buyer)**
```dart
@collection
class Customer {
  Id id = Isar.autoIncrement;
  late String fullName;
  late String fatherName; // Added in Phase 5
  @Index(unique: true) late String cnicNumber;
  late String phoneNumber;
  late String address;
  String? profilePicFilename;
  final contracts = IsarLinks<InstallmentContract>();
}
```

---

## 📦 3. Procurement & Inventory Logic
**Status:** ✅ Complete

### 3.1 Procurement (Adding Stock)
-   **Models**: `Supplier` and `PurchaseBatch`.
-   **Logic**:
    -   1. Select Supplier.
    -   2. Create Batch (Date, Invoice Image).
    -   3. Add Bikes to Batch (Grid Entry).
        -   *Calculation*: `Batch Total = Sum(Bike Purchase Costs)`.

### 3.2 Inventory Management
-   **Display**: Grid of Cards.
-   **Query**: `isar.bikes.filter().statusEqualTo(available)`.
-   **Index**: Searchable by `engineNumber` (Last 4 digits) or `chassisNumber`.

---

## 💰 4. Sales Engine Implementation
**Status:** ✅ Complete

### 4.1 Installment Logic (`InstallmentCalculator`)
A pure Dart utility class handling the financial math.
-   **Formula**: `Total = CashPrice + (CashPrice * Markup%)`
-   **Method**: `calculate({cashPrice, markup, downPayment, months})`
-   **Output**: Returns `monthlyInstallment`, `totalMarkup`, `grandTotal`.

### 4.2 Transaction Flow (`NewSaleController.finalizeSale`)
The system performs an atomic operation to ensure data integrity:
1.  **Validation**: Check if Bike is still `available`.
2.  **DB Write 1**: Create `Sale` record.
3.  **DB Write 2**: Create `InstallmentContract` (if applicable) linked to Sale & Customer.
4.  **DB Write 3**: Update `Bike.status` to `sold` or `installment`.
5.  **File OPS**: Save Customer/Witness images only after validation passes.

---

## ✨ 5. UI/UX Pro Max (The New Standard)
**Status:** ✅ Complete (Latest Enhancements)

This phase introduced advanced UI patterns and strict validation logic.

### 5.1 Enhanced Vehicle Selection (Grouped List)
**Context**: Replaces simple grid with organized Grouped List.
-   **UI Pattern**: `ListView` of `ExpansionTile` widgets.
-   **Grouping Logic**:
    ```dart
    Map<String, List<Bike>> get groupedBikes {
       // 1. Fetch all 'available' bikes
       // 2. Reduce into Map key by bike.model
    }
    ```
-   **Visuals**: Header shows Model Name + Count (e.g., "United 70cc (12)").
-   **UX**: Tapping a bike triggers `Scrollable.ensureVisible` to auto-scroll to the Customer section.

### 5.2 Witness Management System
**Requirement**: Mandatory validation for installment deals.
-   **UI Component**: `WitnessFormStep` (Reusable widget).
-   **Witness 1 (Primary)**:
    -   **Mandatory Fields**: Name, CNIC, Phone, Address.
    -   **Mandatory Image**: CNIC Front.
-   **Witness 2 (Secondary)**:
    -   **Optional**: Toggle to show/hide.
    -   **Data Model**: Saved as `Witness` object with `isPrimary: false`.

### 5.3 Safety Mechanics
-   **Cancel Guard**: `NewSaleController` tracks `hasUnsavedChanges`.
    -   *Logic*: If fields are dirty > Show Alert Dialog on Back/Cancel.
-   **Form Validation**: Custom `Validator` class checks:
    -   CNIC Format: `XXXXX-XXXXXXX-X`
    -   Phone Format: 11 digits

---

## 🛠️ 6. Verification & Maintenance Checklist

### Automated Tests
Run these scripts before every release:
-   [ ] `flutter analyze` - Must contain 0 fatal errors.
-   [ ] `dart test` - Verify `InstallmentCalculator` math.

### Manual Sanity Check
1.  **Clean Install**: Delete `Documents/ShowroomPulse/` and run app. Database should regenerate.
2.  **Sale Flow**:
    -   Add 1 Bike via Procurement.
    -   Sell Bike via New Sale (Installment).
    -   Verify Bike Status changes to `installment` in Inventory.
    -   Verify Images appear in `Media/`.
