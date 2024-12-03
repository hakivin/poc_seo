import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

const token =
    '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';

class GitHubRepoApp extends StatelessWidget {
  const GitHubRepoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GitHub Repos',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const RepoListScreen(),
    );
  }
}

class RepoListScreen extends StatefulWidget {
  final void Function(String repoName)? onRepoTap;

  const RepoListScreen({super.key, this.onRepoTap});

  @override
  RepoListScreenState createState() => RepoListScreenState();
}

class RepoListScreenState extends State<RepoListScreen> {
  final String username = 'flutter'; // Replace with any GitHub username
  List<dynamic> repos = [];
  List<Widget> repoList = [];
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
        repoList = _generateList();
      });
    } else {
      throw Exception('Failed to load repos');
    }
  }

  List<Widget> _generateList() {
    final repoList = <Widget>[];
    for (var repo in repos) {
      final repoName = repo['name'];
      final text = GestureDetector(
        onTap: () => widget.onRepoTap?.call(repoName),
        child: Text(repoName),
      );
      repoList.add(text);
    }
    return repoList;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Material(
        shape: RoundedRectangleBorder(
          side: const BorderSide(color: Color(0xFF01589B)),
          borderRadius: BorderRadius.circular(10),
        ),
        child: SingleChildScrollView(
          child: Column(
            children: repoList,
          ),
        ),
      ),
    );
  }
}

class RepoDetailScreen extends StatefulWidget {
  final String owner;
  final String repoName;

  const RepoDetailScreen({
    super.key,
    required this.owner,
    required this.repoName,
  });

  @override
  RepoDetailScreenState createState() => RepoDetailScreenState();
}

class RepoDetailScreenState extends State<RepoDetailScreen> {
  Map<String, dynamic>? repoDetails;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchRepoDetails();
  }

  Future<void> fetchRepoDetails() async {
    final response = await http.get(
      Uri.parse(
          'https://api.github.com/repos/${widget.owner}/${widget.repoName}'),
      headers: {
        'Authorization': 'token $token',
      },
    );

    if (response.statusCode == 200) {
      setState(() {
        repoDetails = json.decode(response.body);
        isLoading = false;
      });
    } else {
      throw Exception('Failed to load repo details');
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Material(
        child: isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Description:',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    Text(repoDetails?['description'] ?? 'No description'),
                    const SizedBox(height: 16.0),
                    Text('Stars: ${repoDetails?['stargazers_count']}'),
                    Text('Forks: ${repoDetails?['forks_count']}'),
                    Text('Language: ${repoDetails?['language'] ?? 'N/A'}'),
                    Text('Open Issues: ${repoDetails?['open_issues_count']}'),
                    Text('Watchers: ${repoDetails?['watchers_count']}'),
                    Text('Default Branch: ${repoDetails?['default_branch']}'),
                  ],
                ),
              ),
      ),
    );
  }
}
