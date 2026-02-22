# Discount Feature Implementation Plan

## Overview

This plan outlines the integration of a Discount mechanism into the New Sale workflow for both Cash and Installment sales. It includes database schema updates, calculation logic modifications, and UI enhancements.

## Phase 1: Database Updates (Isar Models)

1. **Sale Model (`lib/app/data/models/sale.dart`)**:
   - Add `double discountAmount = 0.0;`
   - Add `double discountPercentage = 0.0;`

2. **Installment Contract Model (`lib/app/data/models/installment_contract.dart`)**:
   - Add `double discountAmount = 0.0;`
   - Add `double discountPercentage = 0.0;`

3. **Code Generation**:
   - Run `flutter pub run build_runner build --delete-conflicting-outputs` to regenerate Isar schema files (`.g.dart`).

## Phase 2: Controller & Calculation Logic

**`NewSaleController` Updates**:

1. **Cash Sales**:
   - **Logic**: `Discount = Bike Cash Sale Price - Received Amount`
   - Calculate discount percentage: `(Discount / Bike Cash Sale Price) * 100`

2. **Installment Sales**:
   - **Form Update**: We'll add a new "Discount" input field to the Installment Markup Configuration section.
   - **Logic**: `New Base Price = Bike Cash Sale Price - Discount`. The markup will then be calculated on this *new base price*.

3. **Save Logic**:
   - Update the `saveSale` method to persist the calculated `discountAmount` and `discountPercentage` into the `Sale` and `InstallmentContract` databases.

## Phase 3: Frontend UI Enhancements

1. **Payment Plan Step (`lib/app/features/sales/presentation/widgets/payment_plan_step.dart`)**:
   - **Cash View**: Display the original Bike Selling Price above the "Received Amount" input. Show the real-time calculated discount.
   - **Installment View**: Add a "Discount (Rs)" input field beside Markup configuration. Subtract this discount from the total before applying markup.

2. **Bike Card & Sale Details**:
   - **`BikeCard`**: Update the UI to show a "Discount" chip/badge displaying both the amount and percentage if a discount was given.
   - **`CashSaleDetailDialog` & `InstallmentSaleDetailDialog`**: Add dedicated rows to show "Original Price", "Discount", and "Final Price/Amount".

## Phase 4: Verification & Testing

- Run `flutter analyze`
- Test full lifecycle of a Cash Sale with discount.
- Test full lifecycle of an Installment Sale with discount.
- Verify that historical data is not broken by the new DB fields (Isar handles adding fields safely).
