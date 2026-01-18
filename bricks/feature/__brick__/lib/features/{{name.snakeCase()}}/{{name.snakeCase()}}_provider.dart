
import 'package:flutter_riverpod/flutter_riverpod.dart';

class {{name.pascalCase()}}Provider extends Notifier<void> {
  {{name.pascalCase()}}Provider() : super();

  @override
  void build() {
    // TODO: implement build
  }
  // Add your controller logic here
}

final {{name.camelCase()}}Provider = NotifierProvider<
    {{name.pascalCase()}}Provider, void>(
  () => {{name.pascalCase()}}Provider(),
);