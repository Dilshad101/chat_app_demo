import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../../data/models/users_listing_model.dart';
import '../repositories/user_repository.dart';

class GetAllUsers implements UseCase<UsersListingModel, NoParams> {
  final UserRepository repository;

  GetAllUsers(this.repository);

  @override
  Future<Either<Failure, UsersListingModel>> call(NoParams params) async {
    return await repository.getAllUsers();
  }
}
