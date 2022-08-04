import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:grocery/providers/auth_provider.dart';
import 'package:grocery/providers/location_provider.dart';
import 'package:grocery/providers/store_provider.dart';
import 'package:grocery/screens/home_screen.dart';
import 'package:grocery/screens/landing_screen.dart';
import 'package:grocery/screens/main_screen.dart';
import 'package:grocery/screens/map_screen.dart';
import 'package:grocery/screens/register_screen.dart';
import 'package:grocery/screens/screen_login.dart';
import 'package:grocery/screens/splash_screen.dart';
import 'package:grocery/screens/welcome_screen.dart';
import 'package:grocery/utils/colors.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  //managing state using changenotifiers
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => AuthProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => LocationProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => StoreProvider(),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: lightGreen,
        fontFamily: 'Lato'
      ),
      home: const SplashScreen(),
      routes: {
        SplashScreen.id:(context)=>const SplashScreen(),
        HomeScreen.id:(context)=>const HomeScreen(),
        WelcomeScreen.id:(context)=>const WelcomeScreen(),
        MapScreen.id:(context)=> MapScreen(),
        LoginScreen.id:(context) => const LoginScreen(),
        RegisterScreen.id:(context) => const RegisterScreen(),
        LandingScreen.id:(context) => const LandingScreen(),
        MainScreen.id:(context)=> const MainScreen(),

      },
      debugShowCheckedModeBanner: false,
    );
  }
}
