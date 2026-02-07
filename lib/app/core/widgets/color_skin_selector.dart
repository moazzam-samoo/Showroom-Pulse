import 'package:flutter/material.dart';
import 'package:tahir_showroom/app/core/constants/app_colors.dart';

class ColorSkinSelector extends StatefulWidget {
  final String? initialValue;
  final Function(String) onChanged;
  final String? Function(String?)? validator;

  const ColorSkinSelector({
    super.key,
    this.initialValue,
    required this.onChanged,
    this.validator,
  });

  @override
  State<ColorSkinSelector> createState() => _ColorSkinSelectorState();
}

class _ColorSkinSelectorState extends State<ColorSkinSelector> {
  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;
  bool _isOpen = false;
  String _activeTab = 'colors'; // 'colors' or 'skins'
  String? _selectedValue;

  // Color options
  final List<String> _colors = [
    'Red', 'Black', 'Blue', 'Silver', 'White',
    'Grey', 'Green', 'Yellow', 'Orange', 'Purple', 'Maroon'
  ];

  // Skin pattern options
  final List<String> _skins = [
    'Lion Skin', 'Zebra Skin', 'Cheetah Skin',
    'Tiger Skin', 'Leopard Skin', 'Snake Skin'
  ];

  @override
  void initState() {
    super.initState();
    _selectedValue = widget.initialValue;
  }

  @override
  void dispose() {
    _closeDropdown();
    super.dispose();
  }

  void _toggleDropdown() {
    if (_isOpen) {
      _closeDropdown();
    } else {
      _openDropdown();
    }
  }

  void _openDropdown() {
    _overlayEntry = _createOverlayEntry();
    Overlay.of(context).insert(_overlayEntry!);
    setState(() => _isOpen = true);
  }

  void _closeDropdown() {
    _overlayEntry?.remove();
    _overlayEntry = null;
    setState(() => _isOpen = false);
  }

  void _selectValue(String value) {
    setState(() => _selectedValue = value);
    widget.onChanged(value);
    _closeDropdown();
  }

  OverlayEntry _createOverlayEntry() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final renderBox = context.findRenderObject() as RenderBox;
    final size = renderBox.size;
    final offset = renderBox.localToGlobal(Offset.zero);

    return OverlayEntry(
      builder: (context) => GestureDetector(
        onTap: _closeDropdown,
        behavior: HitTestBehavior.translucent,
        child: Stack(
          children: [
            Positioned(
              left: offset.dx,
              top: offset.dy + size.height + 4,
              width: size.width,
              child: CompositedTransformFollower(
                link: _layerLink,
                showWhenUnlinked: false,
                offset: Offset(0, size.height + 4),
                child: Material(
                  elevation: 8,
                  borderRadius: BorderRadius.circular(12),
                  color: isDark ? AppColors.darkElevated : Colors.white,
                  child: Container(
                    constraints: const BoxConstraints(maxHeight: 320),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isDark ? AppColors.darkBorderInput : AppColors.lightBorder,
                      ),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Tab Header
                        Container(
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                color: isDark ? AppColors.darkBorderInput : AppColors.lightBorder,
                              ),
                            ),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: _buildTab('Colors', 'colors', isDark),
                              ),
                              Expanded(
                                child: _buildTab('Skins', 'skins', isDark),
                              ),
                            ],
                          ),
                        ),
                        // Content
                        Flexible(
                          child: _buildContent(isDark),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTab(String label, String tabKey, bool isDark) {
    final isActive = _activeTab == tabKey;
    final activeColor = isDark ? AppColors.darkPrimary : AppColors.lightPrimary;

    return GestureDetector(
      onTap: () {
        setState(() => _activeTab = tabKey);
        _overlayEntry?.markNeedsBuild();
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isActive ? activeColor.withOpacity(0.1) : Colors.transparent,
          border: Border(
            bottom: BorderSide(
              color: isActive ? activeColor : Colors.transparent,
              width: 2,
            ),
          ),
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: isActive ? activeColor : (isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary),
            fontWeight: isActive ? FontWeight.bold : FontWeight.w500,
            fontSize: 14,
          ),
        ),
      ),
    );
  }

  Widget _buildContent(bool isDark) {
    final items = _activeTab == 'colors' ? _colors : _skins;

    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 8),
      shrinkWrap: true,
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        final isSelected = item == _selectedValue;

        return InkWell(
          onTap: () => _selectValue(item),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: isSelected
                  ? (isDark ? AppColors.darkPrimary.withOpacity(0.2) : AppColors.lightPrimary.withOpacity(0.1))
                  : Colors.transparent,
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    item,
                    style: TextStyle(
                      color: isSelected
                          ? (isDark ? AppColors.darkPrimary : AppColors.lightPrimary)
                          : (isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary),
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                    ),
                  ),
                ),
                if (isSelected)
                  Icon(
                    Icons.check,
                    size: 20,
                    color: isDark ? AppColors.darkPrimary : AppColors.lightPrimary,
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark ? AppColors.darkElevated : AppColors.lightBackground;
    final border = isDark ? AppColors.darkBorderInput : AppColors.lightBorder;

    return CompositedTransformTarget(
      link: _layerLink,
      child: GestureDetector(
        onTap: _toggleDropdown,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: _isOpen
                  ? (isDark ? AppColors.darkPrimary : AppColors.lightPrimary)
                  : border,
              width: _isOpen ? 2 : 1,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                _selectedValue ?? 'Select Color or Skin',
                style: TextStyle(
                  color: _selectedValue != null
                      ? (isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary)
                      : (isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted),
                ),
              ),
              Icon(
                _isOpen ? Icons.arrow_drop_up : Icons.arrow_drop_down,
                color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
