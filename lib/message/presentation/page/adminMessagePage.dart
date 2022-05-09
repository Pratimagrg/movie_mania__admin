import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:movie_mania_admin/chat/presentation/bloc/chatMessage/chatmessage_cubit.dart';
import 'package:movie_mania_admin/common/sharedPrefs.dart';
import 'package:movie_mania_admin/login/presentation/bloc/login/login_cubit.dart';
import 'package:movie_mania_admin/message/presentation/bloc/roomList/roomlist_cubit.dart';

import '../../../login/presentation/bloc/deviceRegistration/deviceregistration_cubit.dart';

// ignore: must_be_immutable
class AdminMessagePage extends StatefulWidget {
  const AdminMessagePage({Key? key}) : super(key: key);

  @override
  State<AdminMessagePage> createState() => _AdminMessagePageState();
}

class _AdminMessagePageState extends State<AdminMessagePage> {
  late FirebaseMessaging messaging;
  late Timer timer;

  @override
  void initState() {
    BlocProvider.of<RoomlistCubit>(context).getRoomsList(context);

    super.initState();
    timer = Timer.periodic(const Duration(seconds: 60), (Timer t) {
      BlocProvider.of<RoomlistCubit>(context).getRoomsList(context);
    });
    messaging = FirebaseMessaging.instance;
    messaging.getToken().then((value) {});

    FirebaseMessaging.onMessageOpenedApp.listen((event) async {
      if (event.data['type'] == "chat") {
        Navigator.pushNamed(context, 'MessagePage');
      }
    });

    FirebaseMessaging.onMessage.listen((RemoteMessage event) {
      if (event.data['type'] == "notification") {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20.0))),
                title: Text(event.data['title']),
                content: Text(event.data['from_user']),
                actions: [
                  TextButton(
                    child: const Text("Ok"),
                    onPressed: () async {
                      Navigator.pop(context);
                    },
                  )
                ],
              );
            });
      }
      // else {
      //   if (ModalRoute.of(context)!.settings.name == 'MessagePage') {
      //     print(ModalRoute.of(context)!.settings.name);
      //     showDialog(
      //         context: context,
      //         builder: (BuildContext context) {
      //           return AlertDialog(
      //             shape: const RoundedRectangleBorder(
      //                 borderRadius: BorderRadius.all(Radius.circular(20.0))),
      //             title: const Text("Inbox"),
      //             content: Text("Message from " + event.data['from_user']),
      //             actions: [
      //               TextButton(
      //                 child: const Text("Ok"),
      //                 onPressed: () async {
      //                   await BlocProvider.of<ChatmessageCubit>(context)
      //                       .getChatRoom(
      //                           event.data['room_id'],
      //                           event.data['room_name'],
      //                           event.data['from_user'],
      //                           context);
      //                   Navigator.pop(context);
      //                 },
      //               )
      //             ],
      //           );
      //         });
      //   } else {
      //     print(123);
      //   }
      // }
    });
  }

  registerDevice(registrationToken) async {
    String? token = await SharedPrefs().getRegistrationToken();
    BlocProvider.of<DeviceregistrationCubit>(context).registerDevice(token);
  }

  int total = 0;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RoomlistCubit, RoomlistState>(
      builder: (context, state) {
        if (state is RoomlistInitial) {
          return const Scaffold(
            backgroundColor: Colors.black,
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        } else if (state is RoomlistError) {
          return const Scaffold(
            body: Center(
              child: Text('Something went wrong'),
            ),
          );
        } else if (state is RoomListLoaded) {
          return Scaffold(
              appBar: AppBar(
                backgroundColor: Colors.black,
                automaticallyImplyLeading: false,
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Messages'),
                    InkWell(
                      onTap: () async {
                        await SharedPrefs().clearAll();
                        BlocProvider.of<LoginCubit>(context).checkLogin();
                        Navigator.pushNamed(context, 'LoginPage');
                      },
                      child: const FaIcon(
                        // ignore: deprecated_member_use
                        FontAwesomeIcons.signOut,
                        color: Colors.white,
                      ),
                    )
                  ],
                ),
              ),
              body: Padding(
                padding: const EdgeInsets.only(top: 10),
                child: SafeArea(
                    child: state.roomList.isEmpty
                        ? const Center(
                            child: Text(
                              'No meesages yet',
                              style: TextStyle(fontSize: 20),
                            ),
                          )
                        : ListView.separated(
                            separatorBuilder: (context, index) {
                              return Divider(
                                height:
                                    MediaQuery.of(context).size.height * 0.03,
                                thickness: 1.0,
                              );
                            },
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              return ListTile(
                                leading: CircleAvatar(
                                  backgroundColor: Colors.grey.shade300,
                                  child: FaIcon(FontAwesomeIcons.user,
                                      color: Colors.grey.shade600),
                                ),
                                trailing:
                                    state.roomList[index].unread_messages == 0
                                        ? null
                                        : CircleAvatar(
                                            maxRadius: 12,
                                            backgroundColor:
                                                Colors.red.shade500,
                                            child: Text(state
                                                .roomList[index].unread_messages
                                                .toString())),
                                title: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      state.roomList[index].normal_user,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15),
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                  ],
                                ),
                                onTap: () {
                                  BlocProvider.of<ChatmessageCubit>(context)
                                      .getChatRoom(
                                          state.roomList[index].id,
                                          state.roomList[index].name,
                                          state.roomList[index].normal_user,
                                          context);
                                },
                              );
                            },
                            itemCount: state.roomList.length,
                          )),
              ));
        } else {
          return const Scaffold(
            body: Center(
              child: Text('Something went wrong'),
            ),
          );
        }
      },
    );
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }
}
