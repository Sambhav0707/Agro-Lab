import 'package:agrolab/app/modules/bottom_nav_bar/controller/bottom_nav_bar_controller.dart';
import 'package:get/get.dart';

class BottomNavBarBindings  extends Bindings{
  @override
  void dependencies() {
    // TODO: implement dependencies
    Get.lazyPut(()=> BottomNavBarController());
  }
}