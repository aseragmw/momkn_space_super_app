

sealed class CashoutEvent  {
  const CashoutEvent();
}

class GetCurrentBalanceEvent extends CashoutEvent {
  const GetCurrentBalanceEvent();
}


class PerformDebitEvent extends CashoutEvent {
  final double amount;

  PerformDebitEvent(this.amount,);
}

