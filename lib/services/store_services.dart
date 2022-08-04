
import 'package:cloud_firestore/cloud_firestore.dart';

class StoreServices{
  getTopPickedStore(){
    return FirebaseFirestore.instance.collection('vendor').
    where('approved',isEqualTo: true).where('topPicked',isEqualTo: true).where('shopOpen',isEqualTo:true).orderBy('shopName').snapshots();
  }

  getNearByStore(){
    return FirebaseFirestore.instance.collection('vendor').
    where('approved',isEqualTo: true).orderBy('shopName').snapshots();
  }

  getNearByStorePagination(){
    return FirebaseFirestore.instance.collection('vendor').
    where('approved',isEqualTo: true).orderBy('shopName');
  }

}
//shows verified vendors and top picked

