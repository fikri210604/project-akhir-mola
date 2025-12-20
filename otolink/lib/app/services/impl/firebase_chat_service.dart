import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/chat_thread.dart';
import '../../models/message.dart';
import '../../models/user.dart';
import '../chat_service.dart';
import '../log_service.dart';
import '../auth_service.dart';
import 'package:get/get.dart';

class FirebaseChatService implements ChatService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  @override
  Future<String> createOrGetThread(AppUser otherUser, String productId) async {
    try {
      final authService = Get.find<AuthService>();
      final currentUser = authService.currentUser;
      
      if (currentUser == null) throw Exception("User not logged in");

      final q = await _db.collection('chats')
          .where('product_id', isEqualTo: productId)
          .where('participants', arrayContains: currentUser.id)
          .get();

      for (var doc in q.docs) {
        final data = doc.data();
        final participants = List<String>.from(data['participants'] ?? []);
        if (participants.contains(otherUser.id)) {
          return doc.id;
        }
      }

      final docRef = await _db.collection('chats').add({
        'product_id': productId,
        'participants': [currentUser.id, otherUser.id],
        'last_message': '',
        'last_updated': FieldValue.serverTimestamp(),
        'participant_names': {
          currentUser.id: currentUser.displayName,
          otherUser.id: otherUser.displayName,
        }
      });
      return docRef.id;
    } catch (e, s) {
      LogService.error('FirebaseChatService', 'Error creating thread', e, s);
      rethrow;
    }
  }

  @override
  Future<List<ChatThread>> getThreads() async {
    try {
      final authService = Get.find<AuthService>();
      final currentUser = authService.currentUser;
      if (currentUser == null) return [];

      final snapshot = await _db.collection('chats')
          .where('participants', arrayContains: currentUser.id)
          .orderBy('last_updated', descending: true)
          .get();
      
      return snapshot.docs.map((d) => ChatThread.fromMap(d.id, d.data())).toList();
    } catch (e, s) {
      LogService.error('FirebaseChatService', 'Error fetching threads', e, s);
      return [];
    }
  }

  @override
  Stream<List<Message>> getMessages(String threadId) {
    return _db.collection('chats')
        .doc(threadId)
        .collection('messages')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((d) => Message.fromMap(d.id, d.data())).toList();
        });
  }

  @override
  Future<Message> sendMessage(String threadId, Message message) async {
    try {
      final docRef = await _db.collection('chats').doc(threadId).collection('messages').add({
        'sender_id': message.senderId,
        'content': message.content,
        'timestamp': FieldValue.serverTimestamp(),
        'type': 'text',
      });

      await _db.collection('chats').doc(threadId).update({
        'last_message': message.content,
        'last_updated': FieldValue.serverTimestamp(),
      });

      return Message(
        id: docRef.id,
        senderId: message.senderId,
        content: message.content,
        timestamp: DateTime.now(),
        type: 'text'
      );
    } catch (e, s) {
      LogService.error('FirebaseChatService', 'Error sending message', e, s);
      rethrow;
    }
  }
}