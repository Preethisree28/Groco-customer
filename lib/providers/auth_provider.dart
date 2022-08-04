
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:grocery/providers/location_provider.dart';
import 'package:grocery/screens/home_screen.dart';
import 'package:grocery/screens/landing_screen.dart';
import 'package:grocery/screens/main_screen.dart';
import 'package:grocery/services/user_services.dart';
import '../utils/colors.dart';

class AuthProvider with ChangeNotifier {

  String? smsOtp;
  String? verificationId;
 final FirebaseAuth _auth = FirebaseAuth.instance;
  String error = '';
  final UserServices _userServices = UserServices();
  bool loading = false;
  LocationProvider locationData = LocationProvider();
  String? screen;
  double? latitude;
 double? longitude;
  String? address;
  String? location;



  Future<void> verifyPhoneNumber( {required BuildContext context, required String number,double? latitude, double? longitude,String? address}) async {
    loading = true;
    notifyListeners();
    final PhoneVerificationCompleted verificationCompleted =
        (PhoneAuthCredential credential) async {
     loading = false;
      notifyListeners();
      await _auth.signInWithCredential(credential);
    };

    final PhoneVerificationFailed verificationFailed =
        (FirebaseAuthException e) async {
      print(e.code);
      error = e.toString();
      this.loading = false;
      notifyListeners();
    };

  final PhoneCodeSent smsOtpSend = (String verId, int? resendToken){
    this.verificationId = verId;
  //  dialog to enter sms OTP
    smsOtpDialog(context, number);
    this.loading = true;
    notifyListeners();

  };

         try {
      _auth.verifyPhoneNumber(
          phoneNumber: number,
          verificationCompleted: verificationCompleted,
          verificationFailed: verificationFailed,
          codeSent: smsOtpSend,
          codeAutoRetrievalTimeout: (String verId) {
            verificationId = verId;
          });
    } catch (e) {
      error = e.toString();
      notifyListeners();
      print(e);
    }
  }

  Future smsOtpDialog(BuildContext context, String number) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Column(
              children: [
                const Text('Verification Code'),
                const SizedBox(
                  height: 6,
                ),
                Text(
                  'Enter 6 digit OTP received as SMS',
                  style: TextStyle(
                    color: Colors.grey.shade500,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
            content: Container(
              height: 85,
              child: TextField(
                cursorColor: ochre,
                decoration: const InputDecoration(
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: ochre,
                    ),
                  ),

                ),
                textAlign: TextAlign.center,
                keyboardType: TextInputType.number,
                maxLength: 6,
                onChanged: (value) {
                  smsOtp = value;
                },
              ),
            ),
            actions: [
              TextButton(
                onPressed: () async {
                  try {
                    PhoneAuthCredential phoneAuthcredential =
                    PhoneAuthProvider.credential(
                      verificationId: verificationId ?? '',
                      smsCode: smsOtp ?? '',
                    );

                    final UserCredential userCredential = await (_auth
                        .signInWithCredential(phoneAuthcredential));
                    final User? user = (await _auth.signInWithCredential(phoneAuthcredential)).user;
                    if(user!=null){
                        loading = false;
                        notifyListeners();

                      _userServices.getUserById(user.uid).then((snapshot){
                        if(snapshot.exists){

                        //  user data already exists
                          if(screen == 'Login'){
                            //  need to check id user data already exits in db or not
                            //  if exist data will update or create a new user data
                            if(snapshot['address']!=null){
                              Navigator.pushReplacementNamed(context, MainScreen.id);
                            }
                            Navigator.pushReplacementNamed(context,LandingScreen.id);
                          }else{
                            //need to update new selected address
                            updateUser(id: user.uid, number: user.phoneNumber!);
                            Navigator.pushReplacementNamed(context,MainScreen.id);
                          }

                        }else{

                        //  user data does not exists
                        //  creates new data in db

                         _createUser(id:user.uid,number: user.phoneNumber!);
                         Navigator.pushReplacementNamed(context,LandingScreen.id);
                        }
                      });
                    }else{
                      print('Login Failed');
                    }

                  } catch (e) {
                    error = 'Invalid OTP';
                    loading = false;
                    notifyListeners();
                    print(e.toString());
                    Navigator.of(context).pop();
                  }
                },
                child: const Text('DONE', style: TextStyle(color: ochre),),),
            ],
          );
        }).whenComplete((){
          loading = false;
          notifyListeners();
    });
  }

  void _createUser(
      {required String id, required String number}) {
     // location = GeoPoint(latitude!, longitude!);
    _userServices.createUserData({
      'id': id,
      'number': number,
      'latitude':latitude,
      'longitude':longitude,
      'address': address,
      'location':location,
    });
    loading =false;
    notifyListeners();
  }
  Future <bool> updateUser(
        {required String id, required String number}) async{
     // location = GeoPoint(latitude!, longitude!);
      try{
        _userServices.updateUserData({
          'id': id,
          'number': number,
          'latitude':latitude,
          'longitude':longitude,
          'address': address,
          'location':location,
        });

        loading =false;
        notifyListeners();
        return true;
      }catch(e){
        print('Error $e');
        return false;
      }
    }
}
