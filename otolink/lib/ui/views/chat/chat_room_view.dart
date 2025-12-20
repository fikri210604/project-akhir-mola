import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../app/controllers/chat_controller.dart';
import '../../../app/services/auth_service.dart';

class ChatRoomView extends StatefulWidget {
  const ChatRoomView({super.key});

  @override
  State<ChatRoomView> createState() => _ChatRoomViewState();
}

class _ChatRoomViewState extends State<ChatRoomView> {
  late final ChatController controller;
  final String? threadId = Get.arguments as String?;

  @override
  void initState() {
    super.initState();
    controller = Get.find<ChatController>();
    if (threadId != null) {
      controller.initChat(threadId!);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (threadId == null) {
      return const Scaffold(body: Center(child: Text("Chat Error: No Thread ID")));
    }

    final myId = Get.find<AuthService>().currentUser?.id ?? '';

    return Scaffold(
      appBar: AppBar(title: const Text('Chat')),
      body: Column(
        children: [
          Expanded(
            child: Obx(() {
              final msgs = controller.messages;
              if (msgs.isEmpty) {
                return const Center(child: Text("Belum ada pesan"));
              }
              return ListView.builder(
                reverse: true,
                itemCount: msgs.length,
                padding: const EdgeInsets.all(16),
                itemBuilder: (context, index) {
                  final msg = msgs[index];
                  final isMe = msg.senderId == myId;
                  return Align(
                    alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 4),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      decoration: BoxDecoration(
                        color: isMe ? const Color(0xFF0A2C6C) : Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        msg.content,
                        style: TextStyle(color: isMe ? Colors.white : Colors.black87),
                      ),
                    ),
                  );
                },
              );
            }),
          ),
          _buildInput(),
        ],
      ),
    );
  }

  Widget _buildInput() {
    return Container(
      padding: const EdgeInsets.all(8),
      color: Colors.white,
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller.messageController,
              decoration: InputDecoration(
                hintText: 'Tulis pesan...',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16),
              ),
            ),
          ),
          const SizedBox(width: 8),
          IconButton(
            icon: const Icon(Icons.send, color: Color(0xFF0A2C6C)),
            onPressed: controller.sendMessage,
          ),
        ],
      ),
    );
  }
}