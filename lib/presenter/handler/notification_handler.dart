// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
//
// import 'id_handler.dart';
//
// class NotificationHandler {
//   final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
//       FlutterLocalNotificationsPlugin();
//
//   void _initialize() {
//     final DarwinInitializationSettings darwinInitializationSettings =
//         DarwinInitializationSettings(
//           requestAlertPermission: true,
//           requestBadgePermission: true,
//           requestSoundPermission: true,
//           notificationCategories: [],
//         );
//
//     final AndroidInitializationSettings androidInitializationSettings =
//         AndroidInitializationSettings('@mipmap/ic_launcher');
//
//     final LinuxInitializationSettings linuxInitializationSettings =
//         LinuxInitializationSettings(
//           defaultActionName: 'Open notification',
//           defaultIcon: AssetsLinuxIcon('icons/app_icon.png'),
//         );
//
//     final InitializationSettings initializationSettings =
//         InitializationSettings(
//           iOS: darwinInitializationSettings,
//           macOS: darwinInitializationSettings,
//           linux: linuxInitializationSettings,
//           android: androidInitializationSettings,
//         );
//
//     _flutterLocalNotificationsPlugin.initialize(
//       initializationSettings,
//       onDidReceiveNotificationResponse:
//           (NotificationResponse notificationResponse) {
//             switch (notificationResponse.notificationResponseType) {
//               case NotificationResponseType.selectedNotification:
//                 break;
//               case NotificationResponseType.selectedNotificationAction:
//                 break;
//             }
//           },
//     );
//   }
//
//   NotificationHandler._() {
//     _initialize();
//   }
//
//   static final NotificationHandler _instance = NotificationHandler._();
//
//   static NotificationHandler get instance => _instance;
//
//   Future<void> show({title = '待办提醒', body = '专注'}) async {
//     const AndroidNotificationDetails androidNotificationDetails =
//         AndroidNotificationDetails('one', 'One');
//
//     const LinuxNotificationDetails linuxNotificationDetails =
//         LinuxNotificationDetails();
//
//     const DarwinNotificationDetails darwinNotificationDetails =
//         DarwinNotificationDetails();
//
//     const NotificationDetails notificationDetails = NotificationDetails(
//       android: androidNotificationDetails,
//       macOS: darwinNotificationDetails,
//       iOS: darwinNotificationDetails,
//       linux: linuxNotificationDetails,
//     );
//
//     await _flutterLocalNotificationsPlugin.show(
//       IdHandler.instance.nextShowId(),
//       title,
//       body,
//       notificationDetails,
//     );
//   }
// }
//
// class ReceivedNotification {
//   ReceivedNotification({
//     required this.id,
//     required this.title,
//     required this.body,
//     required this.payload,
//   });
//
//   final int id;
//   final String? title;
//   final String? body;
//   final String? payload;
// }
