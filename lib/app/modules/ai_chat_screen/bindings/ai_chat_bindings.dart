import 'package:agrolab/app/modules/ai_chat_screen/controller/ai_chat_controller.dart';
import 'package:get/get.dart';

class AiChatBindings extends Bindings {
  @override
  void dependencies() {
    // TODO: implement dependencies
    Get.lazyPut(()=> AiChatController());
  }
}