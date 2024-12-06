import 'package:envied/envied.dart';

part 'env.g.dart';

@envied
abstract class Env {
  @EnviedField(varName: 'API_TOKEN', obfuscate: true)
  static String apiKey = _Env.apiKey;
}
