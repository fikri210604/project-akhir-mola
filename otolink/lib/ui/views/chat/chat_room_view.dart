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
  final authCtrl = Get.find<AuthController>();

  @override
  void initState() {
    super.initState();
    final threadId = Get.arguments as String;
    controller.initChat(threadId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Chat"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0.5,
      ),
      body: Column(
        children: [
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value && controller.messageList.isEmpty) {
                return const Center(child: CircularProgressIndicator());
              }

              final msgs = controller.messageList;
              if (msgs.isEmpty) {
                return const Center(child: Text("Belum ada pesan"));
              }

              final myId = authCtrl.currentUser.value?.id;

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
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: isMe ? Colors.indigo : Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        msg.text,
                        style: TextStyle(color: isMe ? Colors.white : Colors.black),
                      ),
                    ),
                  );
                },
              );
            }),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: controller.messageController,
                    decoration: InputDecoration(
                      hintText: "Tulis pesan...",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.send, color: Colors.indigo),
                  onPressed: () => controller.sendMessage(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}