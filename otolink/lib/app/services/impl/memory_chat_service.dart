import 'dart:math';

import '../../models/chat_thread.dart';
import '../../models/message.dart';
import '../chat_service.dart';

class MemoryChatService implements ChatService {
  final Map<String, List<Message>> _messages = {};
  final Map<String, ChatThread> _threads = {};

  @override
  Future<List<ChatThread>> listThreads(String userId) async {
    final items = _threads.values.where((t) => t.participantIds.contains(userId)).toList()
      ..sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
    return items;
  }

  @override
  Future<List<Message>> listMessages(String threadId) async {
    return List<Message>.unmodifiable(_messages[threadId] ?? const []);
  }

  @override
  Future<ChatThread> startThread(List<String> participantIds) async {
    for (final t in _threads.values) {
      if (participantIds.toSet().containsAll(t.participantIds) &&
          t.participantIds.toSet().containsAll(participantIds)) {
        return t;
      }
    }
    final id = 't_${DateTime.now().millisecondsSinceEpoch}_${Random().nextInt(9999)}';
    final thread = ChatThread(id: id, participantIds: participantIds, lastMessage: null, updatedAt: DateTime.now());
    _threads[id] = thread;
    _messages[id] = [];
    return thread;
  }

  @override
  Future<Message> sendMessage({required String threadId, required String senderId, required String text}) async {
    final id = 'm_${DateTime.now().millisecondsSinceEpoch}_${Random().nextInt(9999)}';
    final msg = Message(id: id, threadId: threadId, senderId: senderId, text: text, timestamp: DateTime.now());
    final list = _messages[threadId] ??= [];
    list.add(msg);
    final prev = _threads[threadId];
    _threads[threadId] = ChatThread(
      id: threadId,
      participantIds: prev?.participantIds ?? const [],
      lastMessage: msg,
      updatedAt: msg.timestamp,
    );
    return msg;
  }
}

