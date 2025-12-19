import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChatRoomView extends StatelessWidget {
  const ChatRoomView({super.key});

  @override
  Widget build(BuildContext context) {
    final arg = Get.arguments;
    final threadId = arg is String ? arg : null;
    return Scaffold(
      appBar: AppBar(title: const Text('Chat Room')),
      body: Center(
        child: Text(threadId != null ? 'Thread: $threadId' : 'Thread tidak ditemukan'),
      ),
    );
  }
}