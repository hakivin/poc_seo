import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:jaspr/jaspr.dart';
import 'package:jaspr_flutter_embed/jaspr_flutter_embed.dart';

// The flutter widget is only imported on the web (as the server cannot import flutter)
// and is imported as a deferred library, to not block hydration of the remaining website.
@Import.onWeb('../widgets/github_detail.dart', show: [#RepoDetailScreen])
import 'github_detail_component.imports.dart' deferred as github;

const token = 'your_github_token';

class GithubDetailComponent extends StatefulComponent {
  final String repoName;

  const GithubDetailComponent(this.repoName, {super.key});

  @override
  State<GithubDetailComponent> createState() => GithubDetailComponentState();
}

class GithubDetailComponentState extends State<GithubDetailComponent>
    with PreloadStateMixin {
  Document document = const Document.head();

  @override
  Iterable<Component> build(BuildContext context) sync* {
    yield div([
      document,
      FlutterEmbedView.deferred(
        styles: const Styles.raw({
          'height': '100vh',
          'width': '30vw',
        }),
        // We need to set constraints as the flutter view cannot dynamically size itself.
        constraints: ViewConstraints(
          maxWidth: double.infinity,
          maxHeight: double.infinity,
        ),
        // The [FlutterEmbedView.deferred] component will take care of loading
        // the widget and initializing flutter.
        loadLibrary: github.loadLibrary(),
        builder: () => github.RepoDetailScreen(
          owner: 'flutter',
          repoName: component.repoName,
        ),
      ),
    ]);
  }

  @override
  Future<void> preloadState() async {
    document = await fetchRepoDetails('flutter', component.repoName);
  }
}

Future<Document> fetchRepoDetails(String owner, String repoName) async {
  final response = await http.get(
    Uri.parse(
      'https://api.github.com/repos/$owner/$repoName',
    ),
    headers: {
      'Authorization': 'token $token',
    },
  );

  final repoDetails = json.decode(response.body);

  if (response.statusCode == 200) {
    const url =
        'https://www.sierrainteractive.com/wp-content/uploads/2024/10/Image-Placeholder-1200x630-1.jpg';
    return Document.head(
      title: repoName,
      meta: {
        'description': repoDetails['description'] ?? 'No Description',
        'og:description': repoDetails['description'] ?? 'No Description',
        'og:url': 'http://localhost:8080',
        'og:type': 'website',
        'og:site_name': 'Github Repos',
        'og:title': repoName,
        'og:image': url,
        'twitter:image': url,
        'twitter:card': 'summary',
        'hostname': 'Github Repos',
      },
    );
  } else {
    throw Exception('Failed to load repo details');
  }
}
