import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'signup_screen.dart';
import '../../model/technology_model.dart';
import '../home_screen.dart';
import '../../services/authentication_service.dart';

class LoginScreen extends StatefulWidget {
  final AuthenticationService? authenticationService;
  const LoginScreen({Key? key, @required this.authenticationService})
      : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  late AuthenticationService _authenticationService;

  @override
  void initState() {
    _authenticationService = widget.authenticationService!;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade900,
      body: ListView(
        children: [
          Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text(
                      'Login',
                      style: TextStyle(
                        fontSize: 30,
                        color: Colors.grey.shade400,
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    child: TextFormField(
                      key: const ValueKey('emailLoginField'),
                      controller: _emailController,
                      cursorColor: Colors.green.shade900,
                      style: TextStyle(color: Colors.grey.shade400),
                      decoration: InputDecoration(
                        labelText: 'Email',
                        labelStyle: TextStyle(
                          color: Colors.grey.shade400,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25.0),
                          borderSide: BorderSide(
                            color: Colors.green.shade900,
                            width: 2,
                          ),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      validator: (s) =>
                          !s!.contains('@') ? 'invalid email' : null,
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    child: TextFormField(
                      key: const ValueKey('passwordLoginField'),
                      controller: _passwordController,
                      obscureText: true,
                      cursorColor: Colors.green.shade900,
                      style: TextStyle(color: Colors.grey.shade400),
                      decoration: InputDecoration(
                        labelText: 'Password',
                        labelStyle: TextStyle(
                          color: Colors.grey.shade400,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25.0),
                          borderSide: BorderSide(
                            color: Colors.green.shade900,
                            width: 2,
                          ),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      validator: (s) => s!.length <= 6
                          ? 'Password must be greater than 6'
                          : null,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.resolveWith(
                  (states) => Colors.green.shade800,
                ),
              ),
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  final result = await _authenticationService.loginUser(
                    _emailController.value.text.trim(),
                    _passwordController.value.text.trim(),
                  );
                  if (result!.substring(0, 7) == 'ERROR: ') {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          result.substring(7),
                        ),
                        backgroundColor: Colors.redAccent,
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: const Text(
                          'User Signed In',
                        ),
                        backgroundColor: Colors.green.shade400,
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute<HomeScreen>(
                        builder: (_) => ChangeNotifierProvider(
                          create: (_) => TechnologyModel(),
                          child: HomeScreen(
                            authenticationService: _authenticationService,
                          ),
                        ),
                      ),
                    );
                  }
                }
              },
              child: const Text('Login'),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute<SignUpScreen>(
                  builder: (_) => ChangeNotifierProvider(
                    create: (_) => TechnologyModel(),
                    child: SignUpScreen(
                      authenticationService: _authenticationService,
                    ),
                  ),
                ),
              );
            },
            child: const Text('Sign Up'),
          ),
        ],
      ),
    );
  }
}
