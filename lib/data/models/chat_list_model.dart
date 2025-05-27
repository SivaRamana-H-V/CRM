import 'package:cloud_firestore/cloud_firestore.dart';

class ChatListModel {
  final String chatId;
  final List<String> participants;
  final String lastMessage;
  final DateTime lastMessageTime;
  final String customerName;
  final bool isOnline;

  ChatListModel({
    required this.chatId,
    required this.participants,
    required this.lastMessage,
    required this.lastMessageTime,
    required this.customerName,
    this.isOnline = false,
  });

  factory ChatListModel.fromFirestore(DocumentSnapshot doc, {required String customerName}) {
    final data = doc.data() as Map<String, dynamic>;
    return ChatListModel(
      chatId: doc.id,
      participants: List<String>.from(data['participants'] ?? []),
      lastMessage: data['lastMessage'] ?? '',
      lastMessageTime: (data['lastMessageTime'] as Timestamp).toDate(),
      customerName: customerName,
    );
  }
} 