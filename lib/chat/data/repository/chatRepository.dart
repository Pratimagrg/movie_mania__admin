import 'dart:convert';

import 'package:movie_mania_admin/chat/data/model/messageModel.dart';
import 'package:movie_mania_admin/common/api.dart';
import 'package:http/http.dart' as http;
import 'package:movie_mania_admin/common/errorException.dart';

import '../../../common/unAuthorizedException.dart';

class ChatRepository {
  Future<MessageModel> getMessageList(roomId, accessToken) async {
    String roomid = roomId.toString();
    var url = chatApi + roomid + '/message-list';
    var response = await http
        .get(Uri.parse(url), headers: {'authorization': 'JWT ' '$accessToken'});
    if (response.statusCode == 200) {
      final responseJson = json.decode(response.body);
      final MessageModel messageModel = MessageModel.fromJson(responseJson);
      return messageModel;
    } else if (response.statusCode == 401) {
      throw UnAuthorizedException(
          "Your token has been expired. Please login again.");
    } else {
      final responseJson = json.decode(response.body);

      throw ErrorException(responseJson['errors'][0]['message']);
    }
  }

  Future<MessageModel> getNextMessageList(url, accessToken) async {
    var response = await http
        .get(Uri.parse(url), headers: {'authorization': 'JWT ' '$accessToken'});
    if (response.statusCode == 200) {
      final responseJson = json.decode(response.body);
      final MessageModel messageModel = MessageModel.fromJson(responseJson);
      return messageModel;
    } else if (response.statusCode == 401) {
      throw UnAuthorizedException(
          "Your token has been expired. Please login again.");
    } else {
      final responseJson = json.decode(response.body);

      throw ErrorException(responseJson['errors'][0]['message']);
    }
  }
}
