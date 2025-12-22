import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../app/controllers/chat_controller.dart';
import '../../../app/routes/routes.dart';

class ChatListView extends StatefulWidget {
  const ChatListView({super.key});

  @override
  State<ChatListView> createState() => _ChatListViewState();
}

class _ChatListViewState extends State<ChatListView> {
  final controller = Get.find<ChatController>();

  @override
  void initState() {
    super.initState();
    controller.loadThreads();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Pesan", style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.threadList.isEmpty) {
          return const Center(child: Text('Belum ada percakapan'));
        }

        return ListView.separated(
          itemCount: controller.threadList.length,
          separatorBuilder: (_, __) => const Divider(height: 1),
          itemBuilder: (context, index) {
            final thread = controller.threadList[index];
            
            final lastMsg = thread.lastMessage;
            
            return ListTile(
              leading: const CircleAvatar(
                backgroundColor: Color(0xFF0A2C6C),
                child: Icon(Icons.person, color: Colors.white),
              ),
              title: const Text('User', style: TextStyle(fontWeight: FontWeight.bold)), 
              subtitle: Text(
                lastMsg.isNotEmpty ? lastMsg : 'Mulai percakapan...',
                maxLines: 1, 
                overflow: TextOverflow.ellipsis
              ),
              onTap: () {
                Get.toNamed(AppRoutes.chatRoom, arguments: thread.id);
              },
            );
          },
        );
      }),
    );
  }
}