import 'package:cloud_firestore/cloud_firestore.dart';

class MessageModel {
  final String id;
  final String text;
  final String senderId;
  final String receiverId;
  final DateTime timestamp;
  final bool isDelivered;
  final bool isRead;

  MessageModel({
    required this.id,
    required this.text,
    required this.senderId,
    required this.receiverId,
    required this.timestamp,
    this.isDelivered = false,
    this.isRead = false,
  });

  factory MessageModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return MessageModel(
      id: doc.id,
      text: data['text'] ?? '',
      senderId: data['senderId'] ?? '',
      receiverId: data['receiverId'] ?? '',
      timestamp: (data['timestamp'] as Timestamp).toDate(),
      isDelivered: data['isDelivered'] ?? false,
      isRead: data['isRead'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'text': text,
      'senderId': senderId,
      'receiverId': receiverId,
      'timestamp': Timestamp.fromDate(timestamp),
      'isDelivered': isDelivered,
      'isRead': isRead,
    };
  }
} 