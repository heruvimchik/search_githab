import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import 'repositories_bloc/repositories_bloc.dart';

class RepositoriesScreen extends StatelessWidget {
  final String name;
  final dateFormat = DateFormat("yyyy-MM-dd'T'HH:mm:ss'Z'");
  final outputFormat = DateFormat('dd MMM yyyy');

  RepositoriesScreen({Key? key, required this.name}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Expanded(
              child: Text(
                '$name Repositories',
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
      body: BlocBuilder<RepositoriesBloc, RepositoriesState>(
        builder: (context, state) {
          return state.when(
            initial: () => Container(),
            loading: () => const Center(child: CircularProgressIndicator()),
            success: (repos) => ListView.builder(
              itemBuilder: (context, index) {
                final repo = repos[index];
                return Card(
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          repo.name,
                          style:
                              const TextStyle(color: Colors.blue, fontSize: 15),
                        ),
                        Text(
                          repo.description ?? '',
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 5),
                        Text(
                          'Language: ${repo.language ?? ''}',
                        ),
                        const SizedBox(height: 5),
                        Row(
                          children: [
                            const Icon(Icons.star, size: 14),
                            Text(
                              ' ${repo.stargazersCount} stars',
                            ),
                          ],
                        ),
                        const SizedBox(height: 5),
                        Row(
                          children: [
                            const Icon(Icons.account_tree, size: 14),
                            Text(
                              ' ${repo.forksCount} forks',
                            ),
                          ],
                        ),
                        const SizedBox(height: 5),
                        Text(
                          'Default branch: ${repo.defaultBranch}',
                        ),
                        const SizedBox(height: 5),
                        Text(
                          'Updated at: ${outputFormat.format(dateFormat.parse(repo.updatedAt))}',
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
