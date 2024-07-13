import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:super_app/modules/Ordering_Notifications/features/ordering/data/datasources/ordering_remote_data_source.dart';
import 'package:super_app/modules/Ordering_Notifications/features/ordering/data/repositories/oredering_repository_impl.dart';
import 'package:super_app/modules/Ordering_Notifications/features/ordering/domain/entities/order_with_invoice_entity.dart';
import 'package:super_app/modules/Ordering_Notifications/features/ordering/domain/usecases/create_order_usecase.dart';
import 'package:super_app/modules/Ordering_Notifications/features/ordering/domain/usecases/get_orders_with_invoices_usecase.dart';
import 'package:super_app/modules/Ordering_Notifications/features/service_booking_history/data/datasources/service_booking_history_remote_datasource.dart';
import 'package:super_app/modules/Ordering_Notifications/features/service_booking_history/data/repositories/service_booking_history_repo_impl.dart';
import 'package:super_app/modules/Ordering_Notifications/features/service_booking_history/domain/usecases/get_bookings_usecase.dart';
import 'package:super_app/modules/Ordering_Notifications/features/service_booking_history/presentation/bloc/bloc/service_booking_history_event.dart';
import 'package:super_app/modules/Ordering_Notifications/features/service_booking_history/presentation/bloc/bloc/service_booking_history_state.dart';


class ServiceBookingHistoryBloc extends Bloc<ServiceBookingHistoryEvent, ServiceBookingHistoryState> {
  ServiceBookingHistoryBloc() : super(ServiceBookingHistoryInitial()) {
    on<ServiceBookingHistoryEvent>((event, emit) {});

    on<GetBookingsEvent>(
      (event, emit) async {
        emit(GetBookingsLoadingState());
        GeteBookingsUsecase getBookingsUsecase = GeteBookingsUsecase(serviceBookingHistoryRepository: ServiceBookingHistoryRepositoryImpl(serviceBookingHistoryRemoteDataSource: ServiceBookingHistoryRemoteDataSourceImplWithDio()));
        final either = await getBookingsUsecase.call();
        either.fold((l) {
          emit(GetBookingsErrorState(message: l.message));
        }, (r) {
          log("fel blocccc");
          emit(GetBookingsSuccessState(bookings: r));
        });
      },
    );


  }
}
