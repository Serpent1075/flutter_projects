import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:urmytalk/models/models.dart';
import 'package:urmytalk/provider/providers.dart';
import '../urmyexception/urmyauth_exception.dart';
import '../utils/utils.dart';

class ChatState {
  final bool loading;
  final String error;
  final String tmerr;
  List<UrMyMessage> messages;
  String? currentChatroomId;
  Candidates? currentCandidates;

  ChatState({
    this.loading = true,
    this.error = '',
    this.messages = const [],
    this.currentCandidates,
    this.currentChatroomId,
    this.tmerr = '',
  });

  ChatState copyWith({
    bool? loading,
    String? error,
    List<UrMyMessage>? messages,
    Candidates? currentCandidates,
    String? currentChatroomId,
    String? tmerr
  }) {
    return ChatState(
        loading: loading ?? this.loading,
        error: error ?? this.error,
        tmerr: tmerr ?? this.tmerr,
        messages: messages ?? this.messages,
        currentCandidates: currentCandidates ?? this.currentCandidates,
        currentChatroomId: currentChatroomId ?? this.currentChatroomId);
  }
}

final chatProvider = StateNotifierProvider<Chat, ChatState>((ref) {
  return Chat(ref: ref);
});


class Chat extends StateNotifier<ChatState> {
  final Ref ref;
  static ChatState initialAuthState = ChatState();

  Chat({required this.ref}) : super(initialAuthState);

  void setCurrentCandidate(Candidates? candidate) {
    state = state.copyWith(
      currentCandidates: candidate,
    );
  }

  void setCurrentChatroom(String urID, String friendID) {
    var chatroomid = makeChatId(urID, friendID);
    state = state.copyWith(currentChatroomId: chatroomid);
  }

  void setTooManyMessageError() {
    state = state.copyWith(
        loading: state.loading,
        tmerr: 'too-many-messages'
    );
  }

  Future<void> sendMessage(String content, String messageType, String myName, Candidateslist? blacklist, int length) async {
      try {
          await ref.read(chatRepositoryProvider).sendChatting(
              state.currentChatroomId!,
              ref.read(signinProvider).uuid,
              state.currentCandidates!.candidateUuid!,
              content,
              messageType,
              myName,
              blacklist
          );
      } on UrMyTokenExpiredException {
        await ref.read(signinRepositoryProvider).autologin();
        await ref.read(chatRepositoryProvider).sendChatting(
            state.currentChatroomId!,
            ref.read(signinProvider).uuid,
            state.currentCandidates!.candidateUuid!,
            content,
            messageType,
            myName,
            blacklist
        );
      } catch(e) {
        state = state.copyWith(
            error: e.toString()
        );
      }
  }

  void setCurrentChatroomId() {
    var chatroomId = makeChatId(ref.read(signinProvider.notifier).state.uuid, state.currentCandidates!.candidateUuid);
    state = state.copyWith(
        currentChatroomId: chatroomId
    );
  }

  Future<void> sendchatreport(String message, String time, String type, String contents) async {
    try{
      await ref.read(chatRepositoryProvider).sendchatreport(message, time, type, state.currentChatroomId!, state.currentCandidates!.candidateUuid!, contents);
    } on UrMyTokenExpiredException {
      await ref.read(signinRepositoryProvider).autologin();
      await ref.read(chatRepositoryProvider).sendchatreport(message, time, type, state.currentChatroomId!, state.currentCandidates!.candidateUuid!, contents);
    } catch(e) {

    }

  }

  void setErrorEmpty() {
    state = state.copyWith(
        error: "",
        tmerr: ""
    );
  }
}

final chatStateProvider = Provider<ChatState>((ref) {
  final ChatState chat = ref.watch(chatProvider);
  return chat;
});
