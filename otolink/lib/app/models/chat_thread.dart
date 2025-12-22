import 'package:cloud_firestore/cloud_firestore.dart';

class ChatThread {
  final String id;
  final List<String> participants;
  final String lastMessage;
  final DateTime lastMessageTime;

  const ChatThread({
    required this.id,
    required this.participants,
    required this.lastMessage,
    required this.lastMessageTime,
  });

  factory ChatThread.fromMap(Map<String, dynamic> data, String id) {
    return ChatThread(
      id: id,
      participants: List<String>.from(data['participants'] ?? []),
      lastMessage: data['lastMessage'] ?? '',
      lastMessageTime: (data['lastMessageTime'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'participants': participants,
      'lastMessage': lastMessage,
      'lastMessageTime': Timestamp.fromDate(lastMessageTime),
    };
  }
}