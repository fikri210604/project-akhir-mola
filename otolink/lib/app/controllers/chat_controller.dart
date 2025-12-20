import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../models/chat_thread.dart';
import '../models/message.dart';
import '../services/chat_service.dart';
import '../services/auth_service.dart';

class ChatController extends GetxController {
  final ChatService _service;
  final AuthService _authService;
  
  ChatController(this._service, this._authService);

  final RxList<ChatThread> threadList = <ChatThread>[].obs;
  final RxList<Message> messageList = <Message>[].obs;
  final RxBool isLoading = false.obs;
  final RxBool isSending = false.obs;
  
  final TextEditingController messageController = TextEditingController();
  
  String? _currentThreadId;

  @override
  void onClose() {
    messageController.dispose();
    super.onClose();
  }
  
  Future<void> loadThreads() async {
    final user = _authService.currentUser;
    if (user == null) return;

    isLoading.value = true;
    try {
      final res = await _service.listThreads(user.id);
      threadList.assignAll(res);
    } catch (e) {
      print('Error loading threads: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> initChat(String threadId) async {
    _currentThreadId = threadId;
    messageList.clear();
    isLoading.value = true;
    try {
      final res = await _service.listMessages(threadId);
      messageList.assignAll(res);
    } catch (e) {
      print('Error loading messages: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> sendMessage() async {
    final text = messageController.text.trim();
    if (text.isEmpty || _currentThreadId == null) return;

    final user = _authService.currentUser;
    if (user == null) return;

    isSending.value = true;
    try {
      final tempMsg = Message(
        id: 'temp_${DateTime.now().millisecondsSinceEpoch}', 
        threadId: _currentThreadId!, 
        senderId: user.id, 
        text: text, 
        timestamp: DateTime.now()
      );
      
      messageList.add(tempMsg);
      messageController.clear();

      final newMessage = await _service.sendMessage(
        threadId: _currentThreadId!, 
        senderId: user.id, 
        text: text
      );

      final index = messageList.indexWhere((m) => m.id == tempMsg.id);
      if (index != -1) {
        messageList[index] = newMessage;
      } else {
        messageList.add(newMessage);
      }
    } catch (e) {
      Get.snackbar('Error', 'Gagal mengirim pesan: $e');
    } finally {
      isSending.value = false;
    }
  }

  Future<ChatThread> createThread(String otherUserId) async {
    final currentUser = _authService.currentUser;
    if (currentUser == null) {
      throw Exception('User not logged in');
    }
    return await _service.startThread([currentUser.id, otherUserId]);
  }
}