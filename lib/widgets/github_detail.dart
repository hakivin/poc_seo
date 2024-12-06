import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../constants/env.dart';
import 'utils.dart';

class RepoDetailScreen extends StatefulWidget {
  final String owner;
  final String repoName;
  final void Function() onBack;

  const RepoDetailScreen({
    super.key,
    required this.owner,
    required this.repoName,
    required this.onBack,
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
    final token = Env.apiKey;
    final response = await http.get(
      Uri.parse(
        'https://api.github.com/repos/${widget.owner}/${widget.repoName}',
      ),
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

  void _showInfoBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Repository Information',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 8.0),
              _buildInfoRow('Stars', repoDetails?['stargazers_count']),
              _buildInfoRow('Forks', repoDetails?['forks_count']),
              _buildInfoRow('Language', repoDetails?['language'] ?? 'N/A'),
              _buildInfoRow('Open Issues', repoDetails?['open_issues_count']),
              _buildInfoRow('Watchers', repoDetails?['watchers_count']),
              _buildInfoRow('Default Branch', repoDetails?['default_branch']),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return WidgetWrapper(
      child: Scaffold(
        appBar: AppBar(
          leading: BackButton(
            onPressed: widget.onBack,
          ),
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
                    InfoButton(showInfoBottomSheet: _showInfoBottomSheet),
                    _buildInfoRow('Stars', repoDetails?['stargazers_count']),
                    _buildInfoRow('Forks', repoDetails?['forks_count']),
                    _buildInfoRow(
                      'Language',
                      repoDetails?['language'] ?? 'N/A',
                    ),
                    _buildInfoRow(
                      'Open Issues',
                      repoDetails?['open_issues_count'],
                    ),
                    _buildInfoRow('Watchers', repoDetails?['watchers_count']),
                    _buildInfoRow(
                      'Default Branch',
                      repoDetails?['default_branch'],
                    ),
                  ],
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

class InfoButton extends StatelessWidget {
  final void Function(BuildContext) showInfoBottomSheet;

  const InfoButton({super.key, required this.showInfoBottomSheet});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () => showInfoBottomSheet(context),
      child: const Text('Show Info'),
    );
  }
}
