import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_crm_task/data/models/message_model.dart';

class ChatRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<List<MessageModel>> getMessages(String userId, String customerId) {
    return _firestore
        .collection('chats')
        .doc(_getChatId(userId, customerId))
        .collection('messages')
        .orderBy('timestamp', descending: false)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => MessageModel.fromFirestore(doc))
          .toList();
    });
  }

  Future<void> sendMessage({
    required String text,
    required String senderId,
    required String receiverId,
  }) async {
    final chatId = _getChatId(senderId, receiverId);
    final messageRef =
        _firestore.collection('chats').doc(chatId).collection('messages').doc();

    final message = MessageModel(
      id: messageRef.id,
      text: text,
      senderId: senderId,
      receiverId: receiverId,
      timestamp: DateTime.now(),
    );

    await messageRef.set(message.toMap());

    // Update last message in chat document
    await _firestore.collection('chats').doc(chatId).set({
      'lastMessage': text,
      'lastMessageTime': Timestamp.now(),
      'participants': [senderId, receiverId],
    }, SetOptions(merge: true));
  }

  Future<void> markAsDelivered(String messageId, String chatId) async {
    await _firestore
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .doc(messageId)
        .update({'isDelivered': true});
  }

  Future<void> markAsRead(String messageId, String chatId) async {
    await _firestore
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .doc(messageId)
        .update({'isRead': true});
  }

  String _getChatId(String userId1, String userId2) {
    // Create a consistent chat ID regardless of who is sender/receiver
    final List<String> ids = [userId1, userId2]..sort();
    return '${ids[0]}_${ids[1]}';
  }
}
