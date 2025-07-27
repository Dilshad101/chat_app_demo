import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../data/models/users_listing_model.dart';

abstract class UserRepository {
  Future<Either<Failure, UsersListingModel>> getAllUsers();
}
