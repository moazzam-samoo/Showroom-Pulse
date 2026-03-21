# AL-TAHIR Showroom - User Guide

Welcome to the **AL-TAHIR Showroom**, a comprehensive management system specially designed for motorcycle and automotive dealerships. This guide will help you understand how to use the software to its full potential.

Developed by: **Creative District (Moazam Samoo & Tameer Ahmed Khyber)**

---

## 1. Welcome & Introduction

### What is AL-TAHIR Showroom ERP?
AL-TAHIR Showroom ERP is an offline, desktop-based management system. It helps showroom owners manage their inventory, sales, customers, and installment payments without needing an internet connection.

### Who is it for?
This software is built for motorcycle showrooms and small vehicle dealerships in Pakistan who handle both cash sales and installment plans.

### Key Features
- **Unique Vehicle Tracking**: Manage bikes using Engine and Chassis numbers.
- **Installment Engine**: Automatically calculate markups and monthly payments.
- **Offline Data**: Your data stays on your PC, safe and private.
- **Simple Backup**: Export your entire database and images to a single file.

---

## 2. Installation Guide

Follow these steps to install the software on your Windows PC:

1. **Run Setup**: Locate the `AL-TAHIR_Showroom_Setup.exe` file and double-click it.
2. **Follow the Wizard**: Click **Next** through the installation screens. The app will install by default in your `C:\Program Files` folder.
3. **Finish**: Once the progress bar is complete, click **Finish**. A shortcut will appear on your desktop.
4. **First Launch**: Double-click the desktop icon to open the app. 

> [!NOTE]
> The app stores all your data in your **Documents** folder under a folder named `TahirShowroom`. **Do not delete this folder.**

---

## 3. First Time Setup

When you open the app for the first time, you will need to log in.

- **Default Username**: `admin`
- **Default Password**: `admin123`

> [!TIP]
> After your first login, go to **Settings** to change your password for better security.

---

## 4. Dashboard Overview

The Dashboard is your "Command Center." It shows you the most important information at a glance.

### KPI Cards (Key Stats)
- **Total Asset Value**: The total cost value of all bikes currently in your showroom.
- **Units in Stock**: How many bikes are available for sale right now.
- **Monthly Revenue**: Total money collected from sales and installments this month.
- **Active Installments**: The number of customers currently paying monthly installments.

### Navigation
Used the **Sidebar** on the left to move between different sections:
- **Inventory**: View and add bikes.
- **Sales**: Perform new cash or installment sales.
- **Installments**: Manage monthly payments and overdue alerts.
- **Reports**: View your business performance.
- **Settings**: Change app colors and setup backups.

---

## 5. Inventory Management

Manage your bikes easily by keeping track of their unique numbers.

### How to add a new vehicle
1. Click on **Inventory** from the sidebar.
2. Click the **Add New Bike** button (top right).
3. Fill in the details:
   - **Model Name** (e.g., Honda CD 70)
   - **Engine Number** (Must be unique)
   - **Chassis Number** (Must be unique)
   - **Color/CC**
   - **Purchase Price** (Your cost)
   - **Cash Sale Price** (Selling price)
4. **Add Image**: Click the image area to select a photo of the bike.
5. Click **Save**.

### Vehicle Status
- **Available**: Ready for sale.
- **Sold**: Sold on full cash.
- **On Installment**: Currently being paid for by a customer.

---

## 6. Sales & POS

The app supports two types of sales:

### Cash Sale Workflow
1. Go to **Sales** section.
2. Select an **Available Bike**.
3. Enter Customer details (Name, CNIC, Phone).
4. Select **Cash Sale**.
5. Finalize and **Print Receipt**.

### Installment Sale Workflow
1. Select an **Available Bike**.
2. Enter Customer details and **Guarantor (Witness)** details.
3. Set the **Markup %** (e.g., 20% or 30%).
4. Enter the **Down Payment** received.
5. Select the **Duration** (e.g., 6 months, 12 months).
6. The app will automatically show the **Monthly EMI**.
7. Click **Complete Sale** and **Print Contract**.

---

## 7. Installment Management

### Recording Payments (EMIs)
1. Go to **Installments** section.
2. Search for the customer by name or CNIC.
3. Click on the customer to open **Details**.
4. Click **Record Payment**.
5. Enter the amount received and click **Save**.
6. The system will update the remaining balance instantly.

### Overdue Alerts
If a customer misses their payment date, their name will appear in **Red** or show an **Alert Icon** in the dashboard notifications.

---

## 8. Reports & Analytics

Keep an eye on your profits and expenses.

1. Go to **Reports**.
2. Select your period: **Monthly**, **Yearly**, or **All**.
3. View **Revenue** (Total money in) and **Expenses** (Money spent).
4. Profit is calculated automatically after subtracting expenses from sales.
5. Click the **Download PDF** button (top right) to save a detailed summary.

---

## 9. Database Backup & Restore ⭐

This is the **most important** section of the guide. Since the app is offline, you are responsible for your data.

### How to EXPORT (Backup)
1. Go to **Settings** -> **Database Settings**.
2. Click **Export Database Backup**.
3. The app will package all your data and images into a file ending in `.tahir`.
4. **Save this file to a USB Drive or External Hard Drive.**
5. **Recommended Schedule**: Every Saturday or at the end of every business day.

### How to IMPORT (Restore)
1. If you move the app to a new PC, go to **Settings** -> **Database Settings**.
2. Click **Import Database Backup**.
3. Select your `.tahir` backup file.
4. **WARNING**: This will delete current data on the PC and replace it with the backup.
5. Restart the app after the import is complete.

---

## 10. Checkpoints ⭐

### What are Checkpoints?
Checkpoints are like "Mini Backups." The system automatically creates a snapshot of your database every 7 days.

### Difference between Backup and Checkpoint
- **Backup (.tahir)**: Manual file you save to a USB. Includes all images and data.
- **Checkpoint**: Automatic file saved inside your PC. Only includes database records (no images).

### How to Restore from a Checkpoint
1. Go to **Settings** -> **Database Settings**.
2. Click **Reset Options** -> **Restore from Checkpoint**.
3. Select a date from the list to "go back in time."
4. The app will restart and your data will be restored to that date.

---

## 11. Settings

- **Dark/Light Mode**: Toggle the switch in the top bar or settings to change the app's look.
- **Print Settings**: Add your Showroom Name, Address, and Phone Number to appear on invoices.
- **Reset Options**: Use this to clear data or restore checkpoints.

---

## 12. Invoice & PDF Printing

The system generates professional PDFs for your records:
- **Cash Receipt**: For full payments.
- **Installment Contract**: Legal agreement showing monthly plan and witness info.
- **Profit/Loss Report**: Summary of your business for a specific period.

Simply click the **Print** icon on any transaction or report to save/print the PDF.

---

## 13. Troubleshooting

- **App won't open**: Ensure you are running it on a Windows 10 or 11 PC. Try Restarting your PC.
- **Data not showing**: Check if the `Documents/TahirShowroom` folder was accidentally moved or renamed.
- **Print not working**: Ensure a printer is connected and set as "Default" in Windows.

---

## 14. FAQ

**Q: Can I use this on 2 PCs at the same time?**
A: No, this is a single-PC offline system. You can move data between them using Backup/Restore.

**Q: Where is my data?**
A: It is stored locally in `C:\Users\[YourName]\Documents\TahirShowroom`.

---

## 15. Support & Contact

For technical assistance or custom features, please contact:

**Creative District**
- Moazam Samoo: [PLACEHOLDER]
- Tameer Ahmed Khyber: [PLACEHOLDER]
- Email: [PLACEHOLDER]

---
*© 2026 Creative District. All Rights Reserved.*
