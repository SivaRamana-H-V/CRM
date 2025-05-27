import 'package:flutter_crm_task/domain/entities/call_entity.dart';

abstract class CallRepository {
  Future<void> initializeCall();
  Future<void> startCall(String contactId);
  Future<void> answerCall(String callId);
  Future<void> endCall(String callId);
  Future<void> toggleMute(String callId);
  Future<void> toggleSpeaker(String callId);
  Stream<CallEntity> watchCallState(String callId);
  Future<List<CallEntity>> getCallHistory();
} 