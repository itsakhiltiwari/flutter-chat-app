import 'package:flutter/material.dart';
import '../../domain/repositories/chat_repository.dart';
import '../../../auth/domain/entities/user_entity.dart';
import '../../domain/entities/message_entity.dart';

class ChatProvider with ChangeNotifier {
  final ChatRepository chatRepository;

  List<UserEntity> _users = [];
  bool _isLoadingUsers = false;
  String? _userError;

  ChatProvider({required this.chatRepository});

  List<UserEntity> get users => _users;
  bool get isLoadingUsers => _isLoadingUsers;
  String? get userError => _userError;

  Future<void> getUsers() async {
    _isLoadingUsers = true;
    notifyListeners();

    final result = await chatRepository.getUsers();
    result.fold(
      (failure) => _userError = failure.toString(),
      (userList) => _users = userList,
    );

    _isLoadingUsers = false;
    notifyListeners();
  }

  Stream<List<MessageEntity>> getMessages(String receiverId) {
    return chatRepository.getMessages(receiverId);
  }

  Future<void> sendMessage(String receiverId, String text) async {
    await chatRepository.sendMessage(receiverId, text);
  }

  Future<void> editMessage(
      String messageId, String newText, String receiverId) async {
    await chatRepository.editMessage(messageId, newText, receiverId);
  }

  Future<void> deleteMessage(String messageId, String receiverId) async {
    await chatRepository.deleteMessage(messageId, receiverId);
  }
}
