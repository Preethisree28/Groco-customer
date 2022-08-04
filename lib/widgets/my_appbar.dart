import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:grocery/screens/map_screen.dart';
import 'package:grocery/utils/colors.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../providers/location_provider.dart';
import '../screens/welcome_screen.dart';

class MyAppBar extends StatefulWidget {
  const MyAppBar({Key? key}) : super(key: key);

  @override
  State<MyAppBar> createState() => _MyAppBarState();
}

class _MyAppBarState extends State<MyAppBar> {
  String _location = 'Address not set';
  String _address = '';

  @override
  void initState() {
    getPrefs();
    super.initState();
  }

  getPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? location = prefs.getString('location');
    String? address = prefs.getString('address');
    setState(() {
      _location = location!;
      _address = address!;
    });
  }

  @override
  Widget build(BuildContext context) {
    final locationData = Provider.of<LocationProvider>(context);
    return SliverAppBar(
      //app bar becomes scrollable
      automaticallyImplyLeading: false,
      backgroundColor: Theme.of(context).primaryColor,
      elevation: 100.5,
      shadowColor: Colors.black,

      title: TextButton(
        onPressed: () {
          locationData.getCurrentPosition();
          if (locationData.permissionAllowed == true) {
            pushNewScreenWithRouteSettings(
              context,
              settings: RouteSettings(name: MapScreen.id),
              screen: MapScreen(),
              withNavBar: false,
              pageTransitionAnimation: PageTransitionAnimation.cupertino,
            );
          } else {
            print("Permissions denied");
          }
        },
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(

              children: [
                Flexible(
                    child: Text(
                  _location == null ? 'Address not set' : _location,
                  style: const TextStyle(color: Colors.white, fontSize: 16,fontWeight: FontWeight.bold),
                  overflow: TextOverflow.ellipsis,
                ),
                ),
                const SizedBox(width: 10,),
                const Icon(
                    Icons.edit_outlined,
                    color: Colors.white,
                    size: 15
                ),
              ],
            ),
            Flexible(
                child: Text(
              _address == null? 'Press here to set Delivery Location' : _address,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                  color: Colors.white,fontSize: 12),
            )),
          ],
        ),
      ),
      bottom: const PreferredSize(
        child: Padding(
          padding: EdgeInsets.all(10.0),
          child: TextField(
            cursorColor: lightGreen,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(3)),
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: Colors.white,
              contentPadding: EdgeInsets.zero,
              hintText: 'Search',
              prefixIcon: Icon(
                Icons.search,
                color: Colors.grey,
              ),
            ),
          ),
        ),
        preferredSize: Size.fromHeight(56),
      ),
    );
  }
}
