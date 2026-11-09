
import 'package:get/get.dart';

class AppShellController extends GetxController {
  final RxInt selectedIndex = 0.obs;

  void selectPage(int index) {
    selectedIndex.value = index;
  }

  void goHome() {
    selectedIndex.value = 0;
  }

  bool get isHome => selectedIndex.value == 0;

  bool isSelected(int index) => selectedIndex.value == index;
}
