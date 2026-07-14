import 'package:firebase_auth/firebase_auth.dart';

String getLoginErrorMessage(Object error) {
  if (error is FirebaseAuthException) {
    switch (error.code) {
      case 'invalid-credential':
      case 'user-not-found':
      case 'wrong-password':
        return 'Incorrect email or password.';
      case 'invalid-email':
        return 'Please enter a valid email address.';
      case 'user-disabled':
        return 'This account has been disabled.';
      case 'too-many-requests':
        return 'Too many attempts. Please try again later.';
      case 'network-request-failed':
        return 'Please check your internet connection.';
      default:
        return 'Unable to sign in. Please try again.';
    }
  }

  return 'Unable to sign in. Please try again.';
}

String getSignupErrorMessage(Object error) {
  if (error is FirebaseAuthException) {
    switch (error.code) {
      case 'email-already-in-use':
        return 'An account already exists for this email.';
      case 'weak-password':
        return 'Please choose a stronger password.';
      case 'invalid-email':
        return 'Please enter a valid email address.';
      case 'network-request-failed':
        return 'Please check your internet connection.';
      case 'too-many-requests':
        return 'Too many attempts. Please try again later.';
      default:
        return 'Unable to create your account. Please try again.';
    }
  }

  return 'Unable to create your account. Please try again.';
}
