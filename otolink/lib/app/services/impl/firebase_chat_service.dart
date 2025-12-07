import 'package:cloud_firestore/cloud_firestore.dart';

import '../../models/chat_thread.dart';
import '../../models/message.dart';
import '../chat_service.dart';

class FirebaseChatService implements ChatService {
  final FirebaseFirestore _db;
  FirebaseChatService({FirebaseFirestore? db}) : _db = db ?? FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> get _threads => _db.collection('threads');

  String _threadKey(List<String> participantIds) {
    final sorted = [...participantIds]..sort();
    return sorted.join('_');
  }

  ChatThread _threadFromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    final d = doc.data()!;
    return ChatThread(
      id: doc.id,
      participantIds: (d['participantIds'] as List).cast<String>(),
      lastMessage: d['lastMessageText'] != null
          ? Message(
              id: d['lastMessageId'] as String? ?? 'last',
              threadId: doc.id,
              senderId: d['lastMessageSenderId'] as String? ?? '',
              text: d['lastMessageText'] as String? ?? '',
              timestamp: (d['updatedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
            )
          : null,
      updatedAt: (d['updatedAt'] as Timestamp?)?.toDate() ?? DateTime.fromMillisecondsSinceEpoch(0),
    );
  }

  @override
  Future<List<ChatThread>> listThreads(String userId) async {
    final q = await _threads.where('participantIds', arrayContains: userId).orderBy('updatedAt', descending: true).get();
    return q.docs.map(_threadFromDoc).toList();
  }

  @override
  Future<List<Message>> listMessages(String threadId) async {
    final q = await _threads.doc(threadId).collection('messages').orderBy('timestamp').get();
    return q.docs.map((doc) {
      final d = doc.data();
      return Message(
        id: doc.id,
        threadId: threadId,
        senderId: d['senderId'] as String,
        text: d['text'] as String,
        timestamp: (d['timestamp'] as Timestamp).toDate(),
      );
    }).toList();
  }

  @override
  Future<ChatThread> startThread(List<String> participantIds) async {
    final key = _threadKey(participantIds);
    final q = await _threads.where('key', isEqualTo: key).limit(1).get();
    if (q.docs.isNotEmpty) return _threadFromDoc(q.docs.first);
    final ref = await _threads.add({
      'participantIds': participantIds,
      'key': key,
      'updatedAt': FieldValue.serverTimestamp(),
      'lastMessageText': null,
      'lastMessageSenderId': null,
      'lastMessageId': null,
    });
    final snap = await ref.get();
    return _threadFromDoc(snap);
  }

  @override
  Future<Message> sendMessage({required String threadId, required String senderId, required String text}) async {
    final msgRef = await _threads.doc(threadId).collection('messages').add({
      'senderId': senderId,
      'text': text,
      'timestamp': FieldValue.serverTimestamp(),
    });
    await _threads.doc(threadId).update({
      'updatedAt': FieldValue.serverTimestamp(),
      'lastMessageText': text,
      'lastMessageSenderId': senderId,
      'lastMessageId': msgRef.id,
    });
    final msgSnap = await msgRef.get();
    final d = msgSnap.data()!;
    return Message(
      id: msgRef.id,
      threadId: threadId,
      senderId: d['senderId'] as String,
      text: d['text'] as String,
      timestamp: DateTime.now(),
    );
  }
}

