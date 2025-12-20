import '../models/chat_thread.dart';
import '../models/message.dart';

abstract class ChatService {
  Future<List<ChatThread>> listThreads(String userId);
  Stream<List<Message>> messagesStream(String threadId);
  Future<ChatThread> startThread(List<String> participantIds);
  Future<Message> sendMessage({required String threadId, required String senderId, required String text});
}