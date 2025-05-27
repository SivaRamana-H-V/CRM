import 'dart:async';
import 'package:uuid/uuid.dart';
import 'package:flutter_crm_task/domain/entities/call_entity.dart';
import 'package:flutter_crm_task/domain/repositories/call_repository.dart';
import 'package:flutter_crm_task/data/services/webrtc_service.dart';

class CallRepositoryImpl implements CallRepository {
  final WebRTCService _webRTCService;
  final _callStates = <String, StreamController<CallEntity>>{};
  final _callHistory = <CallEntity>[];
  final _uuid = const Uuid();

  CallRepositoryImpl(this._webRTCService);

  @override
  Future<void> initializeCall() async {
    await _webRTCService.initialize();
  }

  @override
  Future<void> startCall(String contactId) async {
    final callId = _uuid.v4();
    final call = CallEntity(
      id: callId,
      contactId: contactId,
      startTime: DateTime.now(),
      state: CallState.calling,
    );

    _updateCallState(call);
    await _webRTCService.startCall();
    _callHistory.add(call);
  }

  @override
  Future<void> answerCall(String callId) async {
    final call = _findCall(callId);
    if (call == null) return;

    final updatedCall = call.copyWith(state: CallState.connected);
    _updateCallState(updatedCall);
    await _webRTCService.answerCall();
  }

  @override
  Future<void> endCall(String callId) async {
    final call = _findCall(callId);
    if (call == null) return;

    final updatedCall = call.copyWith(
      state: CallState.ended,
      endTime: DateTime.now(),
    );
    _updateCallState(updatedCall);
    await _webRTCService.endCall();

    _callStates[callId]?.close();
    _callStates.remove(callId);
  }

  @override
  Future<void> toggleMute(String callId) async {
    final call = _findCall(callId);
    if (call == null) return;

    _webRTCService.toggleMute();
    final updatedCall = call.copyWith(isMuted: !call.isMuted);
    _updateCallState(updatedCall);
  }

  @override
  Future<void> toggleSpeaker(String callId) async {
    final call = _findCall(callId);
    if (call == null) return;

    _webRTCService.toggleSpeaker();
    final updatedCall = call.copyWith(isSpeakerOn: !call.isSpeakerOn);
    _updateCallState(updatedCall);
  }

  @override
  Stream<CallEntity> watchCallState(String callId) {
    if (!_callStates.containsKey(callId)) {
      _callStates[callId] = StreamController<CallEntity>.broadcast();
    }
    return _callStates[callId]!.stream;
  }

  @override
  Future<List<CallEntity>> getCallHistory() async {
    return _callHistory;
  }

  void _updateCallState(CallEntity call) {
    if (!_callStates.containsKey(call.id)) {
      _callStates[call.id] = StreamController<CallEntity>.broadcast();
    }
    _callStates[call.id]!.add(call);
  }

  CallEntity? _findCall(String callId) {
    try {
      return _callHistory.firstWhere((call) => call.id == callId);
    } catch (_) {
      return null;
    }
  }

  void dispose() {
    for (final controller in _callStates.values) {
      controller.close();
    }
    _callStates.clear();
  }
}
