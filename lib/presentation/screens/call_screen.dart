import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_crm_task/domain/entities/call_entity.dart';
import 'package:flutter_crm_task/presentation/providers/call_provider.dart';

class CallScreen extends ConsumerStatefulWidget {
  final String contactName;
  final String contactId;
  final String userId;
  final String userName;
  final bool isIncoming;

  const CallScreen({
    super.key,
    required this.contactName,
    required this.contactId,
    required this.userId,
    required this.userName,
    this.isIncoming = false,
  });

  @override
  ConsumerState<CallScreen> createState() => _CallScreenState();
}

class _CallScreenState extends ConsumerState<CallScreen> {
  bool _isDisposed = false;
  bool _isInitialized = false;
  String? _callId;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_isDisposed) {
        _initializeCall();
      }
    });
  }

  Future<void> _initializeCall() async {
    if (_isDisposed || _isInitialized) return;
    _isInitialized = true;

    try {
      // Generate a unique call ID and store it
      _callId = DateTime.now().millisecondsSinceEpoch.toString();
      ref.read(activeCallProvider.notifier).state = _callId;

      // Initialize the call controller
      await ref.read(callControllerProvider(_callId!).notifier).initialize();

      if (!widget.isIncoming) {
        await ref
            .read(callControllerProvider(_callId!).notifier)
            .startCall(widget.contactId);
      }
    } catch (e) {
      if (!_isDisposed && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content:
                Text('Failed to initialize call. Please check permissions.'),
          ),
        );
        Navigator.of(context).pop();
      }
    }
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(duration.inHours);
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return duration.inHours > 0
        ? '$hours:$minutes:$seconds'
        : '$minutes:$seconds';
  }

  Future<void> _handleEndCall() async {
    if (_isDisposed || _callId == null) return;

    // Pop the screen before ending the call
    if (!_isDisposed && mounted) {
      Navigator.of(context).pop();
    }

    // End the call
    if (!_isDisposed) {
      await ref.read(callControllerProvider(_callId!).notifier).endCall();
      ref.read(activeCallProvider.notifier).state = null;
    }
  }

  @override
  Widget build(BuildContext context) {
    // Watch the call state
    final callStateAsync =
        _callId != null ? ref.watch(callStateProvider(_callId!)) : null;

    // Watch the call controller state for loading/error states
    final controllerState =
        _callId != null ? ref.watch(callControllerProvider(_callId!)) : null;

    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) async {
        if (!didPop) {
          await _handleEndCall();
        }
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        body: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 50),
              Center(
                child: CircleAvatar(
                  radius: 50,
                  child: Text(
                    widget.contactName[0].toUpperCase(),
                    style: const TextStyle(fontSize: 40),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                widget.contactName,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 10),
              if (controllerState?.isLoading ?? false)
                const CircularProgressIndicator(color: Colors.white)
              else if (controllerState?.hasError ?? false)
                Text(
                  controllerState?.error.toString() ?? 'Call error',
                  style: const TextStyle(color: Colors.red),
                )
              else if (callStateAsync != null)
                callStateAsync.when(
                  data: (callState) => Text(
                    callState.state == CallState.connected
                        ? _formatDuration(callState.duration)
                        : callState.state == CallState.calling
                            ? 'Calling...'
                            : callState.state == CallState.ringing
                                ? 'Ringing...'
                                : '',
                    style: const TextStyle(fontSize: 16, color: Colors.white70),
                  ),
                  loading: () =>
                      const CircularProgressIndicator(color: Colors.white),
                  error: (_, __) => const Text(
                    'Error loading call state',
                    style: TextStyle(color: Colors.red),
                  ),
                )
              else
                const Center(
                  child: Text(
                    'Initializing call...',
                    style: TextStyle(fontSize: 16, color: Colors.white70),
                  ),
                ),
              const Spacer(),
              if (_callId != null &&
                  !(controllerState?.isLoading ?? false)) ...[
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildCallButton(
                        icon: callStateAsync?.maybeWhen(
                              data: (call) =>
                                  call.isMuted ? Icons.mic_off : Icons.mic,
                              orElse: () => Icons.mic,
                            ) ??
                            Icons.mic,
                        label: 'Mute',
                        onPressed: () {
                          if (!_isDisposed) {
                            ref
                                .read(callControllerProvider(_callId!).notifier)
                                .toggleMute();
                          }
                        },
                      ),
                      _buildCallButton(
                        icon: callStateAsync?.maybeWhen(
                              data: (call) => call.isSpeakerOn
                                  ? Icons.volume_up
                                  : Icons.volume_down,
                              orElse: () => Icons.volume_down,
                            ) ??
                            Icons.volume_down,
                        label: 'Speaker',
                        onPressed: () {
                          if (!_isDisposed) {
                            ref
                                .read(callControllerProvider(_callId!).notifier)
                                .toggleSpeaker();
                          }
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),
                _buildEndCallButton(),
              ],
              const SizedBox(height: 50),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCallButton({
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        FloatingActionButton(
          heroTag: null,
          onPressed: onPressed,
          backgroundColor: Colors.white24,
          child: Icon(icon, color: Colors.white),
        ),
        const SizedBox(height: 8),
        Text(label, style: const TextStyle(color: Colors.white70)),
      ],
    );
  }

  Widget _buildEndCallButton() {
    return FloatingActionButton(
      heroTag: null,
      onPressed: _handleEndCall,
      backgroundColor: Colors.red,
      child: const Icon(Icons.call_end, color: Colors.white, size: 30),
    );
  }

  @override
  void dispose() {
    _isDisposed = true;
    super.dispose();
  }
}
