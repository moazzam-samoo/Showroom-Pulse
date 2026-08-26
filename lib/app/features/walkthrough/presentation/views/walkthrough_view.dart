import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import 'package:tahir_showroom/app/core/constants/app_colors.dart';
import 'package:tahir_showroom/app/core/constants/app_spacing.dart';
import '../controllers/walkthrough_controller.dart';
import '../widgets/intro_slide.dart';

class WalkthroughView extends GetView<WalkthroughController> {
  const WalkthroughView({super.key});

  @override
  Widget build(BuildContext context) {
    final PageController pageController = PageController();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.lightBackground,
      body: SafeArea(
        child: Column(
          children: [
            // Top Bar (Skip Button)
            Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Align(
                alignment: Alignment.topRight,
                child: TextButton(
                  onPressed: controller.skip,
                  style: TextButton.styleFrom(
                    foregroundColor: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                  ),
                  child: const Text('Skip', style: TextStyle(fontSize: 16)),
                ),
              ),
            ),

            // Page View Carousel
            Expanded(
              child: PageView(
                controller: pageController,
                onPageChanged: controller.onPageChanged,
                children: [
                  IntroSlide(
                    title: 'Welcome to Showroom Pulse',
                    description: 'Explore the next generation of showroom management. Fast, intuitive, and powerful.',
                    visualIcon: LucideIcons.layoutDashboard,
                    iconColor: isDark ? AppColors.darkPrimary : AppColors.lightPrimary,
                  ),
                  IntroSlide(
                    title: 'Manage Sales & Inventory',
                    description: 'Track your bikes, manage stock levels, and record sales with ease.',
                    visualIcon: LucideIcons.bike,
                    iconColor: isDark ? AppColors.darkSuccess : AppColors.lightSuccess,
                  ),
                  IntroSlide(
                    title: 'Customer Management',
                    description: 'Keep detailed records of your customers, their history, and profiles.',
                    visualIcon: LucideIcons.users,
                    iconColor: isDark ? AppColors.darkInfo : AppColors.lightPrimary, // Fallback to lightPrimary
                  ),
                  IntroSlide(
                    title: 'Installment Tracking',
                    description: 'Never miss a payment. Monitor active contracts and upcoming dues.',
                    visualIcon: LucideIcons.calendarClock,
                    iconColor: isDark ? AppColors.darkWarning : AppColors.lightWarning,
                  ),
                  IntroSlide(
                    title: 'Dealers & Partners',
                    description: 'Manage your dealer relationships and procurement efficiently.',
                    visualIcon: LucideIcons.briefcase, // Changed from handshake which was missing
                    iconColor: isDark ? AppColors.darkPrimary : AppColors.lightPrimary,
                  ),
                  IntroSlide(
                    title: 'Reports & Analytics',
                    description: 'Gain valuable insights with detailed financial and operational reports.',
                    visualIcon: LucideIcons.barChart3,
                    iconColor: isDark ? AppColors.darkSuccess : AppColors.lightSuccess,
                  ),
                  IntroSlide(
                    title: 'Investment & ROI',
                    description: 'Monitor your capital, liquid cash, and real-time Return on Investment.',
                    visualIcon: LucideIcons.trendingUp,
                    iconColor: isDark ? AppColors.darkPrimary : AppColors.lightPrimary,
                  ),
                ],
              ),
            ),

            // Page Indicator
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 24),
              child: SmoothPageIndicator(
                controller: pageController,
                count: 7,
                effect: WormEffect(
                  dotHeight: 8,
                  dotWidth: 8,
                  activeDotColor: isDark ? AppColors.darkPrimary : AppColors.lightPrimary,
                  dotColor: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                ),
              ),
            ),

            // Navigation Buttons
            Padding(
              padding: const EdgeInsets.fromLTRB(40, 0, 40, 40),
              child: Obx(() {
                final isLastPage = controller.currentPage.value == 6;
                return SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: () {
                      if (isLastPage) {
                        controller.complete();
                      } else {
                        pageController.nextPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isDark ? AppColors.darkPrimary : AppColors.lightPrimary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      isLastPage ? 'Get Started' : 'Next',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
