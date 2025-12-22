import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import '../services/chat_service.dart';
import '../controllers/auth_controller.dart'; 
import '../models/chat_thread.dart';
import '../models/chat_message.dart';

class ChatController extends GetxController {
  final ChatService _service;
  final AuthController _authController;

  ChatController(this._service, this._authController);

  final RxList<ChatThread> threadList = <ChatThread>[].obs;
  
  final RxList<ChatMessage> _currentMessages = <ChatMessage>[].obs;
  List<ChatMessage> get messageList => _currentMessages;

  final TextEditingController messageController = TextEditingController();

  final RxBool isLoading = false.obs;
  StreamSubscription? _msgSub;
  String? _currentThreadId;

  @override
  void onInit() {
    super.onInit();
    if (_authController.currentUser.value != null) {
      loadThreads();
    }
    ever(_authController.currentUser, (user) {
      if (user != null) loadThreads();
    });
  }

  @override
  void onClose() {
    _msgSub?.cancel();
    messageController.dispose();
    super.onClose();
  }

  Future<void> loadThreads() async {
    final user = _authController.currentUser.value;
    if (user == null) return;

    isLoading.value = true;
    try {
      final res = await _service.listThreads(user.id);
      threadList.assignAll(res);
    } catch (e) {
      print("Error loading threads: $e");
    } finally {
      isLoading.value = false;
    }
  }

  void initChat(String threadId) {
    _currentThreadId = threadId;
    _msgSub?.cancel();
    _msgSub = _service.messageStream(threadId).listen((msgs) {
      _currentMessages.assignAll(msgs);
    });
  }

  Future<void> sendMessage() async {
    final text = messageController.text.trim();
    if (text.isEmpty || _currentThreadId == null) return;

    final user = _authController.currentUser.value;
    if (user == null) return;

    messageController.clear();

    try {
      await _service.sendMessage(
        _currentThreadId!,
        ChatMessage(
          id: '',
          senderId: user.id,
          text: text,
          timestamp: DateTime.now(),
        ),
      );
    } catch (e) {
      print("Error sending message: $e");
    }
  }

  Future<ChatThread> createThread(String otherUserId) async {
    final currentUser = _authController.currentUser.value;
    if (currentUser == null) throw Exception("User not logged in");
    
    return await _service.startThread([currentUser.id, otherUserId]);
  }
}