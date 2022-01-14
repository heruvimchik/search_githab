import 'package:flutter/material.dart';

import 'github_sign_in_page.dart';

class AuthScreen extends StatelessWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: ElevatedButton(
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const GitHubSignInPage(),
              ),
            );
          },
          child: const Text('Log in')),
    );
  }
}
