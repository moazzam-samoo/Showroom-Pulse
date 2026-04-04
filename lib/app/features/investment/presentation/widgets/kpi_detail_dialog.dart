import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// Reusable base dialog for KPI detail popups
class KpiDetailDialog extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color accentColor;
  final Widget body;
  final Widget? footer;

  const KpiDetailDialog({
    super.key,
    required this.title,
    required this.icon,
    required this.accentColor,
    required this.body,
    this.footer,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardCol = isDark ? const Color(0xFF1E293B) : Colors.white;
    final textCol = isDark ? Colors.white : const Color(0xFF0F172A);
    final borderCol = isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0);
    final screenSize = MediaQuery.of(context).size;

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.symmetric(
        horizontal: screenSize.width * 0.1,
        vertical: screenSize.height * 0.06,
      ),
      child: Container(
        constraints: BoxConstraints(
          maxWidth: screenSize.width * 0.75,
          maxHeight: screenSize.height * 0.85,
        ),
        decoration: BoxDecoration(
          color: cardCol,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: borderCol),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(isDark ? 0.5 : 0.15),
              blurRadius: 24,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF0F172A) : const Color(0xFFF1F5F9),
                borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                border: Border(bottom: BorderSide(color: borderCol)),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: accentColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(icon, color: accentColor, size: 22),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Text(
                      title,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: textCol,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: Icon(Icons.close, color: textCol.withOpacity(0.5)),
                    splashRadius: 20,
                  ),
                ],
              ),
            ),

            // Scrollable Body
            Expanded(
              child: ScrollConfiguration(
                behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: body,
                ),
              ),
            ),

            // Footer
            if (footer != null)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF0F172A) : const Color(0xFFF1F5F9),
                  borderRadius: const BorderRadius.vertical(bottom: Radius.circular(16)),
                  border: Border(top: BorderSide(color: borderCol)),
                ),
                child: footer!,
              ),
          ],
        ),
      ),
    );
  }
}

/// Reusable table header cell for KPI detail popups
class KpiTableHeaderCell extends StatelessWidget {
  final String text;
  final TextAlign align;

  const KpiTableHeaderCell(this.text, {super.key, this.align = TextAlign.left});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Text(
        text,
        textAlign: align,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.bold,
          color: isDark ? Colors.white70 : Colors.black87,
          letterSpacing: 0.3,
        ),
      ),
    );
  }
}

/// Reusable table data cell for KPI detail popups
class KpiTableCell extends StatelessWidget {
  final String text;
  final Color? color;
  final bool bold;
  final TextAlign align;

  const KpiTableCell(this.text, {super.key, this.color, this.bold = false, this.align = TextAlign.left});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      child: Text(
        text,
        textAlign: align,
        style: TextStyle(
          fontSize: 12,
          color: color ?? (isDark ? Colors.white.withOpacity(0.85) : Colors.black87),
          fontWeight: bold ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    );
  }
}

/// Reusable funding breakdown row widget
class FundingBreakdownRow extends StatelessWidget {
  final double personal;
  final double partnership;
  final double other;
  final double loan;
  final NumberFormat currencyFormat;

  const FundingBreakdownRow({
    super.key,
    required this.personal,
    required this.partnership,
    required this.other,
    required this.loan,
    required this.currencyFormat,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final mutedColor = isDark ? Colors.white54 : Colors.black54;
    
    final items = <String>[];
    if (personal > 0) items.add('Personal: ${currencyFormat.format(personal)}');
    if (partnership > 0) items.add('Partnership: ${currencyFormat.format(partnership)}');
    if (other > 0) items.add('Other: ${currencyFormat.format(other)}');
    if (loan > 0) items.add('Loan: ${currencyFormat.format(loan)}');
    
    if (items.isEmpty) {
      return Text('No funding data', style: TextStyle(fontSize: 10, color: mutedColor, fontStyle: FontStyle.italic));
    }

    return Wrap(
      spacing: 12,
      runSpacing: 2,
      children: items.map((item) => Text(
        item,
        style: TextStyle(fontSize: 10, color: mutedColor),
      )).toList(),
    );
  }
}

/// Summary row (label + value) used in footer
class KpiSummaryRow extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;
  final bool bold;

  const KpiSummaryRow({
    super.key,
    required this.label,
    required this.value,
    this.valueColor,
    this.bold = false,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textCol = isDark ? Colors.white : const Color(0xFF0F172A);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(fontSize: 12, color: textCol.withOpacity(0.6))),
          Text(value, style: TextStyle(
            fontSize: 12,
            color: valueColor ?? textCol,
            fontWeight: bold ? FontWeight.bold : FontWeight.w600,
          )),
        ],
      ),
    );
  }
}
