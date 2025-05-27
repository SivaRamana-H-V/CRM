class CallEntity {
  final String id;
  final String contactId;
  final DateTime startTime;
  final DateTime? endTime;
  final bool isMuted;
  final bool isSpeakerOn;
  final CallState state;

  CallEntity({
    required this.id,
    required this.contactId,
    required this.startTime,
    this.endTime,
    this.isMuted = false,
    this.isSpeakerOn = false,
    this.state = CallState.idle,
  });

  Duration get duration {
    if (state != CallState.connected) return Duration.zero;
    final end = endTime ?? DateTime.now();
    return end.difference(startTime);
  }

  CallEntity copyWith({
    String? id,
    String? contactId,
    DateTime? startTime,
    DateTime? endTime,
    bool? isMuted,
    bool? isSpeakerOn,
    CallState? state,
  }) {
    return CallEntity(
      id: id ?? this.id,
      contactId: contactId ?? this.contactId,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      isMuted: isMuted ?? this.isMuted,
      isSpeakerOn: isSpeakerOn ?? this.isSpeakerOn,
      state: state ?? this.state,
    );
  }
}

enum CallState {
  idle,
  calling,
  ringing,
  connected,
  ended,
} 