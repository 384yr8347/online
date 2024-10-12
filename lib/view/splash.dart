import 'package:flutter/material.dart';
import 'dart:async';
import 'package:supermarket/view/home.dart';
import 'package:supermarket/view/bottomnav.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:supermarket/view/Login.dart';


class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => 
_SplashScreenState
();
}

class _SplashScreenState extends State<
SplashScreen
> {
  @override
  void initState() {
    super.initState();
    _startTimeout();
     _logoutAndNavigate();
  }

    _logoutAndNavigate() async {
    // تسجيل خروج المستخدم عند بدء التطبيق
    await FirebaseAuth.instance.signOut();

    // الانتقال إلى شاشة تسجيل الدخول
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => Login()), // توجيه المستخدم لشاشة تسجيل الدخول
    );
  }

  void _startTimeout() {
    Timer(Duration(seconds: 5), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => BottomNav()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              Icons.shopping_cart,
              size: 100.0,
              color: Color.fromARGB(255, 82, 147, 122),
            ),
            SizedBox(height: 20),
            Text(
              'Loading..',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 82, 147, 122),
              ),
            ),
            SizedBox(height: 20),
            CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}
