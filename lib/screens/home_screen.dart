
import 'package:flutter/material.dart';
import 'package:grocery/widgets/near_by_store.dart';
import 'package:grocery/widgets/top_picked_store.dart';
import 'package:grocery/widgets/my_appbar.dart';
import '../widgets/image_slider.dart';

class HomeScreen extends StatefulWidget {
   static const String id = 'Home screen';

  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  //init state and constants before override
  Widget build(BuildContext context) {
    // final auth = Provider.of<AuthProvider>(context);
    return Scaffold(
      backgroundColor: Colors.grey[100],
        body: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled){
            return [
              MyAppBar()
            ];
          },
          body: ListView(
            padding: EdgeInsets.only(top: 0.0),
            children: [
              const SizedBox(height: 8,),
               const ImageSlider(),
              Container(
                color: Colors.white,
                  child: TopPickStore(),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 3),
                child: NearByStores(),
              ),
            ],
          ),
        ),
      resizeToAvoidBottomInset: false,
    );
  }
}
