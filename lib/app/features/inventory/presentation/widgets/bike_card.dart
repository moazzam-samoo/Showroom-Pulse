import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:intl/intl.dart';

import 'package:tahir_showroom/app/core/constants/app_colors.dart';
import 'package:tahir_showroom/app/data/models/bike.dart';
import 'package:tahir_showroom/app/features/inventory/presentation/controllers/inventory_controller.dart';

/// Bike Card Widget for Inventory Grid (Pro Max UI - Compact v2)
/// 
/// Enhancements:
/// - Compact Layout (Reduced whitespace)
/// - Highlighted Specs (Engine & Chassis)
/// - Dual Price Display (Purchase & Selling)
/// - Quick Price Update for Procurement Items
class BikeCard extends StatefulWidget {
  final Bike bike;
  final VoidCallback? onTap;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const BikeCard({
    super.key,
    required this.bike,
    this.onTap,
    this.onEdit,
    this.onDelete,
  });

  @override
  State<BikeCard> createState() => _BikeCardState();
}

class _BikeCardState extends State<BikeCard> {
  bool _isHovered = false;
  final currencyFormat = NumberFormat.currency(locale: 'en_PK', symbol: 'Rs ', decimalDigits: 0);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    // Pro Max Colors
    final cardBg = isDark ? const Color(0xFF1E293B) : Colors.white;
    final primaryColor = const Color(0xFF00ACC1); // Cyan
    
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          transform: _isHovered ? Matrix4.identity().scaled(1.02) : Matrix4.identity(),
          decoration: BoxDecoration(
            color: cardBg,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: isDark ? Colors.black.withOpacity(0.3) : Colors.black.withOpacity(0.1),
                blurRadius: _isHovered ? 12 : 8,
                offset: const Offset(0, 4),
              ),
            ],
            border: Border.all(
              color: isDark 
                  ? (_isHovered ? primaryColor.withOpacity(0.5) : const Color(0xFF424242)) // Grey 800
                  : AppColors.lightBorder,
              width: 1,
            ),
          ),
          clipBehavior: Clip.antiAlias,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // 1. Image Area (Expanded to fill more space)
              Expanded(
                flex: 5, 
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    // Image
                    Hero(
                      tag: 'bike_${widget.bike.engineNumber}',
                      child: widget.bike.imageFilename != null
                          ? Image.file(
                              File(widget.bike.imageFilename!),
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => _buildPlaceholder(isDark),
                            )
                          : _buildPlaceholder(isDark),
                    ),
                    
                    // Gradient Overlay
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      height: 50,
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              Colors.black.withOpacity(0.6),
                            ],
                          ),
                        ),
                      ),
                    ),

                    // Status Badge
                    Positioned(
                      top: 10,
                      left: 10,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: _getStatusColor(widget.bike.status),
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(color: Colors.black.withOpacity(0.3), blurRadius: 4, offset: const Offset(0, 2))
                          ],
                        ),
                        child: Text(
                          widget.bike.status.name.toUpperCase(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                    ),

                    // Actions
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Row(
                        children: [
                          if (widget.onEdit != null)
                            _buildGlassButton(LucideIcons.pencil, widget.onEdit!, isDark),
                          if (widget.onDelete != null) 
                            _buildGlassButton(LucideIcons.trash2, widget.onDelete!, isDark, isDestructive: true),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // 2. Info Area
              Expanded(
                flex: 4,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Model & Color
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              widget.bike.model,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: isDark ? Colors.white : Colors.black87,
                                height: 1.1,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Container(
                            width: 14,
                            height: 14,
                            decoration: BoxDecoration(
                              color: _getColor(widget.bike.color),
                              shape: BoxShape.circle,
                              border: Border.all(color: isDark ? Colors.white38 : Colors.grey[400]!, width: 1.5),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),

                      // Specs Container
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: isDark ? Colors.black26 : Colors.grey[100],
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(color: isDark ? Colors.white10 : Colors.grey[300]!),
                        ),
                        child: Column(
                          children: [
                            _buildSpecRow("Engine", widget.bike.engineNumber, isDark),
                            const SizedBox(height: 4),
                            Divider(height: 4, thickness: 1, color: isDark ? Colors.white10 : Colors.grey[300]),
                            const SizedBox(height: 4),
                            _buildSpecRow("Chassis", widget.bike.chassisNumber, isDark),
                          ],
                        ),
                      ),
                      
                      const Spacer(),

                      // Price Section
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          // Purchase Price (Info)
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Purchase',
                                style: TextStyle( fontSize: 9, color: isDark ? Colors.grey[500] : Colors.grey[600] ),
                              ),
                              Text(
                                currencyFormat.format(widget.bike.purchasePrice),
                                style: TextStyle(
                                  fontSize: 12, // Slightly larger
                                  fontWeight: FontWeight.w600, // Semi-bold
                                  color: isDark ? Colors.white70 : Colors.black87, // Clearer color
                                ),
                              ),
                            ],
                          ),
                          
                          // Selling Price or "Set Price"
                          widget.bike.cashSalePrice > 0 
                            ? Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    'Sale Price',
                                    style: TextStyle( fontSize: 9, color: primaryColor.withOpacity(0.8) ),
                                  ),
                                  Text(
                                    currencyFormat.format(widget.bike.cashSalePrice),
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w800,
                                      color: primaryColor,
                                    ),
                                  ),
                                ],
                              )
                            : InkWell(
                                onTap: () => _showSetPriceDialog(context),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                  decoration: BoxDecoration(
                                    color: primaryColor.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(6),
                                    border: Border.all(color: primaryColor),
                                  ),
                                  child: Row(
                                    children: [
                                      Icon(LucideIcons.plusCircle, size: 14, color: primaryColor),
                                      const SizedBox(width: 4),
                                      Text(
                                        "Set Price",
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                          color: primaryColor,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showSetPriceDialog(BuildContext context) {
    final controller = TextEditingController();
    final inventoryController = Get.find<InventoryController>();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Set Selling Price"),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          autofocus: true,
          decoration: const InputDecoration(
            labelText: "Amount (Rs)",
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text("Cancel")),
          ElevatedButton(
            onPressed: () {
              final price = double.tryParse(controller.text) ?? 0.0;
              if (price > 0) {
                inventoryController.updateBikePrice(widget.bike, price);
                Navigator.pop(ctx);
              }
            },
            child: const Text("Save"),
          ),
        ],
      ),
    );
  }

  Widget _buildSpecRow(String label, String value, bool isDark) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label.toUpperCase(),
          style: TextStyle(
            fontSize: 9,
            fontWeight: FontWeight.w600,
            color: isDark ? Colors.grey[500] : Colors.grey[600],
            letterSpacing: 0.5,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 11,
            fontFamily: 'Monospace',
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.grey[300] : Colors.grey[800],
          ),
        ),
      ],
    );
  }

  Widget _buildPlaceholder(bool isDark) {
    return Container(
      color: isDark ? const Color(0xFF0F172A) : Colors.grey[200],
      child: Center(
        child: Icon(
          LucideIcons.bike,
          size: 32,
          color: isDark ? Colors.grey[700] : Colors.grey[400],
        ),
      ),
    );
  }

  Widget _buildGlassButton(IconData icon, VoidCallback onTap, bool isDark, {bool isDestructive = false}) {
    return Padding(
      padding: const EdgeInsets.only(left: 4),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20),
          child: Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: isDark ? Colors.black54 : Colors.white.withOpacity(0.9),
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white24, width: 0.5),
            ),
            child: Icon(
              icon,
              size: 14,
              color: isDestructive ? Colors.redAccent : (isDark ? Colors.white : Colors.black54),
            ),
          ),
        ),
      ),
    );
  }

  Color _getStatusColor(BikeStatusEnum status) {
    switch (status) {
      case BikeStatusEnum.available:
        return const Color(0xFF10B981); // Emerald
      case BikeStatusEnum.sold:
        return const Color(0xFFEF4444); // Red
      case BikeStatusEnum.installment:
        return const Color(0xFFF59E0B); // Amber
      default:
        return Colors.grey;
    }
  }

  Color _getColor(String colorName) {
    switch (colorName.toLowerCase()) {
      case 'red': return Colors.red;
      case 'black': return Colors.black;
      case 'blue': return Colors.blue;
      case 'silver': return const Color(0xFFC0C0C0);
      case 'white': return Colors.white;
      case 'green': return Colors.green;
      case 'grey': return Colors.grey;
      default: return Colors.transparent;
    }
  }
}
