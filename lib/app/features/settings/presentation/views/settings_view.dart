import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/widgets/sidebar_navigation.dart';
import '../../../../core/services/walkthrough_service.dart';
import '../../../walkthrough/presentation/widgets/coach_mark_overlay.dart';
import '../../../walkthrough/presentation/widgets/coach_mark_target.dart';
import '../controllers/settings_controller.dart';
import '../widgets/financial_settings_view.dart';
import '../widgets/database_settings_view.dart';
import '../widgets/general_settings_view.dart';
import '../widgets/profile_settings_view.dart';

class SettingsView extends StatefulWidget {
  const SettingsView({super.key});

  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  final int _selectedNavIndex = 7; // Settings is index 7 in main sidebar

  // Coach mark keys
  final GlobalKey _categorySidebarKey = GlobalKey();
  final GlobalKey _markupSliderKey = GlobalKey();
  final GlobalKey _lateFeeToggleKey = GlobalKey();
  final GlobalKey _exportDatabaseKey = GlobalKey();
  final GlobalKey _importDatabaseKey = GlobalKey();
  final GlobalKey _profilePicUploadKey = GlobalKey();
  final GlobalKey _ownerNameInputKey = GlobalKey();
  final GlobalKey _replayTourKey = GlobalKey();

  bool _showCoachMarks = false;

  @override
  void initState() {
    super.initState();
    _checkWalkthroughStatus();
  }

  Future<void> _checkWalkthroughStatus() async {
    final walkthroughService = Get.find<WalkthroughService>();
    if (!walkthroughService.hasCompletedTab('settings')) {
      Future.delayed(const Duration(milliseconds: 500), () {
        if (mounted) {
          setState(() {
            _showCoachMarks = true;
          });
        }
      });
    }
  }

  void _completeTour() {
    setState(() {
      _showCoachMarks = false;
    });
    Get.find<WalkthroughService>().markTabComplete('settings');
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final controller = Get.find<SettingsController>();

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.lightBackground,
      body: Stack(
        children: [
          Row(
            children: [
              // ═══ Main App Sidebar (same as every other page) ═══
              SidebarNavigation(
                selectedIndex: _selectedNavIndex,
                onItemSelected: (index) {
                  // We handle settings sidebar logic here
                  switch (index) {
                    case 0: Get.offNamed('/dashboard'); break;
                    case 1: Get.offNamed('/procurement'); break;
                    case 2: Get.offNamed('/inventory'); break;
                    case 3: Get.offNamed('/sales'); break;
                    case 4: Get.offNamed('/installments'); break;
                    case 5: Get.offNamed('/customers'); break;
                    case 6: Get.offNamed('/reports'); break;
                    case 7: break; // Already on Settings
                  }
                },
              ),

              // ═══ Settings Content Area ═══
              Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ─── Settings Category Sidebar ───
                    Container(
                      key: _categorySidebarKey,
                      width: 220,
                      margin: const EdgeInsets.fromLTRB(AppSpacing.lg, AppSpacing.lg, 0, AppSpacing.lg),
                      decoration: BoxDecoration(
                        color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isDark ? AppColors.darkBorder : AppColors.lightBorderLight,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(AppSpacing.lg, AppSpacing.lg, AppSpacing.lg, AppSpacing.sm),
                            child: Text(
                              'Settings',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                              ),
                            ),
                          ),
                          const SizedBox(height: AppSpacing.sm),
                          _buildCategoryItem(controller, 'Financials', LucideIcons.percent, isDark),
                          _buildCategoryItem(controller, 'Database', LucideIcons.database, isDark),
                          _buildCategoryItem(controller, 'Profile', LucideIcons.user, isDark),
                          _buildCategoryItem(controller, 'General', LucideIcons.settings, isDark),
                        ],
                      ),
                    ),

                    // ─── Right Content Panel ───
                    Expanded(
                      child: Container(
                        margin: const EdgeInsets.all(AppSpacing.lg),
                        decoration: BoxDecoration(
                          color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isDark ? AppColors.darkBorder : AppColors.lightBorderLight,
                          ),
                        ),
                        child: Obx(() {
                          if (controller.isLoading.value) {
                            return const Center(child: CircularProgressIndicator());
                          }

                          switch (controller.selectedCategory.value) {
                            case 'Financials':
                              return FinancialSettingsView(
                                markupSliderKey: _markupSliderKey,
                                lateFeeToggleKey: _lateFeeToggleKey,
                              );
                            case 'Database':
                              return DatabaseSettingsView(
                                exportDatabaseKey: _exportDatabaseKey,
                                importDatabaseKey: _importDatabaseKey,
                              );
                            case 'Profile':
                              return ProfileSettingsView(
                                profilePicUploadKey: _profilePicUploadKey,
                                ownerNameInputKey: _ownerNameInputKey,
                              );
                            case 'General':
                              return GeneralSettingsView(
                                replayTourKey: _replayTourKey,
                              );
                            default:
                              return const Center(
                                child: Text('Select a category'),
                              );
                          }
                        }),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          // ─── Coach Marks Overlay ───
          if (_showCoachMarks)
            Positioned.fill(
              child: CoachMarkOverlay(
                targets: [
                  CoachMarkTarget(
                    targetKey: _categorySidebarKey,
                    title: 'Settings Navigation',
                    description: 'Switch between Financials, Database, Profile, and General settings.',
                    position: CoachMarkPosition.right,
                  ),
                  CoachMarkTarget(
                    targetKey: _markupSliderKey,
                    title: 'Default Installment Markup',
                    description: 'Set the default percentage markup pre-filled when creating installment sales.',
                    position: CoachMarkPosition.bottom,
                    onBeforeTarget: () async {
                      Get.find<SettingsController>().changeCategory('Financials');
                    },
                  ),
                  CoachMarkTarget(
                    targetKey: _lateFeeToggleKey,
                    title: 'Automatic Late Fee',
                    description: 'Enable/disable automatic penalty for overdue installment payments and set the percentage.',
                    position: CoachMarkPosition.bottom,
                  ),
                  CoachMarkTarget(
                    targetKey: _exportDatabaseKey,
                    title: 'Export Data',
                    description: 'Export your entire database (bikes, sales, customers) as a backup file.',
                    position: CoachMarkPosition.bottom,
                    onBeforeTarget: () async {
                      Get.find<SettingsController>().changeCategory('Database');
                    },
                  ),
                  CoachMarkTarget(
                    targetKey: _importDatabaseKey,
                    title: 'Import & Restore',
                    description: 'Restore data from a previously exported backup file.',
                    position: CoachMarkPosition.bottom,
                  ),
                  CoachMarkTarget(
                    targetKey: _profilePicUploadKey,
                    title: 'Owner Profile',
                    description: 'Upload your profile picture that appears on the dashboard greeting.',
                    position: CoachMarkPosition.bottom,
                    onBeforeTarget: () async {
                      Get.find<SettingsController>().changeCategory('Profile');
                    },
                  ),
                  CoachMarkTarget(
                    targetKey: _ownerNameInputKey,
                    title: 'Owner Name',
                    description: 'Set your name to personalize the dashboard welcome message.',
                    position: CoachMarkPosition.bottom,
                  ),
                  CoachMarkTarget(
                    targetKey: _replayTourKey,
                    title: 'Replay App Tour',
                    description: 'Restart the walkthrough guide anytime to re-learn all app features.',
                    position: CoachMarkPosition.top,
                    onBeforeTarget: () async {
                      Get.find<SettingsController>().changeCategory('General');
                    },
                  ),
                ],
                onComplete: _completeTour,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildCategoryItem(SettingsController controller, String title, IconData icon, bool isDark) {
    return Obx(() {
      final isSelected = controller.selectedCategory.value == title;

      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: 2),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () => controller.changeCategory(title),
            borderRadius: BorderRadius.circular(8),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: 12),
              decoration: BoxDecoration(
                color: isSelected
                    ? (isDark ? AppColors.darkCard : AppColors.lightPrimary.withValues(alpha: 0.1))
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(
                    icon,
                    size: 18,
                    color: isSelected
                        ? (isDark ? AppColors.darkPrimary : AppColors.lightPrimary)
                        : (isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                      color: isSelected
                          ? (isDark ? AppColors.darkPrimary : AppColors.lightPrimary)
                          : (isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }
}
