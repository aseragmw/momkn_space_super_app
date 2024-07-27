

import '../../../domain/entities/debit_transaction.dart';

sealed class CashoutState  {
  const CashoutState();


}

final class CashoutInitial extends CashoutState {}

class GetCurrentBalanceLoadingState extends CashoutState {}

class GetCurrentBalanceErrorState extends CashoutState {
  final String message;
  const GetCurrentBalanceErrorState({required this.message});
}

class GetCurrentBalanceSuccessState extends CashoutState {
  final double balance;
  const GetCurrentBalanceSuccessState({required this.balance});
}


class PerformDebitLoadingState extends CashoutState {}

class PerformDebitErrorState extends CashoutState {
  final String message;
  const PerformDebitErrorState({required this.message});
}

class PerformDebitSuccessState extends CashoutState {
  final DebitTransactionEntity transactionEntity;
  const PerformDebitSuccessState({required this.transactionEntity});
}
