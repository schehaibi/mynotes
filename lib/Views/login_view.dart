import 'package:flutter/material.dart';
import 'package:mynotes/constants/routes.dart';
import 'package:mynotes/services/auth/auth_exceptions.dart';
import 'package:mynotes/services/auth/auth_service.dart';
import 'package:mynotes/utilities/show_error_dialog.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  late final TextEditingController _email;
  late final TextEditingController _password;

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Login")),
      body: Column(
        children: [
          TextField(
            autocorrect: false,
            controller: _email,
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(hintText: "Enter your Email"),
          ),
          TextField(
            controller: _password,
            autocorrect: false,
            obscureText: true,
            decoration: const InputDecoration(hintText: "Enter your password"),
            enableSuggestions: false,
          ),
          TextButton(
              onPressed: () async {
                final email = _email.text;
                final password = _password.text;
                try {
                  await AuthService.firebase()
                      .logIn(email: email, password: password);

                  final user = AuthService.firebase().currentUser;
                  if (user?.isEmailVerified ?? false) {
                    if (!mounted) return;
                    Navigator.of(context)
                        .pushNamedAndRemoveUntil(mainRoute, (route) => false);
                  } else {
                    if (!mounted) return;
                    Navigator.of(context).pushNamedAndRemoveUntil(
                        verifyEmailRoute, (route) => false);
                  }
                } on UserNotFoundAuthException {
                  await showErrorDialog(
                    context,
                    'user not found',
                  );
                } on WeakPasswordAuthException {
                  await showErrorDialog(
                    context,
                    'wrong credentials',
                  );
                } on GenericAuthException {
                  await showErrorDialog(
                    context,
                    'Authentication error',
                  );
                }
              },
              child: const Text("Login")),
          TextButton(
            onPressed: (() {
              Navigator.of(context).pushNamedAndRemoveUntil(
                registerRoute,
                (route) => false,
              );
            }),
            child: const Text("Not register yet? Register here!"),
          ),
        ],
      ),
    );
  }
}
