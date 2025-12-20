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
    Message? lastMsg;
    
    if (d['lastMessage'] != null && d['lastMessage'] is Map) {
      final lm = d['lastMessage'] as Map<String, dynamic>;
      lastMsg = Message(
        id: 'last',
        threadId: doc.id,
        senderId: lm['senderId'] ?? '',
        text: lm['text'] ?? '',
        timestamp: (d['updatedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      );
    }

    return ChatThread(
      id: doc.id,
      participantIds: List<String>.from(d['participantIds'] ?? []),
      lastMessage: lastMsg,
      updatedAt: (d['updatedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Message _messageFromDoc(DocumentSnapshot<Map<String, dynamic>> doc, String threadId) {
    final d = doc.data()!;
    return Message(
      id: doc.id,
      threadId: threadId,
      senderId: (d['senderId'] as String?) ?? '',
      text: (d['text'] as String?) ?? '',
      timestamp: (d['timestamp'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  @override
  Future<List<ChatThread>> listThreads(String userId) async {
    final q = await _threads.where('participantIds', arrayContains: userId).get();
    
    final threads = q.docs.map(_threadFromDoc).toList();
    threads.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
    
    return threads;
  }

  @override
  Future<List<Message>> listMessages(String threadId) async {
    final q = await _threads.doc(threadId).collection('messages').orderBy('timestamp').get();
    return q.docs.map((d) => _messageFromDoc(d, threadId)).toList();
  }

  @override
  Future<ChatThread> startThread(List<String> participantIds) async {
    final key = _threadKey(participantIds);
    final q = await _threads.where('key', isEqualTo: key).limit(1).get();
    
    if (q.docs.isNotEmpty) {
      return _threadFromDoc(q.docs.first);
    }

    final ref = await _threads.add({
      'participantIds': participantIds,
      'key': key,
      'updatedAt': FieldValue.serverTimestamp(),
      'lastMessage': null,
    });
    
    final snap = await ref.get();
    return _threadFromDoc(snap);
  }

  @override
  Future<Message> sendMessage({required String threadId, required String senderId, required String text}) async {
    final msgRef = _threads.doc(threadId).collection('messages').doc();
    
    final msgData = {
      'senderId': senderId,
      'text': text,
      'timestamp': FieldValue.serverTimestamp(),
    };

    final batch = _db.batch();
    batch.set(msgRef, msgData);
    batch.update(_threads.doc(threadId), {
      'updatedAt': FieldValue.serverTimestamp(),
      'lastMessage': msgData, 
    });

    await batch.commit();

    return Message(
      id: msgRef.id,
      threadId: threadId,
      senderId: senderId,
      text: text,
      timestamp: DateTime.now(),
    );
  }
}