import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../app/controllers/auth_controller.dart';
import '../../../app/controllers/chat_controller.dart';
import '../../../app/models/chat_thread.dart';

class ChatListView extends StatelessWidget {
  const ChatListView({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = Get.find<AuthController>();
    final chat = Get.find<ChatController>();
    final user = auth.currentUser.value;

    if (user == null) {
      return Scaffold(
        body: const Center(child: Text('Silakan login untuk melihat chat')),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Chat')),
      body: FutureBuilder<List<ChatThread>>(
        future: chat.threads(user.id),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          final items = snapshot.data ?? const <ChatThread>[];
          if (items.isEmpty) {
            return const Center(child: Text('Belum ada percakapan'));
          }
          return ListView.separated(
            itemCount: items.length,
            separatorBuilder: (_, __) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final t = items[index];
              return ListTile(
                title: Text('Thread ${t.id}'),
                subtitle: Text('Peserta: ${t.participantIds.join(', ')}'),
                onTap: () => Get.toNamed('/chat', arguments: t.id),
              );
            },
          );
        },
      ),
    );
  }
}
