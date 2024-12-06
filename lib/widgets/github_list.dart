import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'utils.dart';

const token = 'your_github_token';

class RepoListScreen extends StatefulWidget {
  final void Function(String repoName)? onRepoTap;

  const RepoListScreen({super.key, this.onRepoTap});

  @override
  RepoListScreenState createState() => RepoListScreenState();
}

class RepoListScreenState extends State<RepoListScreen> {
  final String username = 'flutter'; // Replace with any GitHub username
  List<dynamic> repos = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchRepos();
  }

  Future<void> fetchRepos() async {
    final response = await http.get(
      Uri.parse(
        'https://api.github.com/users/$username/repos',
      ),
      headers: {
        'Authorization': 'token $token',
      },
    );

    if (response.statusCode == 200) {
      setState(() {
        repos = json.decode(response.body);
        isLoading = false;
      });
    } else {
      throw Exception('Failed to load repos');
    }
  }

  @override
  Widget build(BuildContext context) {
    return WidgetWrapper(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('GitHub Repos'),
        ),
        body: isLoading
            ? const Center(child: CircularProgressIndicator())
            : ListView.builder(
                itemCount: repos.length,
                itemBuilder: (context, index) {
                  final repo = repos[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(
                      vertical: 8.0,
                      horizontal: 16.0,
                    ),
                    child: ListTile(
                      title: Text(repo['name']),
                      subtitle: Text(repo['description'] ?? 'No description'),
                      trailing: const Icon(Icons.arrow_forward),
                      onTap: () => widget.onRepoTap?.call(repo['name']),
                    ),
                  );
                },
              ),
      ),
    );
  }
}
