class Message {
  final String id;
  final String threadId;
  final String senderId;
  final String text;
  final DateTime timestamp;

  const Message({
    required this.id,
    required this.threadId,
    required this.senderId,
    required this.text,
    required this.timestamp,
  });
}