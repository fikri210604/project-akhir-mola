import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../app/controllers/chat_controller.dart';
import '../../../app/controllers/auth_controller.dart';

class ChatRoomView extends StatefulWidget {
  const ChatRoomView({super.key});

  @override
  State<ChatRoomView> createState() => _ChatRoomViewState();
}

class _ChatRoomViewState extends State<ChatRoomView> {
  final controller = Get.find<ChatController>();
  final authController = Get.find<AuthController>();

  @override
  void initState() {
    super.initState();
    final String? threadId = Get.arguments;
    if (threadId != null) {
      controller.initChat(threadId);
    }
  }

  @override
  Widget build(BuildContext context) {
    final myId = authController.currentUser.value?.id ?? '';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0.5,
      ),
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Expanded(
            child: Obx(() {
              // Jika loading dan belum ada data
              if (controller.isLoading.value && controller.messageList.isEmpty) {
                return const Center(child: CircularProgressIndicator());
              }

              final msgs = controller.messageList;
              if (msgs.isEmpty) {
                return const Center(child: Text('Mulai percakapan...'));
              }

              return ListView.builder(
                reverse: true, // Data sudah disort Descending, jadi reverse: true benar
                padding: const EdgeInsets.symmetric(vertical: 10),
                itemCount: msgs.length,
                itemBuilder: (context, index) {
                  final msg = msgs[index];
                  final isMe = msg.senderId == myId;
                  
                  return Align(
                    alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      constraints: BoxConstraints(maxWidth: Get.width * 0.75),
                      decoration: BoxDecoration(
                        color: isMe ? const Color(0xFF0A2C6C) : Colors.grey.shade100,
                        borderRadius: BorderRadius.only(
                          topLeft: const Radius.circular(16),
                          topRight: const Radius.circular(16),
                          bottomLeft: isMe ? const Radius.circular(16) : Radius.zero,
                          bottomRight: isMe ? Radius.zero : const Radius.circular(16),
                        ),
                      ),
                      child: Text(
                        msg.text,
                        style: TextStyle(
                          color: isMe ? Colors.white : Colors.black87,
                          fontSize: 15,
                        ),
                      ),
                    ),
                  );
                },
              );
            }),
          ),
          _buildInputArea(),
        ],
      ),
    );
  }

  Widget _buildInputArea() {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Colors.grey.shade200)),
      ),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: TextField(
                  controller: controller.messageController,
                  decoration: const InputDecoration(
                    hintText: 'Tulis pesan...',
                    border: InputBorder.none,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            Container(
              decoration: const BoxDecoration(
                color: Color(0xFF0A2C6C),
                shape: BoxShape.circle,
              ),
              child: IconButton(
                icon: const Icon(Icons.send, color: Colors.white, size: 20),
                onPressed: controller.sendMessage,
              ),
            ),
          ],
        ),
      ),
    );
  }
}