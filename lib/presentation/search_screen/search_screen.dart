import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:search_githab/presentation/repositories_screen/repositories_bloc/repositories_bloc.dart';
import 'package:search_githab/presentation/repositories_screen/repositories_screen.dart';

import 'search_bloc/search_bloc.dart';

class SearchScreen extends StatelessWidget {
  SearchScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Github Search')),
      body: Column(
        children: <Widget>[
          _SearchBar(),
          _SearchBody(),
        ],
      ),
    );
  }
}

class _SearchBar extends StatefulWidget {
  @override
  State<_SearchBar> createState() => _SearchBarState();
}

class _SearchBarState extends State<_SearchBar> {
  final _textController = TextEditingController();

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      //autofocus: true,
      controller: _textController,
      autocorrect: false,
      onSubmitted: (text) {
        context.read<SearchBloc>().add(
              SearchEvent.changeText(text),
            );
      },
      onChanged: (text) {
        context.read<SearchBloc>().add(
              SearchEvent.changeText(text),
            );
      },
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.search),
        suffixIcon: GestureDetector(
          onTap: () => _textController.text = '',
          child: const Icon(Icons.clear),
        ),
        border: InputBorder.none,
        hintText: 'Search...',
      ),
    );
  }
}

class _SearchBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SearchBloc, SearchState>(
      builder: (context, state) {
        return state.when(
          initial: () => Container(),
          loading: () => const Center(child: CircularProgressIndicator()),
          success: (users) => Expanded(
            child: ListView.builder(
              itemCount: users.length,
              itemBuilder: (ctx, index) {
                return Card(
                  elevation: 2,
                  child: ListTile(
                    title: Text(
                      users[index].user.login,
                      style: const TextStyle(color: Colors.blue),
                    ),
                    leading: SizedBox(
                      height: 100,
                      width: 70,
                      //child: Image.network(users[index].user.avatarUrl),
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                            fit: BoxFit.scaleDown,
                            image: NetworkImage(
                              users[index].user.avatarUrl,
                            ),
                          ),
                        ),
                      ),
                    ),
                    subtitle: Text(
                      'Followers: ${users[index].followers}',
                    ),
                    onTap: () {
                      context.read<RepositoriesBloc>().add(
                          RepositoriesEvent.getRepo(users[index].user.login));

                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => RepositoriesScreen(
                            name: users[index].user.login,
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
          error: (error) => Center(
              child: Text(
            error,
            style: const TextStyle(color: Colors.red, fontSize: 18),
          )),
        );
      },
    );
  }
}
