import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:statetest/features/{{name.snakeCase()}}/{{name.snakeCase()}}_provider.dart';


class {{name.pascalCase()}}Screen extends ConsumerWidget {
  const {{name.pascalCase()}}Screen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    
    final provider = ref.watch({{name.camelCase()}}Provider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('{{name.pascalCase()}} Screen'),
      ),
      body: const Center(
        child: Text('This is the {{name.pascalCase()}} screen.'),
      ),
    );
  }
}