import 'package:flutter/material.dart';
import 'package:provider/src/provider.dart';
import 'package:search_githab/domain/api_client/secret_keys.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'auth_bloc/auth_bloc.dart';

class GitHubSignInPage extends StatelessWidget {
  const GitHubSignInPage({Key? key}) : super(key: key);

  //"&scope=public_repo%20read:user%20user:email";
  final String _redirect =
      'https://githabsearch.firebaseapp.com/__/auth/handler';
  final String _userAgentMacOSX =
      "Mozilla/5.0 (Macintosh; Intel Mac OS X 11_6) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/94.0.4606.61 Safari/537.36";
  final String _url = "https://github.com/login/oauth/authorize?client_id=" +
      GitHubKeys.githubClientId +
      "&scope=user:email";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign In'),
      ),
      body: WebView(
        initialUrl: _url,
        userAgent: _userAgentMacOSX,
        javascriptMode: JavascriptMode.unrestricted,
        onWebViewCreated: (WebViewController controller) {
          controller.clearCache();
          CookieManager manager = CookieManager();
          manager.clearCookies();
        },
        onPageFinished: (url) {
          if (url.contains("error=")) {
            //Exception(Uri.parse(url).queryParameters["error"]),
            Navigator.of(context).pop();
          } else if (url.startsWith(_redirect)) {
            final code = url.replaceFirst("$_redirect?code=", "").trim();
            context.read<AuthBloc>().add(AuthEvent.signIn(code));
            Navigator.of(context).pop();
          }
        },
      ),
    );
  }
}
