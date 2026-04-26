import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:window_manager/window_manager.dart';
import '../constants/app_colors.dart';

/// Full-screen lock shown when the device UUID is not in the allow-list.
class UnauthorizedScreen extends StatefulWidget {
  final String deviceId;
  final bool needsInternet;
  final Future<({bool authorized, String deviceId, bool needsInternet})>
      Function()? onRetry;
  final VoidCallback? onAuthorized;
  const UnauthorizedScreen({
    super.key,
    required this.deviceId,
    this.needsInternet = false,
    this.onRetry,
    this.onAuthorized,
  });

  @override
  State<UnauthorizedScreen> createState() => _UnauthorizedScreenState();
}

class _UnauthorizedScreenState extends State<UnauthorizedScreen>
    with WindowListener {
  bool _retrying = false;
  bool _needsInternetHint = false;

  @override
  void initState() {
    super.initState();
    windowManager.addListener(this);
    _needsInternetHint = widget.needsInternet;
    // Show internet popup if first-time launch with no internet
    if (widget.needsInternet) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _showNoInternetDialog();
      });
    }
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

  void _showNoInternetDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.darkSurface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(
            color: AppColors.darkPrimary.withValues(alpha: 0.3),
            width: 1.5,
          ),
        ),
        icon: Container(
          width: 64,
          height: 64,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.orange.withValues(alpha: 0.12),
            border: Border.all(
              color: Colors.orange.withValues(alpha: 0.3),
              width: 2,
            ),
          ),
          child: const Icon(
            Icons.wifi_off_rounded,
            size: 32,
            color: Colors.orange,
          ),
        ),
        title: const Text(
          'Internet Connection Required',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppColors.darkTextPrimary,
          ),
        ),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'This device has not been registered yet.\n\n'
              'A one-time internet connection is required to verify your device license with the server.\n\n'
              'Please connect to the internet and restart the application.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: AppColors.darkTextSecondary,
                height: 1.5,
              ),
            ),
            SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.info_outline,
                    size: 14, color: AppColors.darkPrimary),
                SizedBox(width: 6),
                Text(
                  'After registration, internet is not needed again.',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: AppColors.darkPrimary,
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () async {
                Navigator.of(context).pop();
                await _retryAuthorization();
              },
              icon: const Icon(Icons.restart_alt_rounded, size: 18),
              label: const Text('RETRY INTERNET CHECK'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.darkPrimary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _retryAuthorization() async {
    if (_retrying || widget.onRetry == null) return;

    setState(() {
      _retrying = true;
    });

    final result = await widget.onRetry!.call();

    if (!mounted) return;

    setState(() {
      _retrying = false;
      _needsInternetHint = result.needsInternet;
    });

    if (result.authorized) {
      widget.onAuthorized?.call();
      return;
    }

    if (result.needsInternet) {
      _showNoInternetDialog();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content:
              Text('Access is still blocked by admin. Pull to refresh later.'),
          backgroundColor: AppColors.darkError,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: AppColors.darkBackground,
        body: RefreshIndicator(
          onRefresh: _retryAuthorization,
          color: AppColors.darkPrimary,
          child: LayoutBuilder(
            builder: (context, constraints) => SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: Center(
                  child: Container(
                    constraints: const BoxConstraints(maxWidth: 850),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 40, vertical: 20),
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
                                color:
                                    AppColors.darkError.withValues(alpha: 0.12),
                                border: Border.all(
                                  color: AppColors.darkError
                                      .withValues(alpha: 0.3),
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
                                Text(
                                  _needsInternetHint
                                      ? 'Internet connection required for device registration.'
                                      : 'Hardware identification check failed.',
                                  style: const TextStyle(
                                      fontSize: 14,
                                      color: AppColors.darkTextSecondary),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 32),

                        // Device ID box
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 24, vertical: 20),
                          decoration: BoxDecoration(
                            color: AppColors.darkSurface,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                                color: AppColors.darkPrimary
                                    .withValues(alpha: 0.3),
                                width: 1.5),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.darkPrimary
                                    .withValues(alpha: 0.1),
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
                        const SizedBox(height: 16),

                        // Internet required hint (shown when needs internet)
                        if (_needsInternetHint)
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 12),
                            decoration: BoxDecoration(
                              color: Colors.orange.withValues(alpha: 0.08),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: Colors.orange.withValues(alpha: 0.3),
                              ),
                            ),
                            child: const Row(
                              children: [
                                Icon(Icons.wifi_off_rounded,
                                    size: 20, color: Colors.orange),
                                SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    'No internet connection detected. A one-time internet connection is required '
                                    'to register this device. Please connect to the internet and restart the app.',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.orange,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: ElevatedButton.icon(
                                onPressed:
                                    _retrying ? null : _retryAuthorization,
                                icon: _retrying
                                    ? const SizedBox(
                                        width: 16,
                                        height: 16,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          color: Colors.white,
                                        ),
                                      )
                                    : const Icon(Icons.refresh_rounded,
                                        size: 18),
                                label: Text(
                                  _retrying
                                      ? 'CHECKING PERMISSION...'
                                      : 'RETRY / PULL TO REFRESH',
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.darkPrimary,
                                  foregroundColor: Colors.white,
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 14),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 16),

                        // Side-by-Side Content
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Security Info
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.all(20),
                                decoration: BoxDecoration(
                                  color: AppColors.darkSurface
                                      .withValues(alpha: 0.4),
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
                                    SizedBox(height: 12),
                                    _InfoRow(
                                        icon: Icons.security,
                                        text:
                                            'Prevents unauthorized Devices usage.'),
                                    SizedBox(height: 8),
                                    _InfoRow(
                                        icon: Icons.privacy_tip_outlined,
                                        text:
                                            'Protects your inventory privacy.'),
                                    SizedBox(height: 8),
                                    _InfoRow(
                                        icon: Icons.cloud_done_outlined,
                                        text:
                                            'One-time online verification only.'),
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
                                    padding:
                                        EdgeInsets.only(left: 8, bottom: 12),
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
  final bool needsInternet;
  final Future<({bool authorized, String deviceId, bool needsInternet})>
      Function()? onRetry;
  final VoidCallback? onAuthorized;
  const UnauthorizedApp({
    super.key,
    required this.deviceId,
    this.needsInternet = false,
    this.onRetry,
    this.onAuthorized,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AL-TAHIR Showroom',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: AppColors.darkBackground,
      ),
      home: UnauthorizedScreen(
        deviceId: deviceId,
        needsInternet: needsInternet,
        onRetry: onRetry,
        onAuthorized: onAuthorized,
      ),
    );
  }
}
