import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    naviageTo();
  }

  naviageTo() async {
    await Future.delayed(const Duration(seconds: 2));
    Navigator.pushReplacementNamed(context, 'LoginPage');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      body: Center(
        child: Image.asset(
          'assets/images/moviemania.png',
          height: 200,
          width: MediaQuery.of(context).size.width * 0.7,
        ),
      ),
    );
  }
}
