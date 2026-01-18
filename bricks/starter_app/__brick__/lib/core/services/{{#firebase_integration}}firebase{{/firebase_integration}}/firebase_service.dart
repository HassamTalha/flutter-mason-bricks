{{#create_firestore}}import 'package:cloud_firestore/cloud_firestore.dart';{{/create_firestore}}
{{#create_auth}}import 'package:firebase_auth/firebase_auth.dart';{{/create_auth}}
{{#create_storage}}import 'package:firebase_storage/firebase_storage.dart';{{/create_storage}}

{{#create_auth}}import 'firebase_auth_service.dart';{{/create_auth}}
{{#create_firestore}}import 'firebase_firestore_service.dart';{{/create_firestore}}
{{#create_storage}}import 'firebase_storage_service.dart';{{/create_storage}}

class FirebaseServices {
  FirebaseServices({
    {{#create_auth}}FirebaseAuth? auth,{{/create_auth}}
    {{#create_firestore}}FirebaseFirestore? firestore,{{/create_firestore}}
    {{#create_storage}}FirebaseStorage? storage,{{/create_storage}}
  }) : 
    {{#create_auth}}
    _authService = FirebaseAuthService(auth ?? FirebaseAuth.instance),
    {{/create_auth}}
    {{#create_firestore}}
    _firestoreService = FirebaseFirestoreService(firestore ?? FirebaseFirestore.instance),
    {{/create_firestore}}
    {{#create_storage}}
    _storageService = FirebaseStorageService(storage ?? FirebaseStorage.instance),
    {{/create_storage}}
    // This dummy assignment handles the trailing comma issue professionally
    _isInitialized = true;
  final bool _isInitialized;
  {{#create_auth}}
  final FirebaseAuthService _authService;
  FirebaseAuthService get auth => _authService;
  {{/create_auth}}
  {{#create_firestore}}
  final FirebaseFirestoreService _firestoreService;
  FirebaseFirestoreService get firestore => _firestoreService;
  {{/create_firestore}}
  {{#create_storage}}
  final FirebaseStorageService _storageService;
  FirebaseStorageService get storage => _storageService;
  {{/create_storage}}
}