# Showroom Pulse — Complete Software Analysis Report

**Version:** 1.0  
**Date:** February 16, 2026  
**Author:** Software Analyst  
**Project Type:** Windows Desktop ERP Application  

---

## Table of Contents

1. [What is This Project?](#1-what-is-this-project)
2. [Technologies Used](#2-technologies-used)
3. [Project Architecture](#3-project-architecture)
4. [Database Design](#4-database-design)
5. [File Storage System](#5-file-storage-system)
6. [Screen-by-Screen Analysis](#6-screen-by-screen-analysis)
7. [Core Services (Backend Logic)](#7-core-services-backend-logic)
8. [Reusable UI Components (Widgets)](#8-reusable-ui-components-widgets)
9. [Utility Classes](#9-utility-classes)
10. [Design System (Colors & Themes)](#10-design-system-colors--themes)
11. [Advantages & Disadvantages](#11-advantages--disadvantages)
12. [Summary & Recommendations](#12-summary--recommendations)

---

## 1. What is This Project?

**Showroom Pulse** is a specialized **ERP (Enterprise Resource Planning)** system built for **motorcycle dealerships** in Pakistan. It runs as a **Windows desktop application** — it does NOT need the internet to work.

### What Problems Does It Solve?

| Problem | Solution |
|---------|----------|
| Tracking each motorcycle by unique Engine/Chassis numbers | Inventory module with unique indexed fields |
| Managing cash and installment sales | Sales module supporting both sale types |
| Tracking monthly installment payments | Installments module with payment timeline |
| Keeping records of customers and witnesses | Customer and Witness data models with CNIC-based folders |
| Managing bike purchases from dealers/suppliers | Procurement module with batch tracking |
| Generating financial statements (PDF) | Statement service with PDF/ZIP export |
| Data backup & portability | All data stored in `Documents/ShowroomPulse/` — just copy the folder |

### Core Philosophy

1. **Offline-First** — The app runs 100% without internet. All data is stored locally.
2. **Portable Data** — The database and media files live in `C:\Users\[User]\Documents\ShowroomPulse\`. To backup, just copy the folder. To restore, paste it back.
3. **Scalability** — Modular code structure allows adding new features (spare parts, service center, etc.) easily.

---

## 2. Technologies Used

### Programming Language & Framework

| Technology | Version | What is it? | Why is it used here? |
|------------|---------|-------------|---------------------|
| **Flutter** | SDK ≥3.2.0 | Google's UI toolkit for building multi-platform apps from one codebase | Used to build the desktop UI — beautiful, fast, and cross-platform capable |
| **Dart** | ≥3.2.0 | The programming language Flutter uses | Strong typing, async/await support, and great tooling |

### State Management

| Technology | Version | What is it? | Why is it used here? |
|------------|---------|-------------|---------------------|
| **GetX** | ^4.7.2 | A lightweight Flutter state management + routing + dependency injection solution | Manages app state (reactive variables like `Rx`, `Obx`), handles page navigation, and injects services/controllers |

**How GetX works in this project:**

- **Controllers** (e.g., `SalesController`) hold the business logic and observable state (using `.obs`)
- **Views** rebuild automatically when state changes (using `Obx(() => ...)`)
- **Bindings** (e.g., `SalesBinding`) inject controllers when a page is opened
- **Named routes** (e.g., `Get.offNamed('/dashboard')`) handle navigation

### Database

| Technology | Version | What is it? | Why is it used here? |
|------------|---------|-------------|---------------------|
| **Isar** | ^3.1.0+1 | A super-fast, offline NoSQL database for Flutter | Stores all data locally — bikes, customers, sales, payments, etc. |
| **isar_generator** | ^3.1.0+1 (dev) | Code generator for Isar models | Auto-generates `.g.dart` files from `@collection` annotated classes |
| **build_runner** | ^2.4.6 (dev) | Dart build system | Runs isar_generator to produce generated code |

**How Isar works here:**

- Each data model (like `Bike`, `Customer`) is a `@collection`
- Unique fields have `@Index(unique: true)` — prevents duplicate engine/chassis numbers
- Related data uses `IsarLink` (one-to-one) and `IsarLinks` (one-to-many)
- All database operations are wrapped in `writeTxn()` for safety

### UI & Design Libraries

| Technology | Version | What is it? | Why is it used here? |
|------------|---------|-------------|---------------------|
| **Lucide Icons** | ^0.257.0 | Modern, clean icon set | All navigation and UI icons throughout the app |
| **Google Fonts** | ^6.1.0 | Access to 1000+ Google Fonts | Typography customization for the app interface |
| **flutter_animate** | ^4.5.2 | Animation library | Smooth fade-in and slide animations on the New Sale form |
| **flutter_staggered_grid_view** | ^0.7.0 | Advanced grid layouts | Used for responsive card grids (inventory, sales) |
| **fl_chart** | ^0.66.0 | Charts library | Dashboard performance charts and stock allocation pie charts |

### File & Media Handling

| Technology | Version | What is it? | Why is it used here? |
|------------|---------|-------------|---------------------|
| **file_picker** | ^8.0.0 | File selection dialog | Lets users pick images for bikes, customers, witnesses |
| **path_provider** | ^2.1.1 | Access system directories | Gets the `Documents` folder path for storing data |
| **path** | ^1.8.3 | Path manipulation utilities | Joining and manipulating file paths safely |
| **image** | ^4.1.3 | Image processing library | Can resize/process images before saving |

### Authentication & Security

| Technology | Version | What is it? | Why is it used here? |
|------------|---------|-------------|---------------------|
| **shared_preferences** | ^2.2.2 | Key-value storage | Stores the "Keep me logged in" session data |
| **crypto** | ^3.0.3 | Cryptographic operations | Hashes passwords using SHA-256 (so raw passwords are never stored) |

### PDF & Export

| Technology | Version | What is it? | Why is it used here? |
|------------|---------|-------------|---------------------|
| **pdf** | ^3.11.1 | PDF generation from Dart | Creates installment statement PDFs |
| **printing** | ^5.13.3 | Print/save PDFs | Saves generated PDFs to the Downloads folder |
| **archive** | ^3.4.10 | ZIP file creation | Bundles multiple statement PDFs into a single ZIP file |

### Desktop-Specific

| Technology | Version | What is it? | Why is it used here? |
|------------|---------|-------------|---------------------|
| **window_manager** | ^0.3.7 | Windows window control | Sets window size (1280×720), minimum size (800×600), title bar, and centering |

### Internationalization

| Technology | Version | What is it? | Why is it used here? |
|------------|---------|-------------|---------------------|
| **intl** | ^0.18.1 | Internationalization & formatting | Formats dates (e.g., `DD/MM/YYYY`) and currency numbers |

---

## 3. Project Architecture

### Architecture Pattern: **Feature-Based (Vertical Slices) + GetX MVVM**

The project follows a **clean, modular structure** where each feature is self-contained:

```
lib/
├── main.dart                          ← App entry point
└── app/
    ├── core/                          ← Shared code used across ALL features
    │   ├── bindings/                  ← Global dependency injection
    │   ├── constants/                 ← Colors, spacing, typography, shadows, radius
    │   ├── services/                  ← Database, file system, PDF, theme services
    │   ├── theme/                     ← Light & dark theme definitions
    │   ├── utils/                     ← Financial calculator, formatters
    │   └── widgets/                   ← Reusable UI components
    │
    ├── data/
    │   └── models/                    ← All 10 Isar database models
    │
    └── features/                      ← Each feature is an independent module
        ├── auth/                      ← Login & session management
        ├── dashboard/                 ← Main dashboard with KPIs & charts
        ├── procurement/               ← Supplier & stock purchase management
        ├── inventory/                 ← Bike inventory (CRUD operations)
        ├── sales/                     ← Cash & installment sale creation
        ├── installments/              ← Installment tracking & payment recording
        └── customers/                 ← Customer records & history
```

### Each Feature Module Contains

```
feature_name/
├── data/
│   └── repositories/                  ← Database queries for this feature
├── domain/
│   └── service.dart                   ← Business logic for this feature
└── presentation/
    ├── bindings/                      ← GetX dependency injection
    ├── controllers/                   ← State management & logic (ViewModel)
    ├── views/                         ← UI screens (View)
    └── widgets/                       ← Feature-specific UI components
```

### Advantages of This Architecture

| Advantage | Explanation |
|-----------|-------------|
| **Modular** | Each feature is independent — you can add/remove features without affecting others |
| **Testable** | Controllers can be tested independently from the UI |
| **Scalable** | Adding new features is just creating a new folder under `features/` |
| **Clean separation** | UI (views) is separated from logic (controllers) and data (models/services) |

### Disadvantages

| Disadvantage | Explanation |
|--------------|-------------|
| **Many files for small features** | Even a simple feature has bindings, controllers, views, and widgets folders |
| **GetX coupling** | The project is tightly coupled to GetX — hard to switch to another state management |
| **No formal domain/use-case layer** | Business logic is split between controllers and services (not strictly Clean Architecture) |

---

## 4. Database Design

The project uses **Isar NoSQL database** with **10 collections** (tables):

### Data Model Overview

```
┌──────────────┐     ┌──────────────────┐     ┌──────────────┐
│   Supplier   │────→│  PurchaseBatch   │────→│     Bike     │
│  (dealers)   │     │ (bulk purchases) │     │ (motorcycle) │
└──────────────┘     └──────────────────┘     └──────┬───────┘
                                                     │
                     ┌──────────────────┐            │
                     │      Sale        │←───────────┘
                     │ (cash or inst.)  │←───────────┐
                     └──────────────────┘            │
                                                     │
┌──────────────┐     ┌──────────────────┐     ┌──────┴───────┐
│   Witness    │────→│InstallmentContract│←───│   Customer   │
│ (guarantor)  │     │ (EMI agreement)  │    │  (buyer)     │
└──────────────┘     └───────┬──────────┘     └──────────────┘
                             │
                     ┌───────┴──────────┐
                     │    Payment       │
                     │ (EMI records)    │
                     └──────────────────┘

┌──────────────┐     ┌──────────────────┐
│     User     │     │   AppSettings    │
│ (login auth) │     │  (system config) │
└──────────────┘     └──────────────────┘
```

### Detailed Model Analysis

#### 1. `Bike` — The core asset

| Field | Type | Purpose |
|-------|------|---------|
| `id` | Auto ID | Database primary key |
| `engineNumber` | String (unique) | Unique identifier, used for image naming |
| `chassisNumber` | String (unique) | Second unique identifier |
| `model` | String | e.g., "Honda CD 70" |
| `brand` | String | e.g., "Honda" |
| `color` | String | e.g., "Red" |
| `modelYear` | int | Manufacturing year |
| `purchasePrice` | double | Cost price from supplier |
| `cashSalePrice` | double | Selling price |
| `status` | Enum | `available`, `sold`, `installment` |
| `imageFilename` | String? | e.g., "ENG-998877.jpg" (stored in Media/Bikes/) |
| `batch` | IsarLink | Links to the PurchaseBatch this bike came from |

#### 2. `Customer` — The buyer

| Field | Type | Purpose |
|-------|------|---------|
| `fullName` | String | Customer's name |
| `fatherName` | String? | Father's name |
| `cnicNumber` | String (unique) | National ID (also used as media folder name) |
| `phoneNumber` | String | Primary contact |
| `alternativePhone` | String? | Secondary contact |
| `address` | String? | Full address |
| `profileImageFilename` | String? | Profile photo filename |
| `cnicFrontFilename` | String? | CNIC front image filename |
| `cnicBackFilename` | String? | CNIC back image filename |

#### 3. `Sale` — Records each sale transaction

| Field | Type | Purpose |
|-------|------|---------|
| `saleType` | Enum | `cash` or `installment` |
| `bikeId` | int | Which bike was sold |
| `customerId` | int | Who bought it |
| `totalAmount` | double | Cash: sale price / Installment: total with markup |
| `receivedAmount` | double | Cash: full amount / Installment: down payment |
| `installmentContractId` | int? | Links to contract (for installment sales) |

#### 4. `InstallmentContract` — The EMI agreement

| Field | Type | Purpose |
|-------|------|---------|
| `cashPrice` | double | Base bike price |
| `markupType` | Enum | `percentage` or `fixed` amount |
| `markupValue` | double | e.g., 40.0 (means 40%) |
| `totalMarkupAmount` | double | Calculated markup in Rupees |
| `totalAmount` | double | Grand total after markup |
| `downPayment` | double | Upfront payment |
| `months` | int | Duration (e.g., 12 months) |
| `monthlyEMI` | double | Monthly installment amount |
| `status` | Enum | `active`, `partiallyPaid`, `overdue`, `completed`, `defaulted` |
| `totalPaid` | double | Running total of all payments |
| `paymentsMade` | int | Count of payments received |
| `nextDueDate` | DateTime? | Next EMI due date |
| `lateFeeEnabled` | bool | Whether late fees apply |

**Computed Properties:**

- `remainingBalance` = totalAmount − totalPaid
- `paymentProgress` = totalPaid ÷ totalAmount (0.0 to 1.0)
- `paymentsRemaining` = months − paymentsMade
- `isOverdue` = nextDueDate is in the past

#### 5. `Payment` — Individual EMI payment record

| Field | Type | Purpose |
|-------|------|---------|
| `contractId` | int | Which contract this payment belongs to |
| `amount` | double | Amount paid |
| `paymentDate` | DateTime | When the payment was made |
| `method` | Enum | `cash`, `bankTransfer`, `jazzCash`, `easyPaisa`, `cheque` |
| `collectorName` | String? | Who collected the payment |
| `isDownPayment` | bool | Whether this is the initial down payment |
| `isLateFee` | bool | Whether this is a late fee payment |
| `receiptNumber` | String? | Receipt reference |

#### 6. `Witness` — Guarantor for installment sales

| Field | Type | Purpose |
|-------|------|---------|
| `fullName` | String | Witness name |
| `cnicNumber` | String | CNIC number |
| `phoneNumber` | String | Contact number |
| `relationship` | String? | e.g., "Brother", "Uncle" |
| `address` | String? | Full address |
| `cnicFrontFilename` | String? | CNIC front image filename |
| `cnicBackFilename` | String? | CNIC back image filename |
| `contractId` | int | Which contract this witness belongs to |
| `isPrimary` | bool | Primary or secondary witness |

#### 7. `Supplier` — Dealer who sells bikes to the showroom

| Field | Type | Purpose |
|-------|------|---------|
| `name` | String | Dealer name |
| `cnic` | String (unique) | CNIC of the dealer |
| `phone` | String | Contact number |
| `batches` | IsarLinks (backlink) | All purchase batches from this supplier |

#### 8. `PurchaseBatch` — A group of bikes bought together

| Field | Type | Purpose |
|-------|------|---------|
| `purchaseDate` | DateTime | Date of the purchase |
| `totalAmount` | double | Total cost of all bikes in this batch |
| `totalUnits` | int | Number of bikes in the batch |
| `billImageFilename` | String? | Invoice image filename |
| `supplier` | IsarLink | Which dealer sold these bikes |
| `bikes` | IsarLinks (backlink) | All bikes in this batch |

#### 9. `User` — Local authentication

| Field | Type | Purpose |
|-------|------|---------|
| `username` | String (unique) | Login username |
| `passwordHash` | String | SHA-256 hashed password |
| `displayName` | String | Display name (shown on dashboard) |
| `isActive` | bool | Whether the user account is active |

#### 10. `AppSettings` — System-wide configuration (singleton)

| Field | Type | Purpose |
|-------|------|---------|
| `defaultMarkupPercentage` | double | Default: 40% |
| `automaticLateFeeEnabled` | bool | Auto late fee |
| `lateFeePercentage` | double | Default: 5% |
| `isDarkTheme` | bool | Current theme mode |
| `cloudSyncEnabled` | bool | Cloud sync (future feature) |

---

## 5. File Storage System

Instead of hiding data in `AppData` folders, the project uses a **user-accessible** directory:

```
C:\Users\[User]\Documents\ShowroomPulse\
│
├── Database/                    ← Isar database files
│   └── default.isar
│
└── Media/                       ← All images organized by type
    ├── Bikes/                   ← Bike images (named by engine number)
    │   ├── ENG-998877.jpg
    │   └── ENG-112233.jpg
    │
    ├── Suppliers/               ← Dealer data
    │   └── Ahmed_Autos/
    │       ├── Profile/
    │       ├── CNIC/
    │       └── 2026-01-15/      ← Invoice images by date
    │           └── inv_batch_501.jpg
    │
    └── Customers/               ← Customer data (named by CNIC)
        └── 42101-1234567-1/
            ├── profile.jpg
            ├── cnic_front.jpg
            ├── cnic_back.jpg
            └── Witness/
                ├── witness1_cnic_front.jpg
                └── witness1_cnic_back.jpg
```

### Backup/Restore Process

| Action | Steps |
|--------|-------|
| **Backup** | Copy `ShowroomPulse` folder to USB drive |
| **Restore** | Paste folder back into `Documents`. App detects it automatically on restart |
| **Migration** | Copy folder to new computer — everything works |

### Advantage

- **Zero-config backup** — no export tools needed
- **Transparent data** — user can see all their files
- **No internet needed** — everything is local

### Disadvantage

- **Manual backup** — user must remember to back up
- **No encryption** — files are stored as plain JPEG images
- **Single machine** — can't be used by multiple users on different computers simultaneously

---

## 6. Screen-by-Screen Analysis

### 6.1 Splash Screen

**File:** `lib/main.dart` (SplashScreen class)

**What it does:**

1. Initializes all async services (database, file system, authentication)
2. Checks if user has a saved session ("Keep me logged in")
3. If session exists → goes to Dashboard
4. If no session → goes to Login

**Usage:** First screen when app starts. Shows a loading spinner with the app logo.

| Advantage | Disadvantage |
|-----------|--------------|
| Clean initialization flow | No error recovery UI if initialization fails |
| Auto-login via saved session | App crashes silently on database corruption |

---

### 6.2 Login Screen

**Files:** `lib/app/features/auth/presentation/views/login_view.dart`, `login_card.dart`, `login_controller.dart`

**What it does:**

- Centered login card with motorcycle icon
- Username and Password input fields
- "Keep me logged in" checkbox (uses SharedPreferences)
- SHA-256 password hashing

**Default credentials:** `admin` / `admin123`

**Authentication Flow:**

1. User enters username/password
2. Password is hashed with SHA-256
3. Compared against stored hash in Isar database
4. If "keep logged in" is checked → session ID saved to SharedPreferences
5. On success → navigate to Dashboard

| Advantage | Disadvantage |
|-----------|--------------|
| Password is never stored in plain text | SHA-256 alone is weak for password hashing (bcrypt/scrypt is better) |
| Session persistence via SharedPreferences | No password reset mechanism |
| Clean UI with both dark and light theme support | No multi-user role system (admin, viewer, etc.) |
| Default admin user auto-created on first run | Default password is insecure and not forced to change |

---

### 6.3 Dashboard Screen

**Files:** `lib/app/features/dashboard/presentation/views/dashboard_view.dart`, `dashboard_controller.dart`

**Layout:** Sidebar (left, 64px) + Main content area

**Sections:**

1. **Header** — Welcome message with user name, date, refresh button
2. **KPI Cards (4 gradient cards):**
   - Total Asset Value (sum of all bikes' prices)
   - Units in Stock (available + on installment)
   - Active Contracts (ongoing installment deals)
   - Monthly Revenue (total payments this month)
3. **Performance Velocity Chart** — Weekly sales line chart (last 7 days)
4. **Stock Allocation Chart** — Pie chart showing new vs pre-owned distribution
5. **Transaction Feed** — Live table of recent sales

**Data Loading:** All 4 sections load in parallel using `Future.wait()` for speed.

| Advantage | Disadvantage |
|-----------|--------------|
| Real-time data from database | Some values are hardcoded (e.g., asset growth = 5.2%) |
| Parallel data loading is fast | No caching — reloads from DB every time |
| Clean KPI visualization | Chart data limited to 7-day window |
| Cyber-themed dark mode looks professional | No customizable dashboard widgets |

---

### 6.4 Procurement Screen (Dealers & Stock Purchase)

**Files:** `lib/app/features/procurement/presentation/views/procurement_view.dart`, `supplier_history_view.dart`, `add_stock_view.dart`, `supplier_controller.dart`

**What it does:** Manages the **purchase of bikes from dealers/suppliers**.

**Sub-screens:**

#### a) Supplier History View

- **Layout:** Split view (left: list of suppliers, right: batch details)
- Lists all suppliers with their total batches and units
- Clicking a supplier shows their purchase batch history
- Each batch shows date, number of bikes, total cost, and bill image

#### b) Add Stock View

- **Layout:** Multi-section form
- Choose existing supplier or create new
- Enter batch details: date, invoice image
- Add bikes to the batch: Engine#, Chassis#, Model, Brand, Year, Color, Purchase Price, Sale Price
- Real-time total batch cost calculation
- Footer shows total amount and "Save Batch" button

**How stock purchase works:**

1. Select/create supplier → folder created in `Media/Suppliers/[Name]/`
2. Enter batch date and upload invoice image
3. Add 1 or more bikes with all details
4. On "Save": Supplier saved → PurchaseBatch saved → All Bikes saved with `status = available`

| Advantage | Disadvantage |
|-----------|--------------|
| Batch purchase tracking (real-world workflow) | No supplier-level reporting/analytics |
| Bill image storage for records | Cannot edit a batch after saving |
| Dynamic bike grid with real-time cost calculation | No duplicate bike warning before save (only on save) |
| Supplier CNIC uniqueness enforced | No supplier payment tracking |

---

### 6.5 Inventory Screen

**Files:** `lib/app/features/inventory/presentation/views/inventory_view.dart`, `inventory_controller.dart`, `bike_card.dart`, `add_bike_dialog.dart`, `edit_bike_dialog.dart`, `bike_filter_bar.dart`

**Layout:** Sidebar + Filter bar + Responsive grid of bike cards (4 columns)

**Features:**

- **Search:** by engine number, chassis number, model, brand, color
- **Filter:** by status (available, sold, installment), by brand
- **Add Bike:** dialog with all fields + image picker
- **Edit Bike:** modify details like price, color, model
- **Delete Bike:** with confirmation dialog
- **Bike Card:** shows image, model, brand, price, engine number (last 4 masked), status badge

**Sorting:** Available bikes first, then by status priority

| Advantage | Disadvantage |
|-----------|--------------|
| Multi-field search | No pagination (loads all bikes at once — slow for 1000+ bikes) |
| Status-based filtering | No export to Excel/CSV |
| Direct add/edit/delete operations | No image preview before upload |
| Engine/Chassis uniqueness validation | No bulk operations (delete multiple, change status) |
| Color/skin selector for special bike finishes | No sorting by date, price, or model |

---

### 6.6 Sales Screen

**Files:** `lib/app/features/sales/presentation/views/sales_view.dart`, `new_sale_view.dart`, `sales_controller.dart`, `new_sale_controller.dart`, + 10 widget files

**Layout:** Sidebar + Header + Filter bar + Sales card grid

**Features:**

- **Sales List:** Grid of sale cards showing bike model, customer name, sale date, amount, type (cash/installment)
- **Filter:** by date range (This Month, Last Month, This Year, All Time), by status (Cash, Installment)
- **Search:** across customer name, CNIC, bike model, engine number, chassis number, brand, color, contact number, price
- **New Sale Button:** navigates to the 4-step sale creation form

#### New Sale Form (4 Steps)

**Step 1 — Vehicle Selection:**

- Grid of available bikes with search
- Shows bike image, model, brand, price, engine/chassis
- Click to select a bike

**Step 2 — Customer Information:**

- Full name, father's name, CNIC (auto-formatted with dashes), phone (auto-formatted), alternative phone, address
- Profile image, CNIC front/back image upload
- Auto-search existing customers (can re-use existing customer data)

**Step 3 — Witness Information:**

- Witness 1 (required): name, CNIC, phone, relationship, address, CNIC front/back images
- Witness 2 (optional): same fields

**Step 4 — Payment Terms & Contract:**

- **Cash Sale:** just enter the sale amount
- **Installment Sale:**
  - Select markup type (percentage or fixed)
  - Enter markup value → auto-calculates total
  - Enter down payment
  - Select duration (months) → auto-calculates monthly EMI
  - Set first due date
- **Price Summary Card:** shows base price, markup, total, down payment, monthly EMI
- **Complete Sale button** (FAB) → validates all data → saves to database

**How finalizeSale works (the big 570-line function):**

1. Validates all fields (bike selected, customer data, witness data, payment data)
2. Creates customer folder in Media/
3. Saves customer images
4. Saves witness images
5. Creates Customer record in DB
6. Creates Witness record(s) in DB
7. If installment: creates InstallmentContract
8. Creates Sale record
9. Updates Bike status to `sold` or `installment`
10. Shows success dialog
11. Refreshes sales list and dashboard

| Advantage | Disadvantage |
|-----------|--------------|
| Full end-to-end sale workflow | `finalizeSale` is 570 lines — hard to maintain |
| Both cash and installment sale support | No draft/partial save — must complete all at once |
| Auto-CNIC/phone formatting | No barcode/QR scanning for bike selection |
| Existing customer auto-fill | No sale editing after creation |
| Markup calculator (% or fixed) | No receipt/invoice generation at sale time |
| Unsaved data warning on cancel | Very long single-page form (could overflow on small screens) |
| Smooth animations via flutter_animate | No offline sync / cloud backup |

---

### 6.7 Installments Screen

**Files:** `lib/app/features/installments/presentation/views/installments_view.dart`, `installments_controller.dart`, `customer_card.dart`, `payment_summary_cards.dart`, `payment_timeline.dart`, `progress_ring.dart`, `record_payment_dialog.dart`

**Layout:** Sidebar + Top bar (filters) + Split view (left: customer list, right: detail panel)

**Features:**

- **Customer List:** Shows all installment customers with progress bar, amount, status badge
- **Search:** by customer name, CNIC, bike model
- **Filters:** by status (Active, Partially Paid, Overdue, Completed, Defaulted), "Due This Week" toggle
- **Detail Panel:** (when a customer is selected):
  - Customer header with name, CNIC, phone
  - Progress ring showing payment completion
  - Payment summary cards (total, paid, remaining, monthly EMI)
  - Payment timeline (history of all payments)
  - "Record Payment" button
- **Record Payment Dialog:** Amount, payment method (Cash, Bank Transfer, JazzCash, EasyPaisa, Cheque), collector name, notes
- **Statement Download:** Generate individual PDF statement or download all statements as ZIP

**Overdue Detection:** Automatically flags contracts where `nextDueDate` is in the past.

**Legacy Data Repair:** Auto-fixes older contracts with missing `nextDueDate` or zero down payments.

| Advantage | Disadvantage |
|-----------|--------------|
| Real-time progress tracking | No automated SMS/WhatsApp reminder for due payments |
| Multiple payment methods supported | No partial payment handling (pay less than EMI) |
| PDF statement generation (individual + bulk ZIP) | No payment receipt printing |
| Auto-overdue detection | No late fee auto-calculation (placeholder) |
| Split-view layout shows all info at once | No payment schedule view (calendar of upcoming EMIs) |
| Legacy data repair on load | No contract modification after creation |

---

### 6.8 Customers Screen

**Files:** `lib/app/features/customers/presentation/views/customers_view.dart`, `customers_controller.dart`, `customer_list_sidebar.dart`, `customer_history_panel.dart`, `add_customer_dialog.dart`, `transaction_details_dialog.dart`, `vehicle_card.dart`

**Layout:** Sidebar + Customer list sidebar (inner) + Customer history panel

**Features:**

- **Customer List:** All registered customers with search
- **Stats:** Total customers, growth %, active installments count & value, pending payments
- **Add Customer:** Dialog with full details + image uploads
- **Customer History:** When a customer is selected, shows:
  - Profile info (name, CNIC, phone, address)
  - All transactions (sales) for this customer
  - Vehicle cards for each transaction
  - Transaction details dialog

| Advantage | Disadvantage |
|-----------|--------------|
| Complete customer profile view | No customer editing after creation |
| Transaction history per customer | No customer deletion |
| Stats and growth tracking | No customer communication log |
| Image management (CNIC, profile) | No duplicate detection by phone number |
| Sorting by date and price | Limited stats (no revenue per customer) |

---

## 7. Core Services (Backend Logic)

### 7.1 IsarService (`core/services/isar_service.dart`)

**What it does:** Opens the Isar database with all 10 schema collections and provides access to the database instance throughout the app.

- **init()** — Opens the database in `Documents/ShowroomPulse/Database/`
- **close()** — Closes the database connection
- **clearAllData()** — Deletes all data (for testing/reset)

---

### 7.2 FileService (`core/services/file_service.dart`)

**What it does:** Manages the entire Windows file system — creating folders, saving images, picking files.

**Key Methods (27 total):**

| Method | Purpose |
|--------|---------|
| `init()` | Creates the `ShowroomPulse/Database/Media/Bikes/Customers/Suppliers` folder structure |
| `saveBikeImage()` | Copies bike image to `Media/Bikes/[engineNumber].jpg` |
| `saveCustomerImage()` | Saves profile/CNIC images to `Media/Customers/[CNIC]/` |
| `saveWitnessImage()` | Saves witness images to `Media/Customers/[CNIC]/Witness/` |
| `saveSupplierProfile()` | Saves dealer profile to `Media/Suppliers/[Name]/Profile/` |
| `saveInvoiceImage()` | Saves batch invoice to `Media/Suppliers/[Name]/[Date]/` |
| `pickImage()` | Opens Windows file picker for image selection |
| `getBikeImagePath()` | Returns full path for a bike image filename |
| `getCustomerProfileImagePath()` | Returns full path for a customer image |
| `deleteFile()` / `fileExists()` | File utility methods |

---

### 7.3 AuthService (`features/auth/data/auth_service.dart`)

**What it does:** Handles local user authentication with session persistence.

| Method | Purpose |
|--------|---------|
| `init()` | Loads SharedPreferences |
| `login()` | Validates credentials against Isar database |
| `logout()` | Clears session data |
| `checkSavedSession()` | Auto-login from saved session |
| `createUser()` | Registers a new user |
| `ensureDefaultUser()` | Creates `admin/admin123` if no users exist |
| `hashPassword()` | SHA-256 hashing |

---

### 7.4 StatementService (`core/services/statement_service.dart`)

**What it does:** Generates installment statement PDFs.

| Method | Purpose |
|--------|---------|
| `generateSingleStatement()` | Creates a PDF for one customer's contract |
| `generateGlobalStatement()` | Combined PDF with all contracts |
| `generateGlobalZip()` | Individual PDFs bundled into a ZIP file |

**PDF Sections:**

- Header with "Showroom Pulse" branding
- Customer section (name, CNIC, phone)
- Bike section (model, engine#, chassis#)
- Contract summary (prices, markup, EMI, status)
- Witness section
- Payment history table
- Footer with page numbers

---

### 7.5 SalesService (`features/sales/domain/sales_service.dart`)

**What it does:** Business logic for sales — creates sales, calculates stats for dashboard.

---

### 7.6 ThemeService (`core/services/theme_service.dart`)

**What it does:** Manages light/dark theme switching.

---

## 8. Reusable UI Components (Widgets)

Located in `lib/app/core/widgets/`:

| Widget | File | Purpose |
|--------|------|---------|
| **SidebarNavigation** | `sidebar_navigation.dart` | 64px collapsed sidebar with icon-only navigation. 9 items: Dashboard, Dealers, Inventory, Sales, Installments, Customers, Reports, Settings, Logout |
| **AppTextField** | `app_text_field.dart` | Styled text input with dark/light theme support |
| **AppCard** | `app_card.dart` | Themed card container with border and shadow |
| **AppButton** | `app_button.dart` | Styled button with loading state |
| **AppDialog** | `app_dialog.dart` | Themed dialog wrapper |
| **AppProgressBar** | `app_progress_bar.dart` | Linear progress indicator |
| **StatusBadge** | `status_badge.dart` | Colored pill showing status (Available, Sold, Installment) |
| **ColorSkinSelector** | `color_skin_selector.dart` | Custom widget for selecting bike colors including special skins (e.g., Snake Skin) |

---

## 9. Utility Classes

| Class | File | Purpose |
|-------|------|---------|
| **FinancialCalculator** | `financial_calculator.dart` | Static methods for: total with markup, markup amount, monthly EMI, remaining balance, payment progress, late fee |
| **CnicInputFormatter** | `cnic_input_formatter.dart` | Auto-formats CNIC as `XXXXX-XXXXXXX-X` (dashes after 5th and 12th digit) |
| **PhoneNumberInputFormatter** | `phone_number_input_formatter.dart` | Auto-formats phone as `XXXX-XXXXXXX` |
| **ThousandsSeparatorInputFormatter** | `thousands_separator_input_formatter.dart` | Adds comma separators (e.g., `1,200,000`) |
| **Formatters** | `formatters.dart` | General formatting utilities |
| **InstallmentCalculator** | `installment_calculator.dart` | Installment-specific calculations |

### Financial Formulas Used

```
Markup Amount      = Cash Price × (Markup% ÷ 100)
Total Amount       = Cash Price + Markup Amount
Financed Amount    = Total Amount − Down Payment
Monthly EMI        = Financed Amount ÷ Number of Months
Remaining Balance  = Total Amount − Total Paid
Payment Progress   = Total Paid ÷ Total Amount (clamped 0.0 to 1.0)
Late Fee           = Overdue Amount × (Late Fee% ÷ 100)
```

---

## 10. Design System (Colors & Themes)

The app has **two complete themes** — Dark (default) and Light.

### Dark Theme (Default) — "Executive Command Center"

| Element | Color | Hex |
|---------|-------|-----|
| Primary | Cyan | `#06B6D4` |
| Background | Deep Navy | `#0A0E17` |
| Surface | Dark Blue | `#0F172A` |
| Cards | Slate Blue | `#1E293B` |
| Text Primary | White | `#FFFFFF` |
| Text Secondary | Slate 300 | `#CBD5E1` |
| Success | Emerald | `#10B981` |
| Warning | Amber | `#F59E0B` |
| Error | Red | `#EF4444` |

### Light Theme — "Windows 11 Fluent"

| Element | Color | Hex |
|---------|-------|-----|
| Primary | Blue | `#0078D4` |
| Background | Off-White | `#F3F4F6` |
| Surface | White | `#FFFFFF` |
| Text Primary | Dark Grey | `#111827` |
| Success | Green | `#16A34A` |
| Warning | Orange | `#F97316` |
| Error | Red | `#DC2626` |

### Design Tokens (Constants)

| File | Purpose |
|------|---------|
| `app_colors.dart` | All color values organized by theme |
| `app_spacing.dart` | Consistent spacing values (e.g., `sm=8`, `md=16`, `lg=24`, `xl=32`) |
| `app_radius.dart` | Border radius values |
| `app_shadows.dart` | Elevation shadow definitions |
| `app_typography.dart` | Font sizes and weights |

---

## 11. Advantages & Disadvantages

### Overall Advantages

| # | Advantage | Explanation |
|---|-----------|-------------|
| 1 | **Fully Offline** | Zero internet dependency — perfect for rural Pakistani dealerships |
| 2 | **Simple Backup** | Copy a single folder to USB for complete backup |
| 3 | **Fast & Native** | Flutter desktop runs at native speed with smooth animations |
| 4 | **Complete Workflow** | Covers full dealership lifecycle: purchase → stock → sell → collect payments |
| 5 | **Dual Theme** | Professional dark and light mode |
| 6 | **PDF Exports** | Generates professional installment statements |
| 7 | **Auto-Formatting** | CNIC and phone auto-formatting reduces data entry errors |
| 8 | **Document Storage** | Stores CNIC images for customer and witness verification |
| 9 | **Flexible Markup** | Supports both percentage and fixed markup for installments |
| 10 | **Multiple Payment Methods** | Cash, bank transfer, JazzCash, EasyPaisa, cheque |

### Overall Disadvantages

| # | Disadvantage | Impact | Possible Solution |
|---|--------------|--------|-------------------|
| 1 | **Single Machine** | Only works on one PC at a time | Cloud sync or LAN database |
| 2 | **No Encryption** | Images and DB are readable without security | Encrypt sensitive files |
| 3 | **Weak Password Security** | SHA-256 without salt is vulnerable | Use bcrypt or Argon2 |
| 4 | **No Data Export** | Can't export to Excel/CSV | Add export functionality |
| 5 | **No Print/Receipt** | No invoice or receipt printing | Add printing module |
| 6 | **No Auto-Backup** | User must manually copy folder | Add scheduled auto-backup |
| 7 | **No Reporting Module** | Reports page is placeholder | Build analytics/reports |
| 8 | **No Settings Page** | Settings is placeholder | Build settings UI |
| 9 | **No Sale Editing** | Can't modify a sale after creation | Add edit capability |
| 10 | **Large Controller Files** | `NewSaleController` is 862 lines | Refactor into smaller services |
| 11 | **GetX Coupling** | Hard to switch to Bloc/Riverpod | Architecture decision (tradeoff for simplicity) |
| 12 | **No Multi-User** | No role-based access (admin, employee) | Add user roles |

---

## 12. Summary & Recommendations

### Project Summary

**Showroom Pulse** is a well-structured, offline-first ERP system for motorcycle dealerships. It covers the complete business workflow from purchasing bikes from suppliers, managing inventory, selling via cash or installment, tracking payments, and generating statements. The codebase follows a clean feature-based architecture with proper separation of concerns using GetX.

### Technology Stack Summary

| Layer | Technology |
|-------|-----------|
| Frontend | Flutter (Dart) |
| State Management | GetX (reactive) |
| Database | Isar (NoSQL, local) |
| File Storage | Windows file system (Documents folder) |
| PDF Generation | `pdf` + `archive` packages |
| Authentication | Local with SHA-256 hashing |
| Desktop Control | `window_manager` |

### Key Metrics

| Metric | Count |
|--------|-------|
| Total Dart files | ~106 |
| Feature modules | 7 |
| Data models | 10 |
| Core services | 6 |
| Reusable widgets | 8 |
| Utility classes | 6 |
| Named routes | 7 |
| Lines of code (estimated) | ~8,000+ |

### Top Recommendations

1. **Refactor `NewSaleController`** (862 lines) into smaller, single-responsibility services
2. **Add reporting module** — profit/loss, monthly sales summary, customer analytics
3. **Add auto-backup** — scheduled copy to a second location
4. **Add receipt/invoice printing** at sale time
5. **Strengthen password security** — use bcrypt with salt
6. **Add data export** — Excel/CSV for accounting integration
7. **Build settings page** — for configuring markup defaults, late fee policies, theme
8. **Add sale editing** — allow modifying sale details after creation

---

*Report generated on February 16, 2026*  
*Authored by: Software Analyst Agent*
