import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:super_app/modules/Ordering_Notifications/core/extentions/screen_size.dart';
import 'package:super_app/modules/Ordering_Notifications/core/utils/app_theme.dart';
import 'package:super_app/modules/Ordering_Notifications/core/utils/cache_helper.dart';
import 'package:super_app/modules/Ordering_Notifications/core/utils/snackbar_message.dart';
import 'package:super_app/modules/Ordering_Notifications/core/widgets/custom_app_bar.dart';
import 'package:super_app/modules/Ordering_Notifications/core/widgets/custom_button.dart';
import 'package:super_app/modules/Ordering_Notifications/core/widgets/custom_circular_progress_indicator.dart';
import 'package:super_app/modules/Ordering_Notifications/core/widgets/main_layout.dart';
import 'package:super_app/modules/Ordering_Notifications/features/cashout/presentation/bloc/bloc/cashout_bloc.dart';
import 'package:super_app/modules/Ordering_Notifications/features/cashout/presentation/bloc/bloc/cashout_event.dart';
import 'package:super_app/modules/Ordering_Notifications/features/cashout/presentation/screens/perform_debit_screen.dart';
import 'package:super_app/modules/Ordering_Notifications/features/products/presentation/bloc/bloc/products_bloc.dart';
import 'package:super_app/modules/Ordering_Notifications/features/products/presentation/screens/categories_screen.dart';
import 'package:super_app/modules/Ordering_Notifications/features/products/presentation/widgets/catalog_category_card.dart';

import '../../../../core/network/api_caller.dart';
import '../../domain/entities/debit_transaction.dart';
import '../bloc/bloc/cashout_state.dart';

class TransactionsHistoryScreen extends StatefulWidget {
  const TransactionsHistoryScreen({super.key});

  @override
  State<TransactionsHistoryScreen> createState() =>
      _TransactionsHistoryScreenState();
}

class _TransactionsHistoryScreenState extends State<TransactionsHistoryScreen> {
  List<DebitTransactionEntity> transactions = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    bool found = CacheHelper.containsKey("debit_transactions_key");
    if (found) {
      getCachedData();
    }
  }

  Future<void> getCachedData() async {
    transactions = await CacheHelper.getCachedDebitTransactions();
    List<DebitTransactionEntity> reversed = [];
    for(int i=transactions.length-1;i>=0;i--){
      reversed.add(transactions[i]);
    }
    setState(() {
      transactions= reversed;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MainLayout(
        body: Column(
      children: [
        CustomAppBar(
          title: Image.asset(
            "assets/logo.png",
            height: context.screenAspectRatio * 25,
            fit: BoxFit.fill,
          ),
          showBackCursor: true,
        ),
        Center(
          child: Text(
            "Transactions History",
            style: TextStyle(
                fontSize: AppTheme.fontSize24(context),
                fontWeight: AppTheme.fontWeight700,
                color: AppTheme.primaryGreenColor),
          ),
        ),
        SizedBox(
          height: context.screenAspectRatio * 10,
        ),
        ListView.builder(
            shrinkWrap: true,
            itemCount: transactions.length,
            itemBuilder: (context, index) {
              final transaction = transactions[index];
              return TransactionWidget(
                  date: transaction.date.toString(),
                  amount: transaction.amount.toString());
            }),
        SizedBox(
          height: context.screenAspectRatio * 10,
        ),
      ],
    ));
  }
}

class TransactionWidget extends StatelessWidget {
  const TransactionWidget(
      {super.key, required this.date, required this.amount});
  final String date;
  final String amount;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: context.screenAspectRatio*3),
      decoration: BoxDecoration(border: Border.all(color: AppTheme.orangeColor),borderRadius: AppTheme.boxRadius),
      padding: EdgeInsets.all(context.screenAspectRatio*5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            date.substring(0, 10),
            style: TextStyle(
                color: AppTheme.primaryGreenColor,
                fontWeight: AppTheme.fontWeight600,
                fontSize: AppTheme.fontSize22(context)),
          ),
          Text(
            "$amount EGP",
            style: TextStyle(
                color: Colors.red,
                fontWeight: AppTheme.fontWeight600,
                fontSize: AppTheme.fontSize20(context)),
          )
        ],
      ),
    );
  }
}
