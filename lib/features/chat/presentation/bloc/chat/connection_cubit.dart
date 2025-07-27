import 'dart:async';
import 'package:bloc/bloc.dart';
import '../../../../../core/network/websocket_service.dart';

class ConnectionCubit extends Cubit<WsConnectionStatus> {
  final WebSocketService service;
  StreamSubscription<WsConnectionStatus>? _sub;

  ConnectionCubit(this.service) : super(WsConnectionStatus.connecting) {
    _sub = service.connectionStatus.listen(emit);
    service.connect();
  }

  @override
  Future<void> close() {
    _sub?.cancel();
    service.disconnect();
    return super.close();
  }
}
