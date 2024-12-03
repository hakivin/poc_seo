// GENERATED FILE, DO NOT MODIFY
// Generated with jaspr_builder

import 'package:jaspr/jaspr.dart';
import 'package:poc_seo/components/header.dart' as prefix0;
import 'package:poc_seo/pages/about.dart' as prefix1;
import 'package:poc_seo/app.dart' as prefix2;

/// Default [JasprOptions] for use with your jaspr project.
///
/// Use this to initialize jaspr **before** calling [runApp].
///
/// Example:
/// ```dart
/// import 'jaspr_options.dart';
///
/// void main() {
///   Jaspr.initializeApp(
///     options: defaultJasprOptions,
///   );
///
///   runApp(...);
/// }
/// ```
final defaultJasprOptions = JasprOptions(
  clients: {
    prefix2.App: ClientTarget<prefix2.App>('app'),
  },
  styles: () => [
    ...prefix0.Header.styles,
    ...prefix1.About.styles,
    ...prefix2.AppState.styles,
  ],
);
