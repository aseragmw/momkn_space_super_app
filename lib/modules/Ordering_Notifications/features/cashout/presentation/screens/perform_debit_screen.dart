import 'dart:math';
import 'dart:developer' as dev;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:super_app/modules/Ordering_Notifications/core/extentions/screen_size.dart';
import 'package:super_app/modules/Ordering_Notifications/core/utils/snackbar_message.dart';
import 'package:super_app/modules/Ordering_Notifications/core/widgets/custom_app_bar.dart';
import 'package:super_app/modules/Ordering_Notifications/core/widgets/custom_button.dart';
import 'package:super_app/modules/Ordering_Notifications/core/widgets/custom_circular_progress_indicator.dart';
import 'package:super_app/modules/Ordering_Notifications/core/widgets/custom_text_field.dart';
import 'package:super_app/modules/Ordering_Notifications/features/cashout/presentation/bloc/bloc/cashout_event.dart';
import 'package:super_app/modules/Ordering_Notifications/features/cashout/presentation/screens/generate_code_screen.dart';

import '../../../../core/utils/app_theme.dart';
import '../../../../core/widgets/main_layout.dart';
import '../bloc/bloc/cashout_bloc.dart';
import '../bloc/bloc/cashout_state.dart';

class PeroformCashoutScreen extends StatefulWidget {
  const PeroformCashoutScreen({super.key});

  @override
  State<PeroformCashoutScreen> createState() => PeroformCashoutState();
}

class PeroformCashoutState extends State<PeroformCashoutScreen> {
  final amountTextController = TextEditingController();


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
            "Perform Cash Out",
            style: TextStyle(
                fontSize: AppTheme.fontSize24(context),
                fontWeight: AppTheme.fontWeight700,
                color: AppTheme.primaryGreenColor),
          ),
        ),
        SizedBox(
          height: context.screenAspectRatio * 10,
        ),
        CustomTextField(
            hintText: "Enter Amount",
            trailingIcon: null,
            obsecured: false,
            controller: amountTextController,
            filled: false),
        SizedBox(
          height: context.screenAspectRatio * 10,
        ),

        SizedBox(
          height: context.screenAspectRatio * 10,
        ),
             BlocConsumer<CashoutBloc, CashoutState>(
                builder: (context, state) {
                  if (state is PerformDebitLoadingState) {
                    return const CustomCircularProgressIndicator(
                      color: AppTheme.primaryGreenColor,
                    );
                  } else {
                    return CustomButton(
                        title: "Generate Code",
                        onPress: () {
                          context.read<CashoutBloc>().add(PerformDebitEvent(double.parse(amountTextController.text)));
                        },
                        buttonColor: AppTheme.primaryGreenColor,
                        borderRadius: AppTheme.boxRadius,
                        borderColor: AppTheme.primaryGreenColor,
                        buttonWidth: context.screenWidth * 0.7,
                        fontSize: AppTheme.fontSize18(context));
                  }
                },
                listener: (context, state) {
                  if (state is PerformDebitErrorState) {
                    //TODO not valid logic
                    // SnackBarMessage.showErrorSnackBar(
                    //     message: state.message, context: context);
                    Navigator.of(context).push(MaterialPageRoute(builder: (_)=>GenerateCodeScreen(amount: amountTextController.text,)));
                  }
                  else if(state is PerformDebitSuccessState){
                    Navigator.of(context).push(MaterialPageRoute(builder: (_)=>GenerateCodeScreen(amount: amountTextController.text)));
                  }
                },
              )

      ],
    ));
  }
}


