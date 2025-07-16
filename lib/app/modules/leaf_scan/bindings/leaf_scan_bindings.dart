import 'package:agrolab/app/modules/leaf_scan/controller/leaf_scan_controller.dart';
import 'package:get/get.dart';

class LeafScanBindings extends Bindings {
  @override
  void dependencies() {
    // TODO: implement dependencies
    Get.lazyPut( ()=> LeafScanController());
  }

}