import 'package:flutter/material.dart';

class InvestmentSummaryCard extends StatelessWidget {
  final String title;
  final String amount;
  final IconData icon;
  final Color color;
   final String? subtitle;
  final Widget? extraContent;
  final VoidCallback? onTap;

  const InvestmentSummaryCard({
    super.key,
    required this.title,
    required this.amount,
    required this.icon,
    required this.color,
    this.subtitle,
    this.extraContent,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    // Solid background for clarity
    final bgCol = isDark ? const Color(0xFF1E293B) : Colors.white;
    final textCol = isDark ? Colors.white : const Color(0xFF0F172A);
    final borderCol = isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(16), // Reduced from 20
          decoration: BoxDecoration(
            color: bgCol,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: borderCol),
          ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    color: textCol.withOpacity(0.6),
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.5,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: color, size: 20),
              ),
            ],
          ),
          const SizedBox(height: 12), // Reduced from 16
          Text(
            amount,
            style: TextStyle(
              color: textCol,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          if (subtitle != null) ...[
            const SizedBox(height: 6), // Reduced from 8
            Text(
              subtitle!,
              style: TextStyle(
                color: textCol.withOpacity(0.5),
                fontSize: 12,
              ),
            ),
          ],
          if (extraContent != null) ...[
            const SizedBox(height: 12),
            extraContent!,
          ],
        ],
      ),
    ),
    ),
    );
  }
}

// Authored by: Moazzam Samoo
