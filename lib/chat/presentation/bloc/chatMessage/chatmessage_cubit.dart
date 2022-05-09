import 'dart:convert';
import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:movie_mania_admin/chat/data/model/messageListModel.dart';
import 'package:movie_mania_admin/chat/data/model/messageModel.dart';
import 'package:movie_mania_admin/chat/data/repository/chatRepository.dart';
import 'package:movie_mania_admin/chat/presentation/page/chat.dart';
import 'package:movie_mania_admin/common/api.dart';
import 'package:movie_mania_admin/common/flushBar.dart';
import 'package:movie_mania_admin/common/sharedPrefs.dart';
import 'package:movie_mania_admin/dio/repository.dart';
import 'package:web_socket_channel/io.dart';

import '../../../../common/unAuthorizedException.dart';
import '../../../../dio/dioApi.dart';

part 'chatmessage_state.dart';

class ChatmessageCubit extends Cubit<ChatState> {
  ChatmessageCubit({required this.chatRepository}) : super(ChatState());

  final ChatRepository chatRepository;

  late IOWebSocketChannel channel; //channel varaible for websocket
  bool connected = false; // boolean value to track connection status
  List<MessageListModel> messageList = [];
  List<MessageListModel> newMessageList = [];

  var connectUrl = "";
  var error = "";

  getChatRoom(roomId, name, sender, context) async {
    try {
      channelConnect(name);
      String? accessToken = await SharedPrefs().getAccess();
      MessageModel messages =
          await Repository().getMessageList(roomId, accessToken);
      newMessageList.clear();
      messageList.clear();
      for (var result in messages.results) {
        messageList.add(MessageListModel(
            senderType: result.senderType,
            text: result.text,
            created: result.created,
            messageType: "chat_message"));
      }
      List<MessageListModel> reversedList = List.from(messageList.reversed);
      emit(state.copyWith(
          messageList: reversedList,
          connected: connected,
          next: messages.next));
      state.setNext(messages.next);

      Navigator.of(context)
          .pushNamed(ChatMessage.routeName, arguments: {'id': sender});
    } on UnauthorizedException catch (e) {
      showCustomFlushBar(
          context,
          e.toString(),
          const Icon(
            Icons.error,
            color: Colors.red,
          ));
      Navigator.pushReplacementNamed(context, 'LoginPage');
    } on SocketException catch (e) {
      showCustomFlushBar(
          context,
          e.toString(),
          const Icon(
            Icons.error,
            color: Colors.red,
          ));
      error = e.toString();
      emit(state.copyWith(connected: connected, error: error));
    } catch (e) {
      print(e.toString());
      showCustomFlushBar(
          context,
          e.toString(),
          const Icon(
            Icons.error,
            color: Colors.red,
          ));
      error = e.toString();
      emit(state.copyWith(connected: connected, error: error));
    }
  }

  channelConnect(id) async {
    try {
      var token = await SharedPrefs().getAccess();
      connectUrl = socketBaseURL + "ws/chat/" + id + "?token=" + token!;
      channel = IOWebSocketChannel.connect(connectUrl); //channel IP : Port
      channel.stream.listen((message) {
        Map jsonMessage = json.decode(message);
        if (jsonMessage['sender_type'] == "normal_user") {
          if (jsonMessage['type'] == "chat_message") {
            connected = true;
            messageList.removeAt(0);
            messageList.insert(
                0,
                MessageListModel(
                    senderType: jsonMessage['sender_type'],
                    text: jsonMessage['message'],
                    created: DateTime.now(),
                    messageType: "chat_message"));
            List<MessageListModel> reversedList =
                List.from(messageList.reversed);
            emit(state.copyWith(
                messageList: reversedList, connected: connected));
          } else if (jsonMessage['type'] == "typing_completed") {
            connected = true;
            if (messageList.first.messageType == "typing") {
              messageList.removeAt(0);
            }
            List<MessageListModel> reversedList =
                List.from(messageList.reversed);
            emit(state.copyWith(
                messageList: reversedList,
                //messageController: messageController,
                connected: connected));
          } else {
            connected = true;
            // messageList.add(MessageListModel(
            //     senderType: jsonMessage['sender_type'],
            //     text: "typing...",
            //     created: DateTime.now(),
            //     messageType: "typing"));
            messageList.insert(
                0,
                MessageListModel(
                    senderType: jsonMessage['sender_type'],
                    text: "typing...",
                    created: DateTime.now(),
                    messageType: "typing"));
            // messageList.addAll(newMessageList);
            List<MessageListModel> reversedList =
                List.from(messageList.reversed);

            emit(state.copyWith(
                messageList: reversedList, connected: connected));
          }
        }
      });
    } catch (_) {
      // ignore: avoid_print
      print("error on connecting to websocket.");
    }
  }

  Future<void> sendmsg(String message, String type) async {
    Map<String, String> data = {"message": message, "type": type};

    if (type == "chat_message") {
      messageList.insert(
          0,
          MessageListModel(
              senderType: "admin_user",
              text: message,
              created: DateTime.now(),
              messageType: "chat_message"));
      List<MessageListModel> reversedList = List.from(messageList.reversed);

      emit(state.copyWith(messageList: reversedList, connected: connected));
    }

    channel.sink.add(json.encode(data)); //send message to reciever channel
  }

  onRefresh(context) async {
    if (state.next != null) {
      String? accessToken = await SharedPrefs().getAccess();
      try {
        MessageModel messages =
            await chatRepository.getNextMessageList(state.next, accessToken);

        for (var result in messages.results) {
          newMessageList.add(MessageListModel(
              senderType: result.senderType,
              text: result.text,
              created: result.created,
              messageType: "chat_message"));
        }

        messageList.addAll(newMessageList);
        newMessageList.clear();
        List<MessageListModel> reversedList = List.from(messageList.reversed);

        emit(state.copyWith(
            messageList: reversedList,
            connected: connected,
            next: messages.next));

        state.setNext(messages.next);

        return true;
      } on UnAuthorizedException catch (e) {
        showCustomFlushBar(
            context,
            e.toString(),
            const Icon(
              Icons.error,
              color: Colors.red,
            ));
        Navigator.pushReplacementNamed(context, 'LoginPage');
      }
    } else {
      return false;
    }
  }
}
