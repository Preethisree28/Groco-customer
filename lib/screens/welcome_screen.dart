
import 'package:flutter/material.dart';
import 'package:grocery/providers/auth_provider.dart';
import 'package:grocery/providers/location_provider.dart';
import 'package:grocery/screens/map_screen.dart';
import 'package:grocery/screens/onboarding_screen.dart';
import 'package:grocery/utils/colors.dart';
import 'package:provider/provider.dart';

class WelcomeScreen extends StatefulWidget {


   const WelcomeScreen({Key? key}) : super(key: key);
   static const String id = 'Welcome screen';

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  Widget build(BuildContext context) {

    final auth = Provider.of<AuthProvider>(context);

    bool _validPhoneNumber = false;
    var _phoneNumberController = TextEditingController();


    void showBottomSheet(context){
      showModalBottomSheet(
        context: context,
        //stateful builder is returned to update the state of a modal sheet
        builder:(context)=> StatefulBuilder(
          builder: (context, StateSetter myState){
            return Container(
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
                    const SizedBox(height:15,),
                     Visibility(
                       visible: auth.error =='Invalid OTP'? true:false,
                       child: Container(
                        child: Column(
                          children: [
                            Text(auth.error,style: const TextStyle(color: Colors.red,fontSize: 12),),
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
                          myState((){
                            _validPhoneNumber = true;
                          });
                        } else{
                          myState((){
                            _validPhoneNumber = false;
                          });
                        }
                      },
                      cursorColor: ochre,
                      decoration: const InputDecoration(
                        suffixIcon: Icon(Icons.phone,color: ochre,),
                        hintText: '      Enter your phone number here',
                        hintStyle: TextStyle(color:Colors.grey),
                        prefixText: '+91',
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
                                myState(() {
                                  auth.loading=true;
                                });
                                String number = '+91${_phoneNumberController.text}';
                                 auth.verifyPhoneNumber(
                                     number: number,
                                     context: context,

                                 ).then((value) => _phoneNumberController.clear(),);
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
            );
          },
        ),
        isScrollControlled: true,
      ).whenComplete(() {
        setState(() {
          auth.loading = false;
          _phoneNumberController.clear();
        });
      });
    }


    final locationData = Provider.of<LocationProvider>(context,listen: false);
    //Welcome Screen
    return Scaffold(
      //this property helps the scaffold to remain fixed
      resizeToAvoidBottomInset: false,
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Expanded(
          child: Stack(
            children: [
              Positioned(
                child:TextButton(onPressed: (){}, child: const Text('SKIP',style: TextStyle(color: ochre),), ),
                right: 0.0,
                top: 10.0,
              ),
              Column(
                children: [
                  const SizedBox(height: 50,),
                  const Expanded(child: OnBoardingScreen()),
                  Text('Ready to order from your nearest shop?',style: TextStyle(color:Colors.grey.shade800),),
                  const SizedBox(height: 5,),
                  ElevatedButton(
                    style: TextButton.styleFrom(
                      backgroundColor: ochre,
                      shadowColor: ochre,
                    ),
                    onPressed: () async{
                      setState(() {
                        locationData.loading=true;
                      });
                      await locationData.getCurrentPosition();
                      if(locationData.permissionAllowed == true){
                          Navigator.pushReplacementNamed(context, MapScreen.id);
                          setState(() {
                            locationData.loading=false;
                          });

                      }else{
                        print('Permission denied');
                        setState(() {
                          locationData.loading=false;
                        });
                      }

                    },
                    child: locationData.loading? const CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ) : const Text(
                      'SET YOUR DELIVERY LOCATION',
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.w800),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      setState(() {
                        auth.screen = 'Login';
                      });
                      showBottomSheet(context);
                      setState(() {
                        auth.loading = false;
                      });
                    },
                    child: RichText(
                      text: TextSpan(
                        text: 'Already a customer ? ',
                        style: TextStyle(color: Colors.grey[800]),
                        children:const [
                          TextSpan(
                            text: 'Login',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, color:ochre),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

