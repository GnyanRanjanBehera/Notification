import 'package:firebasedemo/main.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:platform_info/platform_info.dart';
import 'package:firebasedemo/bootstrap.dart';
import 'package:firebasedemo/core/local_storage/app_storage_pod.dart';
import 'package:firebasedemo/features/splash/controller/box_encryption_key_pod.dart';
import 'package:firebasedemo/init.dart';
import 'package:firebasedemo/shared/riverpod_ext/riverpod_observer.dart';

final futureInitializerPod =
    FutureProvider.autoDispose<ProviderContainer>((ref) async {
  ///Additional intial delay duration for app
  // await Future.delayed(const Duration(seconds: 1));
  await (init());
  await Hive.initFlutter();

  ///Replace `appBox` namw with any key you want

  final encryptionCipher = await Platform.I.when(
    mobile: () async {
      final encryptionKey = await ref.watch(boxEncryptionKeyPod.future);
      return HiveAesCipher(encryptionKey);
    },
  );

  ///TODO: Replace box name with your unique name
  final appBox = await Hive.openBox(
    'AppBox',
    encryptionCipher: encryptionCipher,
  );

  baseProviderContainer = ProviderContainer(
    overrides: [
      appBoxProvider.overrideWithValue(appBox),
    ],
    observers: [
      MyObserverLogger(
        talker: talker,
      ),
    ],
  );
  return baseProviderContainer;
});
