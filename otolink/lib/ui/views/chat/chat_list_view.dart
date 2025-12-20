import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../app/controllers/chat_controller.dart';
import '../../../app/services/auth_service.dart';
import '../../../app/routes/routes.dart';

class ChatListView extends StatefulWidget {
  const ChatListView({super.key});

  @override
  State<ChatListView> createState() => _ChatListViewState();
}

class _ChatListViewState extends State<ChatListView> {
  late final ChatController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.find<ChatController>();
    controller.loadThreads();
  }

  @override
  Widget build(BuildContext context) {
    final user = Get.find<AuthService>().currentUser;
    if (user == null) {
      return const Scaffold(body: Center(child: Text("Silakan login untuk melihat chat")));
    }

    return Scaffold(
      appBar: AppBar(title: const Text("Pesan")),
      body: Obx(() {
        final threads = controller.threadList;
        
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (threads.isEmpty) {
          return const Center(child: Text("Belum ada percakapan"));
        }

        return ListView.separated(
          itemCount: threads.length,
          separatorBuilder: (_, __) => const Divider(height: 1),
          itemBuilder: (context, index) {
            final t = threads[index];
            final otherNames = t.participantNames.entries
                .where((e) => e.key != user.id)
                .map((e) => e.value)
                .join(", ");

            return ListTile(
              leading: const CircleAvatar(child: Icon(Icons.person)),
              title: Text(otherNames.isEmpty ? "User" : otherNames),
              subtitle: Text(
                t.lastMessage.isNotEmpty ? t.lastMessage : "Mulai percakapan...",
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              trailing: Text(
                "${t.lastUpdated.hour}:${t.lastUpdated.minute.toString().padLeft(2, '0')}",
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
              onTap: () {
                Get.toNamed(AppRoutes.chat, arguments: t.id);
              },
            );
          },
        );
      }),
    );
  }
}