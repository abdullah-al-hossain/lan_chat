import 'dart:io';
import 'package:crypto/crypto.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class DeviceIdentity {
  static const _key = 'device_id';

  static Future<Map<String, String>> getIdentity() async {
    final prefs = await SharedPreferences.getInstance();
    String? storedId = prefs.getString(_key);

    final deviceInfo = DeviceInfoPlugin();

    String rawId;
    String deviceName;
    String model;

    if (Platform.isAndroid) {
      final android = await deviceInfo.androidInfo;
      rawId = android.id;
      model = android.model;
      deviceName = android.device;
    } else {
      final ios = await deviceInfo.iosInfo;
      rawId = ios.identifierForVendor ?? ios.name;
      model = ios.utsname.machine;
      deviceName = ios.name;
    }

    final deviceId = storedId ??
        sha1.convert(utf8.encode(rawId)).toString();

    if (storedId == null) {
      await prefs.setString(_key, deviceId);
    }

    return {
      'id': deviceId,
      'name': deviceName,
      'model': model,
    };
  }
}
