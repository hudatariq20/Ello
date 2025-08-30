import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:voice_input/features/auth/data/repositories/auth/auth_repository.dart';
import 'package:voice_input/features/auth/domain/entities/app_user.dart';
import 'package:voice_input/features/auth/presentation/auth_provider/auth_providers.dart';

class AuthController extends AsyncNotifier<void> {
  late final AuthRepository _authRepository;
  @override
  Future<void> build() async {
    _authRepository = ref.read(AuthRepositoryProvider);
  }

  Future<void> signUp({required AppUser user, required String password}) async {
    state = const AsyncValue.loading();
    try {
      await _authRepository.signUp(user: user, password: password);
      state = const AsyncData(null); //set the state to the user
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  Future<void> logIn({required String email, required String password}) async {
    state = const AsyncValue.loading();
    try {
      await _authRepository.logInWithEmailAndPassword(
          email: email, password: password);
      state = const AsyncData(null); //set the state to the user
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  Future<void> signOut() async {
    await _authRepository.signOut();
  }

  Future<void> forgotPassword({required String email}) async {
    state = const AsyncValue.loading();
    try {
      await _authRepository.resetPassword(email: email);
      state = const AsyncData(null);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  Future<void> resetPassword({required String email}) async {
    state = const AsyncLoading();
    try {
      await _authRepository.resetPassword(email: email);
      state = const AsyncData(null);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }
}

final authControllerProvider =
    AsyncNotifierProvider<AuthController, void>(() => AuthController());
