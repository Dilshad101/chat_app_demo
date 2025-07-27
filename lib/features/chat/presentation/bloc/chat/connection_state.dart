part of 'connection_bloc.dart';

class ConnectionState extends Equatable {
  final WsConnectionStatus status;
  const ConnectionState({this.status = WsConnectionStatus.connecting});

  ConnectionState copyWith({WsConnectionStatus? status}) {
    return ConnectionState(status: status ?? this.status);
  }

  @override
  List<Object?> get props => [status];
}

