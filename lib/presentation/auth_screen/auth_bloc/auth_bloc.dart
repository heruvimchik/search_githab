import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:search_githab/domain/api_client/api_client_exception.dart';
import 'package:search_githab/domain/api_client/secret_keys.dart';
import 'package:search_githab/domain/entity/user.dart';
import 'package:search_githab/domain/repositories/github_repository.dart';
import 'package:uni_links/uni_links.dart';
import 'package:url_launcher/url_launcher.dart';

part 'auth_bloc.freezed.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final GithubRepository githubRepository;
  StreamSubscription? _subs;

  AuthBloc({required this.githubRepository})
      : super(const AuthState.initial()) {
    on<SignIn>(
      _onSignIn,
    );
  }

  void _onSignIn(
    SignIn event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthState.loading());

    // const String url = "https://github.com/login/oauth/authorize?client_id=" +
    //     GitHubKeys.githubClientId +
    //     "&scope=user:email";
    // //"&scope=public_repo%20read:user%20user:email";
    //
    // _subs = linkStream.listen(
    //     (String? link) async {
    //       _subs?.cancel();
    //       _checkDeepLink(link, emit);
    //     },
    //     cancelOnError: true,
    //     onError: (e) {
    //       print(e);
    //     });
    //
    // if (await canLaunch(url)) {
    //   await launch(
    //     url,
    //     forceSafariVC: false,
    //     forceWebView: true,
    //     //enableDomStorage: true,
    //     enableJavaScript: true,
    //   );
    // } else {
    //   _subs?.cancel();
    //   emit(const AuthState.error('Cannot launch url!'));
    //   return;
    // }
  }

  void _checkDeepLink(String? link, Emitter<AuthState> emit) async {
    print(link);
    if (link != null) {
      String code = link.substring(link.indexOf(RegExp('code=')) + 5);

      try {
        final user = await githubRepository.loginWithGitHub(code);
        print(user.login);
        emit(AuthState.success(user));
      } on ApiClientException catch (e) {
        emit(AuthState.error(e.type));
      }
    }
  }

  @override
  Future<void> close() {
    _subs?.cancel();
    return super.close();
  }
}

@freezed
class AuthEvent with _$AuthEvent {
  const factory AuthEvent.signIn(String code) = SignIn;
}

@freezed
class AuthState with _$AuthState {
  const factory AuthState.initial() = Initial;
  const factory AuthState.loading() = Loading;
  const factory AuthState.success(User user) = Success;
  const factory AuthState.error(String error) = Error;
}
