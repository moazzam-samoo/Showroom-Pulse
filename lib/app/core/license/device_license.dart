import 'dart:io';
import 'allowed_devices.dart';

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
      ['-NoProfile', '-Command', '(Get-CimInstance -Class Win32_ComputerSystemProduct).UUID'],
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

/// Device license gatekeeper.
class DeviceLicense {
  DeviceLicense._();

  /// Checks whether the device's UUID is in the allow-list.
  ///
  /// Returns a record with:
  /// - `authorized`: `true` if the UUID matches
  /// - `deviceId`: the device UUID (for display on the lock screen)
  static Future<({bool authorized, String deviceId})> isDeviceAuthorized() async {
    final deviceId = await getDeviceUuid();

    final authorized = allowedDeviceIds.contains(deviceId);

    return (authorized: authorized, deviceId: deviceId);
  }
}
