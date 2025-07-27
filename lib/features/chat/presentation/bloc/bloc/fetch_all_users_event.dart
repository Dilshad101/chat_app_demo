part of 'fetch_all_users_bloc.dart';

abstract class UserEvent extends Equatable {
  const UserEvent();

  @override
  List<Object> get props => [];
}

class GetAllUsersEvent extends UserEvent {
  const GetAllUsersEvent();
}

class RefreshUsersEvent extends UserEvent {
  const RefreshUsersEvent();
}
