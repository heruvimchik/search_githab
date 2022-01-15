import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:search_githab/domain/api_client/api_client_exception.dart';
import 'package:search_githab/domain/entity/user.dart';
import 'package:search_githab/domain/repositories/github_repository.dart';

part 'auth_bloc.freezed.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final GithubRepository githubRepository;

  AuthBloc({required this.githubRepository})
      : super(const AuthState.initial()) {
    on<SignIn>(
      _onSignIn,
    );
    on<SignOut>(
      _onSignOut,
    );
  }

  void _onSignIn(
    SignIn event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthState.loading());

    try {
      final user = await githubRepository.loginWithGitHub(event.code);
      emit(AuthState.success(user));
    } on ApiClientException catch (e) {
      emit(AuthState.error(e.type));
    }
  }

  void _onSignOut(
    SignOut event,
    Emitter<AuthState> emit,
  ) async {
    try {
      githubRepository.logoutGitHub();
      emit(const AuthState.initial());
    } on ApiClientException catch (e) {
      emit(AuthState.error(e.type));
    }
  }
}

@freezed
class AuthEvent with _$AuthEvent {
  const factory AuthEvent.signIn(String code) = SignIn;
  const factory AuthEvent.signOut() = SignOut;
}

@freezed
class AuthState with _$AuthState {
  const factory AuthState.initial() = Initial;
  const factory AuthState.loading() = Loading;
  const factory AuthState.success(User user) = Success;
  const factory AuthState.error(String error) = Error;
}
