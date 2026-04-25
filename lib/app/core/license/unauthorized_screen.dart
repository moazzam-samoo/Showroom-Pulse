import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:window_manager/window_manager.dart';
import '../constants/app_colors.dart';

/// Full-screen lock shown when the device UUID is not in the allow-list.
class UnauthorizedScreen extends StatefulWidget {
  final String deviceId;
  const UnauthorizedScreen({super.key, required this.deviceId});

  @override
  State<UnauthorizedScreen> createState() => _UnauthorizedScreenState();
}

class _UnauthorizedScreenState extends State<UnauthorizedScreen> with WindowListener {
  @override
  void initState() {
    super.initState();
    windowManager.addListener(this);
  }

  @override
  void dispose() {
    windowManager.removeListener(this);
    super.dispose();
  }

  @override
  void onWindowClose() {
    // Because main.dart globally sets `windowManager.setPreventClose(true)`,
    // we MUST explicitly listen to the close event here and manually exit the app.
    // Exiting the app process guarantees that the next time the user opens the app,
    // the system will run main() again and re-evaluate the hardware device ID.
    exit(0);
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: AppColors.darkBackground,
        body: Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 850),
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Header Area
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.darkError.withValues(alpha: 0.12),
                        border: Border.all(
                          color: AppColors.darkError.withValues(alpha: 0.3),
                          width: 2,
                        ),
                      ),
                      child: const Icon(Icons.lock_outline_rounded,
                          size: 32, color: AppColors.darkError),
                    ),
                    const SizedBox(width: 24),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Unauthorized Device',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: AppColors.darkTextPrimary,
                            letterSpacing: -0.5,
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'Hardware identification check failed.',
                          style: TextStyle(
                              fontSize: 14, color: AppColors.darkTextSecondary),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 32),

                // Device ID box
                Container(
                  width: double.infinity,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                  decoration: BoxDecoration(
                    color: AppColors.darkSurface,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                        color: AppColors.darkPrimary.withValues(alpha: 0.3),
                        width: 1.5),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.darkPrimary.withValues(alpha: 0.1),
                        blurRadius: 20,
                        spreadRadius: -5,
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'YOUR REGISTERED DEVICE ID',
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w800,
                                color: AppColors.darkPrimary,
                                letterSpacing: 2.0,
                              ),
                            ),
                            const SizedBox(height: 8),
                            SelectableText(
                              widget.deviceId,
                              style: const TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Consolas',
                                color: AppColors.darkTextPrimary,
                                letterSpacing: 3,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 20),
                      ElevatedButton.icon(
                        onPressed: () {
                          Clipboard.setData(
                              ClipboardData(text: widget.deviceId));
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('ID Copied Successfully'),
                              backgroundColor: AppColors.darkPrimary,
                              behavior: SnackBarBehavior.floating,
                              width: 200,
                            ),
                          );
                        },
                        icon: const Icon(Icons.copy_rounded, size: 18),
                        label: const Text('COPY ID'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.darkPrimary,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 20),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),

                // Side-by-Side Content
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Security Info
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: AppColors.darkSurface.withValues(alpha: 0.4),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                              color: AppColors.darkBorderInput
                                  .withValues(alpha: 0.5)),
                        ),
                        child: const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'SECURITY PROTOCOL',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: AppColors.darkTextMuted,
                                letterSpacing: 1.5,
                              ),
                            ),
                            const SizedBox(height: 12),
                            _InfoRow(
                                icon: Icons.security,
                                text: 'Prevents unauthorized ERP usage.'),
                            const SizedBox(height: 8),
                            _InfoRow(
                                icon: Icons.privacy_tip_outlined,
                                text: 'Protects your inventory privacy.'),
                            const SizedBox(height: 8),
                            _InfoRow(
                                icon: Icons.settings_remote_outlined,
                                text: 'Enforces machine-based license.'),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 20),
                    // Contacts
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Padding(
                            padding: EdgeInsets.only(left: 8, bottom: 12),
                            child: Text(
                              'CONTACT DEVELOPERS:',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: AppColors.darkTextMuted,
                                letterSpacing: 1.5,
                              ),
                            ),
                          ),
                          _buildContactCard(
                            name: 'Moazzam Samoo',
                            email: 'moazzamsamoo819@gmail.com',
                            phone: '0324 3324008',
                          ),
                          const SizedBox(height: 10),
                          _buildContactCard(
                            name: 'Tameer Khyber',
                            email: 'tameerahmedkhyber@gmail.com',
                            phone: '0324 3690945',
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildContactCard(
      {required String name, required String email, required String phone}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.darkSurface.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(12),
        border:
            Border.all(color: AppColors.darkBorderInput.withValues(alpha: 0.5)),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 14,
            backgroundColor: AppColors.darkPrimary.withValues(alpha: 0.1),
            child: Text(name[0],
                style: const TextStyle(
                    color: AppColors.darkPrimary,
                    fontSize: 12,
                    fontWeight: FontWeight.bold)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name,
                    style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: AppColors.darkPrimary)),
                Text('$email • $phone',
                    style: const TextStyle(
                        fontSize: 10, color: AppColors.darkTextSecondary)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String text;
  const _InfoRow({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon,
            size: 14, color: AppColors.darkPrimary.withValues(alpha: 0.7)),
        const SizedBox(width: 10),
        Expanded(
            child: Text(text,
                style: const TextStyle(
                    fontSize: 12, color: AppColors.darkTextSecondary))),
      ],
    );
  }
}

/// Minimal MaterialApp wrapper that only shows the UnauthorizedScreen.
class UnauthorizedApp extends StatelessWidget {
  final String deviceId;
  const UnauthorizedApp({super.key, required this.deviceId});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AL-TAHIR Showroom',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: AppColors.darkBackground,
      ),
      home: UnauthorizedScreen(deviceId: deviceId),
    );
  }
}
