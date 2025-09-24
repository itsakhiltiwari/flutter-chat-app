import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../providers/chat_provider.dart';
import 'chat_page.dart';
import '../widgets/user_list_tile.dart';

class UserListPage extends StatefulWidget {
  const UserListPage({super.key});

  @override
  _UserListPageState createState() => _UserListPageState();
}

class _UserListPageState extends State<UserListPage> {
  @override
  void initState() {
    super.initState();
    // Fetch users when the page loads
    Future.microtask(
        () => Provider.of<ChatProvider>(context, listen: false).getUsers());
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final chatProvider = Provider.of<ChatProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Chats'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              authProvider.logOut();
            },
          ),
        ],
      ),
      body: Consumer<ChatProvider>(
        builder: (context, chatProvider, child) {
          if (chatProvider.isLoadingUsers) {
            return const Center(child: CircularProgressIndicator());
          }

          if (chatProvider.userError != null) {
            return Center(child: Text('Error: ${chatProvider.userError}'));
          }

          // ** This is the new logic **
          if (chatProvider.users.isEmpty) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  'No other users found. Sign up with another account to start chatting!',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              ),
            );
          }

          return ListView.builder(
            itemCount: chatProvider.users.length,
            itemBuilder: (ctx, index) {
              final user = chatProvider.users[index];
              return UserListTile(
                user: user,
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (ctx) => ChatPage(
                        receiverUser: user,
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
