import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:search_githab/domain/entity/user.dart';
import 'package:search_githab/presentation/auth_screen/auth_bloc/auth_bloc.dart';

import 'github_sign_in_page.dart';

class AuthScreen extends StatelessWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Account'),
      ),
      body: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          return state.when(
            initial: () => LoginButton(
              text: 'Sign In',
              callback: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const GitHubSignInPage(),
                ),
              ),
            ),
            loading: () => const Center(child: CircularProgressIndicator()),
            success: (user) => Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    LoginButton(
                        text: 'Sign Out',
                        callback: () => context
                            .read<AuthBloc>()
                            .add(const AuthEvent.signOut())),
                  ],
                ),
                InfoUser(user: user),
              ],
            ),
            error: (error) => Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                LoginButton(
                  text: 'Sign In',
                  callback: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const GitHubSignInPage(),
                    ),
                  ),
                ),
                Text(
                  error,
                  style: const TextStyle(color: Colors.red, fontSize: 18),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class InfoUser extends StatelessWidget {
  final User user;

  const InfoUser({
    required this.user,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 150,
            width: 100,
            child: DecoratedBox(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                  fit: BoxFit.scaleDown,
                  image: NetworkImage(
                    user.avatarUrl,
                  ),
                ),
              ),
            ),
          ),
          Text(
            'Login: ${user.login}',
            style: const TextStyle(color: Colors.blue),
          ),
          const SizedBox(height: 10),
          Text(
            'Name: ${user.name ?? ''}',
            style: const TextStyle(color: Colors.blue),
          ),
          const SizedBox(height: 10),
          Text(
            'Email: ${user.email ?? ''}',
            style: const TextStyle(color: Colors.blue),
          ),
          const SizedBox(height: 10),
          Text(
            'Public repos: ${user.publicRepos ?? ''}',
            style: const TextStyle(color: Colors.blue),
          ),
          const SizedBox(height: 10),
          Text(
            'Public gists: ${user.publicGists ?? ''}',
            style: const TextStyle(color: Colors.blue),
          ),
          const SizedBox(height: 10),
          Text(
            'Followers: ${user.followers ?? ''}',
            style: const TextStyle(color: Colors.blue),
          ),
          const SizedBox(height: 10),
          Text(
            'Following: ${user.following ?? ''}',
            style: const TextStyle(color: Colors.blue),
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}

class LoginButton extends StatelessWidget {
  final String text;
  final void Function() callback;

  const LoginButton({Key? key, required this.text, required this.callback})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.4,
        child: ElevatedButton(
            onPressed: () {
              callback();
            },
            style: ElevatedButton.styleFrom(
              shape: const StadiumBorder(),
              primary: Colors.amber,
            ),
            child: Text(text)),
      ),
    );
  }
}
