import 'package:flutter/material.dart';
import '../../../auth/domain/entities/user_entity.dart';

class UserListTile extends StatelessWidget {
  final UserEntity user;
  final VoidCallback onTap;

  const UserListTile({
    super.key,
    required this.user,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        child: Text(user.email[0].toUpperCase()),
      ),
      title: Text(user.email),
      subtitle: const Text("Last message..."),
      onTap: onTap,
    );
  }
}
