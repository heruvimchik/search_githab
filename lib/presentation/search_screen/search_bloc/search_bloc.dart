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
  String _text = '';

  final GithubRepository githubRepository;

  void _onTextChanged(
    ChangeText event,
    Emitter<SearchState> emit,
  ) async {
    if (event.text.isEmpty || event.text == _text) return;

    _text = event.text;

    emit(const SearchState.loading());

    final List<UserFollowers> userFollowers = [];
    try {
      final users = await githubRepository.getUsers(event.text);

      if (users.isEmpty) emit(SearchState.success(userFollowers));

      for (User user in users) {
        final followers =
            await githubRepository.getFollowers(user.followersUrl);

        userFollowers.add(UserFollowers(user: user, followers: followers));

        emit(SearchState.success(List.from(userFollowers)));
      }
    } on ApiClientException catch (e) {
      emit(SearchState.error(e.type));
    }
  }
}

@freezed
class SearchEvent with _$SearchEvent {
  const factory SearchEvent.changeText(String text) = ChangeText;
}

@freezed
class SearchState with _$SearchState {
  const factory SearchState.initial() = Initial;
  const factory SearchState.loading() = Loading;
  const factory SearchState.success(List<UserFollowers> users) = Success;
  const factory SearchState.error(String error) = Error;
}
