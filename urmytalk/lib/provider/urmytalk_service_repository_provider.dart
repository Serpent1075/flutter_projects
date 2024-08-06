import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:urmytalk/repositories/urmytalk_service_repository.dart';

final urmytalkserviceRepositoryProvider = Provider<UrMyTalkServiceRepository>((ref) {
  return UrMyTalkServiceRepository(ref: ref);
});
