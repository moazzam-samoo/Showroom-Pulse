# PLAN: Installment Sale Detail Dialog

## Context
User wants a detailed dialog for "Installment Sales" similar to the Cash Sale dialog but with specific fields for installments (Down Payment, Monthly calc, Witness details).

## Requirements

### 1. Data Model (`SaleCardData`)
Need to add the following fields:
- **Financials**:
  - `sellingPrice` (double) - *Total price including markup*
- **Witness Details**:
  - `witnessName` (String?)
  - `witnessCnic` (String?)
  - `witnessPhone` (String?)
  - `witnessImage` (String?)

*Note: `amountPaid` will represent Down Payment. `bikePrice` represents Total Actual Bike Price.*

### 2. Mock Data
Update `SalesCardGrid` to populate these new fields for installment sales.

### 3. UI Implementation (`InstallmentSaleDetailDialog`)
A new widget `InstallmentSaleDetailDialog` that displays:
- **Header**: "Installment Sale Details"
- **Purchaser Section**: Photo, Name, Contact, CNIC, Address, Sale Date.
- **Financial Section**:
  - Down Payment (`amountPaid`)
  - Monthly Installment (`installmentMonthlyPayment`)
  - Total Actual Price (`bikePrice`)
  - Selling Price (`sellingPrice`)
  - Installment Duration
  - Due Date
- **Witness Section**: Photo, Name, CNIC, Phone.
- **Bike Section**: Image, Name, Chassis, Engine.

### 4. Integration
- Update `SaleCard` `onTap` to triggers this dialog when `!isCash`.

## Agent Tasks

| Agent | Task |
|-------|------|
| `backend-specialist` | Update `SaleCardData` class and `SalesCardGrid` mock data. |
| `frontend-specialist` | Create `InstallmentSaleDetailDialog.dart` and update `SaleCard.dart`. |
| `test-engineer` | Verify dialog opens and displays correct data. |
