import 'package:flutter/material.dart';
import '../../../../core/network/websocket_service.dart';

class ConnectionStatus extends StatelessWidget {
  final WsConnectionStatus status;

  const ConnectionStatus({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    if (status == WsConnectionStatus.connecting) {
      return const Text(
        'Connecting...',
        style: TextStyle(fontSize: 14),
      );
    }

    final isConnected = status == WsConnectionStatus.connected;

    return Row(
      children: [
        Text(
          isConnected ? 'Active' : 'Disconnected from server',
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey.shade600,
          ),
        ),
        const SizedBox(width: 8),
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: isConnected ? Colors.green : Colors.red,
            shape: BoxShape.circle,
          ),
        ),
      ],
    );
  }
}