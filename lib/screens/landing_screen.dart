
import 'package:flutter/material.dart';
import 'package:grocery/providers/location_provider.dart';
import 'package:grocery/screens/map_screen.dart';
import 'package:grocery/utils/colors.dart';


class LandingScreen extends StatefulWidget {
  static const String id = 'landing-screen';
  const LandingScreen({Key? key}) : super(key: key);

  @override
  _LandingScreenState createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> {
  LocationProvider _locationProvider = LocationProvider();
  bool _loading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                'Delivery Address not set',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                'Please update your Delivery Location to find the nearest Stores for you',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey),
              ),
            ),
            Container(
              width: 600,
              child: Image.asset(
                'assets/images/city.png',
                fit: BoxFit.fill,
                color: Colors.black12,
              ),
            ),
            _loading? const CircularProgressIndicator(color: lightGreen,):TextButton(
              style: TextButton.styleFrom(
                backgroundColor: Theme.of(context).primaryColor,
              ),
              onPressed: () async {
                setState(() {
                  _loading = true;
                });
                await _locationProvider.getCurrentPosition();
                if (_locationProvider.permissionAllowed == true) {
                  Navigator.pushReplacementNamed(context, MapScreen.id);
                } else {
                  Future.delayed(Duration(seconds: 4), () {
                    if (_locationProvider.permissionAllowed == false) {
                      print('Permission not allowed');
                      setState(() {
                        _loading = false;
                      });
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content: Text(
                              'Please allow permission to find the nearest stores for you.')));
                    }
                  });
                }
              },
              child: const Text(
                'Update your Location',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
