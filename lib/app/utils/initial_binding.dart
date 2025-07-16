import 'package:agrolab/app/modules/about_screen/controller/app_info_controller.dart';
import 'package:agrolab/app/modules/encyclopedia_acreen/controller/encyclopedia_controller.dart';
import 'package:agrolab/app/modules/home_screen/controller/home_controller.dart';
import 'package:get/get.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    // TODO: implement dependencies
    Get.put<HomeController>(HomeController());
    // Get.put(EncyclopediaController());
    // Get.put(AppInfoController());
  }
}
