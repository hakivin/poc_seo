import 'package:jaspr/jaspr.dart';
import '../components/github_detail_component.dart';

class Repo extends StatelessComponent {
  final String repoName;
  const Repo({super.key, required this.repoName});

  @override
  Iterable<Component> build(BuildContext context) sync* {
    yield section([
      GithubDetailComponent(repoName),
    ]);
  }
}
