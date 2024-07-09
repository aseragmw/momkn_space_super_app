


import 'package:super_app/modules/Ordering_Notifications/core/network/api_caller.dart';
import 'package:super_app/modules/Ordering_Notifications/features/notificartions/data/models/notification_model.dart';

abstract class NotificationRemoteDataSource {
  Future<List<NotificationModel>> getNotifications(String mobileNumber, String ip, String password);
}

class NotificationRemoteDataSourceImplWithDio extends NotificationRemoteDataSource {
  @override
  Future<List<NotificationModel>> getNotifications(String mobileNumber, String ip, String password) async {
    final jsonRes = await ApiCaller.postHTTP('/Notification', {"mobileNumber": mobileNumber, "ip": ip, "password": password});
    List<NotificationModel> notifications = [];
    for (var element in jsonRes.data) {
      notifications.add(NotificationModel.fromJson(element));
    }
    return notifications;
  }
}
