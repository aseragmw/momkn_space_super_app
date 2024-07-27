import 'package:dartz/dartz.dart';
import 'package:super_app/modules/Ordering_Notifications/core/errors/failures.dart';
import 'package:super_app/modules/Ordering_Notifications/features/cashout/domain/repositories/cashout_repository.dart';

class GetCurrentBalanceUsecase {
  final CashoutRepository cashoutRepository;
  GetCurrentBalanceUsecase({required this.cashoutRepository});
  Future<Either<Failure, double>> call() => cashoutRepository.getCurrentBalance();
}
