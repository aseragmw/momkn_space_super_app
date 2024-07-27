class DebitTransactionEntity{
  final DateTime date;
  final double amount;
  DebitTransactionEntity(this.date, this.amount);
  Map<String, dynamic> toJson() => {
    'date': date.toIso8601String(),
    'amount': amount,
  };

  factory DebitTransactionEntity.fromJson(Map<String, dynamic> json) {
    return DebitTransactionEntity(
      DateTime.parse(json['date']),
      json['amount'],
    );
  }
}