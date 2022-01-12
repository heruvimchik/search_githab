import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:search_githab/domain/api_client/api_client_exception.dart';
import 'package:search_githab/domain/entity/repository.dart';
import 'package:search_githab/domain/repositories/github_repository.dart';

part 'repositories_bloc.freezed.dart';

class RepositoriesBloc extends Bloc<RepositoriesEvent, RepositoriesState> {
  final GithubRepository githubRepository;

  RepositoriesBloc({required this.githubRepository})
      : super(const RepositoriesState.initial()) {
    on<GetRepo>(
      _onGetRepo,
    );
  }

  void _onGetRepo(
    GetRepo event,
    Emitter<RepositoriesState> emit,
  ) async {
    emit(const RepositoriesState.loading());

    try {
      final repos = await githubRepository.getRepositories(event.name);
      emit(RepositoriesState.success(repos));
    } on ApiClientException catch (e) {
      emit(RepositoriesState.error(e.type));
    }
  }
}

@freezed
class RepositoriesEvent with _$RepositoriesEvent {
  const factory RepositoriesEvent.getRepo(String name) = GetRepo;
}

@freezed
class RepositoriesState with _$RepositoriesState {
  const factory RepositoriesState.initial() = Initial;
  const factory RepositoriesState.loading() = Loading;
  const factory RepositoriesState.success(List<Repository> users) = Success;
  const factory RepositoriesState.error(String error) = Error;
}
