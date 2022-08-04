import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:grocery/screens/welcome_screen.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';


class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child:ElevatedButton(
            onPressed: (){
              FirebaseAuth.instance.signOut();
              pushNewScreenWithRouteSettings(
                context,
                settings: RouteSettings(name: WelcomeScreen.id),
                screen: WelcomeScreen(),
                withNavBar: false,
                pageTransitionAnimation: PageTransitionAnimation.cupertino,
              );
            },
            child: Text('Sign out')
        ),
      ),
    );
  }
}
