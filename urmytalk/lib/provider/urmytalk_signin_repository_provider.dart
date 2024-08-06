import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:urmytalk/repositories/urmytalk_signin_repository.dart';

final signinRepositoryProvider = Provider<SignInRepository>((ref) {
  return SignInRepository(ref: ref);
});
