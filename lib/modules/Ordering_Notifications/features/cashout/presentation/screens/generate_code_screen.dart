import 'dart:math';
import 'dart:developer' as dev;

import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:super_app/modules/Ordering_Notifications/core/extentions/screen_size.dart';
import 'package:super_app/modules/Ordering_Notifications/core/utils/cache_helper.dart';
import 'package:super_app/modules/Ordering_Notifications/core/utils/snackbar_message.dart';
import 'package:super_app/modules/Ordering_Notifications/core/widgets/custom_app_bar.dart';
import 'package:super_app/modules/Ordering_Notifications/core/widgets/custom_button.dart';
import 'package:super_app/modules/Ordering_Notifications/core/widgets/custom_circular_progress_indicator.dart';
import 'package:super_app/modules/Ordering_Notifications/core/widgets/custom_text_field.dart';
import 'package:super_app/modules/Ordering_Notifications/features/cashout/domain/entities/debit_transaction.dart';
import 'package:super_app/modules/Ordering_Notifications/features/cashout/presentation/bloc/bloc/cashout_event.dart';

import '../../../../core/utils/app_theme.dart';
import '../../../../core/widgets/main_layout.dart';
import '../bloc/bloc/cashout_bloc.dart';
import '../bloc/bloc/cashout_state.dart';

class GenerateCodeScreen extends StatefulWidget {
  const GenerateCodeScreen({super.key, required this.amount});
  final String amount;

  @override
  State<GenerateCodeScreen> createState() => GenerateCodeState();
}

class GenerateCodeState extends State<GenerateCodeScreen> {
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
        Text(
          "Your Code",
          style: TextStyle(
              fontSize: AppTheme.fontSize24(context),
              fontWeight: AppTheme.fontWeight700,
              color: AppTheme.primaryGreenColor),
        ),
        SizedBox(
          height: context.screenAspectRatio * 10,
        ),
        Container(
          decoration: BoxDecoration(borderRadius: AppTheme.boxRadius,border: Border.all(color: AppTheme.orangeColor)),
          padding: EdgeInsets.all(context.screenAspectRatio*10),
          child: Text(
            generateOtp(),
            style: TextStyle(
                fontSize: AppTheme.fontSize28(context),
                fontWeight: AppTheme.fontWeight700,
                color: AppTheme.primaryGreenColor),
          ),
        ),

        SizedBox(
          height: context.screenAspectRatio * 10,
        ),
        Container(
          child: Text(
            textAlign: TextAlign.center,
            "Redirect to your nearest Ahly Momkn pickup point to get your cash",
            style: TextStyle(
                fontSize: AppTheme.fontSize22(context),
                fontWeight: AppTheme.fontWeight400,
                color: AppTheme.blackColor),
          ),
        ),
        SizedBox(
          height: context.screenAspectRatio * 10,
        ),
        Container(
          child: Text(
            textAlign: TextAlign.center,
            "Code is valid for only 72H",
            style: TextStyle(
                fontSize: AppTheme.fontSize20(context),
                fontWeight: AppTheme.fontWeight400,
                color: AppTheme.orangeColor),
          ),
        ),
        SizedBox(
          height: context.screenAspectRatio * 10,
        ),
        CustomButton(
            title: "Confirm",
            onPress: ()async {
              double currentBalance = double.parse(CacheHelper.get("balance"));
              double amount = double.parse(widget.amount);
              double newBalance = currentBalance - amount;
              await CacheHelper.put("balance", newBalance.toString());
              final transactions = await CacheHelper.getCachedDebitTransactions();
               transactions.add(DebitTransactionEntity(DateTime.now(), amount));
               await CacheHelper.cacheDebitTransactions(transactions);
              Navigator.of(context).pop();
              Navigator.of(context).pop();
              Navigator.of(context).pop();
              SnackBarMessage.showSuccessSnackBar(message: "Cashed Out Successfully", context: context);
            },
            buttonColor: AppTheme.primaryGreenColor,
            borderRadius: AppTheme.boxRadius,
            borderColor: AppTheme.primaryGreenColor,
            buttonWidth: context.screenWidth * 0.7,
            fontSize: AppTheme.fontSize18(context)),
        SizedBox(
          height: context.screenAspectRatio * 10,
        ),
        CustomButton(
            title: "Cancel",
            onPress: () {
              Navigator.of(context).pop();
              Navigator.of(context).pop();
            },
            buttonColor: AppTheme.transparentColor,
            borderRadius: AppTheme.boxRadius,
            borderColor: AppTheme.primaryGreenColor,
            buttonWidth: context.screenWidth * 0.7,
            fontColor: AppTheme.primaryGreenColor,
            fontSize: AppTheme.fontSize18(context)),
      ],
    ));
  }
}

String generateOtp() {
  Random random = Random();
  int otp = random.nextInt(900000) + 100000; // Ensures a 6-digit number
  return otp.toString();
}
