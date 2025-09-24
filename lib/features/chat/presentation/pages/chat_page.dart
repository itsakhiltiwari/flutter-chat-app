import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../../auth/domain/entities/user_entity.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../domain/entities/message_entity.dart';
import '../providers/chat_provider.dart';
import '../widgets/message_bubble.dart';

class ChatPage extends StatefulWidget {
  final UserEntity receiverUser;
  const ChatPage({super.key, required this.receiverUser});

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final _controller = TextEditingController();

  void _sendMessage() {
    if (_controller.text.isEmpty) return;
    Provider.of<ChatProvider>(context, listen: false)
        .sendMessage(widget.receiverUser.uid, _controller.text);
    _controller.clear();
  }

  void _showEditDialog(MessageEntity message) {
    final editController = TextEditingController(text: message.text);
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Edit Message'),
        content: TextField(
          controller: editController,
          autofocus: true,
          decoration: const InputDecoration(labelText: 'New message'),
        ),
        actions: [
          TextButton(
            child: const Text('Cancel'),
            onPressed: () => Navigator.of(ctx).pop(),
          ),
          TextButton(
            child: const Text('Save'),
            onPressed: () {
              Provider.of<ChatProvider>(context, listen: false).editMessage(
                  message.id, editController.text, widget.receiverUser.uid);
              Navigator.of(ctx).pop();
            },
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmDialog(MessageEntity message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Message'),
        content: const Text('Are you sure you want to delete this message?'),
        actions: [
          TextButton(
            child: const Text('No'),
            onPressed: () => Navigator.of(ctx).pop(),
          ),
          TextButton(
            child: const Text('Yes'),
            onPressed: () {
              Provider.of<ChatProvider>(context, listen: false)
                  .deleteMessage(message.id, widget.receiverUser.uid);
              Navigator.of(ctx).pop();
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = Provider.of<AuthProvider>(context).user!;

    return Scaffold(
      appBar: AppBar(title: Text(widget.receiverUser.email)),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<List<MessageEntity>>(
              stream: Provider.of<ChatProvider>(context)
                  .getMessages(widget.receiverUser.uid),
              builder: (ctx, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('No messages yet.'));
                }
                final messages = snapshot.data!;
                return ListView.builder(
                  itemCount: messages.length,
                  itemBuilder: (ctx, index) {
                    final message = messages[index];
                    final isMe = message.senderId == currentUser.uid;
                    return GestureDetector(
                      onLongPress: isMe
                          ? () {
                              showModalBottomSheet(
                                  context: context,
                                  builder: (ctx) {
                                    return Wrap(
                                      children: <Widget>[
                                        ListTile(
                                          leading: const Icon(Icons.edit),
                                          title: const Text('Edit'),
                                          onTap: () {
                                            Navigator.pop(context);
                                            _showEditDialog(message);
                                          },
                                        ),
                                        ListTile(
                                          leading: const Icon(Icons.delete),
                                          title: const Text('Delete'),
                                          onTap: () {
                                            Navigator.pop(context);
                                            _showDeleteConfirmDialog(message);
                                          },
                                        ),
                                      ],
                                    );
                                  });
                            }
                          : null,
                      child: MessageBubble(
                        key: ValueKey(message.id),
                        message: message.text,
                        isMe: isMe,
                        timestamp: message.timestamp,
                      ),
                    );
                  },
                );
              },
            ),
          ),
          _buildMessageComposer(),
        ],
      ),
    );
  }

  Widget _buildMessageComposer() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _controller,
              decoration: InputDecoration(
                  labelText: 'Send a message...',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25.0)),
                  contentPadding: const EdgeInsets.symmetric(
                      horizontal: 20.0, vertical: 10.0)),
              onSubmitted: (_) => _sendMessage(),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.send),
            onPressed: _sendMessage,
            color: Theme.of(context).primaryColor,
          ),
        ],
      ),
    );
  }
}
