import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:urmytalk/models/models.dart';
import 'package:urmytalk/provider/providers.dart';

class UrMyTalkServiceState {
  final int curruentindex;
  final bool loading;
  final String error;
  UrMyTalkServiceList? servicelist;
  ServicePurchasedList? purchasedlist;


  UrMyTalkServiceState({
    this.curruentindex = 0,
    this.loading = true,
    this.error = '',
    this.servicelist,
    this.purchasedlist,

  });

  UrMyTalkServiceState copyWith({
    int? curruentindex,
    bool? loading,
    String? error,
    UrMyTalkServiceList? servicelist,
    ServicePurchasedList? purchasedlist,

  }) {
    return UrMyTalkServiceState(
      curruentindex: curruentindex ?? this.curruentindex,
      loading: loading ?? this.loading,
      error: error ?? this.error,
      servicelist: servicelist ?? this.servicelist,
      purchasedlist: purchasedlist ?? this.purchasedlist,
    );
  }
}

final urmytalkserviceProvider = StateNotifierProvider<UrMyTalkService, UrMyTalkServiceState>((ref) {
  return UrMyTalkService(ref: ref);
});

class UrMyTalkService extends StateNotifier<UrMyTalkServiceState> {
  final Ref ref;
  static UrMyTalkServiceState initialAuthState = UrMyTalkServiceState();
  UrMyTalkService({required this.ref}) : super(initialAuthState);


}

final urmytalkserviceStateProvider = Provider<UrMyTalkServiceState>((ref) {
  final UrMyTalkServiceState servicestate = ref.watch(urmytalkserviceProvider);
  return servicestate;
});
