import 'dart:core';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:super_app/modules/Ordering_Notifications/core/extentions/screen_size.dart';
import 'package:super_app/modules/Ordering_Notifications/core/utils/app_theme.dart';
import 'package:super_app/modules/Ordering_Notifications/core/utils/snackbar_message.dart';
import 'package:super_app/modules/Ordering_Notifications/core/widgets/custom_app_bar.dart';
import 'package:super_app/modules/Ordering_Notifications/core/widgets/custom_circular_progress_indicator.dart';
import 'package:super_app/modules/Ordering_Notifications/core/widgets/main_layout.dart';
import 'package:super_app/modules/Ordering_Notifications/features/notificartions/presentation/bloc/bloc/notification_bloc.dart';
import 'package:super_app/modules/Ordering_Notifications/features/notificartions/presentation/widgets/notification_widget.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    context.read<NotificationBloc>().add(const GetNotificationsEvent(mobileNumber: "mobileNumber", ip: "ip", password: "password"));
    return MainLayout(
        body: Column(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomAppBar(
          showBackCursor: false,
          title: Text(
            "Notifications",
            style: TextStyle(fontSize: AppTheme.fontSize24(context), fontWeight: AppTheme.fontWeight500, color: AppTheme.blackColor),
          ),
        ),
        SizedBox(
          height: context.screenHeight * 0.025,
        ),
        BlocConsumer(
          builder: (context, state) {
            if (state is GetNotificationstLoadingState) {
              return const CustomCircularProgressIndicator(
                color: AppTheme.primaryGreenColor,
              );
            } else if (state is GetNotificationsSuccessState) {
              return ListView.builder(
                itemBuilder: (context, index) {
                  return NotificationWidget(notificationEntity: state.notifications[index]);
                },
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
              );
            } else {
              return Center(
                child: SizedBox(
                    width: context.screenWidth * 0.8,
                    child: Text(
                      "No Notifications Yet",
                      style: TextStyle(
                          fontSize: AppTheme.fontSize20(context), color: AppTheme.primaryGreenColor, fontWeight: AppTheme.fontWeight600),
                    )),
              );
            }
          },
          listener: (context, state) {
            if (state is GetNotificationsErrorState) {
              SnackBarMessage.showErrorSnackBar(message: state.message, context: context);
            }
          },
        ),
      ],
    ));
  }
}
