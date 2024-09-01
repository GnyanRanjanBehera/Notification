import 'package:fcm_config/fcm_config.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebasedemo/bootstrap.dart';
import 'package:firebasedemo/data/service/user_pod.dart';
import 'package:firebasedemo/firebase_options.dart';
import 'package:firebasedemo/main.dart';
import 'package:platform_info/platform_info.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:talker_dio_logger/talker_dio_logger_interceptor.dart';
import 'package:talker_dio_logger/talker_dio_logger_settings.dart';

Future<void> setupFirebase() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  await FCMConfig.instance.init(
    defaultAndroidForegroundIcon:
        '@drawable/ic_stat_name', //default is @mipmap/ic_launcher
    defaultAndroidChannel: const AndroidNotificationChannel(
      'app', // same as value from android setup
      'app',
      importance: Importance.high,
      sound: RawResourceAndroidNotificationSound('notification'),
    ),
    onBackgroundMessage: _firebaseMessagingBackgroundHandler,
  );
  Platform.I.when(
    android: () async {
      await getToken();
    },
    iOS: () async {
      if (await FCMConfig.instance.messaging.getAPNSToken() != null) {
        await getToken();
      }
    },
  );
}

@pragma("vm:entry-point")
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  talker.debug(
      "Handling a background message: ${message.messageId} title:${message.notification?.title} body:${message.notification?.body} data: ${message.data} ");
}

@pragma("vm:entry-point")
Future<String?> getToken() async {
  final String? token = await FCMConfig.instance.messaging.getToken();
  final fcmDeviceToken = token ?? "";
  if (kDebugMode) {
    print("FCM notification is $fcmDeviceToken");
  }
  saveToken(token: token);
  return token;
}

@pragma("vm:entry-point")
Future<void> saveToken({required String? token}) async {
  final userdb = baseProviderContainer.read(userDBPod);
  final user = userdb.getUser();
  talker.debug("user $user");
  final authtoken = user?.token;

  if (token != null && authtoken != null) {
    final dio = Dio();
    dio.interceptors.add(
      TalkerDioLogger(
        talker: talker,
        settings: const TalkerDioLoggerSettings(
          printRequestHeaders: true,
          printResponseHeaders: true,
          printRequestData: true,
          printResponseData: true,
          printResponseMessage: true,
        ),
      ),
    );

    try {
      final result = await dio.post(
        "https://hxpert.glocian.com/api/FirebaseMessaging",
        data: {
          "fcmToken": token,
        },
        options: Options(
          headers: {
            'Authorization': 'Bearer $authtoken',
          },
        ),
      );
      talker.debug(result.data.toString());
    } catch (e) {
      talker.error(e);
    }
  }
}
