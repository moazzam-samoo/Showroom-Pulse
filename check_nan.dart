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

  print('Checking Bikes...');
  final bikes = await isar.bikes.where().findAll();
  for (var b in bikes) {
    if (b.cashSalePrice.isNaN || b.cashSalePrice.isInfinite) print('Bike ${b.id} cashSalePrice is ${b.cashSalePrice}');
    if (b.purchasePrice.isNaN || b.purchasePrice.isInfinite) print('Bike ${b.id} purchasePrice is ${b.purchasePrice}');
  }

  print('Checking Sales...');
  final sales = await isar.sales.where().findAll();
  for (var s in sales) {
    if (s.totalAmount.isNaN || s.totalAmount.isInfinite) print('Sale ${s.id} totalAmount is ${s.totalAmount}');
    if (s.receivedAmount.isNaN || s.receivedAmount.isInfinite) print('Sale ${s.id} receivedAmount is ${s.receivedAmount}');
    if (s.discountAmount.isNaN || s.discountAmount.isInfinite) print('Sale ${s.id} discountAmount is ${s.discountAmount}');
    if (s.discountPercentage.isNaN || s.discountPercentage.isInfinite) print('Sale ${s.id} discountPercentage is ${s.discountPercentage}');
  }

  print('Checking Contracts...');
  final contracts = await isar.installmentContracts.where().findAll();
  for (var c in contracts) {
    if (c.totalAmount.isNaN || c.totalAmount.isInfinite) print('Contract ${c.id} totalAmount is ${c.totalAmount}');
    if (c.totalPaid.isNaN || c.totalPaid.isInfinite) print('Contract ${c.id} totalPaid is ${c.totalPaid}');
    if (c.totalMarkupAmount.isNaN || c.totalMarkupAmount.isInfinite) print('Contract ${c.id} totalMarkupAmount is ${c.totalMarkupAmount}');
  }

  print('Checking Expenses...');
  final expenses = await isar.expenses.where().findAll();
  for (var e in expenses) {
    if (e.amount.isNaN || e.amount.isInfinite) print('Expense ${e.id} amount is ${e.amount}');
  }

  print('Done.');
  exit(0);
}
