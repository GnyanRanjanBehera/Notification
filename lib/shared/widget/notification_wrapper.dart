import 'package:fcm_config/fcm_config.dart';
import 'package:firebasedemo/bootstrap.dart';
import 'package:firebasedemo/data/service/user_pod.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


extension NotificationWrapperExt on Widget {
  Widget notificationHandler() {
    return NotificationWrapper(
      child: this,
    );
  }
}

class NotificationWrapper extends ConsumerStatefulWidget {
  final Widget child;
  const NotificationWrapper({super.key, required this.child});

  @override
  ConsumerState<NotificationWrapper> createState() =>
      _NotificationWrapperState();
}

class _NotificationWrapperState extends ConsumerState<NotificationWrapper>
    with FCMNotificationMixin, FCMNotificationClickMixin {
  late FlutterLocalNotificationsPlugin localNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  @override
  void initState() {
    super.initState();
    talker.debug("Notification Wrapper started");
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }

  void cancelNotification({required int notificationId}) {
    try {
      //localNotificationsPlugin.cancel(notificationId);
      talker.debug("cancellled notification $notificationId");
    } catch (e) {
      talker.error("Unable to cancel notification due to $e");
    }
  }

  ///Listen to incomming notification :
  @override
  void onNotify(RemoteMessage notification) async {
    talker.debug(
      "incoming notification data: ${notification.data} title:${notification.notification?.title} body:${notification.notification?.body}",
    );
    final notificationId = int.tryParse(notification.messageId ?? "0") ?? 0;
    notificationonActioner(
        data: notification.data, notificationID: notificationId);

    talker.debug("notification ID  ${notification.messageId}");
    // ref.invalidate(newBookingsPod);
  }

  ///Listen to notification tap:
  @override
  void onClick(RemoteMessage notification) {
    talker.debug(
      "notification tap data: ${notification.data} title:${notification.notification?.title} body:${notification.notification?.body}",
    );
    final notificationId = int.tryParse(notification.messageId ?? "0") ?? 0;
    notificationonActioner(
        data: notification.data, notificationID: notificationId);
  }

  void notificationonActioner(
      {required Map<String, dynamic> data, required int notificationID}) async {
    try {
      // final notificationdatamodel = NotificationDataModel.fromMap(data);
      final user = ref.read(userDBPod).getUser();
      if (user != null) {
        // await ref.read(autorouterProvider).navigate(
        //       NotificationActionerRoute(
        //         notificationDataModel: notificationdatamodel,
        //         notificationId: notificationID,
        //       ),
        //     );
      } else {
        talker.error("User have to login to navigate to notification action");
      }
    } catch (e) {
      //Failed to parse notification data
      talker.error(e);
    }
    cancelNotification(notificationId: notificationID);
  }
}