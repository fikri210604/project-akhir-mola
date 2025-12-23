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
    final theme = Theme.of(context);

    if (currentUser == null) return Center(child: Text('please_login'.tr));

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text('messages'.tr),
        backgroundColor: theme.appBarTheme.backgroundColor,
        foregroundColor: theme.appBarTheme.foregroundColor,
        elevation: 0.5,
        actions: [
          IconButton(
            onPressed: () {}, 
            icon: Icon(Icons.search, color: theme.iconTheme.color)
          ),
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
          separatorBuilder: (_, __) => Divider(height: 1, color: theme.dividerColor),
          itemBuilder: (_, index) {
            final thread = chatCtrl.threadList[index];
            final otherId = thread.participants.firstWhere((id) => id != currentUser.id, orElse: () => '?');
            
            return ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              leading: CircleAvatar(
                backgroundColor: theme.colorScheme.primaryContainer,
                child: Icon(Icons.person, color: theme.colorScheme.onPrimaryContainer),
              ),
              title: Text(
                "${'user'.tr} $otherId", 
                style: TextStyle(fontWeight: FontWeight.w600, color: theme.colorScheme.onSurface)
              ),
              subtitle: Text(
                thread.lastMessage.isEmpty ? 'start_conversation'.tr : thread.lastMessage,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(color: theme.colorScheme.onSurface.withValues(alpha: 0.6)),
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