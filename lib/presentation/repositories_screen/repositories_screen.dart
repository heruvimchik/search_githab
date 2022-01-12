import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'repositories_bloc/repositories_bloc.dart';

class RepositoriesScreen extends StatelessWidget {
  final String name;
  const RepositoriesScreen({Key? key, required this.name}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(name),
      ),
      body: BlocBuilder<RepositoriesBloc, RepositoriesState>(
        builder: (context, state) {
          return state.when(
            initial: () => Container(),
            loading: () => const Center(child: CircularProgressIndicator()),
            success: (repos) => ListView.builder(
              itemBuilder: (context, index) {
                return Card(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          repos[index].name,
                        ),
                        Text(
                          repos[index].description,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          '${repos[index].forksCount}',
                        ),
                        Text(
                          '${repos[index].stargazersCount}',
                        ),
                      ],
                    ),
                  ),
                );
              },
              itemCount: repos.length,
            ),
            error: (error) => Center(
                child: Text(
              error,
              style: const TextStyle(color: Colors.red, fontSize: 18),
            )),
          );
        },
      ),
    );
  }
}
