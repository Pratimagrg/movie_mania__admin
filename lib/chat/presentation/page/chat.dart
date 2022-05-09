import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_mania_admin/chat/presentation/bloc/chatMessage/chatmessage_cubit.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class ChatMessage extends StatefulWidget {
  // const ChatMessage({Key? key, required this.id}) : super(key: key);

  // final String id;
  static const routeName = '/MessagePage';

  @override
  State<ChatMessage> createState() => _ChatMessageState();
}

class _ChatMessageState extends State<ChatMessage> {
  TextEditingController messageController = TextEditingController();
  ScrollController scrollController = ScrollController();
  RefreshController refreshController =
      RefreshController(initialRefresh: false);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      if (scrollController.hasClients) {
        final position = scrollController.position.maxScrollExtent;
        scrollController.jumpTo(position);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final Map id = ModalRoute.of(context)!.settings.arguments as Map;
    return BlocBuilder<ChatmessageCubit, ChatState>(
      builder: (context, state) {
        return Scaffold(
          backgroundColor: Colors.black,
          appBar: AppBar(
            backgroundColor: Colors.black,
            title: Text(id['id']),
            leading: Icon(Icons.circle,
                size: 15,
                color: state.connected ? Colors.greenAccent : Colors.redAccent),
            //if app is connected to node.js then it will be gree, else red.
            titleSpacing: 0,
          ),
          body: SafeArea(
            child: GestureDetector(
              onTap: () {
                FocusScope.of(context).unfocus();
                BlocProvider.of<ChatmessageCubit>(context)
                    .sendmsg(messageController.text, "typing_completed");
              },
              child: Stack(
                children: [
                  Column(
                    children: [
                      Expanded(
                        child: Container(
                            color: Colors.white,
                            child: state.messageList.isEmpty
                                ? const Text("No messages yet")
                                : SmartRefresher(
                                    controller: refreshController,
                                    enablePullUp: true,
                                    enablePullDown: false,
                                    onLoading: () async {
                                      bool result = await BlocProvider.of<
                                              ChatmessageCubit>(context)
                                          .onRefresh(context);
                                      if (result) {
                                        refreshController.loadComplete();
                                      } else {
                                        refreshController.loadNoData();
                                      }
                                    },
                                    child: ListView(
                                      reverse: true,
                                      children: [
                                        ListView.builder(
                                            controller: scrollController,
                                            padding: const EdgeInsets.only(
                                                bottom: 16, top: 16),
                                            shrinkWrap: true,
                                            // reverse: true,
                                            itemCount: state.messageList.length,
                                            itemBuilder: (context, index) {
                                              return state.messageList[index]
                                                          .senderType ==
                                                      "admin_user"
                                                  ? chatMessageTile(
                                                      state.messageList[index]
                                                          .text,
                                                      true,
                                                      context)
                                                  : chatMessageTile(
                                                      state.messageList[index]
                                                          .text,
                                                      false,
                                                      context);
                                            }),
                                      ],
                                    ),
                                  )),
                      ),
                      Container(
                          color: Colors.white,
                          padding: const EdgeInsets.all(8),
                          child: TextFormField(
                              onEditingComplete: () {
                                // BlocProvider.of<ChatmessageCubit>(context)
                                //     .sendmsg(messageController.text,
                                //         "typing_completed");
                              },
                              onTap: () {
                                BlocProvider.of<ChatmessageCubit>(context)
                                    .sendmsg(messageController.text, "typing");
                              },
                              style: TextStyle(
                                  fontSize: 16, color: Colors.grey[700]),
                              controller: messageController,
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.white,
                                contentPadding: const EdgeInsets.all(18),
                                hintText: 'Enter your message...',
                                suffixIcon: IconButton(
                                  onPressed: () {
                                    BlocProvider.of<ChatmessageCubit>(context)
                                        .sendmsg(messageController.text,
                                            "chat_message");
                                    Timer(
                                        const Duration(milliseconds: 500),
                                        () => scrollController.jumpTo(
                                            scrollController
                                                .position.maxScrollExtent));

                                    messageController.clear();
                                  },
                                  icon: const Icon(
                                    Icons.send,
                                    color: Colors.black,
                                    size: 25,
                                  ),
                                ),
                                hintStyle: TextStyle(
                                    color: Colors.grey.shade800, fontSize: 17),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(
                                  25,
                                )),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      width: 1.2, color: Colors.black),
                                  borderRadius: BorderRadius.circular(25),
                                ),
                                focusedBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(width: 2.0),
                                    borderRadius: BorderRadius.circular(
                                      25,
                                    )),
                              )))
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  scrollToButton() {
    if (scrollController.hasClients) {
      final position = scrollController.position.maxScrollExtent;
      scrollController.jumpTo(position);
    }
  }

  chatMessageTile(String message, bool sentByMe, context) {
    return Row(
      mainAxisAlignment:
          sentByMe ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 4),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: const Radius.circular(24),
                bottomLeft: sentByMe
                    ? const Radius.circular(24)
                    : const Radius.circular(0),
                topRight: const Radius.circular(24),
                bottomRight: sentByMe
                    ? const Radius.circular(0)
                    : const Radius.circular(24),
              ),
              color: sentByMe ? Colors.black : Colors.grey.shade300),
          padding: const EdgeInsets.all(16),
          child: Container(
            constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.55),
            child: Wrap(
              children: [
                Text(
                  message,
                  style:
                      TextStyle(color: sentByMe ? Colors.white : Colors.black),
                ),
              ],
            ),
          ),
        )
      ],
    );
  }
}
