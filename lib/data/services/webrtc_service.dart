import 'dart:async';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_crm_task/domain/entities/call_entity.dart';

class WebRTCService {
  RTCPeerConnection? _peerConnection;
  MediaStream? _localStream;
  MediaStream? _remoteStream;
  RTCVideoRenderer? _localRenderer;
  RTCVideoRenderer? _remoteRenderer;
  bool _isMuted = false;
  bool _isSpeakerOn = false;
  CallState _callState = CallState.idle;
  Timer? _callTimer;
  Duration _callDuration = Duration.zero;
  DateTime? _callStartTime;

  // Getters
  bool get isMuted => _isMuted;
  bool get isSpeakerOn => _isSpeakerOn;
  CallState get callState => _callState;
  Duration get callDuration {
    if (_callStartTime == null || _callState != CallState.connected) {
      return Duration.zero;
    }
    return DateTime.now().difference(_callStartTime!);
  }

  // Initialize WebRTC
  Future<void> initialize() async {
    await _initializeSecurityProvider();
    await _requestPermissions();
    _localRenderer = RTCVideoRenderer();
    _remoteRenderer = RTCVideoRenderer();
    await _localRenderer!.initialize();
    await _remoteRenderer!.initialize();
    await _createPeerConnection();
    _startCallTimer();
    _callStartTime = DateTime.now();
  }

  // Request necessary permissions
  Future<void> _requestPermissions() async {
    await Permission.microphone.request();
    // For future video call support
    // await Permission.camera.request();
  }

  // Start a call
  Future<void> startCall() async {
    if (_peerConnection == null) {
      throw Exception('WebRTC not initialized');
    }
    _callState = CallState.calling;
    _callStartTime = DateTime.now();
  }

  // Answer a call
  Future<void> answerCall() async {
    if (_peerConnection == null) {
      throw Exception('WebRTC not initialized');
    }
    _callState = CallState.connected;
    _callStartTime = DateTime.now();
  }

  // End the call
  Future<void> endCall() async {
    _stopCallTimer();
    await _localStream?.dispose();
    await _peerConnection?.close();
    _callState = CallState.ended;
    _localStream = null;
    _remoteStream = null;
    _callStartTime = null;
  }

  // Toggle mute
  void toggleMute() {
    if (_localStream != null) {
      final audioTrack = _localStream!.getAudioTracks().first;
      _isMuted = !_isMuted;
      audioTrack.enabled = !_isMuted;
    }
  }

  // Toggle speaker
  void toggleSpeaker() {
    _isSpeakerOn = !_isSpeakerOn;
    // Implement audio output switching logic here
  }

  // Create peer connection
  Future<void> _createPeerConnection() async {
    final configuration = <String, dynamic>{
      'iceServers': [
        {'url': 'stun:stun.l.google.com:19302'},
      ],
      'sdpSemantics': 'unified-plan'
    };

    _peerConnection = await createPeerConnection(configuration);

    // Get local media stream
    _localStream = await navigator.mediaDevices.getUserMedia({
      'audio': true,
      'video': false,
    });

    // Add local stream to peer connection
    _localStream!.getTracks().forEach((track) {
      _peerConnection!.addTrack(track, _localStream!);
    });

    // Handle remote stream
    _peerConnection!.onTrack = (RTCTrackEvent event) {
      if (event.streams.isNotEmpty) {
        _remoteStream = event.streams[0];
      }
    };
  }

  // Start call timer
  void _startCallTimer() {
    _callTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _callDuration += const Duration(seconds: 1);
    });
  }

  // Stop call timer
  void _stopCallTimer() {
    _callTimer?.cancel();
    _callTimer = null;
  }

  // Dispose
  Future<void> dispose() async {
    _stopCallTimer();
    await _localStream?.dispose();
    await _peerConnection?.close();
    await _localRenderer?.dispose();
    await _remoteRenderer?.dispose();
  }

  Future<void> _initializeSecurityProvider() async {
    try {
      const platform = MethodChannel('com.example.flutter_crm_task/provider_installer');
      await platform.invokeMethod('installProvider');
    } catch (e) {
      // If provider installation fails, WebRTC will still work but with potential security warnings
      print('Failed to install security provider: $e');
    }
  }
} 