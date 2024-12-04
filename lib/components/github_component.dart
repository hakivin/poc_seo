import 'package:jaspr/jaspr.dart';
import 'package:jaspr_flutter_embed/jaspr_flutter_embed.dart';
import 'package:jaspr_router/jaspr_router.dart';

// The flutter widget is only imported on the web (as the server cannot import flutter)
// and is imported as a deferred library, to not block hydration of the remaining website.
@Import.onWeb('../widgets/github_list.dart', show: [#RepoListScreen])
import 'github_component.imports.dart' deferred as github;

class GithubComponent extends StatelessComponent {
  const GithubComponent({super.key});

  @override
  Iterable<Component> build(BuildContext context) sync* {
    yield section([
      const Document.head(title: 'Home'),
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
        builder: () => github.RepoListScreen(
          onRepoTap: (repoName) {
            context.push('/repos/$repoName');
          },
        ),
      ),
    ]);
  }
}
