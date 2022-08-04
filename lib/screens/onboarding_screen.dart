import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:grocery/utils/colors.dart';
import 'package:grocery/utils/constants.dart';
import 'package:lottie/lottie.dart';

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({Key? key}) : super(key: key);

  @override
  _OnBoardingScreenState createState() => _OnBoardingScreenState();
}

final _pagecontroller = PageController(initialPage: 0);
int _currentPage = 0;
//children of page view needs list of type widget
List<Widget> _pages = [
  Column(
    children: [
      Lottie.network(
          'https://assets5.lottiefiles.com/packages/lf20_0bcj2nvw.json',
          height: 300),
      const SizedBox(height: 30),
      const Text('Set Your Delivery Location',style: kPageViewTextStyle,textAlign: TextAlign.center,),
    ],
  ),
  SingleChildScrollView(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Lottie.network(
            'https://assets2.lottiefiles.com/packages/lf20_kwrdklsa/data.json',
            height: 300),
        const SizedBox(height: 30),
        const Text('Order Online from Your favourite stores',style: kPageViewTextStyle,textAlign: TextAlign.center,),
      ],
    ),
  ),
  Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Lottie.network(
          'https://assets9.lottiefiles.com/packages/lf20_gxhmijxe.json',
          height: 300),
      const SizedBox(height: 30),
      const Expanded(child: Text('Quick Delivery at Your Doorsteps',style: kPageViewTextStyle,textAlign: TextAlign.center)),
    ],
  ),
  Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Lottie.network(
          'https://assets9.lottiefiles.com/packages/lf20_txatrk7c.json',
          height: 300),
      const SizedBox(height: 30),
      const Expanded(child: Text('Our Delivery Partners are Fully Vaccinated',style: kPageViewTextStyle,textAlign:TextAlign.center ,)),

    ],
  ),
  Column(
    children: [
      Lottie.network(
          'https://assets9.lottiefiles.com/packages/lf20_8puroppj.json',
          height: 300),
      const SizedBox(height: 30),
      const Text('24/7 Delivery with best experience',style: kPageViewTextStyle,textAlign: TextAlign.center),
    ],
  ),
];

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(top:40.0,bottom: 5),
            child: PageView(
                controller: _pagecontroller,
                children: _pages,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });

                }),
          ),
        ),
        const SizedBox(height: 5),
        DotsIndicator(
          dotsCount: _pages.length,
          position: _currentPage.toDouble(),
          decorator: DotsDecorator(
            size: const Size.square(9.0),
            activeColor:ochre,
            activeSize: const Size(18.0, 9.0),
            activeShape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5.0)),
          ),
        ),
        const SizedBox(height:20),
      ],
    );
      //  Page view class is a scrollable list that works page by page requires a page controller
  }
}
