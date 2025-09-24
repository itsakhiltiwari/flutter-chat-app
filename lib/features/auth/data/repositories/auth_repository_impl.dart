import 'package:dartz/dartz.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_data_source.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  AuthRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, UserEntity>> signUp(
      String email, String password) async {
    try {
      final user = await remoteDataSource.signUp(email, password);
      return Right(user);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> logIn(
      String email, String password) async {
    try {
      final user = await remoteDataSource.logIn(email, password);
      return Right(user);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, void>> logOut() async {
    try {
      await remoteDataSource.logOut();
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure("Logout failed"));
    }
  }

  @override
  Stream<UserEntity?> get user => remoteDataSource.user;
}
