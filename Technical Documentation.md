# **AL-TAHIR Showroom Management System - Technical Documentation**

**Version:** 1.0

**Platform:** Windows Desktop (Flutter)

**Architecture:** Feature-Based (Vertical Slices) \+ GetX

**Database:** Isar (NoSQL)

## **1\. Project Overview**

**AL-TAHIR Showroom** is a specialized ERP solution for motorcycle dealerships. The system focuses on unique asset tracking (Engine/Chassis numbers) and a complex installment management engine with automated markup calculations.

**Core Philosophy:**

1. **Offline-First:** The app must run without internet.  
2. **Portable Data:** Complete separation of application logic and user data to allow easy backup/restore via simple folder copying.  
3. **Scalability:** A modular codebase allowing easy addition of new features (e.g., Spare Parts, Service Center) in the future.

## **2\. File System & Data Storage Architecture**

This is the **Critical Requirement** section. The application does not store data in the default hidden AppData folders. Instead, it uses a user-accessible directory structure to ensure data portability.

### **2.1. Root Directory Structure**

The application must initialize and verify this structure on every launch.

**Root Path:** C:\\Users\\\[CurrentUser\]\\Documents\\TahirShowroom\\

TahirShowroom/  
│  
├── Database/                  \# STRICTLY for Isar DB files  
│   ├── default.isar           \# Main database file  
│   └── default.isar.lock      \# Lock file  
│  
├── Media/                     \# STRICTLY for external assets (Images/Docs)  
│   ├── Bikes/                 \# Inventory Images  
│   │   ├── bike\_engine123.jpg  
│   │   └── bike\_engine456.jpg  
│   │  
│   └── Customers/             \# Customer-specific folders (Named by Unique CNIC)  
│       ├── 42101-1234567-1/   \# Folder Name \= Customer CNIC  
│       │   ├── profile.jpg    \# Customer Profile Picture  
│       │   ├── cnic\_front.jpg  
│       │   ├── cnic\_back.jpg  
│       │   │  
│       │   └── Witness/       \# Sub-folder for Guarantor/Witness data  
│       │       ├── witness1\_cnic.jpg  
│       │       └── witness2\_cnic.jpg  
│       │  
│       └── 42201-9876543-2/  
│           └── ...

### **2.2. Data Persistence Strategy**

* **Initialization:** On app startup, the IsarService must check if C:\\Users\\...\\Documents\\TahirShowroom exists.  
* **Backup:** The user can back up the system by simply copying the TahirShowroom folder to a USB drive.  
* **Restoration:** To restore, the user pastes the folder back into Documents. The app detects the existing database and media files automatically upon restart.

## **3\. Database Architecture (Isar)**

The database is designed to be flexible. We use **Collections** for entities and **IsarLinks** for relationships.

### **3.1. Schema Definitions**

#### **A. Collection: Bike**

Represents a physical unit in the showroom.

@collection  
class Bike {  
  Id id \= Isar.autoIncrement;

  late String modelName;      // e.g., "Honda CD 70"  
  late String brand;          // e.g., "Honda"  
  late String color;  
    
  @Index(unique: true)  
  late String engineNumber;   // UNIQUE identifier  
    
  @Index(unique: true)  
  late String chassisNumber;  // UNIQUE identifier  
    
  late double purchasePrice;  // Cost to showroom  
  late double cashSalePrice;  // Standard selling price  
    
  String? imageFilename;      // Stored as "bike\_engine123.jpg", NOT full path  
    
  @enumerated  
  late BikeStatus status;     // Available, Sold, OnInstallment  
    
  DateTime? dateAdded;  
}

enum BikeStatus { available, sold, installment }

#### **B. Collection: Customer**

Represents a buyer. Separated from contracts to allow one customer to buy multiple bikes in the future.

@collection  
class Customer {  
  Id id \= Isar.autoIncrement;

  late String fullName;  
    
  @Index(unique: true)  
  late String cnicNumber;     // Used as Folder Name in Media  
  late String phoneNumber;  
  late String address;  
    
  // Media References (Filenames only)  
  String? profilePicFilename;   
  String? cnicFrontFilename;  
  String? cnicBackFilename;  
    
  // Relationships  
  final contracts \= IsarLinks\<InstallmentContract\>();  
}

#### **C. Collection: InstallmentContract**

Represents the financial agreement for a specific bike.

@collection  
class InstallmentContract {  
  Id id \= Isar.autoIncrement;

  // Financials  
  late double basePrice;          // The cash price of bike  
  late double markupPercentage;   // e.g., 40.0  
  late double totalAmount;        // basePrice \+ (basePrice \* markup)  
  late double downPayment;  
  late int durationMonths;        // e.g., 12  
    
  // Status  
  bool isCompleted \= false;  
  bool isActive \= true;  
  DateTime contractStartDate;  
    
  // Relationships  
  final bike \= IsarLink\<Bike\>();          // Link to 1 Bike  
  final customer \= IsarLink\<Customer\>();  // Link to 1 Customer  
  final payments \= IsarLinks\<Payment\>();  // Link to many Payments  
  final witnesses \= IsarLinks\<Witness\>(); // Link to Witnesses  
}

#### **D. Collection: Witness (Guarantor)**

Details of the person guaranteeing the installment.

@collection  
class Witness {  
  Id id \= Isar.autoIncrement;  
    
  late String name;  
  late String cnicNumber;  
  late String phoneNumber;  
  String? cnicImageFilename; // Saved in Media/Customers/{CNIC}/Witness/  
}

#### **E. Collection: Payment**

A record of a single transaction within a contract.

@collection  
class Payment {  
  Id id \= Isar.autoIncrement;  
    
  late double amount;  
  late DateTime date;  
  String? notes;  
}

## **4\. Functional Modules & Logic**

### **4.1. Module: Inventory Management**

* **Feature Folder:** lib/app/features/inventory/  
* **Logic:**  
  1. User fills "Add Bike" form.  
  2. User selects an image file.  
  3. **System Action:**  
     * Copies image to Media/Bikes/.  
     * Renames image to \[engine\_number\].jpg to prevent duplicates.  
     * Saves Bike object to Isar with imageFilename.  
  4. **Validation:** Check Isar for existing Engine/Chassis number before saving.

### **4.2. Module: Installment Engine**

* **Feature Folder:** lib/app/features/installments/  
* **Logic (The "New Sale" Flow):**  
  1. **Select Bike:** Query Bike collection where status \== available.  
  2. **Customer Data:**  
     * Input Name, CNIC, Phone.  
     * Create Folder: Media/Customers/\[CNIC\]/.  
     * Save images to this folder.  
  3. **Witness Data:**  
     * Input Witness Name/CNIC.  
     * Create Subfolder: Media/Customers/\[CNIC\]/Witness/.  
     * Save witness NIC image here.  
  4. **Financial Calculation:**  
     * Total \= CashPrice \+ (CashPrice \* (UserMarkup / 100))  
     * Monthly \= (Total \- DownPayment) / Months  
  5. **Commit Transaction:**  
     * Start Isar Transaction.  
     * Save Customer.  
     * Save Witness.  
     * Update Bike status to installment.  
     * Save InstallmentContract with links to Bike, Customer, and Witness.  
     * Commit Transaction.

## **5\. Data Flow & Code Structure**

### **5.1. Directory Structure (Codebase)**

lib/  
├── app/  
│   ├── core/  
│   │   ├── services/  
│   │   │   ├── isar\_service.dart       // Handles DB Open/Close  
│   │   │   └── file\_service.dart       // Handles Folder Creation & Image Copying  
│   │   └── utils/  
│   │       └── financial\_calculator.dart  
│   │  
│   ├── data/                           // Global Models (Isar Entities)  
│   │  
│   └── features/  
│       ├── inventory/  
│       │   ├── controllers/  
│       │   └── views/  
│       ├── sales/  
│       │   ├── controllers/            // Handles Cash vs Installment logic  
│       │   └── views/  
│       └── customers/                  // Customer Profile Views

### **5.2. The FileService Logic (Crucial)**

This service abstracts the complexity of the Windows file system from the UI.

class FileService {  
  // Base Path: C:\\Users\\User\\Documents\\TahirShowroom\\  
    
  Future\<String\> getAppDirectory() async {  
    // Logic to get Documents directory and append "TahirShowroom"  
  }

  Future\<String\> saveCustomerImage(File image, String cnic, String type) async {  
    // 1\. Check if folder "Media/Customers/$cnic" exists, if not create it.  
    // 2\. Copy file to this folder.  
    // 3\. Return filename.  
  }

  Future\<String\> saveWitnessImage(File image, String customerCnic) async {  
    // 1\. Check if folder "Media/Customers/$customerCnic/Witness" exists.  
    // 2\. Copy file.  
    // 3\. Return filename.  
  }  
}

## **6\. Future Scalability**

The database schema uses **IsarLinks** (Relationships). This makes the system flexible:

1. **Adding "Service History":** Create a new Service collection and link it to the Bike collection. No need to change the Bike schema.  
2. **Adding "Spare Parts":** Create a SparePart collection. It can function independently of Bikes.  
3. **Multiple Installments:** Since Customer has a list of contracts, one customer can buy 2 bikes on installment simultaneously without data conflict.