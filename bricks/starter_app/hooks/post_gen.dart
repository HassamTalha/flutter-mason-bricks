import 'dart:io';
import 'package:mason/mason.dart';

// This will wrap the MyApp widget with ProviderScope in main.dart
void ensureRiverpodBootstrap(HookContext context) {
  final file = File('lib/main.dart');

  if (!file.existsSync()) {
    context.logger.warn('lib/main.dart not found. Skipping Riverpod setup.');
    return;
  }

  var content = file.readAsStringSync();

  // If ProviderScope already exists, assume everything is already set up
  if (content.contains('ProviderScope(')) {
    context.logger.info('Riverpod already configured in main.dart. Skipping.');
    return;
  }

  const riverpodImport =
      "import 'package:flutter_riverpod/flutter_riverpod.dart';";

  // Ensure Riverpod import exists
  if (!content.contains(riverpodImport)) {
    final flutterImportRegex = RegExp(
      r"import 'package:flutter/material\.dart';",
    );

    if (flutterImportRegex.hasMatch(content)) {
      content = content.replaceFirst(
        flutterImportRegex,
        "import 'package:flutter/material.dart';\n$riverpodImport",
      );
    } else {
      // Fallback: add import at top
      content = '$riverpodImport\n$content';
    }
  }

  // Wrap runApp
  final runAppRegex = RegExp(r'runApp\(([\s\S]*?)\);');
  final match = runAppRegex.firstMatch(content);

  if (match == null) {
    context.logger.warn('runApp() not found. Skipping ProviderScope wrapping.');
    return;
  }

  final originalRunApp = match.group(0)!;
  final innerWidget = match.group(1)!.trim();

  final wrappedRunApp =
      '''
runApp(
  ProviderScope(
    child: $innerWidget,
  ),
);
''';

  content = content.replaceFirst(originalRunApp, wrappedRunApp);

  file.writeAsStringSync(content);

  context.logger.success('Riverpod bootstrap added to main.dart');
}

// This will add necessary dependencies to pubspec.yaml
void addDependencies(HookContext context, String flutterCmd) {
  final useFirebase = context.vars['firebase_integration'] == true;
  final hasAuth = context.vars['create_auth'] == true;
  final hasFirestore = context.vars['create_firestore'] == true;
  final hasStorage = context.vars['create_storage'] == true;
  final dependencies = [
    'flutter_riverpod',
    'freezed_annotation',
    'json_annotation',
    'riverpod_annotation',
    'dio',
    'cached_network_image',
    'intl',
    'flutter_secure_storage',
    'shared_preferences',
    'logger',
    'equatable',
    'flutter_dotenv',
    'file_picker',
    'image_picker',
    if (useFirebase) ...[
      'firebase_core',
      if (hasAuth) 'firebase_auth',
      if (hasFirestore) 'cloud_firestore',
      if (hasStorage) 'firebase_storage',
    ],
  ];

  final devDependencies = [
    'build_runner',
    'freezed',
    'json_serializable',
    'flutter_lints',
    'riverpod_generator',
  ];

  // Add normal dependencies
  for (var dep in dependencies) {
    context.logger.info('➕ Adding dependency: $dep');
    final result = Process.runSync(flutterCmd, ['pub', 'add', dep]);
    stdout.write(result.stdout);
    stderr.write(result.stderr);
  }

  // Add dev dependencies
  for (var dep in devDependencies) {
    context.logger.info('➕ Adding dev dependency: $dep');
    final result = Process.runSync(flutterCmd, ['pub', 'add', '--dev', dep]);
    stdout.write(result.stdout);
    stderr.write(result.stderr);
  }

  // Run flutter pub get to make sure everything is installed
  context.logger.info('📦 Running flutter pub get...');
  final getResult = Process.runSync(flutterCmd, ['pub', 'get']);
  stdout.write(getResult.stdout);
  stderr.write(getResult.stderr);

  context.logger.info('\n✅ Dependencies installed successfully!');
}

// This will run build_runner for code generation e.g. freezed, riverpod_codeGen, etc.
void runBuildRunner(HookContext context, String flutterCmd) {
  context.logger.info(
    '\n🚀 Initialized BUILD Runner for CodeGen - (Open another Terminal for other commands. Leave this one open :))',
  );
  Process.runSync('dart', ['run', 'build_runner', 'watch']);
}

void run(HookContext context) {
  final flutterCmd = Platform.isWindows ? 'flutter.bat' : 'flutter';
  //ensureRiverpodBootstrap(context);
  addDependencies(context, flutterCmd);

  // Run this last as it will keep running
  runBuildRunner(context, flutterCmd);
}
