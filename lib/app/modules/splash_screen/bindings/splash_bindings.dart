import 'package:agrolab/app/modules/splash_screen/controller/splash_controller.dart';
import 'package:get/get.dart';

class SplashBindings extends Bindings {
  @override
  void dependencies() {
    // TODO: implement dependencies
    Get.lazyPut(()=> SplashController());
  }
}