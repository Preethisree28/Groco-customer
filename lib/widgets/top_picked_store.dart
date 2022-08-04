import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:grocery/providers/store_provider.dart';
import 'package:grocery/services/store_services.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

class TopPickStore extends StatefulWidget {
  const TopPickStore({Key? key}) : super(key: key);

  @override
  _TopPickStoreState createState() => _TopPickStoreState();
}

class _TopPickStoreState extends State<TopPickStore> {
  StoreServices _storeServices = StoreServices();


  //this is to find the user lan and long to calculate distance.


  @override
  Widget build(BuildContext context) {
    final _storeData = Provider.of<StoreProvider>(context);
    _storeData.getUserLocationData(context);

    String? getDistance(location){
      var distance = Geolocator.distanceBetween(_storeData.userLatitude, _storeData.userLongitude, location.latitude, location.longitude);
      var distanceInKm = distance/1000;
      return distanceInKm.toStringAsFixed(2);
    }
    return Container(
      child: StreamBuilder<QuerySnapshot>(
        stream: _storeServices.getTopPickedStore(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapShot){
          if(!snapShot.hasData) return const CircularProgressIndicator(color: Colors.lightGreen,);
          List shopDistance = [];
         for(int i=0; i<=snapShot.data!.docs.length-1; i++){
          var distance = Geolocator.distanceBetween(
              _storeData.userLatitude, _storeData.userLongitude,
            snapShot.data!.docs[i]['latitude'],
            snapShot.data!.docs[i]['longitude'],
          );
          var distanceInKm = distance/1000;
          shopDistance.add(distanceInKm);
         }
         shopDistance.sort();  //sorts the nearest distance shop within radius 10km
          if(shopDistance[0]>10){
            return Container();
          }
          return Container(
            height: 250,
            child: Padding(
              padding: const EdgeInsets.only(left: 8.0, right: 8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom:10, top:20),
                    child: Row(
                      children: [
                        SizedBox(
                            child: Lottie.asset('assets/images/like.json'),
                           height: 50,
                        ),
                        const Text('Top Picked Stores For You',
                        style:  TextStyle(
                          fontWeight:FontWeight.w900,
                          fontSize: 18,
                        ),
                        ),
                      ],
                    ),
                  ),
                  Flexible(
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: snapShot.data!.docs.map((DocumentSnapshot document){
                        var parseLocation = getDistance(document['location']);
                        if(double.parse(parseLocation!)<=10) {
                          //shows stores within 10km range
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                            width: 80,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  width: 80,
                                  height: 80,
                                  child: Card(
                                    shadowColor: Colors.black87,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(4),
                                      child: Image.network(
                                          document['logo'], fit: BoxFit.cover),
                                    ),
                                  ),
                                ),
                                Container(
                                  height: 35,
                                  child: Text(
                                    document['shopName'], style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                Text(
                                  '${getDistance(document['location'])}Km',
                                  style: const TextStyle(
                                    color: Colors.grey,
                                    fontSize: 10,
                                  ),
                                ),
                              ],
                            ),
                              ),
                          );
                        }else{
                          return Container();
                        }
                      }).toList(),
                    ),
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

