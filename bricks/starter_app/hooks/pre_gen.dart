import 'package:mason/mason.dart';

void run(HookContext context) async {
  // 1. Check the first answer
  final isSimple = context.vars['firebase_integration'] == false;

  if (isSimple) {
    // Branch A: Simple Setup (No more questions)
    context.logger.info('🚀 Using default simple setup...');
  } else {
    // Branch B: Custom Setup (Trigger 3 more questions)
    context.logger.info('🛠️ Customizing your project...');

    // Question 1: Firebase Auth Service
    final createAuth = context.logger.confirm(
      "Would you like to include Firebase Auth service?",
      defaultValue: true,
    );

    // Question 2: Multi-select Packages
    final createFirestore = context.logger.confirm(
      'Would you like to include Firestore service?',
      defaultValue: true,
    );

    // Question 3: Confirmation
    final createStorage = context.logger.confirm(
      'Would you like to include Firebase Storage service?',
      defaultValue: true,
    );

    // Update the variables so the template can use them
    context.vars = {
      ...context.vars,
      'create_auth': createAuth,
      'create_firestore': createFirestore,
      'create_storage': createStorage,
    };
  }
}
