import 'message.dart';

class ChatThread {
  final String id;
  final List<String> participantIds;
  final Message? lastMessage;
  final DateTime updatedAt;

  const ChatThread({
    required this.id,
    required this.participantIds,
    this.lastMessage,
    required this.updatedAt,
  });
}