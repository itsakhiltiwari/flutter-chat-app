import 'package:dartz/dartz.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../../auth/domain/entities/user_entity.dart';
import '../../domain/entities/message_entity.dart';
import '../../domain/repositories/chat_repository.dart';
import '../datasources/chat_remote_data_source.dart';

class ChatRepositoryImpl implements ChatRepository {
  final ChatRemoteDataSource remoteDataSource;

  ChatRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<UserEntity>>> getUsers() async {
    try {
      final users = await remoteDataSource.getUsers();
      return Right(users);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Stream<List<MessageEntity>> getMessages(String receiverId) {
    return remoteDataSource.getMessages(receiverId);
  }

  @override
  Future<Either<Failure, void>> sendMessage(
      String receiverId, String text) async {
    try {
      await remoteDataSource.sendMessage(receiverId, text);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> editMessage(
      String messageId, String newText, String receiverId) async {
    try {
      await remoteDataSource.editMessage(messageId, newText, receiverId);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteMessage(
      String messageId, String receiverId) async {
    try {
      await remoteDataSource.deleteMessage(messageId, receiverId);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
