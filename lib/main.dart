import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:search_githab/presentation/repositories_screen/repositories_bloc/repositories_bloc.dart';
import 'domain/api_client/github_client.dart';
import 'domain/repositories/github_repository.dart';
import 'presentation/search_screen/search_bloc/search_bloc.dart';
import 'presentation/search_screen/search_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<GithubRepository>(
          lazy: false,
          create: (context) => GithubRepository(
            githubClient: GithubClient(),
          ),
        ),
        BlocProvider<SearchBloc>(
          create: (BuildContext context) => SearchBloc(
            githubRepository: context.read<GithubRepository>(),
          ),
        ),
        BlocProvider<RepositoriesBloc>(
          create: (BuildContext context) => RepositoriesBloc(
            githubRepository: context.read<GithubRepository>(),
          ),
        ),
      ],
      child: MaterialApp(
        title: '',
        theme: ThemeData(
          appBarTheme: const AppBarTheme(
            backgroundColor: Color.fromRGBO(3, 37, 65, 1),
          ),
        ),
        home: const SearchScreen(),
      ),
    );
  }
}
