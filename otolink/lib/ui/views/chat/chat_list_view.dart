import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../app/controllers/chat_controller.dart';
import '../../../app/controllers/auth_controller.dart';
import '../../../app/routes/routes.dart';

class ChatListView extends StatefulWidget {
  const ChatListView({super.key});

  @override
  State<ChatListView> createState() => _ChatListViewState();
}

class _ChatListViewState extends State<ChatListView> {
  final chatCtrl = Get.find<ChatController>();
  final authCtrl = Get.find<AuthController>();

  @override
  void initState() {
    super.initState();
    chatCtrl.loadThreads();
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = authCtrl.currentUser.value;
    if (currentUser == null) return Center(child: Text('please_login'.tr));

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text('messages'.tr),
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        foregroundColor: Theme.of(context).appBarTheme.foregroundColor,
        elevation: 0.5,
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.search)),
        ],
      ),
      body: Obx(() {
        if (chatCtrl.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        if (chatCtrl.threadList.isEmpty) {
          return Center(child: Text('no_messages'.tr));
        }

        return ListView.separated(
          itemCount: chatCtrl.threadList.length,
          separatorBuilder: (_, __) => const Divider(height: 1),
          itemBuilder: (_, index) {
            final thread = chatCtrl.threadList[index];
            final otherId = thread.participants.firstWhere((id) => id != currentUser.id, orElse: () => '?');
            
            return ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              leading: CircleAvatar(
                backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                child: Icon(Icons.person, color: Theme.of(context).colorScheme.onPrimaryContainer),
              ),
              title: Text(
                "${'user'.tr} $otherId", 
                style: const TextStyle(fontWeight: FontWeight.w600)
              ),
              subtitle: Text(
                thread.lastMessage.isEmpty ? 'start_conversation'.tr : thread.lastMessage,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              trailing: Text(
                DateFormat('HH:mm').format(thread.lastMessageTime),
                style: const TextStyle(color: Colors.grey, fontSize: 12),
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