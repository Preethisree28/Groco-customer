import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/auth_provider.dart';
import '../providers/location_provider.dart';
import '../utils/colors.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);
  static const String id = 'login-screen';

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  bool _validPhoneNumber = false;
  final _phoneNumberController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    final locationData = Provider.of<LocationProvider>(context);
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Container(
            child: Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom *1.2,
                top:20.0,
                left:20.0,
                right:20.0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Visibility(
                    visible: auth.error =='Invalid OTP'? true:false,
                    child: Container(
                      child: Column(
                        children: [
                          Text(auth.error ,style: const TextStyle(color: Colors.red,fontSize: 12),),
                          const SizedBox(height:5,),
                        ],
                      ),
                    ),
                  ),
                  const Text('LOGIN',style: TextStyle(fontSize: 20,fontWeight:FontWeight.bold),),
                  const  Text('Enter your phone number to proceed',style: TextStyle(fontSize:15,color: Colors.grey),),
                  const SizedBox(height: 20,),
                  TextField(
                    controller: _phoneNumberController,
                    maxLength: 10,
                    onChanged:(value){
                      if(value.length==10){
                        setState((){
                          auth.loading = false;
                          _validPhoneNumber = true;
                        });
                      } else{
                        setState((){
                          auth.loading = false;
                          _validPhoneNumber = false;
                        });
                      }
                    },
                    cursorColor: ochre,
                    decoration: const InputDecoration(
                      suffixIcon: Icon(Icons.phone,color: ochre,),
                      hintText: '      Enter your phone number here',
                      hintStyle: TextStyle(color:Colors.grey),
                      prefixText: '+91 ',
                      labelText: '10 digit mobile number',
                      labelStyle: TextStyle(color: ochre),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: ochre,
                        ),
                      ),
                    ),
                    autofocus: true,
                    keyboardType: TextInputType.phone,
                  ),
                  const SizedBox(height:10),
                  Row(
                    children: [
                      Expanded(
                        child: AbsorbPointer(
                          //absorb pointer blocks the widget so here if its invalid input it blocks the button
                          absorbing: _validPhoneNumber ? false : true,
                          child: ElevatedButton(
                            style:TextButton.styleFrom(
                              backgroundColor: _validPhoneNumber? ochre : Colors.grey,
                              shadowColor: _validPhoneNumber? ochre : Colors.grey,
                            ),
                            onPressed:(){
                              setState(() {
                                auth.loading=true;
                                auth.screen = 'MapScreen';
                                auth.latitude = locationData.latitude;
                                auth.longitude= locationData.longitude;
                                auth.address = locationData.selectedAddress.addressLine;
                              });
                              String number = '+91${_phoneNumberController.text}';
                              auth.verifyPhoneNumber(
                                number: number,
                                context: context,
                                latitude: locationData.latitude,
                                longitude: locationData.longitude,
                                address: locationData.selectedAddress.addressLine,
                              ).then((value){
                                _phoneNumberController.clear();
                                setState(() {
                                  auth.loading = true;
                                });
                              });
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(top:10,bottom:10),
                              child: (auth.loading) ? const CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                              ) : Text(_validPhoneNumber ? 'CONTINUE':'ENTER PHONE NUMBER',style: const TextStyle(color:Colors.white,fontSize:18,fontWeight: FontWeight.bold),textAlign:TextAlign.center),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
