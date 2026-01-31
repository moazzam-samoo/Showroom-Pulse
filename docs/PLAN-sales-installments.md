# 🏍️ Phase 4: Sales & Installments Module (`feature/sales`)

> **Goal:** Implement the core revenue generation flow, supporting both Cash and Installment sales with a verified 40% markup engine.

---

## 📅 Execution Strategy

We will build this phase in **3 Steps**, following the "UI First" Vertical Slice approach.

### 1️⃣ Step 1: Foundation & Models (Backend Specialist)
**Objective:** Define the data structure for complex sales.
- **New Models:**
  - `Sale` (Parent record)
  - `InstallmentContract` (Linked to Sale, holds markup/plan details)
  - `Witness` (Guarantors for installments)
  - `Payment` (Individual transactions)
- **Logic:**
  - `InstallmentCalculator` class (Pure Dart logic, unit tested).
  - Formula: `Total = CashPrice + (CashPrice * 0.40)`.

### 2️⃣ Step 2: Sales Dashboard UI (Frontend Specialist)
**Objective:** A landing page to view history and start new sales.
- **View:** `SalesView`
- **Components:**
  - `SalesStatsRow` (Today's Sales, Pending Recoveries)
  - `RecentSalesTable` (List of transactions)
  - `NewSaleButton` (Navigates to Wizard)

### 3️⃣ Step 3: "New Sale" Wizard UI (Frontend Specialist)
**Objective:** A 3-step dedicated page for processing a sale.
- **View:** `NewSaleView` (Stepper Layout)
  - **Step 1: Bike Selection** (Searchable Grid of `status==available`)
  - **Step 2: Customer** (CNIC search or "New Customer" form)
  - **Step 3: Payment Plan**
    - **Toggle:** Cash / Installment
    - **Cash:** Simple "Received Amount" field.
    - **Installment:**
      - Down Payment Input
      - Months Input (1-12)
      - *Auto-calculated:* Monthly Installment, Total Markup, Grand Total.
      - **Witness Form:** 2 required witnesses.

### 4️⃣ Step 4: Logic Integration (Orchestrator)
**Objective:** Connect UI to Controller to Database.
- **Controller:** `SalesController`
- **Actions:**
  - `processCashSale()`: Mark bike sold, create Sale record.
  - `processInstallmentSale()`: Mark bike installment, create Sale + Contract + Customer folder.

---

## 🛠️ Verification Plan
- [ ] **Unit Test:** `InstallmentCalculator` correctly adds 40% markup.
- [ ] **Flow Test:** "Available" bike disappears from Inventory after sale.
- [ ] **Data Test:** Sale record links correctly to Customer and Bike.

---

## 🚀 Recommended Start
Run: `/create` to scaffold the `feature/sales` branch and basic files.
