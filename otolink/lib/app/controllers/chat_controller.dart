import 'package:get/get.dart';

import '../models/chat_thread.dart';
import '../models/message.dart';
import '../services/chat_service.dart';

class ChatController extends GetxController {
  final ChatService _service;
  ChatController(this._service);

  Future<List<ChatThread>> threads(String userId) => _service.listThreads(userId);
  Future<List<Message>> messages(String threadId) => _service.listMessages(threadId);
  Future<ChatThread> start(List<String> participantIds) => _service.startThread(participantIds);
  Future<Message> send({required String threadId, required String senderId, required String text}) =>
      _service.sendMessage(threadId: threadId, senderId: senderId, text: text);
}

