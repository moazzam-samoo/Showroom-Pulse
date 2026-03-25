import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tahir_showroom/app/data/models/investment.dart';

class InvestmentHistoryCard extends StatelessWidget {
  final Investment investment;
  final VoidCallback? onTap;

  const InvestmentHistoryCard({
    super.key,
    required this.investment,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat.currency(locale: 'en_PK', symbol: 'Rs ', decimalDigits: 0);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final bgCol = isDark ? const Color(0xFF1E293B) : Colors.white;
    final textCol = isDark ? Colors.white : const Color(0xFF0F172A);
    final borderCol = isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0);

    // Color and Icon Logic
    Color typeColor;
    IconData typeIcon;
    String typeLabel;

    switch (investment.type) {
      case InvestmentTypeEnum.capitalInjection:
        typeColor = Colors.green;
        typeIcon = Icons.arrow_downward;
        typeLabel = 'Capital Added';
        break;
      case InvestmentTypeEnum.bikePurchase:
        typeColor = Colors.red;
        typeIcon = Icons.motorcycle;
        typeLabel = 'Bike Purchase';
        break;
      case InvestmentTypeEnum.withdrawal:
        typeColor = Colors.orange;
        typeIcon = Icons.arrow_upward;
        typeLabel = 'Withdrawal';
        break;
      case InvestmentTypeEnum.bikeSale:
        typeColor = const Color(0xFF3B82F6); // Blue
        typeIcon = Icons.attach_money;
        typeLabel = 'Cash Sale Revenue';
        break;
      case InvestmentTypeEnum.installmentPayment:
        typeColor = const Color(0xFF06B6D4); // Teal/Cyan
        typeIcon = Icons.payments;
        typeLabel = 'Installment Payment';
        break;
    }

    if (investment.isLocked) {
      typeIcon = Icons.lock;
    }

    return Card(
      elevation: 0,
      color: bgCol,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: borderCol),
      ),
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              // Icon Circle
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: typeColor.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(typeIcon, color: typeColor),
              ),
              const SizedBox(width: 16),

              // Details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          typeLabel,
                          style: TextStyle(
                            color: textCol,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          currencyFormat.format(investment.amount),
                          style: TextStyle(
                            color: typeColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          DateFormat('dd MMM yyyy, hh:mm a').format(investment.date),
                          style: TextStyle(
                            color: textCol.withOpacity(0.6),
                            fontSize: 12,
                          ),
                        ),
                        if (investment.profitAmount > 0)
                          Text(
                            '+ ${currencyFormat.format(investment.profitAmount)} profit',
                            style: const TextStyle(
                              color: Colors.green,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                      ],
                    ),
                    if (investment.description != null && investment.description!.isNotEmpty) ...[
                      const SizedBox(height: 8),
                      Text(
                        investment.description!,
                        style: TextStyle(
                          color: textCol.withOpacity(0.8),
                          fontSize: 13,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Authored by: Moazzam Samoo
