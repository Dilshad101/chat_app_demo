import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../../data/models/chat_message.dart';
import '../repositories/message_repository.dart';

class SendMessage implements UseCase<void, ChatMessage> {
  final MessageRepository repository;
  SendMessage(this.repository);

  @override
  Future<Either<Failure, void>> call(ChatMessage params) async {
    try {
      await repository.sendMessage(params);
      return const Right(null);
    } catch (_) {
      return Left(CacheFailure());
    }
  }
}
