import 'package:get/get.dart';
import 'package:tahir_showroom/app/core/services/walkthrough_service.dart';

class WalkthroughController extends GetxController {
  final WalkthroughService _walkthroughService = Get.find<WalkthroughService>();
  
  final currentPage = 0.obs;
  final totalPages = 6;

  void onPageChanged(int index) {
    currentPage.value = index;
  }

  void next() {
    if (currentPage.value < totalPages - 1) {
      currentPage.value++;
    } else {
      complete();
    }
  }

  Future<void> complete() async {
    await _walkthroughService.markWalkthroughComplete();
    Get.offAllNamed('/login', arguments: {'first_install': true});
  }

  Future<void> skip() async {
    await complete();
  }
}
