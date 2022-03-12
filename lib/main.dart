import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';

import 'model/technology_model.dart';
import 'screens/home_screen.dart';
import 'services/authentication_service.dart';
import 'screens/auth_screens/login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);
  final AuthenticationService _authenticationService = AuthenticationService();

  Future<User?> getCurrentUser() async {
    return FirebaseAuth.instance.currentUser;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Technology',
      home: ChangeNotifierProvider(
        create: (_) => TechnologyModel(),
        child: FutureBuilder<User?>(
            future: getCurrentUser(),
            builder: (context, snapshot) {
              if (snapshot.connectionState != ConnectionState.done) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              if (snapshot.data == null) {
                return LoginScreen(
                  authenticationService: _authenticationService,
                );
              }
              return HomeScreen(
                authenticationService: _authenticationService,
              );
            }),
      ),
    );
  }
}
