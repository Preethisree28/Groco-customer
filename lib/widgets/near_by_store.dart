import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:grocery/providers/store_provider.dart';
import 'package:grocery/services/store_services.dart';
import 'package:grocery/utils/colors.dart';
import 'package:grocery/utils/constants.dart';
import 'package:paginate_firestore/bloc/pagination_listeners.dart';
import 'package:paginate_firestore/paginate_firestore.dart';
import 'package:provider/provider.dart';

class NearByStores extends StatefulWidget {
  @override
  _NearByStoresState createState() => _NearByStoresState();
}

class _NearByStoresState extends State<NearByStores> {
  StoreServices _storeServices = StoreServices();
  PaginateRefreshedChangeListener refreshedChangeListener =
      PaginateRefreshedChangeListener();

  @override
  Widget build(BuildContext context) {
    final _storeData = Provider.of<StoreProvider>(context);
    _storeData.getUserLocationData(context);

    String? getDistance(location) {
      var distance = Geolocator.distanceBetween(_storeData.userLatitude,
          _storeData.userLongitude, location.latitude, location.longitude);
      var distanceInKm = distance / 1000;
      return distanceInKm.toStringAsFixed(2);
    }

    return Container(
      color: Colors.white,
      child: StreamBuilder<QuerySnapshot>(
        stream: _storeServices.getNearByStore(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapShot) {
          if (!snapShot.hasData)
            return const CircularProgressIndicator(
              color: Colors.lightGreen,
            );
          List shopDistance = [];
          for (int i = 0; i <= snapShot.data!.docs.length - 1; i++) {
            var distance = Geolocator.distanceBetween(
              _storeData.userLatitude,
              _storeData.userLongitude,
              snapShot.data!.docs[i]['latitude'],
              snapShot.data!.docs[i]['longitude'],
            );
            var distanceInKm = distance / 1000;
            shopDistance.add(distanceInKm);
          }
          shopDistance
              .sort(); //sorts the nearest distance shop within radius 10km
          if (shopDistance[0] > 10) {
            return Container(
              child: Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                        bottom: 50, top: 30, left: 20, right: 20),
                    child: Container(
                      child: const Center(
                        child: Text(
                          'Currently we are not servicing in your area, Please try again later or try another location.',
                          textAlign: TextAlign.left,
                          style: TextStyle(color: Colors.black54, fontSize: 18),
                        ),
                      ),
                    ),
                  ),
                  Image.asset(
                    'assets/images/city.png',
                    color: Colors.black12,
                  ),
                  Positioned(
                    right: 10.0,
                    top: 80,
                    child: Container(
                        width: 100,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Made by: ',
                              style: TextStyle(color: Colors.black54),
                            ),
                            Text(
                              'PREETHI',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Anton',
                                letterSpacing: 2,
                                color: Colors.grey.shade600,
                              ),
                            )
                          ],
                        )),
                  )
                ],
              ),
            );
          }

          return Padding(
            padding: EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RefreshIndicator(
                  child: PaginateFirestore(
                    bottomLoader: SizedBox(
                      height: 30,
                      width: 30,
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(
                            Theme.of(context).primaryColor),
                      ),
                    ),
                    header: SliverToBoxAdapter(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Padding(
                            padding:
                                EdgeInsets.only(left: 8, right: 8, top: 20),
                            child: Text(
                              "All Nearby Stores",
                              style: TextStyle(
                                  fontWeight: FontWeight.w900, fontSize: 18),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 8, right: 8, bottom: 10),
                            child: Text(
                              "Find quality products just near you",
                              style: TextStyle(
                                  color: Colors.grey.shade700, fontSize: 12),
                            ),
                          ),
                        ],
                      ),
                    ),
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemBuilderType: PaginateBuilderType.listView,
                    itemBuilder: (context, document, index) {
                      final data = document[index].data() as Map?;
                      return Padding(
                        padding: const EdgeInsets.all(4),
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: 100,
                                height: 110,
                                child: Card(
                                  shadowColor: Colors.black87,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(4),
                                    child: Image.network(data!['logo'],
                                        fit: BoxFit.cover),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    child: Text(
                                      data!['shopName'],
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  const SizedBox(height: 3),
                                  Text(
                                    data!['description'],
                                    style: kStoreCardStyle
                                  ),
                                  const SizedBox(height: 3),
                                  Container(
                                    width:
                                        MediaQuery.of(context).size.width - 250,
                                    child: Text(
                                      data!['address'],
                                      overflow: TextOverflow.ellipsis,
                                      style: kStoreCardStyle
                                    ),
                                  ),
                                  const SizedBox(height: 3),
                                  Text(
                                    '${getDistance(data!['location'])}Km',
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                        fontSize: 12,
                                        color: lightGreen
                                    ),
                                  ),
                                  const SizedBox(height: 3),
                                  Row(
                                    //this is to show rating
                                    children: const [
                                      Icon(
                                        Icons.star,
                                        size: 12,
                                        color: ochre,
                                      ),
                                       SizedBox(width: 4),
                                       Text(
                                        '3.9',
                                        style: kStoreCardStyle,
                                      )
                                    ],
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      );
                    },
                    query: _storeServices.getNearByStorePagination(),
                    listeners: [refreshedChangeListener],
                    footer: SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 30),
                        child: Container(
                          child: Stack(
                            children: [
                              Center(
                                child: Text(
                                  '**Thats all folks!**',
                                  style: TextStyle(color: Colors.grey.shade600),
                                ),
                              ),
                              Image.asset(
                                'assets/images/city.png',
                                color: Colors.black12,
                              ),
                              Positioned(
                                right: 10.0,
                                top: 80,
                                child: Container(
                                    width: 100,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          'Made by: ',
                                          style:
                                              TextStyle(color: Colors.black54),
                                        ),
                                        Text(
                                          'PREETHI',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontFamily: 'Anton',
                                            letterSpacing: 2,
                                            color: Colors.grey.shade600,
                                          ),
                                        )
                                      ],
                                    )),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  onRefresh: () async {
                    refreshedChangeListener.refreshed = true;
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
