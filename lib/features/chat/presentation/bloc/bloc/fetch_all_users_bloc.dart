import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../../core/error/failures.dart';
import '../../../../../core/usecases/usecase.dart';
import '../../../data/models/users_listing_model.dart';
import '../../../domain/usecases/get_all_users_usecase.dart';

part 'fetch_all_users_event.dart';
part 'fetch_all_users_state.dart';

const String SERVER_FAILURE_MESSAGE = 'Server Failure';
const String CACHE_FAILURE_MESSAGE = 'Cache Failure';

class UserBloc extends Bloc<UserEvent, UserState> {
  final GetAllUsers getAllUsers;

  UserBloc({required this.getAllUsers}) : super(const UserInitial()) {
    on<GetAllUsersEvent>(_onGetAllUsers);
  }

  Future<void> _onGetAllUsers(
    GetAllUsersEvent event,
    Emitter<UserState> emit,
  ) async {
    emit(const UserLoading());

    final failureOrUsers = await getAllUsers(NoParams());

    emit(_eitherLoadedOrErrorState(failureOrUsers));
  }

  UserState _eitherLoadedOrErrorState(failureOrUsers) {
    return failureOrUsers.fold(
      (failure) => UserError(message: _mapFailureToMessage(failure)),
      (usersListing) => UserLoaded(usersListing: usersListing),
    );
  }

  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case const (ServerFailure):
        return SERVER_FAILURE_MESSAGE;
      case const (CacheFailure):
        return CACHE_FAILURE_MESSAGE;
      default:
        return 'Unexpected Error';
    }
  }
}
