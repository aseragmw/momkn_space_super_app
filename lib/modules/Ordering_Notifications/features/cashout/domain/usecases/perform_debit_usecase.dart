import 'package:dartz/dartz.dart';
import 'package:super_app/modules/Ordering_Notifications/core/errors/failures.dart';
import 'package:super_app/modules/Ordering_Notifications/features/cashout/domain/entities/debit_transaction.dart';
import 'package:super_app/modules/Ordering_Notifications/features/cashout/domain/repositories/cashout_repository.dart';

class PerformDebitUsecase {
  final CashoutRepository cashoutRepository;
  PerformDebitUsecase({required this.cashoutRepository});
  Future<Either<Failure, DebitTransactionEntity>> call(double amount) => cashoutRepository.performDebit(amount);
}
