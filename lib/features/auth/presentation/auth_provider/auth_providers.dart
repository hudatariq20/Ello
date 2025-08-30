import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:voice_input/features/auth/data/repositories/auth/auth_repository.dart';
import 'package:voice_input/features/auth/data/repositories/user/user_repository.dart';
import 'package:voice_input/features/auth/domain/entities/app_user.dart';
import 'package:voice_input/features/auth/presentation/auth_provider/auth_user_providers.dart';

final UserRepositoryProvider = Provider<UserRepository>((ref) {
  return UserRepository();
});

final AuthRepositoryProvider = Provider<AuthRepository>((ref) {
  final userRepository = ref.watch(UserRepositoryProvider);
  return AuthRepository(userRepository: userRepository);
});

final AuthUserProvider = StreamProvider<AppUser?>((ref) {
  final authUser = ref.watch(AuthUserStreamProvider).value;
  if (authUser == null) {
    //if the user is not logged in, return a stream of null
    return Stream.value(null);
  }
  return ref.watch(UserRepositoryProvider).getUser(authUser.uid);
});
