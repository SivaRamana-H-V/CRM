import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_crm_task/data/models/message_model.dart';
import 'package:flutter_crm_task/data/repositories/chat_repository.dart';

final chatRepositoryProvider = Provider<ChatRepository>((ref) {
  return ChatRepository();
});

final chatMessagesProvider = StreamProvider.family<List<MessageModel>, ({String customerId, String userId})>((ref, params) {
  final repository = ref.watch(chatRepositoryProvider);
  return repository.getMessages(params.userId, params.customerId);
});

final chatControllerProvider = Provider((ref) {
  final repository = ref.watch(chatRepositoryProvider);
  return ChatController(repository);
});

class ChatController {
  final ChatRepository _repository;

  ChatController(this._repository);

  Future<void> sendMessage({
    required String text,
    required String senderId,
    required String receiverId,
  }) async {
    await _repository.sendMessage(
      text: text,
      senderId: senderId,
      receiverId: receiverId,
    );
  }

  Future<void> markAsDelivered(String messageId, String chatId) async {
    await _repository.markAsDelivered(messageId, chatId);
  }

  Future<void> markAsRead(String messageId, String chatId) async {
    await _repository.markAsRead(messageId, chatId);
  }
} 