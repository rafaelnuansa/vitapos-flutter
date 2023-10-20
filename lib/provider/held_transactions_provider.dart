import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vitapos/models/held_transaction.dart';

final heldTransactionsProvider =
    StateNotifierProvider<HeldTransactionsNotifier, List<HeldTransaction>>(
  (ref) => HeldTransactionsNotifier(),
);

class HeldTransactionsNotifier extends StateNotifier<List<HeldTransaction>> {
  HeldTransactionsNotifier() : super([]);

  void addHeldTransaction(HeldTransaction transaction) {
    state = [...state, transaction];
  }

  void removeHeldTransaction(HeldTransaction transaction) {
    state = state
        .where((heldTransaction) => heldTransaction.name != transaction.name)
        .toList();
  }

  void updateHeldTransaction(HeldTransaction transaction) {
    state = state.map((heldTransaction) {
      if (heldTransaction.name == transaction.name) {
        return transaction;
      }
      return heldTransaction;
    }).toList();
  }
}
