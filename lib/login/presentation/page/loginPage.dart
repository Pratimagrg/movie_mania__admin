import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:movie_mania_admin/login/presentation/bloc/login/login_cubit.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController usernameController = TextEditingController();

  TextEditingController passwordController = TextEditingController();
  // late FirebaseMessaging messaging;

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    // messaging = FirebaseMessaging.instance;
    // messaging.getToken().then((value) {
    //   SharedPrefs().setRegistrationToken(value!);
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
          child: GestureDetector(
              onTap: () {
                FocusScope.of(context).unfocus();
              },
              child: BlocConsumer<LoginCubit, LoginState>(
                listener: (context, state) {
                  if (state.status == "loaded") {
                    // Navigator.pushReplacement(
                    //     context,
                    //     MaterialPageRoute(
                    //         builder: (context) => AdminMessagePage()));
                    Navigator.pushReplacementNamed(context, 'MessagePage');
                  } else if (state.status == "error") {
                    showFlushBar(state.errorMessage);
                  }
                },
                builder: (context, state) {
                  if (state.status == "loading") {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (state.status == "initial") {
                    return SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Form(
                            key: _formKey,
                            child: Column(
                              children: [
                                SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * 0.13,
                                ),
                                Center(
                                  child: Image.asset(
                                    'assets/images/moviemania.png',
                                    height: 100,
                                    width:
                                        MediaQuery.of(context).size.width * 0.4,
                                  ),
                                ),
                                const SizedBox(
                                  height: 30,
                                ),
                                customTextField(
                                    'Username',
                                    state.usernameController,
                                    FontAwesomeIcons.user, (value) {
                                  return null;
                                }),
                                const SizedBox(
                                  height: 20,
                                ),
                                customTextField(
                                    'Password',
                                    state.passwordController,
                                    FontAwesomeIcons.lock, (value) {
                                  return null;
                                }),
                                SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * 0.08,
                                ),
                                InkWell(
                                  onTap: () {
                                    if (_formKey.currentState!.validate()) {
                                      BlocProvider.of<LoginCubit>(context)
                                          .loginUser(context);
                                      //login(username.text, password.text);
                                    }
                                  },
                                  child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 30, vertical: 10),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(15),
                                        color: Colors.red.shade900,
                                      ),
                                      child: const Text(
                                        'Login',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 18,
                                        ),
                                      )),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  } else {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                },
              ))),
    );
  }

  showFlushBar(errorMessage) {
    return Flushbar(
      icon: const Icon(
        Icons.close,
        color: Colors.red,
      ),
      shouldIconPulse: false,
      message: errorMessage,
      duration: const Duration(seconds: 2),
      backgroundColor: Colors.black,
      flushbarPosition: FlushbarPosition.TOP,
      borderRadius: BorderRadius.circular(8),
    )..show(context);
  }

  SingleChildScrollView loginFields(BuildContext context, state) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Form(
            key: _formKey,
            child: Column(
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.13,
                ),
                Center(
                  child: Image.asset(
                    'assets/images/moviemania.png',
                    height: 100,
                    width: MediaQuery.of(context).size.width * 0.4,
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                customTextField(
                    'Username', state.usernameController, FontAwesomeIcons.user,
                    (value) {
                  return null;
                }),
                const SizedBox(
                  height: 20,
                ),
                customTextField(
                    'Password', state.passwordController, FontAwesomeIcons.lock,
                    (value) {
                  return null;
                }),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.08,
                ),
                InkWell(
                  onTap: () {
                    if (_formKey.currentState!.validate()) {
                      BlocProvider.of<LoginCubit>(context).loginUser(context);
                      //login(username.text, password.text);
                    }
                  },
                  child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 30, vertical: 10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: Colors.red.shade900,
                      ),
                      child: const Text(
                        'Login',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                        ),
                      )),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget customTextField(String title, TextEditingController controller,
      IconData icon, Function validator) {
    return Container(
        margin: const EdgeInsets.only(top: 15, right: 20, left: 20, bottom: 15),
        child: TextFormField(
            obscureText: title == 'Password' ? true : false,
            style: TextStyle(fontSize: 16, color: Colors.grey[700]),
            controller: controller,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return title + ' cannot be empty';
              } else {
                return validator(value);
              }
            },
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white,
              contentPadding: const EdgeInsets.all(18),
              hintText: 'Enter your ' + title,
              prefixIcon: Icon(
                icon,
                color: Colors.grey.shade700,
                size: 20,
              ),
              errorStyle: TextStyle(
                  color: Colors.red.shade800,
                  fontSize: 14,
                  fontWeight: FontWeight.w600),
              hintStyle: TextStyle(color: Colors.grey.shade700, fontSize: 16),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(
                15,
              )),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(width: 1.0, color: Colors.grey.shade700),
                borderRadius: BorderRadius.circular(15),
              ),
              focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(width: 2.0),
                  borderRadius: BorderRadius.circular(
                    15,
                  )),
            )));
  }
}



// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:movie_mania_admin/login/presentation/bloc/cubit/login_cubit.dart';

// class LoginPage extends StatefulWidget {
//   LoginPage({Key? key}) : super(key: key);

//   @override
//   State<LoginPage> createState() => _LoginPageState();
// }

// class _LoginPageState extends State<LoginPage> {
//   TextEditingController usernameController = TextEditingController();

//   TextEditingController passwordController = TextEditingController();

//   final _formKey = GlobalKey<FormState>();

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.black,
//       body: SafeArea(
//           child: GestureDetector(
//         onTap: () {
//           FocusScope.of(context).unfocus();
//         },
//         child: BlocBuilder<LoginCubit, LoginState>(
//           builder: (context, state) {
//             if (state is LoginInitial) {
//               return const Center(
//                 child: CircularProgressIndicator(),
//               );
//             } else if (state is LoginDetailState) {
//               return loginFields(context, state);
//             } else if (state is LoginLoading) {
//               return const Center(
//                 child: CircularProgressIndicator(),
//               );
//             } else {
//               return const Center(
//                 child: Text('Something went wrong'),
//               );
//             }
//           },
//         ),
//       )),
//     );
//   }

//   SingleChildScrollView loginFields(
//       BuildContext context, LoginDetailState state) {
//     return SingleChildScrollView(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         crossAxisAlignment: CrossAxisAlignment.center,
//         children: [
//           Form(
//             key: _formKey,
//             child: Column(
//               children: [
//                 SizedBox(
//                   height: MediaQuery.of(context).size.height * 0.13,
//                 ),
//                 Center(
//                   child: Image.asset(
//                     'assets/images/moviemania.png',
//                     height: 100,
//                     width: MediaQuery.of(context).size.width * 0.4,
//                   ),
//                 ),
//                 const SizedBox(
//                   height: 30,
//                 ),
//                 customTextField(
//                     'Username', state.usernameController, FontAwesomeIcons.user,
//                     (value) {
//                   return null;
//                 }),
//                 const SizedBox(
//                   height: 20,
//                 ),
//                 customTextField(
//                     'Password', state.passwordController, FontAwesomeIcons.lock,
//                     (value) {
//                   return null;
//                 }),
//                 SizedBox(
//                   height: MediaQuery.of(context).size.height * 0.08,
//                 ),
//                 InkWell(
//                   onTap: () {
//                     if (_formKey.currentState!.validate()) {
//                       BlocProvider.of<LoginCubit>(context).loginUser(context);
//                       //login(username.text, password.text);
//                     }
//                   },
//                   child: Container(
//                       padding: const EdgeInsets.symmetric(
//                           horizontal: 30, vertical: 10),
//                       decoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(15),
//                         color: Colors.red.shade900,
//                       ),
//                       child: const Text(
//                         'Login',
//                         style: TextStyle(
//                           color: Colors.white,
//                           fontSize: 18,
//                         ),
//                       )),
//                 )
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget customTextField(String title, TextEditingController controller,
//       IconData icon, Function validator) {
//     return Container(
//         margin: const EdgeInsets.only(top: 15, right: 20, left: 20, bottom: 15),
//         child: TextFormField(
//             obscureText: title == 'Password' ? true : false,
//             style: TextStyle(fontSize: 16, color: Colors.grey[700]),
//             controller: controller,
//             validator: (value) {
//               if (value == null || value.isEmpty) {
//                 return title + ' cannot be empty';
//               } else {
//                 return validator(value);
//               }
//             },
//             decoration: InputDecoration(
//               filled: true,
//               fillColor: Colors.white,
//               contentPadding: const EdgeInsets.all(18),
//               hintText: 'Enter your ' + title,
//               prefixIcon: Icon(
//                 icon,
//                 color: Colors.grey.shade700,
//                 size: 20,
//               ),
//               errorStyle: TextStyle(
//                   color: Colors.red.shade800,
//                   fontSize: 14,
//                   fontWeight: FontWeight.w600),
//               hintStyle: TextStyle(color: Colors.grey.shade700, fontSize: 16),
//               border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(
//                 15,
//               )),
//               enabledBorder: OutlineInputBorder(
//                 borderSide: BorderSide(width: 1.0, color: Colors.grey.shade700),
//                 borderRadius: BorderRadius.circular(15),
//               ),
//               focusedBorder: OutlineInputBorder(
//                   borderSide: const BorderSide(width: 2.0),
//                   borderRadius: BorderRadius.circular(
//                     15,
//                   )),
//             )));
//   }
// }
