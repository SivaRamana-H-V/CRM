import 'package:flutter/material.dart';
import 'package:flutter_crm_task/presentation/screens/call_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../data/models/call_model.dart';
import '../providers/call_provider.dart';

class NoHeroPageRoute<T> extends MaterialPageRoute<T> {
  NoHeroPageRoute({required super.builder, super.settings});

  @override
  Widget buildTransitions(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    return FadeTransition(opacity: animation, child: child);
  }
}

class CallLog {
  final String contactName;
  final String contactId;
  final DateTime timestamp;
  final Duration duration;
  final bool isOutgoing;
  final bool isMissed;

  CallLog({
    required this.contactName,
    required this.contactId,
    required this.timestamp,
    required this.duration,
    required this.isOutgoing,
    this.isMissed = false,
  });
}

// Mock call logs provider
final callLogsProvider = StateNotifierProvider<CallLogsNotifier, List<CallLog>>(
  (ref) {
    return CallLogsNotifier();
  },
);

class CallLogsNotifier extends StateNotifier<List<CallLog>> {
  CallLogsNotifier()
    : super([
        CallLog(
          contactName: 'John Doe',
          contactId: '1',
          timestamp: DateTime.now().subtract(const Duration(hours: 1)),
          duration: const Duration(minutes: 5, seconds: 32),
          isOutgoing: true,
        ),
        CallLog(
          contactName: 'Jane Smith',
          contactId: '2',
          timestamp: DateTime.now().subtract(const Duration(hours: 2)),
          duration: const Duration(seconds: 0),
          isOutgoing: false,
          isMissed: true,
        ),
      ]);

  void addCallLog(CallLog log) {
    state = [log, ...state];
  }

  void clearLogs() {
    state = [];
  }
}

class CallLogsScreen extends ConsumerWidget {
  const CallLogsScreen({super.key});

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inDays == 0) {
      return DateFormat.jm().format(timestamp);
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      return DateFormat.EEEE().format(timestamp);
    } else {
      return DateFormat.yMd().format(timestamp);
    }
  }

  String _formatDuration(Duration duration) {
    if (duration.inSeconds < 60) {
      return '${duration.inSeconds}s';
    } else if (duration.inMinutes < 60) {
      return '${duration.inMinutes}m ${duration.inSeconds % 60}s';
    } else {
      return '${duration.inHours}h ${duration.inMinutes % 60}m';
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final callLogs = ref.watch(callLogsProvider);

    return callLogs.isEmpty
        ? const Center(
          child: Text(
            'No call history',
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
        )
        : ListView.builder(
          itemCount: callLogs.length,
          itemBuilder: (context, index) {
            final call = callLogs[index];
            final name = call.isOutgoing ? call.contactName : call.contactName;
            return ListTile(
              leading: CircleAvatar(
                child: Text(
                  name[0].toUpperCase(),
                  style: const TextStyle(fontSize: 20),
                ),
              ),
              title: Text(
                name,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Row(
                children: [
                  Icon(
                    call.isOutgoing
                        ? Icons.call_made
                        : call.isMissed
                        ? Icons.call_missed
                        : Icons.call_received,
                    size: 16,
                    color: call.isMissed ? Colors.red : Colors.green,
                  ),
                  const SizedBox(width: 4),
                  Text(_formatTimestamp(call.timestamp)),
                  if (!call.isMissed) ...[
                    const Text(' • '),
                    Text(_formatDuration(call.duration)),
                  ],
                ],
              ),
              trailing: IconButton(
                icon: const Icon(Icons.call),
                onPressed: () {
                  Navigator.push(
                    context,
                    NoHeroPageRoute(
                      builder:
                          (context) => CallScreen(
                            contactName: call.contactName,
                            contactId: call.contactId,
                            isIncoming: !call.isOutgoing,
                            userId: '1',
                            userName: 'John Doe',
                          ),
                    ),
                  );
                },
              ),
            );
          },
        );
  }
}
