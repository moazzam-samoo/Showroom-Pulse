# Showroom Pulse ERP – Task Tracker

## Phase 1: Core Foundation (`core/setup`) ✅ COMPLETE

- [x] Create `core/setup` branch
- [x] Create `pubspec.yaml` with dependencies
- [x] Create `lib/main.dart` with window config
- [x] Create `PROJECT_LOG.md` at root
- [x] Copy `REMEMBERING.md` to root
- [x] Create core constants (colors, typography, spacing, radius)
- [x] Create core services (IsarService, FileService, ThemeService)
- [x] Create core utils (FinancialCalculator, Formatters)
- [x] Create core widgets (AppCard, AppButton, AppTextField, etc.)
- [x] Create data models (Bike, Customer, Contract, etc.)
- [x] Run Isar code generation
- [x] Test build

## Phase 2: Authentication & Dashboard

### Login (`feature/auth`) - ✅ COMPLETE

- [x] Create `feature/auth` branch
- [x] Analyze `Dark Theme UI/Login Page.png`
- [x] Build Login UI (login_view.dart, login_card.dart)
- [x] Get UI Approval (Windows build fixed, verified on Windows)
- [x] Add Login Logic:
  - [x] Add shared_preferences + crypto dependencies
  - [x] Create auth_service.dart (authentication + session)
  - [x] Create login_controller.dart (form validation + flow)
  - [x] Add "Keep me logged in" checkbox to login_card.dart
  - [x] Add SplashScreen with session check
  - [x] Create dashboard placeholder with logout
  - [x] Test app builds successfully

### Dashboard (`feature/dashboard`) - ✅ UI COMPLETE

- [x] Analyze `Dark Theme UI/Dashboard Page.png`
- [x] Build Dashboard UI:
  - [x] Create sidebar navigation widget
  - [x] Create KPI section (4 gradient cards)
  - [x] Create performance chart (area chart)
  - [x] Create stock allocation chart (donut chart)
  - [x] Create live transaction feed table
  - [x] Create main dashboard_view.dart
  - [x] Fix light mode visibility (borders, background)
- [ ] Get UI Approval
- [ ] Add Dashboard Logic (connect to real data)

## Phase 3: Inventory Management (`feature/inventory`)

- [x] Create `feature/inventory` branch
- [x] Analyze `Inventory Page.png` and `Add New Bike Page.png`
- [x] Build Inventory UI:
  - [x] Create `bike_card.dart` (image, model, VIN, status badge)
  - [x] Create `bike_filter_bar.dart` (search, brand, cc, status filters)
  - [x] Create `add_bike_dialog.dart` (3-section form)
  - [x] Create `inventory_view.dart` (grid layout + FAB)
- [ ] Get UI Approval
- [x] Add Inventory Logic:
  - [x] Create `inventory_controller.dart`
  - [x] Create `inventory_service.dart`
  - [x] Connect to Isar (Bike collection CRUD)
  - [x] **Refactor Add Bike Dialog (UI/UX Pro Max)**
    - [x] Remove Stock field
    - [x] Implement 2-column "Dark Blue" layout with Cyan headers
    - [x] Change Color input to Dropdown
    - [x] Ensure "Save" updates list immediately

## Phase 3b: Procurement & V2 Migration (NEW - `feature/procurement`)

- [x] Create `feature/procurement` branch
- [x] Update Data Models (Bike V2, Supplier, PurchaseBatch)
- [x] Migrate Isar Schema (Breaking Change)
- [x] Update FileService for Suppliers Directory
- [x] Build Procurement UI:
  - [x] Create `add_stock_view.dart` (Batch Entry - Per Unit Price)
  - [x] Create `supplier_history_view.dart`
  - [x] Create `supplier_card.dart` (Integrated into History View)
- [x] Refactor Inventory View (Update BikeCard, Logic)
- [x] **New Supplier Image Uploads** (Profile & CNIC)
- [x] **Fix "Add Supplier" Icon** in `SupplierHistoryView`
- [x] **Structure Supplier Files** (`Media/Suppliers/{Name}/{Type}/`)
- [x] **Batch Edit/Delete** (Sync with File System & Full Edit Support)
- [x] **Supplier Edit/Delete** (Sync with File System)
  - [x] Update `SupplierService` (Update logic + Folder Rename + Cascading Delete)
  - [x] Update `SupplierController` (Edit Dialog + Delete Confirm)
  - [x] Update `SupplierHistoryView` (Add Edit/Delete icons to list)

## Phase 3c: Stabilization & Verification (`feature/procurement`)

- [x] **Automated Verification**
  - [x] Run `checklist.py` (Lint, Security, Tests)
  - [x] Fix critical issues found (Dialog Crash, Overflow)
- [x] **Code Review (Null Safety)**
  - [x] Scan `InventoryView` and `BikeCard` for risky bangs (`!`)
  - [x] Sanity check `AddBikeDialog` inputs
- [x] **UI Consistency Check**
  - [x] Verify Light Mode in new screens (Fixed White-on-White)
- [x] **UX Enhancements**
  - [x] Implement Global Keyboard Shortcuts (Enter/Esc) via `AppDialog`

## Phase 4: Sales & Installments Module (`feature/sales`)

- [x] **Step 1: Foundation & Models** (Verified)
  - [x] Create `Sale`, `InstallmentContract`, `Payment` models
  - [x] Implement `InstallmentCalculator` logic (Percentage/Fixed Markup)
- [x] **Step 2: Sales Dashboard UI** (Verified)
  - [x] Build `SalesStatsRow` (KPIs)
  - [x] Build `RecentSalesTable`
  - [x] Assemble `SalesView`
- [x] **Step 3: New Sale Wizard** (Verified)
  - [x] Build Stepper UI (Bike -> Customer -> Plan)
- [x] **Step 4: Integration** (Verified)
  - [x] Connect Logic (Calculation & Saving)
  - [x] **Refactor UI (User Feedback)**
    - [x] Separate Dashboard & Sales View
    - [x] Convert New Sale Stepper to Single Page Form
    - [x] Fix Transparency & Overflow Issues
    
## Phase 5: UI/UX Pro Max Enhancements (`feature/ui-polish`)

- [x] Add `flutter_animate` for smooth interactions
- [x] Upgrade Typography to `GoogleFonts.outfit`
  - [x] **Sales View Polish**
    - [x] Glassmorphic Filter Bar
    - [x] Animated Data Table
    - [x] **Split View Layout** (Cash vs Installment Columns)
    - [x] **Masonry Grid Layout** (Variable Height Cards)
    - [x] **Status & Date Filtering Logic** (Dynamic View Switching)
- [x] **New Sale Polish**
  - [x] Staggered Entrance Animation
  - [x] Sticky "Total" Footer
  - [x] Interactive Bike Cards
  - [x] Resized Payment Toggles (Compact UI)
  - [x] Verified "Add Sale" Logic Connection
  - [x] Fixed "Blank Page" Layout Bug (CustomerFormStep)
  - [x] Refined Sales List Badges (Compact & Aligned)
  - [x] **Vehicle Selection**: Display inventory, search implementation (Model, Engine, Chassis) <!-- id: 5 -->
  - [x] **Customer Information**: Default to "New Customer", Add "Father Name" field <!-- id: 6 -->
  - [x] **Witness Information**: 
    - [x] Witness 1 (Mandatory): Name, CNIC, Phone, Address, CNIC Front Image (Required) <!-- id: 7 -->
    - [x] Witness 2 (Optional): Collapsible, same fields, Back Image (Optional) <!-- id: 8 -->
  - [x] **Auto-Scroll**: Scroll to entry section upon bike selection <!-- id: 9 -->
  - [x] **Cancel Confirmation**: Show dialog if entries made <!-- id: 10 -->
  - [x] **Validation & Testing**: Verify schema updates and form submission <!-- id: 11 -->
- [x] **Enhanced Vehicle Selection** (Option B) <!-- id: 12 -->
    - [x] Update `NewSaleController` to fetch/group available bikes <!-- id: 13 -->
    - [x] Refactor `BikeSelector` UI for grouped display <!-- id: 14 -->
    - [x] Verify selection and auto-scroll <!-- id: 15 -->
  - [x] Enabled Sales Filters & Export (Interactive UI)

- [x] **Bug Fixes & Orchestration**
  - [x] **Fix**: Implement Sales Search Bar (Name, Bike, CNIC)
  - [x] **Fix**: Default Filter to 'All Time'
  - [x] **Fix**: Sales Card Interaction for Installments
