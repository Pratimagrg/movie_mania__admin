import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:movie_mania_admin/common/api.dart';
import 'package:movie_mania_admin/common/errorException.dart';
import 'package:movie_mania_admin/login/data/model/loginDetailModel.dart';

class LoginRepository {
  Future<LoginDetailModel> loginUser(String username, String password) async {
    Map data = {"username": username, "password": password};

    var response = await http.post(
        Uri.parse(
          loginApi,
        ),
        headers: {"Content-Type": "application/x-www-form-urlencoded"},
        body: data);
    if (response.statusCode == 200) {
      final responseJson = json.decode(response.body);
      final LoginDetailModel loginDetails =
          LoginDetailModel.fromJson(responseJson);
      return loginDetails;
    } else {
      final responseJson = json.decode(response.body);

      throw ErrorException(responseJson['errors'][0]['message'][0].toString());
    }
  }
}
