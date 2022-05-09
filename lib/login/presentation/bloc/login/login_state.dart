part of 'login_cubit.dart';

class LoginState {
  final TextEditingController usernameController;
  final TextEditingController passwordController;
  final String status;
  final String errorMessage;
  const LoginState(
      {required this.usernameController,
      required this.passwordController,
      this.status = "initial",
      this.errorMessage = ""});

  List<Object> get props =>
      [usernameController, passwordController, status, errorMessage];

  LoginState copyWith(
      {TextEditingController? usernameController,
      TextEditingController? passwordController,
      String? status,
      String? errorMessage}) {
    return LoginState(
        usernameController: usernameController ?? this.usernameController,
        passwordController: passwordController ?? this.passwordController,
        status: status ?? this.status,
        errorMessage: errorMessage ?? this.errorMessage);
  }
}

// @immutable
// abstract class LoginState {}

// class LoginInitial extends LoginState {}

// class LoginLoading extends LoginState {}

// class LoginError extends LoginState {
//   final String error;

//   LoginError({required this.error});

//   List<Object> get props => [error];
// }

// class LoginDetailState extends LoginState {
//   final TextEditingController usernameController;
//   final TextEditingController passwordController;

//   LoginDetailState(
//       {required this.usernameController, required this.passwordController});
// }

// class LoginDetailLoaded extends LoginState {
//   final LoginDetailModel loginDetails;
//   LoginDetailLoaded({required this.loginDetails});

//   List<Object> get props => [loginDetails];
// }
