import 'dart:io';

import 'package:demo_app/index.dart';
import 'package:demo_app/models/user.dart';
import 'package:demo_app/services/database.dart';
import 'package:demo_app/validation/validation_methods.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'otp_screen.dart';


class UserDetail extends StatefulWidget  {

  // final String  mobileNumber;
  //
  // const UserDetail({Key key, this.mobileNumber}) : super(key: key);
  @override
  _UserDetail createState() => _UserDetail();
}

class _UserDetail extends State<UserDetail>{
  final FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseUser firebaseuser;
  String mobileNumber="";
  User user= new User();
 // _UserDetail(this.mobileNumber);

  @override
  void initState(){
    super.initState();
  //  print(widget.mobileNumber);
    initUser();
    //getCurrentUser();
  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }


  initUser() async{
    firebaseuser = await _auth.currentUser();
    if (firebaseuser != null) {
    } else {
      print("user.uid");
      // User is not available. Do something else
    }
    setState(() {});
  }
 /* Future<bool> _onBackPressed() {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Please Complete the profile before going back'),
            content: Text('Are you sure to Go back?'),
            actions: <Widget>[
              FlatButton(
                child: Text('NO'),
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
              ),
              FlatButton(
                child: Text('YES'),
                onPressed: () {
                  Navigator. pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => OTPScreen(mobileNumber: widget.mobileNumber,),
                    ),
                  );
                },
              ),
            ],
          );
        });
  }*/


  final scaffoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController _firstName = TextEditingController();



  GlobalKey<FormState> _key = new GlobalKey();
  bool _validate = false;

  Widget _buildLogo() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 50),
          child: Text(
            'Demo Flutter App',
            style: TextStyle(
              fontSize: MediaQuery.of(context).size.height / 25,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        )
      ],
    );
  }

  Widget _buildSignUpForm() {
    return Form(
      key: _key,
      autovalidate: _validate,
      child: Padding(
        padding: EdgeInsets.all(8),
        child: Column(
          children: <Widget>[
            Container(
              child: TextFormField(
                controller: _firstName,
                keyboardType: TextInputType.text,
                validator: validateName,
                maxLength: 14,
                onSaved: (String val){
                },

                decoration: InputDecoration(
                    prefixIcon: Icon(
                      Icons.account_circle,
                      color: Colors.grey[800],
                    ),
                    labelText: 'Enter Full Name'),
              ),

            )

          ],
        ),
      ),
    );
  }


  _sendToServer(){
    if (_key.currentState.validate()) {
      // No any error in validation
      _key.currentState.save();


    } else {
      // validation error
      setState(() {
        _validate = true;
      });
    }
  }

  Widget _buildSignUpButton() {
    return Builder(
      builder: (BuildContext context) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              height: 1.4 * (MediaQuery
                  .of(context)
                  .size
                  .height / 25),
              width: 5 * (MediaQuery
                  .of(context)
                  .size
                  .width / 10),
              margin: EdgeInsets.only(top: 40),
              child: RaisedButton(
                //elevation: 5.0,
                color: Color(0xff2196F3),

                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),

                onPressed: () async{
                  _sendToServer();
                  user.displayName = _firstName.text;
                  user.uid = firebaseuser.uid;
                 // user.phoneNumber = widget.mobileNumber;
                  String retString =  await  DataBase().updateUser(user);
                  if(retString =='Success'){
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                          builder: (context) => MainScreen()),
                          (route) => false,
                    );
                  } else{
                    print("Not success");
                  }
                },
                child: Text(
                  "Continue",
                  style: TextStyle(
                    color: Colors.white,
                    letterSpacing: 1.5,
                    fontSize: MediaQuery
                        .of(context)
                        .size
                        .height / 40,
                  ),
                ),
              ),
            )
          ],
        );
      },
    );
  }


  Widget _buildContainer() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        ClipRRect(
          borderRadius: BorderRadius.all(
            Radius.circular(20),
          ),

          child: Container(
            margin: EdgeInsets.only(bottom: 20),
            //padding: EdgeInsets.only(bottom: 0),
            height: MediaQuery.of(context).size.height/2,

            width: MediaQuery.of(context).size.width * 0.8,
            decoration: BoxDecoration(
              color: Colors.white,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              //   crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(bottom: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        "Sign Up",
                        style: TextStyle(
                          fontSize: MediaQuery.of(context).size.height / 30,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                _buildSignUpForm(),
                _buildSignUpButton(),
              ],
            ),
          ),
        ),

      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return new WillPopScope(
      //onWillPop: _onBackPressed,
      child: SafeArea(
        child: Scaffold(
          key: scaffoldKey,
          resizeToAvoidBottomPadding: false,
          resizeToAvoidBottomInset: false,
          backgroundColor: Color(0xff1E364C),

          body:SingleChildScrollView(
            child: Stack(
              children: <Widget>[
                Container(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Color(0xff1E364C),
                    ),
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    _buildLogo(),
                    _buildContainer(),
                    //   _buildLoginBtn(),
                  ],

                )
              ],
            ),
          ),
        ),
      ),

    );
  }
}
