import '../models/chat_thread.dart';
import '../models/message.dart';
import '../models/user.dart';

abstract class ChatService {
  Future<String> createOrGetThread(AppUser otherUser, String productId);
  Future<List<ChatThread>> getThreads();
  Stream<List<Message>> getMessages(String threadId);
  Future<Message> sendMessage(String threadId, Message message);
}