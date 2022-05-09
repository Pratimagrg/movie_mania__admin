import 'package:movie_mania_admin/common/api.dart';
import 'package:movie_mania_admin/message/data/model/roomListModel.dart';
import 'package:movie_mania_admin/dio/dioApi.dart';
import '../chat/data/model/messageModel.dart';
import '../login/data/model/loginDetailModel.dart';

class Repository {
  Future<List<RoomListModel>> getRoomssList() async {
    var response = await Api().dio.get(roomListApi);

    final List<RoomListModel> roomList = response.data
        .map<RoomListModel>((rooms) => RoomListModel.fromJson(rooms))
        .toList();
    return roomList;
  }

  Future<bool> registerDevice(registrationToken) async {
    Map body = {'registration_id': registrationToken, 'type': 'android'};
    // ignore: unused_local_variable
    var response = await Api().dio.post(registerDeviceApi, data: body);
    return true;
  }

  Future<LoginDetailModel> loginUser(String username, String password) async {
    Map data = {"username": username, "password": password};
    var response = await Api().dio.post(loginApi, data: data);

    final LoginDetailModel loginDetails =
        LoginDetailModel.fromJson(response.data);
    return loginDetails;
  }

  Future<MessageModel> getMessageList(roomId, accessToken) async {
    String roomid = roomId.toString();
    var url = chatApi + roomid + '/message-list';
    var response = await Api().dio.get(url);
    final MessageModel messageModel = MessageModel.fromJson(response.data);
    return messageModel;
  }
}
