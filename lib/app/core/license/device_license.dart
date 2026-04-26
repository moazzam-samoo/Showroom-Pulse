import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Fetches the unique Motherboard UUID from the current Windows device
/// using PowerShell. This UUID is permanent and unrelated to network adapters.
///
/// Returns the UUID string, or 'UNKNOWN_DEVICE_ID' on failure.
Future<String> getDeviceUuid() async {
  if (!Platform.isWindows) {
    return 'UNSUPPORTED_PLATFORM';
  }

  try {
    final result = await Process.run(
      'powershell',
      [
        '-NoProfile',
        '-Command',
        '(Get-CimInstance -Class Win32_ComputerSystemProduct).UUID'
      ],
      runInShell: true,
    );

    if (result.exitCode != 0) return 'UNKNOWN_DEVICE_ID';

    final output = (result.stdout as String).trim();
    if (output.isEmpty) return 'UNKNOWN_DEVICE_ID';

    return output.toUpperCase();
  } catch (_) {
    return 'UNKNOWN_DEVICE_ID';
  }
}

/// Device license gatekeeper — checks Firebase Firestore for first-time
/// registration, then caches authorization permanently.
///
/// Strategy:
///   - First launch: MUST have internet → checks Firebase → caches forever
///   - Subsequent launches: uses cache (no internet needed)
///   - If internet is available: silently re-checks Firebase (for revocation)
///   - Cache persists until app is uninstalled
class DeviceLicense {
  DeviceLicense._();

  static const _keyAuthorized = 'device_license_authorized';
  static const _networkProbeHost = 'firestore.googleapis.com';

  static Future<bool> _hasInternetConnection() async {
    try {
      final lookup = await InternetAddress.lookup(_networkProbeHost)
          .timeout(const Duration(seconds: 2));
      return lookup.isNotEmpty;
    } catch (_) {
      return false;
    }
  }

  static Future<bool> _fetchRemoteAuthorization(String deviceId) async {
    final doc = await FirebaseFirestore.instance
        .collection('allowed_devices')
        .doc(deviceId)
        .get()
        .timeout(const Duration(seconds: 10));
    return doc.exists && (doc.data()?['active'] == true);
  }

  /// Unified authorization flow with online revalidation and cache fallback.
  ///
  /// Behavior:
  /// - If internet is available, always revalidate against Firebase.
  /// - If online check fails, fallback to cache if present.
  /// - If no cache and no internet, require internet for initial verification.
  /// - When [forceOnline] is true, skip cache shortcuts and try remote first.
  static Future<({bool authorized, String deviceId, bool needsInternet})>
      isDeviceAuthorized() async {
    final deviceId = await getDeviceUuid();
    final prefs = await SharedPreferences.getInstance();
    final cachedAuth = prefs.getBool(_keyAuthorized);

    final hasInternet = await _hasInternetConnection();

    if (hasInternet) {
      try {
        final remoteAuthorized = await _fetchRemoteAuthorization(deviceId);
        await prefs.setBool(_keyAuthorized, remoteAuthorized);
        return (
          authorized: remoteAuthorized,
          deviceId: deviceId,
          needsInternet: false,
        );
      } catch (_) {
        if (cachedAuth != null) {
          return (
            authorized: cachedAuth,
            deviceId: deviceId,
            needsInternet: false,
          );
        }
        return (authorized: false, deviceId: deviceId, needsInternet: true);
      }
    }

    if (cachedAuth != null) {
      return (
        authorized: cachedAuth,
        deviceId: deviceId,
        needsInternet: !cachedAuth,
      );
    }

    return (authorized: false, deviceId: deviceId, needsInternet: true);
  }
}
