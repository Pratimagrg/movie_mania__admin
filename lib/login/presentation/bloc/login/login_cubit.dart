import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_mania_admin/common/errorException.dart';
import 'package:movie_mania_admin/common/sharedPrefs.dart';
import 'package:movie_mania_admin/dio/repository.dart';
import 'package:movie_mania_admin/login/data/model/loginDetailModel.dart';
import 'package:movie_mania_admin/login/data/respository/loginRepository.dart';

import '../../../../common/flushBar.dart';
import '../../../../common/unAuthorizedException.dart';
import '../deviceRegistration/deviceregistration_cubit.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit({required this.loginRepository})
      : super(LoginState(
            usernameController: TextEditingController(),
            passwordController: TextEditingController())) {
    checkLogin();
  }
  final LoginRepository loginRepository;

  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  late LoginDetailModel loginDetail;

  getLoginDetails() {
    emit(state.copyWith(
        usernameController: usernameController,
        passwordController: passwordController,
        status: "initial",
        errorMessage: ""));
  }

  loginUser(context) async {
    try {
      emit(state.copyWith(
          usernameController: usernameController,
          passwordController: passwordController,
          status: "loading",
          errorMessage: ""));
      var userDetails = await Repository()
          .loginUser(usernameController.text, passwordController.text);
      loginDetail = userDetails;
      await SharedPrefs().setAccessToken(userDetails.access);
      //String? registrationToken = await SharedPrefs().getRegistrationToken();
      //registerDevice(registrationToken, context);
      emit(state.copyWith(
          usernameController: usernameController,
          passwordController: passwordController,
          status: "loaded",
          errorMessage: ""));
    } catch (e) {
      showCustomFlushBar(
          context,
          e.toString(),
          const Icon(
            Icons.error,
            color: Colors.red,
          ));
      emit(state.copyWith(
          usernameController: usernameController,
          passwordController: passwordController,
          status: "initial",
          errorMessage: ""));
    }
  }

  registerDevice(registrationToken, context) async {
    try {
      String? token = await SharedPrefs().getRegistrationToken();
      BlocProvider.of<DeviceregistrationCubit>(context).registerDevice(token);
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
  }

  checkLogin() async {
    var token = await SharedPrefs().getAccess();
    if (token != null) {
      emit(state.copyWith(
          usernameController: usernameController,
          passwordController: passwordController,
          status: "loaded",
          errorMessage: ""));
    } else {
      emit(state.copyWith(
          usernameController: usernameController,
          passwordController: passwordController,
          status: "initial",
          errorMessage: ""));
    }
  }
}
