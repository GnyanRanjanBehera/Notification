import 'package:firebasedemo/core/local_storage/app_storage_pod.dart';
import 'package:firebasedemo/data/service/user_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final userDBPod = Provider.autoDispose<UserDbService>((ref) {
  return UserDbService(appBox: ref.watch(appBoxProvider));
});
