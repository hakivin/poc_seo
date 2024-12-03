import 'package:jaspr/jaspr.dart';
import 'dart:convert';
import 'package:jaspr_flutter_embed/jaspr_flutter_embed.dart';
import 'package:http/http.dart' as http;

// The flutter widget is only imported on the web (as the server cannot import flutter)
// and is imported as a deferred library, to not block hydration of the remaining website.
@Import.onWeb('../widgets/github.dart', show: [#RepoDetailScreen])
import 'github_detail_component.imports.dart' deferred as github;

const token =
    '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';

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
    return Document.head(
      title: repoName,
      meta: {
        "description": repoDetails['description'] ?? 'No Description',
        "og:title": repoName,
        "og:image": "https://opengraph.githubassets.com/e12142122b71e8609499abe7afb63edd6c1fde47a204e0a2771c68c892fa8732/hakivin/space-evader",
        "twitter:image": "https://opengraph.githubassets.com/e12142122b71e8609499abe7afb63edd6c1fde47a204e0a2771c68c892fa8732/hakivin/space-evader",
      },
    );
  } else {
    throw Exception('Failed to load repo details');
  }
}
