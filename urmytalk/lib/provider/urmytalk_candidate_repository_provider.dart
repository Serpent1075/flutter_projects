import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:urmytalk/repositories/urmytalk_candidate_repository.dart';

final candidateRepositoryProvider = Provider<CandidateRepository>((ref) {
  return CandidateRepository(ref: ref);
});
