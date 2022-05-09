import 'package:dio/dio.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_mania_admin/chat/data/repository/chatRepository.dart';
import 'package:movie_mania_admin/chat/presentation/bloc/chatMessage/chatmessage_cubit.dart';
import 'package:movie_mania_admin/login/data/respository/registerDeviceRepository.dart';
import 'package:movie_mania_admin/login/presentation/bloc/deviceRegistration/deviceregistration_cubit.dart';
import 'package:movie_mania_admin/login/presentation/bloc/login/login_cubit.dart';
import 'package:movie_mania_admin/login/presentation/page/loginPage.dart';
import 'package:movie_mania_admin/message/data/repository/roomListRepository.dart';
import 'package:movie_mania_admin/message/presentation/bloc/roomList/roomlist_cubit.dart';
import 'package:movie_mania_admin/message/presentation/page/adminMessagePage.dart';
import 'package:movie_mania_admin/splash_screen/presentation/pages/splash.dart';

import 'chat/presentation/page/chat.dart';
import 'login/data/respository/loginRepository.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_messageHandler);

  runApp(const MyApp());
}

Future<void> _messageHandler(RemoteMessage message) async {
  print("background message recieved");
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.
  late Dio dio;

  @override
  void initState() {
    super.initState();
    // dio = Dio();

    // dio.interceptors.add(RetryOnConnectionChangeInterceptor(
    //     requestRetrier: DioConnectivityRequestRetrier(
    //         dio: dio, connectivity: Connectivity())));
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ChatmessageCubit>(
            create: (BuildContext context) =>
                ChatmessageCubit(chatRepository: ChatRepository())),
        BlocProvider<LoginCubit>(
            create: (BuildContext context) =>
                LoginCubit(loginRepository: LoginRepository())),
        BlocProvider<RoomlistCubit>(
            create: (BuildContext context) =>
                RoomlistCubit(roomListRepository: RoomListRepository())),
        BlocProvider<DeviceregistrationCubit>(
            create: (BuildContext context) => DeviceregistrationCubit(
                registerDeviceRepository: RegisterDeviceRepository())),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.red,
        ),
        initialRoute: 'SplashScreen',
        routes: {
          'MessagePage': (context) => const AdminMessagePage(),
          'SplashScreen': (context) => const SplashScreen(),
          'LoginPage': (context) => const LoginPage(),
          ChatMessage.routeName: (context) => ChatMessage(),
        },
      ),
    );
  }
}
