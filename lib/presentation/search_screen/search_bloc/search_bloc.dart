import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stream_transform/stream_transform.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:search_githab/domain/api_client/api_client_exception.dart';
import 'package:search_githab/domain/entity/user.dart';
import 'package:search_githab/domain/repositories/github_repository.dart';

part 'search_bloc.freezed.dart';

const _duration = Duration(milliseconds: 600);

EventTransformer<Event> debounce<Event>(Duration duration) {
  return (events, mapper) => events.debounce(duration).switchMap(mapper);
}

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  SearchBloc({required this.githubRepository})
      : super(const SearchState.initial()) {
    on<ChangeText>(_onTextChanged, transformer: debounce(_duration));
  }

  final GithubRepository githubRepository;

  void _onTextChanged(
    ChangeText event,
    Emitter<SearchState> emit,
  ) async {
    if (event.text.isEmpty) return;

    emit(const SearchState.loading());

    try {
      final users = await githubRepository.getUsers(event.text);
      emit(SearchState.success(users));
    } on ApiClientException catch (e) {
      emit(SearchState.error(e.type));
    }
  }
}

@freezed
abstract class SearchEvent with _$SearchEvent {
  const factory SearchEvent.changeText(String text) = ChangeText;
}

@freezed
abstract class SearchState with _$SearchState {
  const factory SearchState.initial() = Initial;
  const factory SearchState.loading() = Loading;
  const factory SearchState.success(List<User> users) = Success;
  const factory SearchState.error(String error) = Error;
}
