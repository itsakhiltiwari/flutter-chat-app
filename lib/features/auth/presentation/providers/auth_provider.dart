import 'package:flutter/material.dart';
import 'package:flutter_chat_app/core/error/failures.dart' show ServerFailure;
import '../../domain/repositories/auth_repository.dart';
import '../../domain/entities/user_entity.dart';

class AuthProvider with ChangeNotifier {
  final AuthRepository authRepository;
  UserEntity? _user;
  bool _isLoading = false;
  String? _errorMessage;

  AuthProvider({required this.authRepository}) {
    authRepository.user.listen((user) {
      _user = user;
      notifyListeners();
    });
  }

  UserEntity? get user => _user;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isAuthenticated => _user != null;

  Future<void> signUp(String email, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final result = await authRepository.signUp(email, password);
    result.fold(
      (failure) => _errorMessage = (failure as ServerFailure).message,
      (userEntity) => _user = userEntity,
    );

    _isLoading = false;
    notifyListeners();
  }

  Future<void> logIn(String email, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final result = await authRepository.logIn(email, password);

    result.fold(
      (failure) {
        if (failure is ServerFailure) {
          _errorMessage = failure.message;
        } else {
          _errorMessage = 'An unexpected error occurred.';
        }
      },
      (userEntity) {
        _user = userEntity;
        _errorMessage = null;
      },
    );

    _isLoading = false;
    notifyListeners();
  }

  Future<void> logOut() async {
    await authRepository.logOut();
    _user = null;
    notifyListeners();
  }
}
