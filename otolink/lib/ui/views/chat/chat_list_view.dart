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
      appBar: AppBar(title: const Text('Pesan')),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        final threads = controller.threadList;
        if (threads.isEmpty) {
          return const Center(child: Text('Belum ada percakapan'));
        }

        return ListView.separated(
          itemCount: threads.length,
          separatorBuilder: (_, __) => const Divider(height: 1),
          itemBuilder: (context, index) {
            final thread = threads[index];
            final lastMsg = thread.lastMessage;
            
            return ListTile(
              leading: const CircleAvatar(
                backgroundColor: Colors.indigo,
                child: Icon(Icons.person, color: Colors.white),
              ),
              title: Text('Percakapan ${index + 1}'), 
              subtitle: Text(
                lastMsg?.text ?? 'Belum ada pesan',
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