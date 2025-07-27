import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../../data/models/chat_message.dart';
import '../repositories/message_repository.dart';

class ChatParams {
  final String userA;
  final String userB;
  ChatParams({required this.userA, required this.userB});
}

class GetMessagesForChat implements UseCase<List<ChatMessage>, ChatParams> {
  final MessageRepository repository;
  GetMessagesForChat(this.repository);

  @override
  Future<Either<Failure, List<ChatMessage>>> call(ChatParams params) async {
    try {
      final messages = await repository.getMessagesForChat(params.userA, params.userB);
      return Right(messages);
    } catch (_) {
      return Left(CacheFailure());
    }
  }
}
