import 'dart:async';
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
  final RxBool isMessagesLoading = true.obs; 
  final RxBool isSending = false.obs;
  
  final TextEditingController messageController = TextEditingController();
  
  String? _currentThreadId;
  StreamSubscription? _msgSub;

  @override
  void onClose() {
    _msgSub?.cancel();
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
    } finally {
      isLoading.value = false;
    }
  }

  void initChat(String threadId) {
    if (_currentThreadId == threadId) return;

    _currentThreadId = threadId;
    messageList.clear();
    isMessagesLoading.value = true;
    
    _msgSub?.cancel();
    _msgSub = _service.messagesStream(threadId).listen((msgs) {
      Future.delayed(Duration.zero, () {
        if (isClosed) return;
        messageList.assignAll(msgs);
        isMessagesLoading.value = false;
      });
    }, onError: (e) {
      isMessagesLoading.value = false;
    });
  }

  Future<void> sendMessage() async {
    final text = messageController.text.trim();
    if (text.isEmpty || _currentThreadId == null) return;

    final user = _authService.currentUser;
    if (user == null) return;

    messageController.clear();
    try {
      await _service.sendMessage(
        threadId: _currentThreadId!, 
        senderId: user.id, 
        text: text
      );
    } catch (e) {
      Get.snackbar('Error', 'Gagal mengirim pesan');
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