import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:urmytalk/models/models.dart';
import 'package:urmytalk/provider/providers.dart';
import 'package:urmytalk/urmyexception/exceptions.dart';

class CandidateState {
  final int curruentindex;
  final bool loading;
  final bool loadingnumber;
  final String error;
  final String pmerr;
  final String tmerr;

  Candidateslist? filteredcandidates;
  Candidateslist? candidates;
  Candidateslist? blacklist;
  Candidateslist? friends;
  Candidates? currentCandidate;
  int? numberoffriend;
  int? numberofcandidate;
  int? numberofurmy;

  CandidateState(
      {this.curruentindex = 0,
      this.loading = true,
      this.loadingnumber = false,
      this.error = '',
      this.pmerr = '',
      this.tmerr = '',
      this.filteredcandidates,
      this.candidates,
      this.blacklist,
      this.friends,
      this.currentCandidate,
      this.numberoffriend,
      this.numberofcandidate,
      this.numberofurmy
      });

  CandidateState copyWith({
    int? curruentindex,
    bool? loading,
    bool? loadingnumber,
    String? error,
    String? pmerr,
    String? tmerr,
    Candidateslist? filteredcandidates,
    Candidateslist? candidates,
    Candidateslist? blacklist,
    Candidateslist? friends,
    Candidates? currentCandidate,
    int? numberoffriend,
    int? numberofcandidate,
    int? numberofurmy
  }) {
    return CandidateState(
        curruentindex: curruentindex ?? this.curruentindex,
        loading: loading ?? this.loading,
        loadingnumber: loadingnumber ?? this.loadingnumber,
        error: error ?? this.error,
        pmerr: pmerr ?? this.pmerr,
        tmerr: tmerr ?? this.tmerr,
        filteredcandidates: filteredcandidates ?? this.filteredcandidates,
        candidates: candidates ?? this.candidates,
        blacklist: blacklist ?? this.blacklist,
        friends: friends ?? this.friends,
        currentCandidate: currentCandidate ?? this.currentCandidate,
        numberoffriend: numberoffriend ?? this.numberoffriend,
        numberofcandidate: numberofcandidate ?? this.numberofcandidate,
        numberofurmy: numberofurmy ?? this.numberofurmy
    );
  }
}

final candidateProvider =
    StateNotifierProvider<Candidate, CandidateState>((ref) {
  return Candidate(ref: ref);
});

final blacklistProvider = FutureProvider<Candidateslist?>((ref){
  return ref.read(candidateProvider).blacklist;
});

final checknumberofurmyProvider = FutureProvider<int>((ref) async {
  return await ref.read(candidateProvider.notifier).checknumberofurmy();
});

final checknumberofcandidateProvider = FutureProvider<int>((ref) async{
  return await ref.read(candidateProvider.notifier).checknumberofcandidate();
});

class Candidate extends StateNotifier<CandidateState> {
  final Ref ref;
  static CandidateState initialAuthState = CandidateState();

  Candidate({required this.ref}) : super(initialAuthState);

  String getName(String uuid) {
    for (var data in state.friends!.candidatelist!) {
      if (data.candidateUuid == uuid) {
        return data.candidateName!;
      }
    }

    for (var data in state.candidates!.candidatelist!) {
      if (data.candidateUuid == uuid) {
        return data.candidateName!;
      }
    }
    return "no name";
  }

  Map<String, dynamic> getProfile(String uuid){
    Map<String, dynamic> mymap = {};
    for (var data in state.friends!.candidatelist!) {
      if (data.candidateUuid == uuid) {
        mymap['addable'] = false;
        mymap['name'] = data.candidateName;
        mymap['profileUrl'] = data.contentUrl;
        mymap['propic'] = data.profilePicPath;
        return mymap;
      }
    }

    for (var data in state.candidates!.candidatelist!) {
      if (data.candidateUuid == uuid) {
        mymap['addable'] = true;
        mymap['name'] = data.candidateName;
        mymap['profileUrl'] = data.contentUrl;
        mymap['propic'] = data.profilePicPath;
        return mymap;
      }
    }

    mymap['addable'] = true;
    mymap['name'] = 'none';
    mymap['profileUrl'] = 'none';
    mymap['propic'] = 'none';
    return mymap;
  }

  Candidates? getCandidate(String uuid) {
    for (var data in state.friends!.candidatelist!) {
      if (data.candidateUuid == uuid) {
        return data;
      }
    }

    for (var data in state.candidates!.candidatelist!) {
      if (data.candidateUuid == uuid) {
        return data;
      }
    }
    return null;
  }

  String getPicture(String uuid) {
    for (var data in state.candidates!.candidatelist!) {
      if (data.candidateUuid == uuid) {
        return data.contentUrl! + data.profilePicPath!.first.filename!;
      }
    }
    return "no name";
  }

  Future<void> getCandidateList() async {
    try {
      var candidates = await ref.read(candidateRepositoryProvider).listcandidate();
      Candidateslist? filteredcandidates = Candidateslist(candidatelist: [...?candidates.candidatelist]);
      filteredcandidates = filteredCandidateList(filteredcandidates);
      filteredcandidates = ref.read(candidateRepositoryProvider).filterAgeCandidatelist(filteredcandidates!);
      state = state.copyWith(
        filteredcandidates: filteredcandidates,
        candidates: candidates,
        loading: false,
      );
    } catch (e) {

      Candidateslist result = Candidateslist(candidatelist: []);
      state = state.copyWith(
        candidates: result,
        loading: false,
      );
    }
  }

  Future<void> getFriendList() async {
    try {
      var friends = await ref.read(candidateRepositoryProvider).getFriendlist();
      friends.candidatelist!.sort((a,b) => double.parse(b.opponentGrade!).compareTo(double.parse(a.opponentGrade!)));
      state = state.copyWith(
        friends: friends,
        loading: false,
        numberoffriend: friends.candidatelist == null ? 0 : friends.candidatelist!.length,
      );
    } catch (e) {
      Candidateslist result = Candidateslist(candidatelist: []);
      state = state.copyWith(
        friends: result,
        loading: false,
      );
    }
  }

  void setTooManyFriendError() {
    state = state.copyWith(
      tmerr: 'too-many-friends',
    );
  }

  Future<void> addAnonymousFriendList(String uuid) async {
      try {
        var friends = await ref.read(candidateRepositoryProvider).addAnonymousFriendlist(uuid);
        friends.candidatelist!.sort((a,b) => double.parse(b.opponentGrade!).compareTo(double.parse(a.opponentGrade!)));
        state = state.copyWith(
          friends: friends,
          loading: false,
        );
        var filteredcandidates = filteredCandidateList(state.candidates!);
        state = state.copyWith(
          filteredcandidates: filteredcandidates,
          loading: false,
        );
      } catch (e) {
        Candidateslist friends = Candidateslist(candidatelist: []);
        state = state.copyWith(
          friends: friends,
          loading: false,
        );
      }
  }

  Future<void> addFriendList(Candidates friend) async {
      try {
        var friends = await ref.read(candidateRepositoryProvider).addFriendlist(friend);
        friends.candidatelist!.sort((a,b) => double.parse(b.opponentGrade!).compareTo(double.parse(a.opponentGrade!)));
        state = state.copyWith(
          friends: friends,
          loading: false,
        );
        var filteredcandidates = filteredCandidateList(state.candidates!);
        state = state.copyWith(
          filteredcandidates: filteredcandidates,
          loading: false,
        );
      } catch (e) {

        Candidateslist friends = Candidateslist(candidatelist: []);
        state = state.copyWith(
          friends: friends,
          loading: false,
        );
      }
  }

  Future<void> deleteFriendList(Candidates friend) async {
    try {
      var friends = await ref.read(candidateRepositoryProvider).deleteFriendList(friend);
      friends.candidatelist!.sort((a,b) => double.parse(b.opponentGrade!).compareTo(double.parse(a.opponentGrade!)));
      state = state.copyWith(
        friends: friends,
        loading: false,
      );

      var filteredcandidates = filteredCandidateList(state.candidates!);
      state = state.copyWith(
        filteredcandidates: filteredcandidates,
        loading: false,
      );
    } catch (e) {
      state = state.copyWith(
        friends: state.friends,
        loading: false,
      );
    }
  }

  Future<void> getBlackList() async {
    try {
      var blacks = await ref.read(candidateRepositoryProvider).getBlackList();
      state = state.copyWith(
        blacklist: blacks,
        loading: false,
      );
    } catch (e) {
      state = state.copyWith(
        loading: false,
      );
    }
  }

  Future<void> addBlackList(Candidates blacklist) async {
    try {
      var blacklists = await ref.read(candidateRepositoryProvider).addBlacklist(blacklist);
      state = state.copyWith(
        blacklist: blacklists,
        loading: false,
      );
      getFriendList();
      var filteredcandidates = filteredCandidateList(state.candidates!);
      state = state.copyWith(
        filteredcandidates: filteredcandidates,
        loading: false,
      );
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<void> deleteBlackList(Candidates blacklist) async {
    try {
      var blacklists = await ref.read(candidateRepositoryProvider).deleteBlackList(blacklist);
      state = state.copyWith(
        blacklist: blacklists,
        loading: false,
      );
      getCandidateList();
      var filteredcandidates = filteredCandidateList(state.candidates!);
      state = state.copyWith(
        filteredcandidates: filteredcandidates,
        loading: false,
      );
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<int> checknumberofcandidate() async {
    try {
      int numberofcandidate =
          await ref.read(candidateRepositoryProvider).checknumberofcandidate();
      state = state.copyWith(
        loadingnumber: false,
        numberofcandidate: numberofcandidate,
        error: "",
        pmerr: ""
      );
      return numberofcandidate;
    } on UrMyTokenExpiredException {
      try {
        await ref.read(signinRepositoryProvider).getFirebaseAuthToken();
      } on UrMyPMException {
        state = state.copyWith(
            pmerr: "pm-time"
        );
        return 0;
      }
      int numberofcandidate =
          await ref.read(candidateRepositoryProvider).checknumberofcandidate();
      state = state.copyWith(
        loadingnumber: false,
        numberofcandidate: numberofcandidate,
      );
      return numberofcandidate;
    } catch (e) {
      state = state.copyWith(
        loadingnumber: false,
        numberofcandidate: 0,
      );
      return 0;
    }
  }

  Future<int> checknumberofurmy() async {
    try {
      int numberofurmy =
      await ref.read(candidateRepositoryProvider).checknumberofurmy();
      state = state.copyWith(
        loadingnumber: false,
        numberofurmy: numberofurmy,
        error: "",
        pmerr: ""
      );
      return numberofurmy;
    } on UrMyTokenExpiredException {
      try {
        await ref.read(signinRepositoryProvider).getFirebaseAuthToken();
      } on UrMyPMException {
        state = state.copyWith(
            pmerr: "pm-time"
        );
        return 0;
      }
      try{
        int numberofurmy = await ref.read(candidateRepositoryProvider).checknumberofurmy();
        state = state.copyWith(
          loadingnumber: false,
          numberofurmy: numberofurmy,
        );
        return numberofurmy;
      } catch (e) {
        return 0;
      }
    } catch (e) {
      state = state.copyWith(
        loadingnumber: false,
        numberofurmy: 0,
      );
      return 0;
    }
  }

  Candidateslist? filteredCandidateList(Candidateslist candidates) {

      if (state.friends != null) {
        for (int i = 0; i < state.friends!.candidatelist!.length; i++) {
          for (int j = 0; j < candidates.candidatelist!.length; j++) {
            if (candidates.candidatelist![j].candidateUuid ==
                state.friends!.candidatelist![i].candidateUuid) {
              candidates.candidatelist!.removeAt(j);
              break;
            }
          }
        }
      }

      if (state.blacklist != null) {
        for (int i = 0; i < state.blacklist!.candidatelist!.length; i++) {
          for (int j = 0; j < candidates.candidatelist!.length; j++) {
            if (candidates.candidatelist![j].candidateUuid ==
                state.blacklist!.candidatelist![i].candidateUuid) {
              candidates.candidatelist!.removeAt(j);
              break;
            }
          }
        }
      }
      return candidates;
  }


  void agefilter() async{
    Candidateslist? resultcandilist = ref.read(candidateRepositoryProvider).filterAgeCandidatelist(state.candidates!);
    state = state.copyWith(
      filteredcandidates: resultcandilist
    );
  }

  void setErrorEmpty() {
    state = state.copyWith(
      error: "",
      pmerr: "",
      tmerr: ""
    );
  }

  Future<void> sendCandidateReport(Candidates candidates, String type, String contents) async {
    try{
      await addBlackList(candidates);
      await ref.read(candidateRepositoryProvider).sendcandidatereport(candidates.candidateUuid, type, contents);
    } on UrMyTokenExpiredException {
      await ref.read(signinRepositoryProvider).getFirebaseAuthToken();
      await ref.read(candidateRepositoryProvider).sendcandidatereport(candidates.candidateUuid, type, contents);
    } catch(e) {

    }
  }
}

final candidateStateProvider = Provider<CandidateState>((ref) {
  final CandidateState candidate = ref.watch(candidateProvider);
  return candidate;
});
