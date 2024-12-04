import 'package:jaspr/jaspr.dart';
import '../components/github_component.dart';

class Home extends StatelessComponent {
  const Home({super.key});

  @override
  Iterable<Component> build(BuildContext context) sync* {
    yield section([
      const Document.head(title: 'Home'),
      const GithubComponent(),
    ]);
  }
}
