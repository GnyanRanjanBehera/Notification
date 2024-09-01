import 'package:firebasedemo/data/model/user_data.dart';
import 'package:hive_flutter/hive_flutter.dart';

class UserDbService {
  final Box appBox;

  UserDbService({required this.appBox});

  final userBoxKey = 'user';

  Future<void> deleteUser() async {
    await appBox.delete(userBoxKey);
  }

  UserData? getUser() {
    final result = appBox.get(userBoxKey);
    if (result != null) {
      return UserData.fromJson(result);
    } else {
      return null;
    }
  }

  Future<void> saveUser({required UserData userData}) async {
    await appBox.put(userBoxKey, userData.toJson());
  }
}
