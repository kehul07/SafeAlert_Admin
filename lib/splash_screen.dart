import 'dart:async';

import 'package:flutter/material.dart';
import 'package:safe_alert_admin/admin_login.dart';
import 'package:safe_alert_admin/home_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Utils.dart';
import 'notification_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {



  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Timer.periodic(Duration(seconds: 3), (_){
      checkLoginStatus();
    });
  }


  Future<void> checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    String? cityName = prefs.getString("city");

    if(!mounted) return;

    if (isLoggedIn) {
      Utils.navigateWithSlideTransitionWithPushReplacement(
        context: context,
        screen: HomeScreen(cityName: cityName!,),
        begin: const Offset(1, 0),
        end: Offset.zero,
      );
    }else{
      Utils.navigateWithSlideTransitionWithPushReplacement(
        context: context,
        screen:const AdminLogin(),
        begin: const Offset(1, 0),
        end: Offset.zero,
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Text("Admin Mode",style: TextStyle(color: Colors.yellow.shade700,fontSize: 30,fontWeight: FontWeight.bold),),
      ),
    );
  }
}
