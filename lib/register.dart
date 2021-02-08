import 'dart:io';

import 'package:demo_app/otp_screen.dart';
import 'package:demo_app/validation/validation_methods.dart';
import 'package:flutter/material.dart';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {



  @override
  void initState() {
    super.initState();
  }



  TextEditingController _phoneNumberController = TextEditingController();


  GlobalKey<FormState> _key = new GlobalKey();
  final scaffoldKey = GlobalKey<ScaffoldState>();
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
    return StatefulBuilder(builder: (BuildContext context, StateSetter state) {
      return Form(
        key: _key,
        autovalidate: _validate,
        child: Padding(
          padding: EdgeInsets.all(8),
          child: Column(
            children: <Widget>[
              Container(
                child: TextFormField(
                  keyboardType: TextInputType.number,
                  controller: _phoneNumberController,
                  maxLength: 13,
                  autofocus: false,
                  decoration: InputDecoration(
                      prefix: Container(
                        padding: EdgeInsets.all(4.0),
                        child: Text(
                          "",
                          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                        ),
                      ),
                      hintText: "E.g +923336456678"
                  ),
                  autocorrect: false,
                  validator: validatePhoneNumber,
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildSignUpButton() {
    return Builder(
      builder: (BuildContext context) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              height: 1.4 * (MediaQuery.of(context).size.height / 25),
              width: 5 * (MediaQuery.of(context).size.width / 10),
              margin: EdgeInsets.only(top: 40),
              child: RaisedButton(
                //elevation: 5.0,
                color: Color(0xff2196F3),

                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),

                onPressed: () {
                  if (_key.currentState.validate()) {
                    // No any error in validation
                    _key.currentState.save();
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>OTPScreen(mobileNumber: _phoneNumberController.text)));

                  } else{
                    setState(() {
                      _validate = true;
                    });
                  }
                },

                child: Text(
                  "Next",
                  style: TextStyle(
                    color: Colors.white,
                    letterSpacing: 1.5,
                    fontSize: MediaQuery.of(context).size.height / 40,
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
            height: MediaQuery.of(context).size.height * 0.5,

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
                        "Register Form",
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
    return SafeArea(
      child: Scaffold(
        key: scaffoldKey,
        resizeToAvoidBottomPadding: false,
        resizeToAvoidBottomInset: false,
        backgroundColor: Color(0xff1E364C),
        body: SingleChildScrollView(
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
                  //    _buildLoginBtn(),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
