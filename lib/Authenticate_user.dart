import 'package:demo_app/register.dart';
import 'package:demo_app/userDetail.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'index.dart';

class Authenticate extends StatefulWidget {
  @override
  _AuthenticateState createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  FirebaseUser user;

  @override
  void initState() {
    super.initState();

    initUser();
  }

  String userid;
  initUser() async {
    user = await _auth.currentUser();
    setState(() {});
  }


  @override
  Widget build(BuildContext context) {
    return user != null
        ? Scaffold(
//        appBar: AppBar(title: Text('Home ${user.email}'),),

        body: StreamBuilder<DocumentSnapshot>(
            stream: Firestore.instance.collection('users').document(user.uid).snapshots(),
            // ignore: missing_return
            builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
              if (snapshot.hasError)
                return Center(
                  child: Text("Something went wrong  please come back later"),
                );

              switch (snapshot.connectionState) {
                case ConnectionState.none:
                  return Center(child: Text("Please check your internet"));
                  break;
                case ConnectionState.waiting:
                  return Center(
                    child: Text("Loading Main Screen"),
                  );
                  break;
                default:
                  return _authenticate(snapshot.data);
                  break;
              }
            }))
        : Register();
  }

  _authenticate(DocumentSnapshot snapshot) {
      if (snapshot.data == null) {
        return Register();
      } else if(snapshot.data['displayName'] ==null || snapshot.data['displayName'] == ''){
        return UserDetail();
      }
      else {
        return MainScreen();
      }
  }
}
