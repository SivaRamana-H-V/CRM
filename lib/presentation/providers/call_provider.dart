import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/call_entity.dart';
import '../../domain/repositories/call_repository.dart';
import '../../data/repositories/call_repository_impl.dart';
import '../../data/services/webrtc_service.dart';

final webRTCServiceProvider = Provider<WebRTCService>((ref) {
  final service = WebRTCService();
  ref.onDispose(() => service.dispose());
  return service;
});

final callRepositoryProvider = Provider<CallRepository>((ref) {
  final service = ref.watch(webRTCServiceProvider);
  final repository = CallRepositoryImpl(service);
  ref.onDispose(() {
    repository.dispose();
    });
  return repository;
});

final callStateProvider = StreamProvider.family<CallEntity, String>((ref, callId) {
  final repository = ref.watch(callRepositoryProvider);
  return repository.watchCallState(callId);
});

final callHistoryProvider = FutureProvider<List<CallEntity>>((ref) {
  final repository = ref.watch(callRepositoryProvider);
  return repository.getCallHistory();
});

final activeCallProvider = StateProvider<String?>((ref) => null);

class CallController extends StateNotifier<AsyncValue<void>> {
  final CallRepository _repository;
  final String _callId;

  CallController(this._repository, this._callId) : super(const AsyncValue.data(null));

  Future<void> initialize() async {
    state = const AsyncValue.loading();
    try {
      await _repository.initializeCall();
      state = const AsyncValue.data(null);
    } catch (error, stack) {
      state = AsyncValue.error(error, stack);
    }
  }

  Future<void> startCall(String contactId) async {
    state = const AsyncValue.loading();
    try {
      await _repository.startCall(contactId);
      state = const AsyncValue.data(null);
    } catch (error, stack) {
      state = AsyncValue.error(error, stack);
    }
  }

  Future<void> answerCall() async {
    state = const AsyncValue.loading();
    try {
      await _repository.answerCall(_callId);
      state = const AsyncValue.data(null);
    } catch (error, stack) {
      state = AsyncValue.error(error, stack);
    }
  }

  Future<void> endCall() async {
    state = const AsyncValue.loading();
    try {
      await _repository.endCall(_callId);
      state = const AsyncValue.data(null);
    } catch (error, stack) {
      state = AsyncValue.error(error, stack);
    }
  }

  Future<void> toggleMute() async {
    try {
      await _repository.toggleMute(_callId);
    } catch (error, stack) {
      state = AsyncValue.error(error, stack);
    }
  }

  Future<void> toggleSpeaker() async {
    try {
      await _repository.toggleSpeaker(_callId);
    } catch (error, stack) {
      state = AsyncValue.error(error, stack);
    }
  }
}

final callControllerProvider = StateNotifierProvider.family<CallController, AsyncValue<void>, String>(
  (ref, callId) {
    final repository = ref.watch(callRepositoryProvider);
    return CallController(repository, callId);
  },
);
