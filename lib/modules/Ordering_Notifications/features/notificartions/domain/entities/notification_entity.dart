import 'package:equatable/equatable.dart';

class NotificationEntity extends Equatable {
  final int id;
  final String title;
  final String body;
  final String effectiveDate;
  final String userMobileNumber;
  final String senderName;

  const NotificationEntity({required this.id, required this.title, required this.body, required this.effectiveDate, required this.userMobileNumber, required this.senderName});

  @override
  List<Object?> get props => [id,title,body,effectiveDate,userMobileNumber,senderName];

}
