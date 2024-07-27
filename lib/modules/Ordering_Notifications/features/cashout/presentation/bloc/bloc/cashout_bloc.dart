import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:super_app/modules/Ordering_Notifications/features/cashout/domain/usecases/get_current_balance_usecase.dart';
import 'package:super_app/modules/Ordering_Notifications/features/cashout/domain/usecases/perform_debit_usecase.dart';
import 'package:super_app/modules/Ordering_Notifications/features/products/data/datasources/products_remote_data_source.dart';
import 'package:super_app/modules/Ordering_Notifications/features/products/data/repositories/products_repository_impl.dart';
import 'package:super_app/modules/Ordering_Notifications/features/products/domain/entities/brand_entity.dart';
import 'package:super_app/modules/Ordering_Notifications/features/products/domain/entities/catalog_entity.dart';
import 'package:super_app/modules/Ordering_Notifications/features/products/domain/entities/sku_entity.dart';
import 'package:super_app/modules/Ordering_Notifications/features/products/domain/entities/sub_category_entity.dart';
import 'package:super_app/modules/Ordering_Notifications/features/products/domain/usecases/get_brands_usecase.dart';
import 'package:super_app/modules/Ordering_Notifications/features/products/domain/usecases/get_catalogs_categories_subcategories_usecase.dart';
import 'package:super_app/modules/Ordering_Notifications/features/products/domain/usecases/get_skus_usecase.dart';

import '../../../data/datasources/cashout_remote_data_source.dart';
import '../../../data/repositories/cashout_repository_impl.dart';
import 'cashout_event.dart';
import 'cashout_state.dart';



class CashoutBloc extends Bloc<CashoutEvent, CashoutState> {
  CashoutBloc() : super(CashoutInitial()) {
    on<CashoutEvent>((event, emit) {});

    on<GetCurrentBalanceEvent>(
          (event, emit) async {
        emit(GetCurrentBalanceLoadingState());
        GetCurrentBalanceUsecase getCurrentBalanceUsecase = GetCurrentBalanceUsecase(
            cashoutRepository: CashoutRepositoryImpl(cashoutRemoteDataSource: CashoutRemoteDataSourceImplWithDio()));
        final either = await getCurrentBalanceUsecase.call();
        either.fold((l) {
          emit(GetCurrentBalanceErrorState(message: l.message));
        }, (r) {
          log("fel blocccc");
          emit(GetCurrentBalanceSuccessState( balance: r));
        });
      },
    );

    on<PerformDebitEvent>(
          (event, emit) async {
        emit(PerformDebitLoadingState());
        PerformDebitUsecase performDebitUsecase = PerformDebitUsecase(
            cashoutRepository: CashoutRepositoryImpl(cashoutRemoteDataSource: CashoutRemoteDataSourceImplWithDio()));
        final either = await performDebitUsecase.call(event.amount);
        either.fold((l) {
          emit(PerformDebitErrorState(message: l.message));
        }, (r) {
          log("fel blocccc");
          emit(PerformDebitSuccessState( transactionEntity: r));
        });
      },
    );

  }
}
