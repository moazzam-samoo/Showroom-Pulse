import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// WalkthroughService manages the state of the first-time app walkthrough.
class WalkthroughService extends GetxService {
  static const String _walkthroughKey = 'walkthrough_completed';
  late SharedPreferences _prefs;
  
  // Observable state for walkthrough completion
  final RxBool hasCompletedWalkthrough = false.obs;

  /// Initialize the service and load the stored state
  Future<WalkthroughService> init() async {
    _prefs = await SharedPreferences.getInstance();
    hasCompletedWalkthrough.value = _prefs.getBool(_walkthroughKey) ?? false;
    return this;
  }

  /// Mark the walkthrough as complete
  Future<void> markWalkthroughComplete() async {
    await _prefs.setBool(_walkthroughKey, true);
    hasCompletedWalkthrough.value = true;
  }

  /// Reset the walkthrough (e.g., for replay from settings)
  Future<void> resetWalkthrough() async {
    await _prefs.setBool(_walkthroughKey, false);
    hasCompletedWalkthrough.value = false;
  }

  /// Check if a specific tab has completed its coach marks tour
  bool hasCompletedTab(String tabName) {
    return _prefs.getBool('${_walkthroughKey}_$tabName') ?? false;
  }

  /// Mark a specific tab's coach marks tour as complete
  Future<void> markTabComplete(String tabName) async {
    await _prefs.setBool('${_walkthroughKey}_$tabName', true);
  }

  /// Reset all walkthrough states (intro slides and all tab tours)
  Future<void> resetAllTabs() async {
    // Reset main walkthrough
    await resetWalkthrough();
    
    // Clear all tab-specific keys
    final keys = _prefs.getKeys();
    for (String key in keys) {
      if (key.startsWith('${_walkthroughKey}_')) {
        await _prefs.remove(key);
      }
    }
  }
}

// Authored by: Moazzam Samoo
