import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:voice_input/features/auth/presentation/auth_provider/auth_providers.dart';

final AuthUserStreamProvider = StreamProvider<auth.User?>((ref) {
  return ref
      .read(AuthRepositoryProvider)
      .user; //get the user stream from the auth repository
});
