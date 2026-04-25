/// Hardcoded set of authorized Device UUIDs (Motherboard IDs).
/// To authorize a new machine, add its UUID here and rebuild.
/// The UUID never changes even if Wi-Fi or Ethernet is disabled/changed.
const Set<String> allowedDeviceIds = {
  // Add your clients' Device UUIDs here (as shown on the Unauthorized screen)
  '3A3E78A7-1A46-4A19-8C7F-745D224729F7', // Example format
};
