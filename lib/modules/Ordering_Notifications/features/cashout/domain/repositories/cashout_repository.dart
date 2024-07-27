import 'package:dartz/dartz.dart';
import 'package:super_app/modules/Ordering_Notifications/core/errors/failures.dart';
import 'package:super_app/modules/Ordering_Notifications/features/cashout/domain/entities/debit_transaction.dart';
import 'package:super_app/modules/Ordering_Notifications/features/products/data/models/sku_model.dart';
import 'package:super_app/modules/Ordering_Notifications/features/products/domain/entities/brand_entity.dart';
import 'package:super_app/modules/Ordering_Notifications/features/products/domain/entities/catalog_entity.dart';
import 'package:super_app/modules/Ordering_Notifications/features/products/domain/entities/sub_category_entity.dart';

abstract class CashoutRepository {
  Future<Either<Failure, double>> getCurrentBalance();
  Future<Either<Failure, DebitTransactionEntity>> performDebit(double amount);
}
