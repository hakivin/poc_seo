import 'package:jaspr/jaspr.dart';
import 'package:poc_seo/components/github_component.dart';

class Home extends StatelessComponent {
  const Home({super.key});

  @override
  Iterable<Component> build(BuildContext context) sync* {
    yield section([
      const Document.head(title: 'Home'),
      img(src: 'images/logo.png', width: 80),
      h1([text('Welcome')]),
      p([text('You successfully create a new Jaspr site.')]),
      const GithubComponent(),
    ]);
  }
}
