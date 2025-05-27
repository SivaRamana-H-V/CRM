class CallModel {
  final String id;
  final String callerId;
  final String callerName;
  final String customerId;
  final String customerName;
  final DateTime timestamp;
  final Duration duration;
  final bool isOutgoing;
  final bool isMissed;
  final bool isOngoing;

  CallModel({
    required this.id,
    required this.callerId,
    required this.callerName,
    required this.customerId,
    required this.customerName,
    required this.timestamp,
    this.duration = const Duration(),
    required this.isOutgoing,
    this.isMissed = false,
    this.isOngoing = false,
  });

  CallModel copyWith({
    String? id,
    String? callerId,
    String? callerName,
    String? customerId,
    String? customerName,
    DateTime? timestamp,
    Duration? duration,
    bool? isOutgoing,
    bool? isMissed,
    bool? isOngoing,
  }) {
    return CallModel(
      id: id ?? this.id,
      callerId: callerId ?? this.callerId,
      callerName: callerName ?? this.callerName,
      customerId: customerId ?? this.customerId,
      customerName: customerName ?? this.customerName,
      timestamp: timestamp ?? this.timestamp,
      duration: duration ?? this.duration,
      isOutgoing: isOutgoing ?? this.isOutgoing,
      isMissed: isMissed ?? this.isMissed,
      isOngoing: isOngoing ?? this.isOngoing,
    );
  }
} 