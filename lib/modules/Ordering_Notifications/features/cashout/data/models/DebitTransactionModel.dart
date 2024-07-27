import 'package:super_app/modules/Ordering_Notifications/features/cashout/domain/entities/debit_transaction.dart';

class DebitTransactionModel extends DebitTransactionEntity{
  DebitTransactionModel(super.date, super.amount);

  Map<String, dynamic> toJson() => {
    'date': date.toIso8601String(),
    'amount': amount,
  };

  factory DebitTransactionModel.fromJson(Map<String, dynamic> json) {
    return DebitTransactionModel(
      DateTime.parse(json['date']),
      json['amount'],
    );
  }
}