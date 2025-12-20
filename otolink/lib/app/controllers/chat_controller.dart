import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/message.dart';
import '../models/chat_thread.dart';
import '../services/chat_service.dart';
import '../services/auth_service.dart';
import 'base_controller.dart';

class ChatController extends BaseController {
  final ChatService _service;
  final AuthService _authService;
  
  ChatController(this._service, this._authService);

  final messageController = TextEditingController();
  final RxList<Message> messages = <Message>[].obs;
  final RxList<ChatThread> threadList = <ChatThread>[].obs;
  String? currentThreadId;

  @override
  void onInit() {
    super.onInit();
  }

  void initChat(String threadId) {
    currentThreadId = threadId;
    messages.bindStream(_service.getMessages(threadId));
  }

  Future<void> loadThreads() async {
    final list = await runAsync(() => _service.getThreads(), defaultValue: <ChatThread>[]);
    if (list != null) threadList.assignAll(list);
  }

  Future<void> sendMessage() async {
    final text = messageController.text.trim();
    if (text.isEmpty || currentThreadId == null) return;

    final user = _authService.currentUser;
    if (user == null) {
      _handleError('Anda harus login');
      return;
    }

    messageController.clear();

    final msg = Message(
      id: '',
      senderId: user.id,
      content: text,
      timestamp: DateTime.now(),
    );

    await runAsync(() => _service.sendMessage(currentThreadId!, msg), showLoading: false);
  }

  void _handleError(String msg) {
    if (Get.context != null) {
      ScaffoldMessenger.of(Get.context!).showSnackBar(SnackBar(content: Text(msg)));
    }
  }

  @override
  void onClose() {
    messageController.dispose();
    super.onClose();
  }
}