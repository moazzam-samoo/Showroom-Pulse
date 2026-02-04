# **Tahir Showroom Management System \- Technical Documentation**

**Version:** 2.0 (Updated with Procurement & Batch Logic)

**Platform:** Windows Desktop (Flutter)

**Architecture:** Feature-Based (Vertical Slices) \+ GetX

**Database:** Isar (NoSQL)

## **1\. Project Overview**

**Tahir Showroom** is a specialized ERP solution for motorcycle dealerships.

**Core Philosophy:**

1. **Offline-First:** Runs without internet.  
2. **Portable Data:** Critical requirement. User data lives in Documents/TahirShowroom/ for easy copy-paste backup.  
3. **Asset Tracking:** Unique tracking via Engine/Chassis numbers.

## **2\. File System & Data Storage (Critical)**

**Root Path:** C:\\Users\\\[CurrentUser\]\\Documents\\TahirShowroom\\

TahirShowroom/  
│  
├── Database/                  \# STRICTLY for Isar DB files  
│   ├── default.isar  
│  
├── Media/                     \# External Assets  
    ├── Bikes/                 \# Inventory Images  
    │   ├── ENG-998877.jpg     \# Naming Convention: \[EngineNumber\].jpg  
    │  
    ├── Suppliers/             \# NEW: Dealer Data  
    │   ├── Dealer\_AhmedAutos/ \# Folder Name: Dealer Name \+ ID  
    │   │   ├── profile.jpg  
    │   │   └── Invoices/  
    │   │       └── inv\_batch\_501.jpg  
    │  
    └── Customers/             \# Buyer Data  
        ├── 42101-1234567-1/   \# Folder Name: CNIC  
            ├── profile.jpg  
            ├── cnic\_front.jpg  
            └── Witness/       \# Guarantor Data  
                └── witness\_cnic.jpg

## **3\. Database Architecture (Isar)**

### **A. Procurement Module (New & Updated)**

**1\. Collection: Supplier**

Represents the dealer from whom bikes are purchased.

@collection  
class Supplier {  
  Id id \= Isar.autoIncrement;  
  late String name;           // e.g., "Ahmed Autos"  
  late String cnic;  
  late String phone;  
  String? profilePicFilename; // Stored in Media/Suppliers/{Name}/  
    
  final batches \= IsarLinks\<PurchaseBatch\>();  
}

**2\. Collection: PurchaseBatch (The Lot Header)**

Represents a bulk purchase transaction on a specific date.

@collection  
class PurchaseBatch {  
  Id id \= Isar.autoIncrement;  
  late DateTime purchaseDate;  
    
  late double totalBatchCost; // Calculated: Sum of all linked bikes' purchasePrice  
    
  String? billImageFilename;  // Stored in Media/Suppliers/{Name}/Invoices/  
    
  final supplier \= IsarLink\<Supplier\>();  
  final bikes \= IsarLinks\<Bike\>();  
}

**3\. Collection: Bike (The Asset \- Updated)**

@collection  
class Bike {  
  Id id \= Isar.autoIncrement;

  // \-- Identification \--  
  @Index(unique: true)  
  late String engineNumber;     
  @Index(unique: true)  
  late String chassisNumber;  
    
  // \-- Specs \--  
  late String modelName;  
  late String brand;  
  late String color;  
  late int modelYear;         // NEW: Affects price  
    
  // \-- Financials \--  
  late double purchasePrice;  // NEW: Variable per unit logic  
  late double cashSalePrice;  
    
  // \-- Media \--  
  String? imageFilename;      // Stored as \[engineNumber\].jpg in Media/Bikes/  
    
  // \-- Status \--  
  @enumerated  
  late BikeStatus status;     // Available, Sold, Installment  
    
  // \-- Relationships \--  
  final batch \= IsarLink\<PurchaseBatch\>(); // Link to source  
}

### **B. Sales Module (Existing)**

**4\. Collection: Customer**

* **Fields:** fullName, cnicNumber (Unique), phoneNumber, profilePicFilename.  
* **Links:** contracts (One customer can have multiple deals).

**5\. Collection: InstallmentContract**

* **Fields:** basePrice, markupPercentage (Default 40%), totalAmount, downPayment, durationMonths.  
* **Links:** bike, customer, witnesses, payments.

## **4\. Functional Modules & UI Logic (Instructions for AI)**

### **4.1. Procurement (Purchasing)**

* **Goal:** Manage inbound stock from dealers.  
* **Flow:**  
  1. **Select/Create Supplier:** Create folder Media/Suppliers/\[Name\].  
  2. **Create Batch:** Enter Date and upload Bill Image.  
  3. **Add Bikes (Grid):** User enters Engine \#, Chassis \#, Year, and **Cost Price** for each unit.  
  4. **Save:** System saves PurchaseBatch and links all new Bike entries.

### **4.2. Inventory Management**

* **Goal:** View Available Stock.  
* **Logic:** Query Bike where status \== Available.  
* **Display:** Grid Cards showing Image, Model, and Sale Price.

### **4.3. Sales (Installment Engine)**

* **Goal:** Sell a bike.  
* **Logic:**  
  * **Markup:** Total \= CashPrice \+ (CashPrice \* 0.40).  
  * **Folders:** Create Media/Customers/\[CNIC\]/Witness/ for documents.  
  * **Transaction:** Atomic save (Customer \-\> Contract \-\> Bike Status Update).

## **5\. UI Generation Prompts (For Agentic AI)**

Use these prompts to generate the specific screens.

### **Prompt 1: "Add Stock" (Procurement) Screen**

**Task:** Create a Flutter screen AddStockView using GetX.

**Layout:**

* **Header:** Supplier Dropdown (or Add New button), Date Picker, and Bill Image Upload.  
* **Body:** A dynamic list/table of bikes to add.  
* **Row Items:** Image Picker (Thumbnail), Model Name, Year (Int), Color, Engine \#, Chassis \#, **Purchase Price**.  
* **Footer:** Display "Total Batch Cost" (Sum of all rows' purchase prices) and a "Save Batch" button.  
  **Logic:**  
* When user adds a row, update the total cost in real-time (Obx).  
* Validate that Engine/Chassis numbers are unique before saving.

### **Prompt 2: "Supplier History" Screen**

**Task:** Create SupplierHistoryView.

**Layout:** Split View (Left: List of Suppliers, Right: Details).

* **Left Panel:** List of Supplier Cards (Profile Pic, Name, Total Batches).  
* **Right Panel:** When a supplier is selected, show a List of PurchaseBatch cards.  
* **Batch Card:** Shows Date, Total Items (e.g., "12 Bikes"), Total Cost.  
* **Expansion:** Clicking a Batch Card expands to show the Grid of Bikes purchased in that batch (Image, Model, Price).

### **Prompt 3: "Inventory" Screen (Stock View)**

**Task:** Create InventoryView.

**Layout:** A responsive Grid of Cards.

**Card Content:**

* Top: Bike Image (from Media/Bikes/).  
* Middle: Model Name, Color, Year.  
* Bottom: Engine Number (Last 4 digits masked), Cash Sale Price, Status Chip (Green for Available).  
  **Logic:** Only fetch bikes where isSold \== false. Include a Search Bar for Engine/Chassis filtering.

## **6\. Implementation Strategy**

* **FileService:** Must handle the creation of the new Suppliers folder structure.  
* **Data Migration:** Note that this V2 schema is a breaking change from V1 (Added PurchaseBatch).