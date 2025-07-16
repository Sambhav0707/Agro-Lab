import 'package:agrolab/app/modules/encyclopedia_acreen/controller/encyclopedia_controller.dart';
import 'package:get/get.dart';

class EncyclopediaBindings extends Bindings {
  @override
  void dependencies() {
    // TODO: implement dependencies
    Get.lazyPut(()=> EncyclopediaController());
  }
}