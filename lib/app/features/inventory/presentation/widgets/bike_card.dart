import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:intl/intl.dart';
import 'package:flutter/services.dart';
import 'package:tahir_showroom/app/core/utils/thousands_separator_input_formatter.dart';

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
  final bool compact;

  const BikeCard({
    super.key,
    required this.bike,
    this.onTap,
    this.onEdit,
    this.onDelete,
    this.compact = false,
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
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              // Base subtle shadow always present
              BoxShadow(
                color: Colors.black.withOpacity(isDark ? 0.3 : 0.05),
                blurRadius: 12,
                spreadRadius: 0,
                offset: const Offset(0, 4),
              ),
              // Attractive colored shadow when hovered
              if (_isHovered)
                BoxShadow(
                  color: primaryColor.withOpacity(isDark ? 0.4 : 0.25),
                  blurRadius: isDark ? 25 : 20,
                  spreadRadius: isDark ? 2 : 1,
                  offset: const Offset(0, 8),
                ),
            ],
            border: Border.all(
              color: isDark 
                  ? (_isHovered ? primaryColor.withOpacity(0.5) : const Color(0xFF424242)) // Grey 800
                  : (_isHovered ? primaryColor.withOpacity(0.5) : AppColors.lightBorder),
              width: 1,
            ),
          ),
          clipBehavior: Clip.antiAlias,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // 1. Image Area
              Stack(
                children: [
                  // Image
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                    child: SizedBox(
                      height: 150, // Match SaleCard exact dimension
                      width: double.infinity,
                      child: Hero(
                        tag: 'bike_${widget.bike.engineNumber}',
                        child: widget.bike.imageFilename != null
                            ? Image.file(
                                File(widget.bike.imageFilename!),
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) => _buildPlaceholder(isDark),
                              )
                            : _buildPlaceholder(isDark),
                      ),
                    ),
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
                      top: widget.compact ? 4 : 10,
                      left: widget.compact ? 4 : 10,
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: widget.compact ? 4 : 10,
                          vertical: widget.compact ? 1 : 4,
                        ),
                        decoration: BoxDecoration(
                          color: _getStatusColor(widget.bike.status),
                          borderRadius: BorderRadius.circular(widget.compact ? 8 : 12),
                          boxShadow: [
                            BoxShadow(color: Colors.black.withOpacity(0.3), blurRadius: 4, offset: const Offset(0, 2))
                          ],
                        ),
                        child: Text(
                          _getStatusText(widget.bike.status),
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: widget.compact ? 8 : 10,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                    ),

                    // Actions (Hide in compact mode)
                    if (!widget.compact)
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

              // 2. Info Area
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12), // Same padding as SaleCard
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Model & Color
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              "${widget.bike.brand} ${widget.bike.model}",
                              style: TextStyle(
                                fontSize: widget.compact ? 14 : 16,
                                fontWeight: FontWeight.bold,
                                color: isDark ? Colors.white : Colors.black87,
                                height: 1.1,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Row(
                            children: [
                              Text(
                                widget.bike.color,
                                style: TextStyle(
                                  fontSize: widget.compact ? 10 : 12,
                                  color: isDark ? Colors.white70 : Colors.black54,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              SizedBox(width: widget.compact ? 4 : 6),
                              _buildColorIndicator(widget.bike.color, widget.compact, isDark),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(height: widget.compact ? 4 : 10),

                      // Specs Container
                      Container(
                        padding: EdgeInsets.all(widget.compact ? 4 : 8),
                        decoration: BoxDecoration(
                          color: isDark ? Colors.black26 : Colors.grey[100],
                          borderRadius: BorderRadius.circular(widget.compact ? 4 : 6),
                          border: Border.all(color: isDark ? Colors.white10 : Colors.grey[300]!),
                        ),
                        child: Column(
                          children: [
                            _buildSpecRow("Engine", widget.bike.engineNumber, isDark),
                            SizedBox(height: widget.compact ? 2 : 4),
                            Divider(height: widget.compact ? 1 : 4, thickness: 1, color: isDark ? Colors.white10 : Colors.grey[300]),
                            SizedBox(height: widget.compact ? 2 : 4),
                            _buildSpecRow("Chassis", widget.bike.chassisNumber, isDark),
                          ],
                        ),
                      ),
                      
                      const SizedBox(height: 12), // Push the price down instead of using Spacer()

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
                                style: TextStyle(
                                  fontSize: widget.compact ? 8 : 9,
                                  color: isDark ? Colors.grey[500] : Colors.grey[600],
                                ),
                              ),
                              Text(
                                currencyFormat.format(widget.bike.purchasePrice),
                                style: TextStyle(
                                  fontSize: widget.compact ? 11 : 12,
                                  fontWeight: FontWeight.w600,
                                  color: isDark ? Colors.white70 : Colors.black87,
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
                                    style: TextStyle(
                                      fontSize: widget.compact ? 8 : 9,
                                      color: primaryColor.withOpacity(0.8),
                                    ),
                                  ),
                                  Text(
                                    currencyFormat.format(widget.bike.cashSalePrice),
                                    style: TextStyle(
                                      fontSize: widget.compact ? 14 : 16,
                                      fontWeight: FontWeight.w800,
                                      color: primaryColor,
                                    ),
                                  ),
                                ],
                              )
                            : InkWell(
                                onTap: () => _showSetPriceDialog(context),
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: widget.compact ? 4 : 10,
                                    vertical: widget.compact ? 2 : 6,
                                  ),
                                  decoration: BoxDecoration(
                                    color: primaryColor.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(widget.compact ? 4 : 6),
                                    border: Border.all(color: primaryColor),
                                  ),
                                  child: Row(
                                    children: [
                                      Icon(
                                        LucideIcons.plusCircle,
                                        size: widget.compact ? 12 : 14,
                                        color: primaryColor,
                                      ),
                                      SizedBox(width: widget.compact ? 3 : 4),
                                      Text(
                                        "Set Price",
                                        style: TextStyle(
                                          fontSize: widget.compact ? 10 : 12,
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
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            ThousandsSeparatorInputFormatter()
          ],
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
              final price = double.tryParse(controller.text.replaceAll(',', '')) ?? 0.0;
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
            fontSize: widget.compact ? 8 : 9,
            fontWeight: FontWeight.w600,
            color: isDark ? Colors.grey[500] : Colors.grey[600],
            letterSpacing: 0.5,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: widget.compact ? 10 : 11,
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

  String _getStatusText(BikeStatusEnum status) {
    if (status.name.toLowerCase() == 'installment') return 'INSTALLMENT (RESERVED)';
    if (status.name.toLowerCase() == 'sold') return 'SOLD (NOT AVAILABLE)';
    return status.name.toUpperCase();
  }

  Widget _buildColorIndicator(String colorName, bool compact, bool isDark) {
    List<Color> colors = _getColors(colorName);
    
    return Container(
      width: compact ? 12 : 14,
      height: compact ? 12 : 14,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        // Use gradient if multiple colors, otherwise solid color
        gradient: colors.length > 1 
            ? LinearGradient(
                colors: colors,
                // Create hard stops for distinct separation (e.g. zebra stripes)
                stops: _generateStops(colors.length),
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              )
            : null,
        color: colors.length == 1 ? colors.first : null,
        border: Border.all(
          color: isDark ? Colors.white38 : Colors.grey[400]!, 
          width: 1.5
        ),
      ),
    );
  }

  List<double> _generateStops(int count) {
    // Generate even stops for sharp transitions if needed, 
    // or smooth gradient. For skins like zebra/lion, sharp transitions look better.
    // However, LinearGradient wraps smoothly. Text request implied "divided into parts".
    // Let's use a simpler LinearGradient for now which naturally divides the space.
    if (count == 2) return [0.4, 0.6]; // Slight blur in middle
    return List.generate(count, (index) => index / (count - 1));
  }

  List<Color> _getColors(String colorName) {
    switch (colorName.toLowerCase()) {
      // Solid Colors
      case 'red': return [Colors.red];
      case 'black': return [Colors.black];
      case 'blue': return [Colors.blue];
      case 'silver': return [const Color(0xFFC0C0C0)];
      case 'white': return [Colors.white];
      case 'green': return [Colors.green];
      case 'grey': return [Colors.grey];
      case 'yellow': return [Colors.yellow];
      case 'orange': return [Colors.orange];
      case 'purple': return [Colors.purple];
      case 'maroon': return [const Color(0xFF800000)];
      
      // Skins (Multi-color)
      case 'lion skin': 
        return [Colors.black, const Color(0xFFFFD700)]; // Black & Gold/Yellow
      case 'zebra skin': 
        return [Colors.black, Colors.white]; // Black & White
      case 'cheetah skin': 
        return [const Color(0xFFD2691E), const Color(0xFFFFD700)]; // Chocolate & Gold
      case 'tiger skin': 
        return [const Color(0xFFFFA500), Colors.black]; // Orange & Black
      case 'leopard skin': 
        return [const Color(0xFFFFD700), Colors.black]; // Gold & Black
      case 'snake skin': 
        return [const Color(0xFF556B2F), const Color(0xFF8B4513)]; // Dark Olive Green & Saddle Brown
      
      default: return [Colors.transparent];
    }
  }
}
