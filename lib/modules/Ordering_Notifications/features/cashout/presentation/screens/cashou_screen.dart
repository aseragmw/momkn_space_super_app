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
import 'package:super_app/modules/Ordering_Notifications/features/cashout/presentation/screens/transactions_history_screen.dart';
import 'package:super_app/modules/Ordering_Notifications/features/products/presentation/bloc/bloc/products_bloc.dart';
import 'package:super_app/modules/Ordering_Notifications/features/products/presentation/screens/categories_screen.dart';
import 'package:super_app/modules/Ordering_Notifications/features/products/presentation/widgets/catalog_category_card.dart';

import '../../../../core/network/api_caller.dart';
import '../bloc/bloc/cashout_state.dart';

class CashoutScreen extends StatefulWidget {
  const CashoutScreen({super.key});

  @override
  State<CashoutScreen> createState() => _CashoutScreenState();
}


class _CashoutScreenState extends State<CashoutScreen> {
  String balance = "0";

  Future<void> getCachedBalance()async{
    bool found = CacheHelper.containsKey("balance");
    if(found){
      final cached = await CacheHelper.get("balance");

      setState(() {
balance=cached;
      });
    }
    else{
      try {
        final jsonRes = await ApiCaller.getHTTP(
          'http://balanceportal.runasp.net/api/ProfessorTransaction/transactions/67401668800119/last-balance',
          null,
        );
        await CacheHelper.put("balance", jsonRes.data.toString());
        setState(() {
          balance = jsonRes.data.toString();
        });
      } catch (e) {
        log("${e.toString()} in getcaached balance");

      }
    }
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCachedBalance();
  }


  @override
  Widget build(BuildContext context) {
    context.read<CashoutBloc>().add(const GetCurrentBalanceEvent());
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
          trailingWidget: IconButton(onPressed: (){
            Navigator.of(context).push(MaterialPageRoute(builder: (_)=>TransactionsHistoryScreen()));
          },icon: Icon(Icons.history,size: context.screenAspectRatio*15,color: AppTheme.orangeColor,),),
        ),
        Center(
          child: Text(
            "Cash Out",
            style: TextStyle(
                fontSize: AppTheme.fontSize24(context),
                fontWeight: AppTheme.fontWeight700,
                color: AppTheme.primaryGreenColor),
          ),
        ),
        SizedBox(
          height: context.screenAspectRatio * 10,
        ),
        Text(
          textAlign: TextAlign.center,
          "Your Balance",
          style: TextStyle(
              fontSize: AppTheme.fontSize20(context),
              color: AppTheme.primaryGreenColor,
              fontWeight: AppTheme.fontWeight600),
        ),
        Text(
          textAlign: TextAlign.center,
          balance.toString(),
          style: TextStyle(
              fontSize: AppTheme.fontSize20(context),
              color: AppTheme.blackColor,
              fontWeight: AppTheme.fontWeight600),
        ),
        SizedBox(
          height: context.screenAspectRatio * 10,
        ),
        CustomButton(
            title: "Perform Cash Out",
            onPress: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => PeroformCashoutScreen()));
            },
            buttonColor: AppTheme.primaryGreenColor,
            borderRadius: AppTheme.boxRadius,
            borderColor: AppTheme.primaryGreenColor,
            buttonWidth: context.screenWidth * 0.7,
            fontSize: AppTheme.fontSize18(context))
      ],
    ));
  }
}
