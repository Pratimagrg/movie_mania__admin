part of 'roomlist_cubit.dart';

@immutable
abstract class RoomlistState {}

class RoomlistInitial extends RoomlistState {}

class RoomlistError extends RoomlistState {}

class RoomListLoaded extends RoomlistState {
  final List<RoomListModel> roomList;
  final List newMesageRoomNo;

  RoomListLoaded({required this.roomList, required this.newMesageRoomNo});

  List<Object> get props => [roomList, newMesageRoomNo];
}
