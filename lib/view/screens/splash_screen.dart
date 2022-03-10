import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:page_transition/page_transition.dart';
import 'home_screen.dart';

class SplashScreenF extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreenF> {
  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
      splashIconSize: MediaQuery.of(context).size.height,
      duration: 2000,
      splash: Container(

        decoration: BoxDecoration(
          color: Color(0xffffffff),
          // color: Colors.white,
        ),
        child: Center(
          child: Column(
           // crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(child: Image.asset("assets/images/luncherIcon.png"),),
              SizedBox(height: 50,),
              Text("Weather App",style: TextStyle(color: Colors.blue,fontSize: 32,fontWeight: FontWeight.bold),)
            ],
          ),
        ),
      ),
      nextScreen: HomeScreen(),
      splashTransition: SplashTransition.slideTransition,
      pageTransitionType: PageTransitionType.rightToLeft,
      backgroundColor: Color.fromRGBO(238, 240, 249, 1.0),
    );
  }
}
