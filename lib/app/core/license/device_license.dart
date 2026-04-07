import 'dart:io';

/// Hardcoded set of authorized MAC addresses (uppercase, colon-delimited).
/// To authorize a new machine, add its MAC here and rebuild.
const Set<String> _allowedMacs = {
  'BC:03:58:FE:C3:4C', //Moazam's Device
  'AA:09:10:D9:55:BD', //Shumail's Device
  '38:BA:F8:C2:88:7D', // Tahir's Device (Client)
};

/// Normalizes any MAC format (dash or colon) to uppercase colon-delimited.
String _normalizeMac(String raw) {
  return raw.trim().toUpperCase().replaceAll('-', ':');
}

/// Fetches all physical MAC addresses from the current Windows device
/// using the `getmac` command with CSV output.
///
/// Returns a list of normalized MAC strings, or `['UNKNOWN']` on failure.
Future<List<String>> getDeviceMacAddresses() async {
  try {
    final result = await Process.run(
      'getmac',
      ['/FO', 'CSV', '/NH'],
      runInShell: true,
    );

    if (result.exitCode != 0) return ['UNKNOWN'];

    final output = (result.stdout as String).trim();
    if (output.isEmpty) return ['UNKNOWN'];

    final macs = <String>[];

    for (final line in output.split('\n')) {
      final trimmed = line.trim();
      if (trimmed.isEmpty) continue;

      // CSV columns: "MAC","Transport","Status"
      // Split by comma, strip quotes
      final columns =
          trimmed.split(',').map((c) => c.replaceAll('"', '').trim()).toList();
      if (columns.isEmpty) continue;

      final mac = columns[0];

      // Skip virtual/disconnected adapters
      if (mac == 'N/A' || mac.isEmpty) continue;
      if (trimmed.contains('Media disconnected')) continue;
      if (trimmed.contains('Disconnected')) continue;

      macs.add(_normalizeMac(mac));
    }

    return macs.isEmpty ? ['UNKNOWN'] : macs;
  } catch (_) {
    return ['UNKNOWN'];
  }
}

/// Returns the first physical MAC address found on the device.
Future<String> getDeviceMacAddress() async {
  final macs = await getDeviceMacAddresses();
  return macs.first;
}

/// Device license gatekeeper.
class DeviceLicense {
  DeviceLicense._();

  /// Checks whether any of the device's MAC addresses are in the allow-list.
  ///
  /// Returns a record with:
  /// - `authorized`: `true` if at least one MAC matches
  /// - `macAddress`: the first physical MAC (for display on the lock screen)
  static Future<({bool authorized, String macAddress})>
      isDeviceAuthorized() async {
    final macs = await getDeviceMacAddresses();
    final displayMac = macs.first;

    final authorized = macs.any((mac) => _allowedMacs.contains(mac));

    return (authorized: authorized, macAddress: displayMac);
  }
}
