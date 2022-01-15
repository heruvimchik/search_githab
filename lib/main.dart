import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:search_githab/presentation/repositories_screen/repositories_bloc/repositories_bloc.dart';
import 'domain/api_client/github_client.dart';
import 'domain/repositories/github_repository.dart';
import 'presentation/auth_screen/auth_bloc/auth_bloc.dart';
import 'presentation/auth_screen/auth_screen.dart';
import 'presentation/search_screen/search_bloc/search_bloc.dart';
import 'presentation/search_screen/search_screen.dart';

void main() async {
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
        BlocProvider<AuthBloc>(
          lazy: false,
          create: (BuildContext context) => AuthBloc(
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
        home: const HomeWidget(),
      ),
    );
  }
}

class HomeWidget extends StatefulWidget {
  const HomeWidget({Key? key}) : super(key: key);

  @override
  _HomeWidgetState createState() => _HomeWidgetState();
}

class _HomeWidgetState extends State<HomeWidget> {
  int _selectedTab = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedTab,
        children: [
          SearchScreen(),
          const AuthScreen(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedTab,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            label: 'Account',
          ),
        ],
        onTap: (value) {
          FocusManager.instance.primaryFocus?.unfocus();
          if (_selectedTab == value) return;
          setState(() {
            _selectedTab = value;
          });
        },
      ),
    );
  }
}
