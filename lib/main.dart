import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_chat_app/firebase_options.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'features/auth/data/datasources/auth_remote_data_source.dart';
import 'features/auth/data/repositories/auth_repository_impl.dart';
import 'features/auth/presentation/providers/auth_provider.dart'
    as auth_provider;
import 'features/auth/presentation/widgets/auth_wrapper.dart';

import 'features/chat/data/datasources/chat_remote_data_source.dart';
import 'features/chat/data/repositories/chat_repository_impl.dart';
import 'features/chat/presentation/providers/chat_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final firebaseAuth = FirebaseAuth.instance;
    final firestore = FirebaseFirestore.instance;

    final authRemoteDataSource =
        AuthRemoteDataSourceImpl(firebaseAuth, firestore);
    final authRepository =
        AuthRepositoryImpl(remoteDataSource: authRemoteDataSource);

    final chatRemoteDataSource =
        ChatRemoteDataSourceImpl(firestore, firebaseAuth);
    final chatRepository =
        ChatRepositoryImpl(remoteDataSource: chatRemoteDataSource);

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) =>
              auth_provider.AuthProvider(authRepository: authRepository),
        ),
        ChangeNotifierProvider(
          create: (_) => ChatProvider(chatRepository: chatRepository),
        ),
      ],
      child: MaterialApp(
        title: 'Flutter Chat App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: const AuthWrapper(),
      ),
    );
  }
}
