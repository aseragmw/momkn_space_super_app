


import 'dart:developer';

import 'package:super_app/modules/Ordering_Notifications/core/network/api_caller.dart';
import 'package:super_app/modules/Ordering_Notifications/features/notificartions/data/models/notification_model.dart';

abstract class NotificationRemoteDataSource {
  Future<List<NotificationModel>> getNotifications(String mobileNumber, String ip, String password);
}

class NotificationRemoteDataSourceImplWithDio extends NotificationRemoteDataSource {
  @override
  Future<List<NotificationModel>> getNotifications(String mobileNumber, String ip, String password) async {
    final jsonRes = await ApiCaller.postHTTP('https://kyc-75cv.onrender.com/System/Notification', {"mobileNumber":"01227773835",
      "ip":"3.3.3",
      "password":"1234"});
    List<NotificationModel> notifications = [];
    log(jsonRes.data.toString());
    for (var element in jsonRes.data) {
      notifications.add(NotificationModel.fromJson(element));
    }
    return notifications;
  }
}
