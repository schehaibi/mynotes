import 'package:flutter/material.dart';
import 'package:mynotes/constants/routes.dart';
import 'package:mynotes/services/auth/auth_exceptions.dart';
import 'package:mynotes/services/auth/auth_service.dart';
import 'package:mynotes/utilities/show_error_dialog.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  late final TextEditingController
      _email; //declaring the type of variables _email and _password like in java
  late final TextEditingController
      _password; //late mean that we will add a value to the variables soon

  @override
  void initState() {
    _email = TextEditingController(); //instanciate our variables
    _password = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose(); //kill the instance
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Register")),
      body: Column(
        children: [
          TextField(
            controller: _email,
            autocorrect: false,
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(hintText: 'Enter your email'),
          ),
          TextField(
            controller: _password,
            obscureText: true,
            enableSuggestions: false,
            autocorrect: false,
            decoration: const InputDecoration(hintText: "Enter your password"),
          ),
          TextButton(
            onPressed: () async {
              final email = _email.text;
              final password = _password.text;
              try {
                await AuthService.firebase()
                    .createUser(email: email, password: password);
                AuthService.firebase().sendEmailVerification();
                if (!mounted) return;
                Navigator.of(context).pushNamed(
                  verifyEmailRoute,
                );
              } on WeakPasswordAuthException {
                await showErrorDialog(
                  context,
                  "weak password",
                );
              } on InvalidEmailAuthException {
                await showErrorDialog(
                  context,
                  "invalid email",
                );
              } on EmailAlreadyInUseAuthException {
                await showErrorDialog(
                  context,
                  "email already in use",
                );
              } on GenericAuthException {
                await showErrorDialog(
                  context,
                  "email already in use",
                );
              }
            },
            child: const Text('Register'),
          ),
          TextButton(
              onPressed: () {
                Navigator.of(context)
                    .pushNamedAndRemoveUntil(loginRoute, (route) => false);
              },
              child: const Text("Already registred! Login here!")),
        ],
      ),
    );
  }
}
