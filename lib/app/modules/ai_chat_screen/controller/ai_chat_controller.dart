import 'package:get/get.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:flutter/material.dart';

class ChatMessage {
  final String text;
  final bool isUser;
  ChatMessage({required this.text, required this.isUser});
}

class AiChatController extends GetxController {
  late String cropName;
  late String diseaseName;
  late String severity;

  final TextEditingController messageController = TextEditingController();
  final ScrollController scrollController = ScrollController();
  final messages = <ChatMessage>[].obs;
  var isTyping = false.obs;

  final String apiKey = "AIzaSyDu9y58GS5Wy8iGGFonZPRC8-SuwHL3YIs";
  late GenerativeModel model;
  late ChatSession chatSession;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments ?? {};
    cropName = args['cropName'] ?? '';
    diseaseName = args['diseaseName'] ?? '';
    severity = args['severity'] ?? '';
    _initializeGemini();
    _askInitialQuestion();
  }

  void _initializeGemini() {
    try {
      model = GenerativeModel(
        model: 'gemini-2.0-flash',
        apiKey: apiKey,
      );
      chatSession = model.startChat();
    } catch (e) {
      debugPrint('Error initializing Gemini: $e');
    }
  }

  Future<void> _askInitialQuestion() async {
    String cropFormatted = cropName.isNotEmpty
        ? cropName[0].toUpperCase() + cropName.substring(1).toLowerCase()
        : '';
    String diseaseFormatted = diseaseName.isNotEmpty
        ? diseaseName[0].toUpperCase() + diseaseName.substring(1).toLowerCase()
        : '';
    String initialQuestion =
        "How can I treat $cropFormatted plants affected by $diseaseFormatted with a disease severity of $severity? Please provide detailed steps for treatment, necessary precautions, and prevention tips for future. Format your response with bullet points and use **bold text** (with double asterisks without backslashes) for important terms and headings.";
    messages.add(ChatMessage(text: initialQuestion, isUser: true));
    isTyping.value = true;
    await sendMessage(initialQuestion, isInitial: true);
  }

  Future<void> sendMessage(String text, {bool isInitial = false}) async {
    try {
      if (text.trim().isEmpty) return;
      if (!isInitial) {
        messages.add(ChatMessage(text: text, isUser: true));
      }
      messageController.clear();
      isTyping.value = true;
      _scrollToBottom();
      final response = await chatSession.sendMessage(Content.text(text));
      String responseText = response.text ??
          "Sorry, I couldn't generate a response. Please try again.";
      responseText = responseText.replaceAll(r'\*\*', '**');
      isTyping.value = false;
      messages.add(ChatMessage(text: responseText, isUser: false));
      _scrollToBottom();
    } catch (e) {
      isTyping.value = false;
      messages.add(ChatMessage(text: "Error: $e", isUser: false));
      debugPrint('Error sending message: $e');
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (scrollController.hasClients) {
        scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  void onClose() {
    messageController.dispose();
    scrollController.dispose();
    super.onClose();
  }
}
