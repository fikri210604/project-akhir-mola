import 'package:cloud_firestore/cloud_firestore.dart';

class ChatThread {
  final String id;
  final String productId;
  final List<String> participants;
  final String lastMessage;
  final DateTime lastUpdated;
  final Map<String, String> participantNames;

  const ChatThread({
    required this.id,
    required this.productId,
    required this.participants,
    required this.lastMessage,
    required this.lastUpdated,
    required this.participantNames,
  });

  factory ChatThread.fromMap(String id, Map<String, dynamic> map) {
    return ChatThread(
      id: id,
      productId: map['product_id'] ?? '',
      participants: List<String>.from(map['participants'] ?? []),
      lastMessage: map['last_message'] ?? '',
      lastUpdated: (map['last_updated'] as Timestamp?)?.toDate() ?? DateTime.now(),
      participantNames: Map<String, String>.from(map['participant_names'] ?? {}),
    );
  }
}