import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:lottie/lottie.dart';
import '../../../utils/utils.dart';
import 'package:get/get.dart';
import '../controller/ai_chat_controller.dart';

class AIChatScreen extends GetView<AiChatController> {
  const AIChatScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color backgroundColor = const Color(0xffe9edf1);
    Color accentColor = const Color(0xff2d5765);

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: accentColor,
        title: const Text(
          'AI Treatment Assistant',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Neumorphic(
              style: NeumorphicStyle(
                depth: -2,
                boxShape:
                    NeumorphicBoxShape.roundRect(BorderRadius.circular(10)),
              ),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Disease: ${controller.diseaseName}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      'Plant: ${controller.cropName}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      'Severity: ${controller.severity}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: controller.severity.startsWith("7") ||
                                controller.severity.startsWith("8") ||
                                controller.severity.startsWith("9")
                            ? Colors.red.shade800
                            : controller.severity.startsWith("5") ||
                                    controller.severity.startsWith("6")
                                ? Colors.orange.shade800
                                : Colors.green.shade800,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: Obx(
                () => controller.messages.isEmpty && controller.isTyping.value
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Lottie.asset(
                              'assets/plant.json',
                              width: 200,
                              height: 200,
                              fit: BoxFit.contain,
                            ),
                            const SizedBox(height: 20),
                            Text(
                              "Analyzing your ${controller.cropName}...",
                              style: TextStyle(
                                color: accentColor,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        controller: controller.scrollController,
                        padding: const EdgeInsets.all(10),
                        itemCount: controller.messages.length,
                        itemBuilder: (context, index) {
                          return MessageBubble(
                            message: controller.messages[index],
                            backgroundColor: backgroundColor,
                            accentColor: accentColor,
                          );
                        },
                      )),
          ),
          Obx(() => controller.isTyping.value && controller.messages.isNotEmpty
              ? Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  child: Row(
                    children: [
                      Text(
                        "AI is typing",
                        style: TextStyle(
                          color: Colors.grey.shade700,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                      const SizedBox(width: 8),
                      SizedBox(
                        width: 12,
                        height: 12,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: accentColor,
                        ),
                      ),
                    ],
                  ),
                )
              : const SizedBox.shrink()),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: backgroundColor,
              boxShadow: const [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 4,
                  offset: Offset(0, -2),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: Neumorphic(
                    style: NeumorphicStyle(
                      depth: -2,
                      boxShape: NeumorphicBoxShape.roundRect(
                          BorderRadius.circular(25)),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: TextField(
                        controller: controller.messageController,
                        decoration: const InputDecoration(
                          hintText: 'Ask a follow-up question...',
                          border: InputBorder.none,
                        ),
                        onSubmitted: controller.isTyping.value
                            ? null
                            : (text) => controller.sendMessage(text),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Obx(() => NeumorphicButton(
                      style: NeumorphicStyle(
                        color: accentColor,
                        boxShape: const NeumorphicBoxShape.circle(),
                      ),
                      onPressed: controller.isTyping.value
                          ? null
                          : () => controller
                              .sendMessage(controller.messageController.text),
                      child: const Icon(
                        Icons.send,
                        color: Colors.white,
                      ),
                    )),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class MessageBubble extends StatelessWidget {
  final ChatMessage message;
  final Color backgroundColor;
  final Color accentColor;

  const MessageBubble({
    Key? key,
    required this.message,
    required this.backgroundColor,
    required this.accentColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment:
            message.isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          if (!message.isUser)
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: CircleAvatar(
                backgroundColor: accentColor,
                radius: 16,
                child: const Icon(
                  Icons.smart_toy,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ),
          Flexible(
            child: Neumorphic(
              style: NeumorphicStyle(
                depth: message.isUser ? 2 : -2,
                intensity: 0.8,
                color: message.isUser ? accentColor : Colors.white,
                boxShape:
                    NeumorphicBoxShape.roundRect(BorderRadius.circular(12)),
              ),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: message.isUser
                    ? Text(
                        message.text,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      )
                    : SelectableText.rich(
                        formatMessageText(
                          message.text,
                          isUser: message.isUser,
                        ),
                        toolbarOptions: const ToolbarOptions(
                          copy: true,
                          selectAll: true,
                          cut: false,
                          paste: false,
                        ),
                      ),
              ),
            ),
          ),
          if (message.isUser)
            Padding(
              padding: const EdgeInsets.only(left: 8),
              child: CircleAvatar(
                backgroundColor: Colors.grey.shade300,
                child: Icon(
                  Icons.person,
                  color: Colors.grey.shade700,
                  size: 20,
                ),
                radius: 16,
              ),
            ),
        ],
      ),
    );
  }
}
