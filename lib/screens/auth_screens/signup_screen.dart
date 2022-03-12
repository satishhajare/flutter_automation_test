import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'login_screen.dart';
import '../home_screen.dart';
import '../../model/technology_model.dart';
import '../../services/authentication_service.dart';

class SignUpScreen extends StatefulWidget {
  final AuthenticationService? authenticationService;
  const SignUpScreen({Key? key, @required this.authenticationService})
      : super(key: key);

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
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
      body: ListView(children: [
        Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    'Signup',
                    style: TextStyle(
                      fontSize: 30,
                      color: Colors.grey.shade400,
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  child: TextFormField(
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
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  child: TextFormField(
                    controller: _confirmPasswordController,
                    obscureText: true,
                    cursorColor: Colors.green.shade900,
                    style: TextStyle(color: Colors.grey.shade400),
                    decoration: InputDecoration(
                      labelText: 'Confirm Password',
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
                    validator: (s) => _passwordController.value.text !=
                            _confirmPasswordController.value.text
                        ? 'Password dont match'
                        : null,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.all(16),
          child: ElevatedButton(
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.resolveWith(
                (states) => Colors.green.shade800,
              ),
            ),
            onPressed: () async {
              if (_formKey.currentState!.validate()) {
                final result = await _authenticationService.registerNewUser(
                  _emailController.value.text.trim(),
                  _passwordController.value.text,
                );
                if (result == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Error registering new user',
                      ),
                      backgroundColor: Colors.redAccent,
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                } else if (result.substring(0, 7) == 'ERROR: ') {
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
                              create: (context) => TechnologyModel(),
                              child: HomeScreen(
                                authenticationService: _authenticationService,
                              ),
                            )),
                  );
                }
              }
            },
            child: const Text('Sign Up!'),
          ),
        ),
        TextButton(
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute<LoginScreen>(
                  builder: (_) => ChangeNotifierProvider(
                        create: (context) => TechnologyModel(),
                        child: LoginScreen(
                          authenticationService: _authenticationService,
                        ),
                      )),
            );
          },
          child: const Text('Login'),
        ),
      ]),
    );
  }
}
