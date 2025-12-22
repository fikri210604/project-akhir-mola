import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/chat_thread.dart';
import '../../models/chat_message.dart';
import '../chat_service.dart';

class FirebaseChatService implements ChatService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  @override
  Future<List<ChatThread>> listThreads(String userId) async {
    final snap = await _db.collection('threads')
        .where('participants', arrayContains: userId)
        .get();
        
    return snap.docs.map((d) => ChatThread.fromMap(d.data(), d.id)).toList();
  }

  @override
  Future<ChatThread> startThread(List<String> userIds) async {
    final snap = await _db.collection('threads')
        .where('participants', arrayContains: userIds.first)
        .get();

    for (var doc in snap.docs) {
      final List<dynamic> participants = doc['participants'];
      if (participants.contains(userIds.last)) {
        return ChatThread.fromMap(doc.data(), doc.id);
      }
    }

    final doc = await _db.collection('threads').add({
      'participants': userIds,
      'lastMessage': '',
      'lastMessageTime': FieldValue.serverTimestamp(),
    });

    return ChatThread(
      id: doc.id,
      participants: userIds,
      lastMessage: '',
      lastMessageTime: DateTime.now(),
    );
  }

  @override
  Future<void> sendMessage(String threadId, ChatMessage message) async {
    await _db.collection('threads').doc(threadId).collection('messages').add(message.toMap());
    
    await _db.collection('threads').doc(threadId).update({
      'lastMessage': message.text,
      'lastMessageTime': FieldValue.serverTimestamp(),
    });
  }

  @override
  Stream<List<ChatMessage>> messageStream(String threadId) {
    return _db.collection('threads')
        .doc(threadId)
        .collection('messages')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snap) => snap.docs
            .map((d) => ChatMessage.fromMap(d.data(), d.id))
            .toList());
  }
}