import '../models/chat_thread.dart';
import '../models/chat_message.dart';

abstract class ChatService {
  Future<List<ChatThread>> listThreads(String userId);
  Future<ChatThread> startThread(List<String> userIds);
  Future<void> sendMessage(String threadId, ChatMessage message);
  Stream<List<ChatMessage>> messageStream(String threadId);
}