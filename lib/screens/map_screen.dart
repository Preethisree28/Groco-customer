
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:grocery/providers/location_provider.dart';
import 'package:grocery/screens/home_screen.dart';
import 'package:grocery/screens/landing_screen.dart';
import 'package:grocery/screens/main_screen.dart';
import 'package:grocery/screens/screen_login.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

import '../providers/auth_provider.dart';
import '../utils/colors.dart';

class MapScreen extends StatefulWidget {

  static const String id = 'map-screen';

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  LatLng? currentLocation = const LatLng(37.421632,122.084664);
  GoogleMapController? _mapController;
  bool _locating = false;
  bool _loggedIn = false;
  User? user;


  @override
  void initState() {
    //  check if user is logged in or not while opening map screen
    getCurrentUser();
    super.initState();
  }

  void getCurrentUser(){
    setState(() {
      user = FirebaseAuth.instance.currentUser;
    });
    if(user!=null){
      setState(() {
        _loggedIn = true;

      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final locationData = Provider.of<LocationProvider>(context);
    final _auth = Provider.of<AuthProvider>(context);
    setState(() {
      currentLocation = LatLng(locationData.latitude!, locationData.longitude!);
    });

    void onCreated(GoogleMapController controller) {
      setState(() {
        _mapController = controller;
      });
    }

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            GoogleMap(
              initialCameraPosition:
                  CameraPosition(target: currentLocation!, zoom: 16.4746),
              zoomControlsEnabled: false,
              minMaxZoomPreference: const MinMaxZoomPreference(1.5, 20.8),
              myLocationButtonEnabled: true,
              myLocationEnabled: true,
              mapType: MapType.normal,
              mapToolbarEnabled: true,
              onMapCreated: onCreated,
              onCameraMove: (CameraPosition position) {
                setState(() {
                  _locating = true;
                });
                locationData.onCameraMove(position);
              },
              onCameraIdle: () {
                setState(() {
                  _locating = false;
                });
                locationData.getMoveCamera();
              },
            ),
            Center(
              child: Container(
                height: 50,
                margin: const EdgeInsets.only(bottom: 40),
                child: Lottie.asset('assets/images/usermarker.json',height:20),
              ),
            ),
             Center(
              child: SpinKitPulse(
                color: Colors.red.shade500,
                size: 100.0,
              ),
            ),
            Positioned(
              bottom: 0.0,
              child: Container(
                height: 200,
                width: MediaQuery.of(context).size.width,
                color: Colors.white,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _locating
                          ? LinearProgressIndicator(
                              backgroundColor: Colors.transparent,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                  Theme.of(context).primaryColor),
                            )
                          : Container(),
                      Padding(
                        padding: const EdgeInsets.only(left: 10,right: 20),
                        child: TextButton.icon(
                          onPressed: () {},
                          icon: const Icon(
                            Icons.location_searching,
                            color: ochre,
                          ),
                          label:
                            SingleChildScrollView(
                              child: Text(_locating
                                  ? 'Locating....' : locationData.selectedAddress == null ? 'Locating....':
                              locationData.selectedAddress.featureName,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(color: blue,fontWeight: FontWeight.bold,fontSize: 20),
                        ),
                            ),
            ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left:20,right: 20),
                        child: Text(_locating?'':locationData
                            .selectedAddress == null? '': locationData.selectedAddress.addressLine,style:const TextStyle(color:Colors.black54),),
                      ),
                      const SizedBox(height:20),
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: SizedBox(
                          width:MediaQuery.of(context).size.width-40,  //40 is padding from both sides 20 on each side
                          child: AbsorbPointer(
                            absorbing: _locating ? true:false,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom( primary: _locating? Colors.grey:blue),
                              onPressed: (){
                                //save address in shared preferences
                                locationData.savePrefs();
                                if(_loggedIn == false){
                                  Navigator.pushNamed(context,LoginScreen.id);
                                }else{
                                  setState(() {
                                    _auth.latitude = locationData.latitude;
                                    _auth.longitude = locationData.longitude;
                                    _auth.address = locationData.selectedAddress.addressLine;
                                    _auth.location = locationData.selectedAddress.featureName;

                                  });
                                  _auth.updateUser(
                                      id: user!.uid,
                                      number: user!.phoneNumber!,
                                  ).then((value){
                                    if(value ==true){
                                      Navigator.pushNamed(context,MainScreen.id);
                                    }
                                  });
                                }
                              },
                              child: const Text('CONFIRM LOCATION',style: TextStyle(color:Colors.white,fontWeight: FontWeight.w800,fontSize: 18),),),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
