import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:urmytalk/repositories/urmytalk_signup_repository.dart';

final signupRepositoryProvider = Provider<SignUpRepository>((ref) {
  return SignUpRepository(ref: ref);
});
