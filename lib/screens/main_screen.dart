import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:grocery/screens/favourite_screen.dart';
import 'package:grocery/screens/home_screen.dart';
import 'package:grocery/screens/my_orders_screen.dart';
import 'package:grocery/screens/profile_screen.dart';
import 'package:grocery/utils/colors.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({Key? key}) : super(key: key);
  static const String id = 'main-screen';

  @override
  Widget build(BuildContext context) {
    PersistentTabController _controller;

    _controller = PersistentTabController(initialIndex: 0);

    List<Widget> _buildScreens() {
      return [
        HomeScreen(),
        FavouriteScreen(),
        MyOrders(),
        ProfileScreen(),
      ];
    }

    List<PersistentBottomNavBarItem> _navBarsItems() {
      return [
        PersistentBottomNavBarItem(
          icon: Image.asset('assets/images/logo.png'),
          title: ("Home"),
          activeColorPrimary: CupertinoColors.white,
          inactiveColorPrimary: CupertinoColors.white,
        ),
        PersistentBottomNavBarItem(
          icon: Icon(CupertinoIcons.heart_fill),
          title: ("My Favourites"),
          activeColorPrimary: CupertinoColors.systemPink,
          inactiveColorPrimary: CupertinoColors.white,
        ),
        PersistentBottomNavBarItem(
          icon: Icon(CupertinoIcons.shopping_cart),
          title: ("My Orders"),
          activeColorPrimary: ochre,
          inactiveColorPrimary: CupertinoColors.white,
        ),
        PersistentBottomNavBarItem(
          icon: Icon(CupertinoIcons.profile_circled),
          title: ("My Account"),
          activeColorPrimary: blue,
          inactiveColorPrimary: CupertinoColors.white,
        ),
      ];
    }

    return Scaffold(
      body: PersistentTabView(
        context,
        navBarHeight: 56,
        controller: _controller,
        screens: _buildScreens(),
        items: _navBarsItems(),
        confineInSafeArea: true,
        backgroundColor: lightGreen, // Default is Colors.white.
        handleAndroidBackButtonPress: true, // Default is true.
        resizeToAvoidBottomInset:
            true, // This needs to be true if you want to move up the screen when keyboard appears. Default is true.
        stateManagement: true, // Default is true.
        hideNavigationBarWhenKeyboardShows:
            true, // Recommended to set 'resizeToAvoidBottomInset' as true while using this argument. Default is true.
        decoration: NavBarDecoration(
          borderRadius: BorderRadius.circular(0.0),
          colorBehindNavBar: Colors.white,
          border:Border.all(
            color: Colors.white30
          )
        ),
        popAllScreensOnTapOfSelectedTab: true,
        popActionScreens: PopActionScreensType.all,
        itemAnimationProperties: ItemAnimationProperties(
          // Navigation Bar's items animation properties.
          duration: Duration(milliseconds: 200),
          curve: Curves.ease,
        ),
        screenTransitionAnimation: ScreenTransitionAnimation(
          // Screen transition animation on change of selected tab.
          animateTabTransition: true,
          curve: Curves.ease,
          duration: Duration(milliseconds: 200),
        ),
        navBarStyle:
            NavBarStyle.neumorphic, // Choose the nav bar style with this property.
      ),
    );
  }
}
