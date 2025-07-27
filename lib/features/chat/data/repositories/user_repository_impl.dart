import 'package:dartz/dartz.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/repositories/user_repository.dart';
import '../datasources/chat_local_data_source.dart';
import '../datasources/number_trivia_remote_data_source.dart';
import '../models/users_listing_model.dart';

typedef Future<UsersListingModel> _UsersGetter();

class UsersRepostoryImpl implements UserRepository {
  final ChatRemoteDataSource remoteDataSource;
  final ChatLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  UsersRepostoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, UsersListingModel>> getAllUsers() async {
    return await _getallusers(() {
      return remoteDataSource.getAllUsers();
    });
  }

  Future<Either<Failure, UsersListingModel>> _getallusers(
    _UsersGetter getUsers,
  ) async {
    if (await networkInfo.isConnected) {
      try {
        final users = await getUsers();
        localDataSource.getAllCachedUserProfile();
        return Right(users);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      try {
        final users = await localDataSource.getAllCachedUserProfile();
        final userList = UsersListingModel(users: users);

        return Right(userList);
      } on CacheException {
        return Left(CacheFailure());
      }
    }
  }
}
