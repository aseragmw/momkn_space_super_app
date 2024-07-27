import 'dart:convert';
import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:super_app/modules/Ordering_Notifications/core/network/api_caller.dart';
import 'package:super_app/modules/Ordering_Notifications/features/cashout/data/models/DebitTransactionModel.dart';

abstract class CashoutRemoteDataSource {
  Future<double> getCurrentBalance();
  Future<DebitTransactionModel> performDebit(double amount);
}

class CashoutRemoteDataSourceImplWithDio extends CashoutRemoteDataSource {
  @override
  Future<double> getCurrentBalance() async {
    try {
      final jsonRes = await ApiCaller.getHTTP(
        'http://balanceportal.runasp.net/api/ProfessorTransaction/transactions/67401668800119/last-balance',
        null,
      );

      return jsonRes.data;
    } catch (e) {
      log("${e.toString()} error in get balance in datasource");
      rethrow;
    }
  }

  @override
  Future<DebitTransactionModel> performDebit(double amount) async {
    try {

      final jsonRes = await ApiCaller.postHTTP(
        'http://balanceportal.runasp.net/api/ProfessorTransaction/transactions',
        {
          "nationalId": "67401668800119",
          "transactionReference": "ref",
          "reference2": "ref",
          "transactionAmount": amount,
          "type": "Debit",
          "status": "Approved"
        },
      );
      log(jsonRes.data.toString());
      if(jsonRes.statusCode==200){

        return DebitTransactionModel(DateTime.now(), amount);
      }
      else{
        throw Exception("Error in performing debit in datasource 1");
      }
    } catch (e) {
      log("${e.toString()} error in performing debit in datasource");
      rethrow;
    }
  }
}
