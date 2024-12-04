import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

const token =
    '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';

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
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxWidth: MediaQuery.sizeOf(context).width * 0.3,
        maxHeight: MediaQuery.sizeOf(context).height,
      ),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
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
                          vertical: 8.0, horizontal: 16.0),
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
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxWidth: MediaQuery.sizeOf(context).width * 0.3,
        maxHeight: MediaQuery.sizeOf(context).height,
      ),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          appBar: AppBar(
            title: Text(widget.repoName),
          ),
          body: isLoading
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Description:',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      const SizedBox(height: 8.0),
                      Text(
                        repoDetails?['description'] ?? 'No description',
                        style: const TextStyle(fontSize: 16),
                      ),
                      const Divider(height: 32.0),
                      _buildInfoRow('Stars', repoDetails?['stargazers_count']),
                      _buildInfoRow('Forks', repoDetails?['forks_count']),
                      _buildInfoRow(
                          'Language', repoDetails?['language'] ?? 'N/A'),
                      _buildInfoRow(
                          'Open Issues', repoDetails?['open_issues_count']),
                      _buildInfoRow('Watchers', repoDetails?['watchers_count']),
                      _buildInfoRow(
                          'Default Branch', repoDetails?['default_branch']),
                    ],
                  ),
                ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, dynamic value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          Text(
            '$value',
            style: const TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }
}
