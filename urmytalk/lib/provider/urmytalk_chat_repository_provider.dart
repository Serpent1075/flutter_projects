import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:urmytalk/repositories/urmytalk_chat_repository.dart';

final chatRepositoryProvider = Provider<ChatRepository>((ref) {
  return ChatRepository(ref: ref);
});
