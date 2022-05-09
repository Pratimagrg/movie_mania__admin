import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:movie_mania_admin/common/sharedPrefs.dart';
import 'package:movie_mania_admin/dio/dioApi.dart';
import 'package:movie_mania_admin/dio/repository.dart';
import 'package:movie_mania_admin/message/data/model/roomListModel.dart';
import 'package:movie_mania_admin/message/data/repository/roomListRepository.dart';

import '../../../../common/flushBar.dart';
part 'roomlist_state.dart';

class RoomlistCubit extends Cubit<RoomlistState> {
  RoomlistCubit({required this.roomListRepository}) : super(RoomlistInitial());

  final RoomListRepository roomListRepository;

  List newMesageRoomNo = [];
  List<RoomListModel> rooms = [];

  getRoomsList(context) async {
    try {
      String? accessToken = await SharedPrefs().getAccess();
      List<RoomListModel> roomList =
          // await roomListRepository.getRoomList(accessToken);
          await Repository().getRoomssList();
      rooms = roomList;
      emit(
          RoomListLoaded(roomList: roomList, newMesageRoomNo: newMesageRoomNo));
    } on UnauthorizedException catch (e) {
      showCustomFlushBar(
          context,
          e.toString(),
          const Icon(
            Icons.error,
            color: Colors.red,
          ));
      Navigator.pushReplacementNamed(context, 'LoginPage');
    } catch (e) {
      showCustomFlushBar(
          context,
          e.toString(),
          const Icon(
            Icons.error,
            color: Colors.red,
          ));
      emit(RoomlistError());
    }
  }

  checkMessage(int roomNo, List newMesageRoomNo) {
    if (newMesageRoomNo.isNotEmpty) {
      for (var message in newMesageRoomNo) {
        if (roomNo == message) {
          return true;
        } else {
          return false;
        }
      }
    } else {
      return false;
    }
  }

  checkTotalMessage(int roomNo, List newMesageRoomNo) {
    if (newMesageRoomNo.isNotEmpty) {
      int total = 0;
      for (var message in newMesageRoomNo) {
        if (roomNo == message) {
          total = total + 1;
        }
      }
      return total;
    } else {
      return false;
    }
  }

  // addNewItem(roomId, context) async {
  //   try{

  //   newMesageRoomNo.add(roomId);
  //   String? accessToken = await SharedPrefs().getAccess();
  //   List<RoomListModel> roomList =
  //       await roomListRepository.getRoomList(accessToken);
  //   rooms = roomList;

  //   emit(RoomListLoaded(roomList: roomList, newMesageRoomNo: newMesageRoomNo));
  //   }on UnAuthorizedException catch (e) {
  //     showCustomFlushBar(
  //         context,
  //         e.toString(),
  //         const Icon(
  //           Icons.error,
  //           color: Colors.red,
  //         ));
  //     Navigator.pushReplacementNamed(context, 'LoginPage');
  //   }
  // }

  removeNewMessage(roomId) async {
    newMesageRoomNo.remove(roomId);

    emit(RoomListLoaded(roomList: rooms, newMesageRoomNo: newMesageRoomNo));
  }
}
