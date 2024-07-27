import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:super_app/modules/Ordering_Notifications/core/errors/failures.dart';
import 'package:super_app/modules/Ordering_Notifications/core/utils/cache_helper.dart';
import 'package:super_app/modules/Ordering_Notifications/features/cashout/data/datasources/cashout_remote_data_source.dart';
import 'package:super_app/modules/Ordering_Notifications/features/cashout/domain/entities/debit_transaction.dart';
import 'package:super_app/modules/Ordering_Notifications/features/cashout/domain/repositories/cashout_repository.dart';
import 'package:super_app/modules/Ordering_Notifications/features/products/data/datasources/products_remote_data_source.dart';
import 'package:super_app/modules/Ordering_Notifications/features/products/data/models/sku_model.dart';
import 'package:super_app/modules/Ordering_Notifications/features/products/domain/entities/brand_entity.dart';
import 'package:super_app/modules/Ordering_Notifications/features/products/domain/entities/catalog_entity.dart';
import 'package:super_app/modules/Ordering_Notifications/features/products/domain/entities/sub_category_entity.dart';
import 'package:super_app/modules/Ordering_Notifications/features/products/domain/repositories/products_repository.dart';


class CashoutRepositoryImpl extends CashoutRepository {
  final CashoutRemoteDataSource cashoutRemoteDataSource;
  CashoutRepositoryImpl({required this.cashoutRemoteDataSource});

  @override
  Future<Either<Failure, double>> getCurrentBalance() async{
    try {
      final val = await cashoutRemoteDataSource.getCurrentBalance();
      return Right(val);
    } catch (e) {
      log(e.toString());
      return const Left(Failure(message: 'Error Getting Balance'));
    }
  }

  @override
  Future<Either<Failure, DebitTransactionEntity>> performDebit(double amount)async {
    try {
      final val = await cashoutRemoteDataSource.performDebit(amount);
      return Right(val);
    } catch (e) {
      log(e.toString());
      return const Left(Failure(message: 'Error Performing Cashout'));
    }
  }
}
