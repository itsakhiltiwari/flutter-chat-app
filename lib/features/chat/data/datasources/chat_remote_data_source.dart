import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../../core/error/exceptions.dart';
import '../../../auth/data/models/user_model.dart';
import '../models/message_model.dart';

abstract class ChatRemoteDataSource {
  Future<List<UserModel>> getUsers();
  Stream<List<MessageModel>> getMessages(String receiverId);
  Future<void> sendMessage(String receiverId, String text);
  Future<void> editMessage(String messageId, String newText, String receiverId);
  Future<void> deleteMessage(String messageId, String receiverId);
}

class ChatRemoteDataSourceImpl implements ChatRemoteDataSource {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _firebaseAuth;

  ChatRemoteDataSourceImpl(this._firestore, this._firebaseAuth);

  String get _currentUserId => _firebaseAuth.currentUser!.uid;

  @override
  Future<List<UserModel>> getUsers() async {
    try {
      final snapshot = await _firestore.collection('users').get();
      return snapshot.docs
          .where((doc) => doc.id != _currentUserId)
          .map((doc) => UserModel.fromFirestore(doc))
          .toList();
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Stream<List<MessageModel>> getMessages(String receiverId) {
    List<String> ids = [_currentUserId, receiverId];
    ids.sort();
    String chatRoomId = ids.join("_");

    return _firestore
        .collection('chat_rooms')
        .doc(chatRoomId)
        .collection('messages')
        .orderBy('timestamp', descending: false)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => MessageModel.fromFirestore(doc))
            .toList());
  }

  @override
  Future<void> sendMessage(String receiverId, String text) async {
    List<String> ids = [_currentUserId, receiverId];
    ids.sort();
    String chatRoomId = ids.join("_");

    final newMessage = MessageModel(
      id: '', // Firestore will generate it
      senderId: _currentUserId,
      receiverId: receiverId,
      text: text,
      timestamp: DateTime.now(),
    );

    await _firestore
        .collection('chat_rooms')
        .doc(chatRoomId)
        .collection('messages')
        .add(newMessage.toFirestore());
  }

  @override
  Future<void> editMessage(
      String messageId, String newText, String receiverId) async {
    List<String> ids = [_currentUserId, receiverId];
    ids.sort();
    String chatRoomId = ids.join("_");

    await _firestore
        .collection('chat_rooms')
        .doc(chatRoomId)
        .collection('messages')
        .doc(messageId)
        .update({'text': newText});
  }

  @override
  Future<void> deleteMessage(String messageId, String receiverId) async {
    List<String> ids = [_currentUserId, receiverId];
    ids.sort();
    String chatRoomId = ids.join("_");

    await _firestore
        .collection('chat_rooms')
        .doc(chatRoomId)
        .collection('messages')
        .doc(messageId)
        .delete();
  }
}
