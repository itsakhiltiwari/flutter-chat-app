import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/user_entity.dart';

abstract class AuthRepository {
  Future<Either<Failure, UserEntity>> signUp(String email, String password);
  Future<Either<Failure, UserEntity>> logIn(String email, String password);
  Future<Either<Failure, void>> logOut();
  Stream<UserEntity?> get user;
}
