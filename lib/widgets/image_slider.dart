
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';

class ImageSlider extends StatefulWidget {
  const ImageSlider({Key? key}) : super(key: key);

  @override
  _ImageSliderState createState() => _ImageSliderState();
}

class _ImageSliderState extends State<ImageSlider> {
  int _index = 0;
  List <String> _carouselImages = [];
  fetchCarouselImages()async{
    var _fireStoreInstance = FirebaseFirestore.instance;
    QuerySnapshot qn = await _fireStoreInstance.collection("slider").get();
    if(mounted){
      setState(() {
        for(int i = 0; i<qn.docs.length; i++){
          _carouselImages.add(
            qn.docs[i]["image"],
          );
          print(qn.docs[i]["image"]);
        }
      });
    }
   return qn.docs;
  }
@override
  void initState() {
    fetchCarouselImages();
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          CarouselSlider(items: _carouselImages.map((item) => Padding(
            padding: const EdgeInsets.only(left:5, right: 5),
            child: Container(
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                image: DecorationImage(image: NetworkImage(item),fit: BoxFit.fill,)
              ),
            ),
          )).toList(),
              options: CarouselOptions(
                viewportFraction:0.8,
                initialPage: 0,
                autoPlay: true,
                height: 150,
                onPageChanged: (int i,carouselPageChangedReason){
                  setState(() {
                    _index=i;
                  });
                }
              ),
          ),
          const SizedBox(height:10),
          DotsIndicator(
              dotsCount: _carouselImages.length == 0 ? 1 : _carouselImages.length,
             position: _index.toDouble(),
            decorator: DotsDecorator(
                size: const Size.square(5.0),
                activeSize: const Size(6.0, 7.0),
                activeColor: Theme.of(context).primaryColor,
                spacing: const EdgeInsets.all(2),
                color: Theme.of(context).primaryColor.withOpacity(0.5),
            ),
          ),

        ],
      ),
    );
  }
}

































































































