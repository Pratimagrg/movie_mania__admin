import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:movie_mania_admin/common/api.dart';
import '../../../common/unAuthorizedException.dart';
import '../model/roomListModel.dart';

class RoomListRepository {
  getRoomList(accessToken) async {
    print("i am in room list repository");
    try {
      var response = await http.get(Uri.parse(roomListApi),
          headers: {'authorization': 'JWT ' '$accessToken'});

      if (response.statusCode == 200) {
        final responseJson = json.decode(response.body);
        final List<RoomListModel> roomList = responseJson
            .map<RoomListModel>((rooms) => RoomListModel.fromJson(rooms))
            .toList();
        return roomList;
      } else if (response.statusCode == 401) {
        throw UnAuthorizedException(
            "Your token has been expired. Please login again.");
      } else {
        throw Exception('Failed to get room list');
      }
    } catch (e) {
      throw Exception('Failed to get room list');
    }
  }
}
