import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../../common/api.dart';
import '../../../common/sharedPrefs.dart';
import '../../../common/unAuthorizedException.dart';

class RegisterDeviceRepository {
  Future<bool> registerDevice(registrationToken) async {
    Map data = {'registration_id': registrationToken, 'type': 'android'};
    var access = await SharedPrefs().getAccess();

    final response = await http.post(Uri.parse(registerDeviceApi),
        headers: {'authorization': 'JWT ' '$access'}, body: data);

    if (response.statusCode == 201) {
      return true;
    } else if (response.statusCode == 401) {
      throw UnAuthorizedException(
          "Your token has been expired. Please login again.");
    } else {
      return false;
    }
  }
}
