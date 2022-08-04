import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:grocery/screens/home_screen.dart';
import 'package:grocery/screens/landing_screen.dart';
import 'package:grocery/screens/main_screen.dart';
import 'package:grocery/screens/welcome_screen.dart';
import 'package:grocery/services/user_services.dart';
import 'package:grocery/utils/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);
  static const String id = 'Splash screen';
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
    User? user = FirebaseAuth.instance.currentUser;
  double customOpacity = 0;
  @override
  void initState() {
    Timer(const  Duration(seconds:5),
        //callback function
        () {
     FirebaseAuth.instance.authStateChanges().listen((User? user) {
       if(user == null){
         Navigator.pushReplacementNamed(
           context,
          WelcomeScreen.id,
         );
       }else{
       //of user has data in firestore check delivery address set or not
         getUserData();
       }
     });
    });
    super.initState();
  }

  getUserData()async{
    UserServices _userServices = UserServices();

    _userServices.getUserById(user!.uid).then((result){
    //check location details is there or not
      if(result['address']!=null){
      //  if address details exists
        updatePrefs(result);
      }
      //if address details does not exists
      Navigator.pushReplacementNamed(context, LandingScreen.id);
    });
  }
    Future<void>updatePrefs(result)async{
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setDouble('latitude', result['latitude']);
      prefs.setDouble('longitude',result['longitude']);
      prefs.setString('address',result['address']);
      prefs.setString('location',result['location'] );
    //  after update prefs navigate to home screen
      Navigator.pushReplacementNamed(context, MainScreen.id);
    }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: green,
      body: Center(
        child: Hero(
          tag: 'logo',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TweenAnimationBuilder(
                onEnd: (){
                  setState(() {
                    customOpacity = 1;
                  });
                },
                curve:Curves.bounceOut,
                duration: const Duration(seconds: 2),
                tween: Tween<double>(begin: 50, end: 100),
                builder: (BuildContext context, double value, Widget? child) {
                  return Image.asset('assets/images/logo.png',
                  height: value,
                    width: value,
                  );
                },
              ),
              const SizedBox(
                height: 5,
              ),
              AnimatedOpacity(
                duration: const Duration(seconds: 1),
                opacity: customOpacity,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Text(
                      'GRO',
                      style: TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 30,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      'CO',
                      style: TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 30,
                        color: Colors.yellow,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
