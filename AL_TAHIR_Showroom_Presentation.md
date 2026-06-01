# AL-TAHIR Showroom - Professional Project Documentation & User Flow

## 1. Project Overview & Architecture
*This section highlights the professional software engineering principles applied throughout the application.*

### Entity-Relationship Architecture (Data Flow)
The application is built on a highly relational data architecture. 
- A **Purchase** automatically updates **Inventory** records.
- The **Inventory** feeds directly into **Dashboard Metrics**.
- Creating a **Sale** instantly generates an **Installment Contract** and updates **Customer History**.

### Dynamic State Management
The Executive Command Center (Dashboard) utilizes dynamic state management to render real-time calculations. Any **Investment** addition or **Withdrawal** made instantly recalculates the *Capital Investment*, *Stock Allocation*, and *Performance Velocity* without requiring manual refreshes.

### Role-Based Access Control (RBAC) & Security
The system secures critical paths using access control logic. 
- **Administrative Rights:** Settings (Database Import/Export), Financial Configurations, and Capital Investments are locked behind secure administrative access.
- **Data Integrity:** Strict input validation ensures correct formatting (e.g., CNIC uploads, required pricing parameters) before any database commits occur.

---

## 2. Exhaustive Application User Flow (Tree Structure)
*This tree represents the complete A-to-Z navigation architecture of the application.*

```text
[App Launch]
 ├── [0. Authentication (Login)]
 │    └── Secure Login Portal (Dark Theme)
 │
 ├── [1. Executive Command Center (Dashboard)]
 │    ├── Quick Action Shortcuts
 │    │    ├── New Sale          -> (Routes to Sales Management)
 │    │    ├── Add Bike          -> (Routes to Inventory)
 │    │    ├── Investment        -> (Routes to Investment Screen)
 │    │    ├── Add Expense       -> (Routes to Settings/Expenses)
 │    │    ├── Customers         -> (Routes to Customers Screen)
 │    │    └── Installments      -> (Routes to Installment Screen)
 │    └── Real-time Performance Metrics
 │         ├── Capital Investment Details
 │         ├── Units in Stock Detail & Low Stock Alerts
 │         ├── Monthly Sales Revenue & Targets
 │         ├── Total Installment Value & Contracts
 │         ├── Performance Velocity (Weekly Sales Graph)
 │         └── Stock Allocation Distribution (Pie Chart)
 │
 ├── [2. Dealers & Purchases Screen]
 │    ├── Search Dealers (Search Bar)
 │    ├── Add New Supplier
 │    ├── Edit / Delete Supplier
 │    ├── Add Stock Batch
 │    │    ├── Supplier & Bike Details Inputs
 │    │    ├── Total Cost of Bike(s)
 │    │    └── Add Multiple Bikes Feature
 │    └── Download Data Feature
 │
 ├── [3. Inventory Management Screen]
 │    ├── Filter & Search System
 │    ├── Edit / Delete Bike Details
 │    ├── Set Price Features
 │    └── Add Bike Screen
 │         ├── Basic & Purchase Details
 │         ├── Technical Specs
 │         ├── Bike Papers Details
 │         └── Bike Image Upload
 │
 ├── [4. Sales Management Screen]
 │    ├── Filters & Search System
 │    ├── Download / Delete Sales Data
 │    └── New Sales Screen
 │         ├── Vehicle Selection
 │         ├── Customer Information
 │         ├── Witness Information
 │         ├── Payment Terms & Contract Details
 │         └── Document Tracking
 │
 ├── [5. Installments Screen]
 │    ├── Filters & Search System
 │    ├── Installment Metrics (Remaining days/months, Cleared payments)
 │    └── Download Installment Data Feature
 │
 ├── [6. Customers Screen]
 │    ├── Total Customers Metric & Data View
 │    ├── Pending Payments & Active Installment History
 │    ├── Edit, Delete & Download Customers
 │    └── Add New Customer Screen
 │         ├── Personal & Contact Information
 │         └── Media Uploads (CNIC Photo & Profile Photo)
 │
 ├── [7. Report Analysis Screen]
 │    ├── Report Summaries & Download (Filter by Year/Month)
 │    ├── Core Financial Displays (Available Cash, Net Profit, Total Expenses)
 │    └── Specific Bike Metric Displays
 │
 ├── [8. Investment Screen]
 │    ├── Core Financials (Total Invested, Available Cash, Net Profit)
 │    ├── Asset Valuation Metrics
 │    │    ├── Sold & Complete Bike Purchasing Values
 │    │    ├── Active Inventory Purchasing Values
 │    │    └── Maintenance Spent & Total Expenses
 │    ├── Installment Predictions (Future Payment, Future Profit)
 │    ├── Filters & Separate Detail Views (Withdrawals vs Capital)
 │    ├── Download Investment Data
 │    ├── Add Capital Screen
 │    │    ├── Category Selection (Loan, Partnership, Other)
 │    │    └── Amount, Date & Optional Note
 │    └── Withdraw Screen
 │         ├── Amount, Date & Optional Note
 │         ├── Reason (Personal use, maintenance, expenses)
 │         └── Capital Source Deduction Selection
 │
 ├── [9. Settings Screen]
 │    ├── Financial Section (Markup, EMI rounding, Late fees/percentages, Expense categories)
 │    ├── Inventory Section (Add/Edit Brands, Models, Model Years)
 │    ├── Database Section (Storage path, Export/Import Backup, Compress Media, Reset App)
 │    ├── Profile Section (Owner Name/Pic, Login User/Password)
 │    └── General Section (Showroom Info/Logo, Currency, Dark/Light Theme, App Walkthrough)
 │
 └── [10. Exit Screen]
      └── Confirmation to Exit Options
```

---

## 3. Visual Storyboard & Implementation Details

<div style="page-break-after: always;"></div>

### Page 1: Authentication Portal
![Login Screen](./App%20UI/Dark%20Theme%20UI/Login%20Page.png)
*Caption: Secure entry point enforcing Role-Based Access Control (RBAC) and data isolation.*

<div style="page-break-after: always;"></div>

### Page 2: The Executive Command Center
![Main Dashboard](./app_screenshots/dashboard_screen.png)
*Caption: The central hub utilizing dynamic state management to render real-time KPIs (Capital, Sales, Stock) with quick-access routing.*

<div style="page-break-after: always;"></div>

### Page 3: Dealers & Purchases Management
![Dealers Screen](./app_screenshots/dealers_and_purchases_screen.png)
*Caption: Supplier and procurement portal. Highlights the "Add Stock Batch" system calculating multi-unit costs.*

<div style="page-break-after: always;"></div>

### Page 4: Inventory Engine
**Inventory Management View:**
![Inventory Main Screen](./app_screenshots/inventory_management_screen.png)

**Add Bike Details:**
![Add Bike Modal/Form](./app_screenshots/add_bike_screen.png)
*Caption: Comprehensive asset tracking with detailed specifications, pricing configurations, and image handling.*

<div style="page-break-after: always;"></div>

### Page 5: Sales Orchestration
**Sales Control Panel:**
![Sales Main Screen](./app_screenshots/sales_management_screen.png)

**New Sale Generation:**
![New Sale Contract](./app_screenshots/new_sales_screen.png)
*Caption: End-to-end checkout system mapping vehicles to customers, enforcing contract terms, and handling document tracking.*

<div style="page-break-after: always;"></div>

### Page 6: Installment Tracking
![Installment Screen](./app_screenshots/installement_screen.png)
*Caption: Automated tracking of remaining terms and cleared payments, heavily integrated with Sales data.*

<div style="page-break-after: always;"></div>

### Page 7: Customer Relationship Management (CRM)
**Customer Database:**
![Customers Screen](./app_screenshots/customers_screen.png)

**Add Customer Portal:**
![Add New Customer Form](./app_screenshots/add_new_customer.png)
*Caption: Secure profile management with integrated media upload (CNIC/Photos) and linked active payment histories.*

<div style="page-break-after: always;"></div>

### Page 8: Financial Report Analysis
![Reports Screen](./app_screenshots/report_and_analysis_screen.png)
*Caption: Advanced financial aggregation summarizing available cash, net profits, and targeted time-based reporting.*

<div style="page-break-after: always;"></div>

### Page 9: Investment & Asset Valuation
**Asset Portfolio:**
![Investment Screen](./app_screenshots/investment_screen.png)

**Transaction Handlers:**
![Add Capital](./app_screenshots/add_capital_screen.png)
<br/>
![Withdraw Modal](./app_screenshots/withdrawl_screen.png)
*Caption: Core financial engine tracking investments versus withdrawals, providing predictive installment modeling and complete asset valuation.*

<div style="page-break-after: always;"></div>

### Page 10: System Settings & Security
![Settings Screen](./app_screenshots/settings_screen.png)
*Caption: Administrative control center handling robust database backups, dynamic styling (Dark/Light mode), and core financial rules (EMI rounding, Markup).*
