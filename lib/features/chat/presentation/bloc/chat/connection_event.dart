part of 'connection_bloc.dart';

abstract class ConnectionEvent extends Equatable {
  const ConnectionEvent();

  @override
  List<Object?> get props => [];
}

class ConnectionStarted extends ConnectionEvent {
  const ConnectionStarted();
}

class _StatusChanged extends ConnectionEvent {
  final WsConnectionStatus status;
  const _StatusChanged(this.status);

  @override
  List<Object?> get props => [status];
}

