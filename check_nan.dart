import 'package:flutter/foundation.dart';
import 'package:isar/isar.dart';
import 'package:tahir_showroom/app/data/models/bike.dart';
import 'package:tahir_showroom/app/data/models/sale.dart';
import 'package:tahir_showroom/app/data/models/installment_contract.dart';
import 'package:tahir_showroom/app/data/models/payment.dart';
import 'package:tahir_showroom/app/data/models/expense.dart';
import 'dart:io';

void main() async {
  await Isar.initializeIsarCore(download: true);
  
  final isar = await Isar.open(
    [BikeSchema, SaleSchema, InstallmentContractSchema, PaymentSchema, ExpenseSchema],
    directory: r'C:\Users\Moazzam Samoo\Desktop\Tahir Showroom\isar_data',
    name: 'tahir_db',
  );

  debugPrint('Checking Bikes...');
  final bikes = await isar.bikes.where().findAll();
  for (var b in bikes) {
    if (b.cashSalePrice.isNaN || b.cashSalePrice.isInfinite) debugPrint('Bike ${b.id} cashSalePrice is ${b.cashSalePrice}');
    if (b.purchasePrice.isNaN || b.purchasePrice.isInfinite) debugPrint('Bike ${b.id} purchasePrice is ${b.purchasePrice}');
  }

  debugPrint('Checking Sales...');
  final sales = await isar.sales.where().findAll();
  for (var s in sales) {
    if (s.totalAmount.isNaN || s.totalAmount.isInfinite) debugPrint('Sale ${s.id} totalAmount is ${s.totalAmount}');
    if (s.receivedAmount.isNaN || s.receivedAmount.isInfinite) debugPrint('Sale ${s.id} receivedAmount is ${s.receivedAmount}');
    if (s.discountAmount.isNaN || s.discountAmount.isInfinite) debugPrint('Sale ${s.id} discountAmount is ${s.discountAmount}');
    if (s.discountPercentage.isNaN || s.discountPercentage.isInfinite) debugPrint('Sale ${s.id} discountPercentage is ${s.discountPercentage}');
  }

  debugPrint('Checking Contracts...');
  final contracts = await isar.installmentContracts.where().findAll();
  for (var c in contracts) {
    if (c.totalAmount.isNaN || c.totalAmount.isInfinite) debugPrint('Contract ${c.id} totalAmount is ${c.totalAmount}');
    if (c.totalPaid.isNaN || c.totalPaid.isInfinite) debugPrint('Contract ${c.id} totalPaid is ${c.totalPaid}');
    if (c.totalMarkupAmount.isNaN || c.totalMarkupAmount.isInfinite) debugPrint('Contract ${c.id} totalMarkupAmount is ${c.totalMarkupAmount}');
  }

  debugPrint('Checking Expenses...');
  final expenses = await isar.expenses.where().findAll();
  for (var e in expenses) {
    if (e.amount.isNaN || e.amount.isInfinite) debugPrint('Expense ${e.id} amount is ${e.amount}');
  }

  debugPrint('Done.');
  exit(0);
}
