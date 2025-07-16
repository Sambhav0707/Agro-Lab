import 'package:agrolab/app/modules/about_screen/controller/app_info_controller.dart';
import 'package:get/get.dart';

class AppInfoBinding extends Bindings {
  @override
  void dependencies() {
    // TODO: implement dependencies
    Get.lazyPut(() => AppInfoController());
  }
}
