import 'package:get/get.dart';
import 'package:isar/isar.dart';
import 'package:tahir_showroom/app/core/services/isar_service.dart';
import 'package:tahir_showroom/app/core/services/file_service.dart';
import 'package:tahir_showroom/app/data/models/bike.dart';
import 'package:tahir_showroom/app/data/models/customer.dart';
import 'package:tahir_showroom/app/data/models/installment_contract.dart';
import 'package:tahir_showroom/app/data/models/payment.dart';
import 'package:tahir_showroom/app/data/models/sale.dart';
import 'package:tahir_showroom/app/data/models/witness.dart';
import 'package:tahir_showroom/app/features/sales/presentation/widgets/sale_card.dart';

/// Sales Service - Handles sales-related database operations
class SalesService {
  final IsarService _isarService = Get.find<IsarService>();
  final FileService _fileService = Get.find<FileService>();

  /// Get all sales from the database with related data
  Future<List<SaleCardData>> getAllSales() async {
    final isar = _isarService.isar;
    final sales = await isar.sales.where().findAll();

    List<SaleCardData> saleCards = [];

    for (var sale in sales) {
      final saleCard = await _transformToCardData(sale);
      if (saleCard != null) {
        saleCards.add(saleCard);
      }
    }

    return saleCards;
  }

  /// Get a single sale by ID with all related data
  Future<SaleCardData?> getSaleById(int id) async {
    final isar = _isarService.isar;
    final sale = await isar.sales.get(id);

    if (sale == null) return null;

    return await _transformToCardData(sale);
  }

  /// Get recent sales for dashboard (limited)
  Future<List<SaleCardData>> getRecentSales(int limit) async {
    final isar = _isarService.isar;
    final sales = await isar.sales
        .where()
        .sortBySaleDateDesc()
        .limit(limit)
        .findAll();

    List<SaleCardData> saleCards = [];

    for (var sale in sales) {
      final saleCard = await _transformToCardData(sale);
      if (saleCard != null) {
        saleCards.add(saleCard);
      }
    }

    return saleCards;
  }

  /// Transform database models to SaleCardData for UI
  Future<SaleCardData?> _transformToCardData(Sale sale) async {
    final isar = _isarService.isar;

    // Fetch related bike
    final bike = await isar.bikes.get(sale.bikeId);
    if (bike == null) return null;

    // Fetch related customer
    final customer = await isar.customers.get(sale.customerId);
    if (customer == null) return null;

    // Fetch installment contract if applicable
    InstallmentContract? contract;
    List<Witness> witnesses = [];
    
    if (sale.saleType == SaleType.installment && sale.installmentContractId != null) {
      contract = await isar.installmentContracts.get(sale.installmentContractId!);
      
      // Load witnesses associated with this installment contract
      if (contract != null) {
        witnesses = await isar.witness
            .filter()
            .contractIdEqualTo(contract.id)
            .findAll();
      }
    } else if (sale.saleType == SaleType.cash) {
      // Load witnesses for cash sales (contractId = -saleId)
      // We use negative sale ID to distinguish cash sale witnesses from contract witnesses
      witnesses = await isar.witness
          .filter()
          .contractIdEqualTo(-sale.id)  // Cash sales use negative sale ID
          .findAll();
    }

    // Format date to DD/MM/YYYY
    final formattedDate = '${sale.saleDate.day.toString().padLeft(2, '0')}/${sale.saleDate.month.toString().padLeft(2, '0')}/${sale.saleDate.year}';

    // Calculate installment details if applicable
    String? installmentDueDate;
    if (contract != null) {
      installmentDueDate = '${contract.firstDueDate.day.toString().padLeft(2, '0')}/${contract.firstDueDate.month.toString().padLeft(2, '0')}/${contract.firstDueDate.year}';
    }

    // Get primary witness or first witness
    Witness? primaryWitness;
    if (witnesses.isNotEmpty) {
      // Try to find primary witness first
      primaryWitness = witnesses.firstWhere(
        (w) => w.isPrimary,
        orElse: () => witnesses.first,
      );
    }

    // Create list of WitnessData for all witnesses (with paths, so just skip this one)
    // final List<WitnessData> witnessDataList = ... (Removed as unused)

    // Convert bike image filename to full path
    String bikeImagePath = '';
    if (bike.imageFilename != null && bike.imageFilename!.isNotEmpty) {
      bikeImagePath = _fileService.getBikeImagePath(bike.imageFilename!);
    }

    // Convert customer profile image filename to full path
    String? customerImagePath;
    if (customer.profileImageFilename != null && customer.profileImageFilename!.trim().isNotEmpty) {
      customerImagePath = _fileService.getCustomerProfileImagePath(
        customer.profileImageFilename!,
        customer.cnicNumber,
      );
    }

    // Convert witness CNIC image filename to full path (for backward compatibility)
    String? primaryWitnessCnicPath;
    if (primaryWitness?.cnicFrontFilename != null && primaryWitness!.cnicFrontFilename!.isNotEmpty) {
      primaryWitnessCnicPath = _fileService.getWitnessCnicImagePath(
        primaryWitness.cnicFrontFilename!,
        customer.cnicNumber,
      );
    }

    // Update witness data list with full image paths
    final List<WitnessData> witnessDataListWithPaths = witnesses.map((w) => WitnessData(
      fullName: w.fullName,
      cnicNumber: w.cnicNumber,
      phoneNumber: w.phoneNumber,
      address: w.address,
      cnicFrontFilename: w.cnicFrontFilename != null && w.cnicFrontFilename!.isNotEmpty
        ? _fileService.getWitnessCnicImagePath(w.cnicFrontFilename!, customer.cnicNumber)
        : null,
      isPrimary: w.isPrimary,
    )).toList();

    return SaleCardData(
      bikeModel: '${bike.brand} ${bike.model}',
      bikeImage: bikeImagePath,
      bikeChassisNumber: bike.chassisNumber,
      bikeEngineNumber: bike.engineNumber,
      customerName: customer.fullName,
      customerCnic: customer.cnicNumber,
      customerContact: customer.phoneNumber,
      purchaserImage: customerImagePath,
      customerAddress: customer.address ?? '',
      saleDate: formattedDate,
      amountPaid: await _calculateAmountPaid(sale, contract, isar),
      bikePrice: contract?.cashPrice ?? sale.totalAmount,
      sellingPrice: contract?.totalAmount,
      amountRemaining: contract?.remainingBalance,
      isCash: sale.saleType == SaleType.cash,
      installmentDuration: contract?.months,
      installmentMonthlyPayment: contract?.monthlyEMI,
      installmentDueDate: installmentDueDate,
      witnessName: primaryWitness?.fullName,
      witnessCnic: primaryWitness?.cnicNumber,
      witnessPhone: primaryWitness?.phoneNumber,
      witnessImage: primaryWitnessCnicPath,
      witnesses: witnessDataListWithPaths.isNotEmpty ? witnessDataListWithPaths : null,
      isInstallmentCompleted: contract?.status == ContractStatusEnum.completed,
    );
  }

  Future<double> _calculateAmountPaid(Sale sale, InstallmentContract? contract, Isar isar) async {
    if (sale.saleType == SaleType.cash) {
      // For cash sales, if receivedAmount is 0, assume full payment (migration fix)
      return sale.receivedAmount > 0 ? sale.receivedAmount : sale.totalAmount;
    } else if (contract != null) {
      // Use the cached totalPaid from the contract model
      return contract.totalPaid;
    }
    return 0;
  }

  /// Calculate dashboard statistics
  Future<Map<String, dynamic>> calculateDashboardStats() async {
    final isar = _isarService.isar;
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final firstDayOfMonth = DateTime(now.year, now.month, 1);

    // Total daily sales (today)
    final todaySales = await isar.sales
        .filter()
        .saleDateBetween(today, now)
        .findAll();
    final totalDailySales = todaySales.fold<double>(
      0, 
      (sum, sale) => sum + sale.receivedAmount,
    );

    // Yesterday's sales for growth calculation
    final yesterdaySales = await isar.sales
        .filter()
        .saleDateBetween(yesterday, today)
        .findAll();
    final yesterdayTotal = yesterdaySales.fold<double>(
      0, 
      (sum, sale) => sum + sale.receivedAmount,
    );

    // Calculate daily growth percentage
    double dailyGrowth = 0;
    if (yesterdayTotal > 0) {
      dailyGrowth = ((totalDailySales - yesterdayTotal) / yesterdayTotal) * 100;
    } else if (totalDailySales > 0) {
      dailyGrowth = 100; // If no sales yesterday but today has sales
    }

    // Pending installments (sum of remaining balances)
    final activeContracts = await isar.installmentContracts
        .filter()
        .statusEqualTo(ContractStatusEnum.active)
        .findAll();
    
    final pendingInstallments = activeContracts.fold<double>(
      0, 
      (sum, contract) => sum + contract.remainingBalance,
    );

    // Overdue installments count
    // An installment is overdue if the current date is past the due date
    // We need to calculate the current due date based on contract start and months passed
    int overdueCount = 0;
    for (var contract in activeContracts) {
      // Simple check: if first due date has passed and remaining balance > 0
      if (now.isAfter(contract.firstDueDate) && contract.remainingBalance > 0) {
        // More sophisticated logic could track individual installment payments
        overdueCount++;
      }
    }

    // Active contracts count
    final activeContractsCount = activeContracts.length;

    // New contracts this month
    final newContractsThisMonth = await isar.installmentContracts
        .filter()
        .contractDateBetween(firstDayOfMonth, now)
        .count();

    // Monthly revenue (all sales this month)
    final monthlySales = await isar.sales
        .filter()
        .saleDateBetween(firstDayOfMonth, now)
        .findAll();
    final monthlyRevenue = monthlySales.fold<double>(
      0, 
      (sum, sale) => sum + sale.receivedAmount,
    );

    // Revenue on track (simple heuristic: projected monthly revenue based on days passed)
    final daysInMonth = DateTime(now.year, now.month + 1, 0).day;
    final daysPassed = now.day;
    final projectedRevenue = (monthlyRevenue / daysPassed) * daysInMonth;
    const monthlyTarget = 8400000.0; // You can make this configurable
    final isRevenueOnTrack = projectedRevenue >= monthlyTarget * 0.9; // 90% threshold

    return {
      'totalDailySales': totalDailySales,
      'dailyGrowth': dailyGrowth,
      'pendingInstallments': pendingInstallments,
      'overdueInstallments': overdueCount,
      'activeContracts': activeContractsCount,
      'newContractsMonth': newContractsThisMonth,
      'monthlyRevenue': monthlyRevenue,
      'isRevenueOnTrack': isRevenueOnTrack,
    };
  }

  /// Get weekly sales data for performance chart (last 7 days)
  Future<List<double>> getWeeklySalesData() async {
    final isar = _isarService.isar;
    final now = DateTime.now();
    final List<double> weeklyCounts = List.filled(7, 0);
    
    for (int i = 0; i < 7; i++) {
      final date = now.subtract(Duration(days: 6 - i));
      final startOfDay = DateTime(date.year, date.month, date.day);
      final endOfDay = startOfDay.add(const Duration(days: 1));
      
      final count = await isar.sales
          .filter()
          .saleDateBetween(startOfDay, endOfDay)
          .count();
      
      weeklyCounts[i] = count.toDouble();
    }
    
    return weeklyCounts;
  }

  /// Get today's sales count
  Future<int> getTodaySalesCount() async {
    final isar = _isarService.isar;
    final now = DateTime.now();
    final startOfDay = DateTime(now.year, now.month, now.day);
    final endOfDay = startOfDay.add(const Duration(days: 1));
    
    return await isar.sales
        .filter()
        .saleDateBetween(startOfDay, endOfDay)
        .count();
  }

  /// Get stock allocation data (new vs pre-owned)
  /// Note: Currently all bikes are treated as new models since isPreOwned property doesn't exist
  Future<Map<String, dynamic>> getStockAllocation() async {
    final isar = _isarService.isar;
    final allBikes = await isar.bikes.where().findAll();
    
    // For now, treat all bikes as new models
    // TODO: Add isPreOwned field to Bike model or use another differentiation
    int newModels = allBikes.length;
    int preOwned = 0;
    
    final total = newModels + preOwned;
    
    return {
      'newModelsCount': newModels,
      'preOwnedCount': preOwned,
      'newModelsPercent': total > 0 ? 100.0 : 0.0, // All are new for now
      'preOwnedPercent': 0.0,
    };
  }

  /// Calculate total asset value (all bikes' purchase prices)
  Future<double> calculateTotalAssetValue() async {
    final isar = _isarService.isar;
    final bikes = await isar.bikes.where().findAll();
    double total = 0;
    
    for (var bike in bikes) {
      total += bike.purchasePrice;
    }
    
    return total;
  }

  /// Get low stock alert count (models with less than 5 available units)
  Future<int> getLowStockAlert() async {
    final isar = _isarService.isar;
    final bikes = await isar.bikes
        .filter()
        .statusEqualTo(BikeStatusEnum.available)
        .findAll();
    
    Map<String, int> modelCounts = {};
    for (var bike in bikes) {
      modelCounts[bike.model] = (modelCounts[bike.model] ?? 0) + 1;
    }
    
    int lowStockModels = 0;
    for (var count in modelCounts.values) {
      if (count < 5) lowStockModels++;
    }
    
    return lowStockModels;
  }
}

// Authored by: Moazzam Samoo
