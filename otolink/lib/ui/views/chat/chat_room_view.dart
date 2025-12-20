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
      appBar: AppBar(title: const Text('Chat')),
      body: Column(
        children: [
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }

              final msgs = controller.messageList;
              if (msgs.isEmpty) {
                return const Center(child: Text('Belum ada pesan'));
              }

              final reversedMsgs = msgs.toList().reversed.toList();

              return ListView.builder(
                reverse: true, 
                itemCount: reversedMsgs.length,
                itemBuilder: (context, index) {
                  final msg = reversedMsgs[index];
                  final isMe = msg.senderId == myId;
                  
                  return Align(
                    alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: isMe ? Colors.indigo : Colors.grey.shade200,
                        borderRadius: BorderRadius.only(
                          topLeft: const Radius.circular(12),
                          topRight: const Radius.circular(12),
                          bottomLeft: isMe ? const Radius.circular(12) : Radius.zero,
                          bottomRight: isMe ? Radius.zero : const Radius.circular(12),
                        ),
                      ),
                      child: Text(
                        msg.text,
                        style: TextStyle(color: isMe ? Colors.white : Colors.black87),
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
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(blurRadius: 2, color: Colors.black.withOpacity(0.1))]
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller.messageController,
              decoration: const InputDecoration(
                hintText: 'Tulis pesan...',
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(horizontal: 16),
              ),
            ),
          ),
          Obx(() => IconButton(
            icon: controller.isSending.value 
                ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))
                : const Icon(Icons.send, color: Colors.indigo),
            onPressed: controller.isSending.value 
                ? null 
                : controller.sendMessage,
          )),
        ],
      ),
    );
  }
}