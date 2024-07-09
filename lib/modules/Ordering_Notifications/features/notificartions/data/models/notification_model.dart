
import 'package:super_app/modules/Ordering_Notifications/core/constants/api_conatsants.dart';
import 'package:super_app/modules/Ordering_Notifications/features/notificartions/domain/entities/notification_entity.dart';

class NotificationModel extends NotificationEntity {
  const NotificationModel({required super.id, required super.title, required super.body, required super.effectiveDate, required super.userMobileNumber, required super.senderName});

 

  factory NotificationModel.fromJson(Map<String, dynamic> jsonData) {
    return NotificationModel(id: jsonData[idAPIKey], title: jsonData[titleAPIKey], body: jsonData[bodyAPIKey], effectiveDate: jsonData[effectiveDataAPIKey], userMobileNumber: jsonData[userMobileNumberAPIKey], senderName: jsonData[senderNameAPIKey]);
  }
  Map<String, dynamic> toJson() {
    return {
      idAPIKey:id,
      titleAPIKey:title,
      bodyAPIKey:body,
      effectiveDataAPIKey:effectiveDate,
      userMobileNumberAPIKey:userMobileNumber,
      senderNameAPIKey:senderName,
    };
  }
}

