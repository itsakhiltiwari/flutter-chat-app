import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../auth/domain/entities/user_entity.dart';
import '../entities/message_entity.dart';

abstract class ChatRepository {
  Future<Either<Failure, List<UserEntity>>> getUsers();
  Stream<List<MessageEntity>> getMessages(String receiverId);
  Future<Either<Failure, void>> sendMessage(String receiverId, String text);
  Future<Either<Failure, void>> editMessage(
      String messageId, String newText, String receiverId);
  Future<Either<Failure, void>> deleteMessage(
      String messageId, String receiverId);
}
