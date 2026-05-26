<div align="center">
  <img src="assets/app_logo.jpeg" alt="AL-TAHIR Showroom Logo" width="200" style="border-radius:20px; box-shadow: 0 4px 8px rgba(0,0,0,0.1);"/>
  <br/>
  <h1>🏍️ AL-TAHIR Showroom ERP</h1>
  <img src="https://img.shields.io/badge/version-1.0.0-blue?style=for-the-badge" alt="Version 1.0.0" />
  <p>Comprehensive Automotive Inventory & Installment Management System</p>
</div>

<p align="center">
  <a href="#-overview">Overview</a> •
  <a href="#-key-features">Features</a> •
  <a href="#-tech-stack">Tech Stack</a> •
  <a href="#-screenshots">Screenshots</a> •
  <a href="#-installation">Installation</a>
</p>

<p align="center">
  <img src="https://skillicons.dev/icons?i=flutter,dart,cpp,windows" alt="Tech Stack" />
</p>

---

## 📌 Overview

**AL-TAHIR Showroom** is a tailored, high-performance desktop application designed specifically for modern automotive and motorcycle dealerships. Built using **Flutter** and **Dart** for a buttery-smooth UI, and leveraging **C++** for native Windows integrations, this ERP system centralizes the complexities of inventory tracking, point-of-sale (POS) operations, and long-term installment accounting into one beautifully crafted interface.

## ✨ Key Features

- 📦 **Smart Inventory Management**: Track vehicles by Chassis and Engine numbers. Real-time availability status for Available, Sold, or Installment stock.
- 💳 **Advanced Installment Tracking**: Automate monthly EMI calculations, generate dynamic payment schedules, alert staff about overdue accounts, and utilize intuitive number formatting for inputs.
- 💰 **Comprehensive POS**: Seamlessly handle Cash and Installment sales workflows with automated contract generation.
- 📊 **Real-time Analytics Dashboard**: Executive KPIs, total asset value breakdowns, performance metrics, and professional graphical reporting.
- 🌙 **Adaptive UI/UX**: State-of-the-art Glassmorphism UI, smooth micro-animations, and full Dark/Light mode support.
- 🖨️ **Invoice & PDF Generation**: Built-in native print support for cash receipts, installment contracts, and refined system reports.
- 🔒 **Backup & Recovery**: Automated `.tahir` ZIP backups via Isar database dumping.
- 🛡️ **Hardware Security**: Device locking mechanisms via permanent Windows Motherboard UUID binding to securely prevent unauthorized duplication, bypassing unreliable network/MAC address changes.

---

## 🛠 Tech Stack

| Technology | Purpose |
|------------|---------|
| <img src="https://upload.wikimedia.org/wikipedia/commons/1/17/Google-flutter-logo.png" width="20"/> **Flutter** | Cross-platform UI Framework for fluid desktop rendering |
| <img src="https://upload.wikimedia.org/wikipedia/commons/thumb/7/7e/Dart-logo.png/600px-Dart-logo.png" width="20"/> **Dart** | Core programming language for business logic & multi-threading |
| <img src="https://upload.wikimedia.org/wikipedia/commons/1/18/ISO_C%2B%2B_Logo.svg" width="20"/> **C++** | Native Windows desktop integration (Window Manager & Tray) |
| 🗄️ **Isar Database** | Blazing fast, NoSQL local database tailored for Flutter |
| 📊 **FL Chart** | Highly customizable data visualization & graphical metrics |
| 🔔 **Local Notifier** | Native OS-level notifications for overdue payments |

---

## 📸 Screenshots

### Executive Dashboard
> *Real-time KPI metrics, graphical asset tracking, and recent transactions.*
<p align="center">
  <img src="assets/screenshots/Dashboard.png" alt="Dashboard View" width="800" style="border-radius:12px"/>
</p>

### Inventory Management
> *Track engine/chassis numbers, filter models, and monitor available units.*
<p align="center">
  <img src="assets/screenshots/inventory.png" alt="Inventory View" width="800" style="border-radius:12px"/>
</p>

### Installment Contracts
> *Handle comprehensive multi-month contracts, penalty tracking, and EMI ledgers.*
<p align="center">
  <img src="assets/screenshots/installments.png" alt="Installments View" width="800" style="border-radius:12px"/>
</p>

### Reporting & Analytics
> *Filterable reports tracking revenue vs. expenses to measure net profit.*
<p align="center">
  <img src="assets/screenshots/reports.png" alt="Reports View" width="800" style="border-radius:12px"/>
</p>

*(Note: Actual user data hidden/anonymized in system previews for internal safety)*

---

## 🚀 Installation & Build Requirements

*Because this application uses secure, localized Isar storage and native Windows APIs, ensure the following is installed on your workstation:*

1. **Flutter SDK**: `^3.2.0`
2. **Visual Studio build tools** (with C++ Desktop Development enabled)
3. **Dart SDK**: `^3.2.0`

### Running Locally

```bash
# Clone the repository
git clone https://github.com/your-repo/tahir_showroom.git

# Navigate to directory
cd tahir_showroom

# Install required Dart packages
flutter pub get

# Generate Isar Schema maps (Required for DB runtime)
dart run build_runner build -d

# Run the app natively on Windows
flutter run -d windows
```

### Building for Production

To compile a highly optimized, obfuscated, and release-ready Windows executable (which secures hardcoded lists like authorized Motherboard UUIDs):

```bash
flutter build windows --release --obfuscate --split-debug-info=build/debug-info
```
The compiled `.exe` and associated DLL dependencies will be located in `build\windows\x64\runner\Release\`.

#### Creating the Installer
Once the production build is finished, use **Inno Setup** to package the application.
Open `installer/setup.iss` in Inno Setup Compiler and compile it to generate a redistributable `ALTahirShowroom_Setup_v1.0.0.exe` file.

---

## 🔐 Security & Privacy Practices

This software handles sensitive financial and customer metadata.
- **Hardware Authorization (UUID Binding)**: The application checks the system's permanent Windows Motherboard UUID during the startup sequence. This ensures 100% reliable hardware locking that doesn't break when network adapters (Wi-Fi/Ethernet) change. Unauthorized devices are physically gated behind an inescapable lock screen protecting all local APIs from initializing.
- **No Hardcoded Credentials**: Administrative credentials are obfuscated and stored securely using `crypto` SHA-256 protocols. They are never kept statically in the source code.
- **Binary Obfuscation**: Production binaries are compiled using Flutter's native obfuscation protocols (`--obfuscate`) to scramble reverse-engineering attempts of sensitive constants.
- **Local Isolation**: All customer profiles and business ledgers are securely stored locally inside the application's secure application data directories using Isar indexing.
- **DO NOT commit `*.isar` or `.tahir` backup files to version control.**

---

## 🚀 Future Roadmap (V2.0 & Beyond)

We are actively planning the next evolution of the Al-Tahir Showroom ERP to move beyond offline operations and integrate cutting-edge technology. For detailed plans, see our [FUTURE_FEATURES.md](FUTURE_FEATURES.md) file. Upcoming highlights include:
- **Platform Expansion**: Transitioning to a real-time cloud database to support a fully synchronized Android App and Web Dashboard.
- **AI Integrations**: Predictive stock management based on historical sales and voice-controlled data entry.
- **Automation**: Digital biometric signatures and AI-powered document scanning (OCR) for customer CNICs.
- **Multi-Branch Management**: Centralized master dashboard so that one owner can handle multiple showroom branches from a single interface.

---

## 📄 License & Copyright

This is a proprietary, closed-source application developed exclusively for **AL-TAHIR Showroom**. 
Unauthorized copying, modification, distribution, or execution of this software, via any medium, is strictly prohibited. 
For licensing inquiries, please contact the developers.

## 📞 Support & Contact

For technical support, bug reports, or system maintenance, please reach out to the **Creative District** development team:
- **Developers**: Moazam Samoo & Tameer Ahmed Khyber

---

<p align="center">
  <i>Developed specifically for AL-TAHIR Showroom operations.</i><br/>
  <b>Built and Created by Creative District.</b>
  <br/>
  Developers <b>Moazam Samoo</b> & <b>Tameer Ahmed Khyber</b>
</p>
