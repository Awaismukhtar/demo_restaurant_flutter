import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class UserProfile extends StatefulWidget {
  @override
  _UserProfileState createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {



  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<String> currentUser() async {
    user = await _auth.currentUser();
    return user != null ? user.uid : null;
  }

  FirebaseUser user;

  @override
  void initState() {
    super.initState();

    initUser();
  }

  String userid;

  initUser() async {
    user = await _auth.currentUser();
    if (user != null) {
      userid = user.uid;
    } else {
      print("user.uid");
      // User is not available. Do something else
    }
    setState(() {});
  }


  @override
  Widget build(BuildContext context) {

    // Size screenSize = MediaQuery.of(context.size;
    //final data = ModalRoute.of(context).settings.arguments as String;
    return SafeArea(
      child: Scaffold(
          backgroundColor: Colors.white,
          resizeToAvoidBottomPadding: false,
          appBar: AppBar(
            title: Center(child:Text('My Profile')),
            flexibleSpace: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                    colors: [Colors.blue[800], Colors.blue[800]],
                    begin: const FractionalOffset(0.0, 0.0),
                    end: const FractionalOffset(0.5, 0.0),
                    stops: [0.0, 1.0],
                    tileMode: TileMode.clamp
                ),
              ),
            ),
            actions: <Widget>[

              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Container(
                        child: Text(
                          'My Profile',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 19),
                        )),
                  ],
                ),
              ),
            ],
            backgroundColor: Colors.grey[800],
            elevation: 0.0,
          ),
          body: user !=null ? Container(
            child: StreamBuilder(
              stream: Firestore.instance.collection('users').where("uid", isEqualTo:user.uid).snapshots(),
              builder:
                  (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasData) {
                  return ListView.builder(
                    itemCount: snapshot.data.documents.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Stack(
                        children: <Widget>[
                          Ink(
                            color: Color(0xff2D3040),
                            height: 140,
                          ),
                          SingleChildScrollView(
                            child: Column(
                              children: <Widget>[

                                SizedBox(height: 75.0),
                                snapshot
                                    .data.documents
                                    .elementAt(index)['image'] !=null ?Center(
                                  child: Container(
                                    width: 120.0,
                                    height: 120.0,
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                        image: NetworkImage(snapshot
                                            .data.documents
                                            .elementAt(index)['image']),
                                        fit: BoxFit.cover,
                                      ),
                                      borderRadius:
                                      BorderRadius.circular(50.0),
                                      border: Border.all(
                                        color: Color(0xffE1E1E1),
                                        width: 5.0,
                                      ),
                                    ),
                                  ),
                                ):Container(

                                  width: 100,
                                  height: 90,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(100),
                                    border: Border.all(
                                      color: Colors.white,
                                      width: 6.0,
                                    ),
                                  ),
                                  child: ClipRRect(
                                      borderRadius: BorderRadius.circular(80),
                                      child: Image.network("https://thumbs.dreamstime.com/b/user-profile-avatar-icon-134114292.jpg",
                                          width: 80,
                                          height: 80,
                                          fit: BoxFit.fill)),
                                ),
                                //_buildFullName(),
                                Container(
                                  margin: EdgeInsets.only(top: 20),
                                  child: Text(
                                    snapshot.data.documents
                                        .elementAt(index)['displayName'],
                                    style: TextStyle(
                                      fontFamily: 'Poppins',
                                      color: Colors.black,
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
//
                                Container(
                                  margin: EdgeInsets.only(top: 30),
                                  child: Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.center,
                                    children: <Widget>[
                                      Container(
                                        //color: Colors.grey[500],
                                        color: Colors.indigo[300],
                                        width: MediaQuery
                                            .of(context)
                                            .size
                                            .width,
                                        height: 34,
                                        child: Center(
                                          child: Text(
                                            'Personal Information',
                                            style: TextStyle(
                                              fontFamily: 'Poppins',
                                              color: Colors.white,
                                              fontSize:20.0,
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 17,
                                ),
//                                  //    _showPersonalInformation(context),
                                Container(
                                    padding: EdgeInsets.all(20),
                                    child: Card(
                                      color: Colors.white,
                                      child: Container(
                                        alignment: Alignment.topLeft,
                                        padding: EdgeInsets.all(10),
                                        child: Column(
                                          children: <Widget>[
                                            Column(
                                              children: <Widget>[
                                                snapshot.data.documents
                                                    .elementAt(
                                                    index)['displayName'] !=null?           ListTile(
                                                  leading: Icon(Icons.email, color: Color(0xff00AFFF),),
                                                  title: Text("Name",style: TextStyle(fontSize: 18,color: Colors.black,fontFamily: "Poppins",fontWeight: FontWeight.w400),),
                                                  subtitle: Container(
                                                    margin:EdgeInsets.only(top:7),
                                                    child: Text(snapshot.data.documents
                                                        .elementAt(
                                                        index)[
                                                    'displayName'],style: TextStyle(fontSize: 15,color: Colors.black54)),
                                                  ),
                                                ):Container(),
                                                Divider(),
                                                snapshot.data.documents
                                                    .elementAt(
                                                    index)['age'] !=null?ListTile(
                                                  leading: Icon(Icons.person, color: Color(0xff00AFFF),),
                                                  title: Text("Age",style: TextStyle(fontSize: 18,color: Colors.black,fontFamily: "Poppins",fontWeight: FontWeight.w400)),
                                                  subtitle: Container(
                                                    margin:EdgeInsets.only(top:7),
                                                    child: Text(
                                                        snapshot.data.documents
                                                            .elementAt(
                                                            index)['age'],style: TextStyle(fontSize: 15,color: Colors.black54)),
                                                  ),
                                                ):Container(),
                                                Divider(),
                                                snapshot.data.documents
                                                    .elementAt(
                                                    index)['phoneNumber'] !=null?ListTile(
                                                  leading: Icon(Icons.phone, color: Color(0xff00AFFF),),
                                                  title: Text("Phone Number",style: TextStyle(fontSize: 18,color: Colors.black,fontFamily: "Poppins",fontWeight: FontWeight.w400)),
                                                  subtitle: Container(
                                                    margin:EdgeInsets.only(top:7),
                                                    child: Text(snapshot.data.documents
                                                        .elementAt(
                                                        index)[
                                                    'phoneNumber'],style: TextStyle(fontSize: 15,color: Colors.black54)),
                                                  ),
                                                ):Container(),
                                                Divider(),
                                                snapshot.data.documents
                                                    .elementAt(
                                                    index)['city'] !=null?ListTile(
                                                  leading: Icon(Icons.person, color: Color(0xff00AFFF),),
                                                  title: Text("City",style: TextStyle(fontSize: 18,color: Colors.black,fontFamily: "Poppins",fontWeight: FontWeight.w400)),
                                                  subtitle: Container(
                                                    margin:EdgeInsets.only(top:7),
                                                    child: Text(
                                                        snapshot.data.documents
                                                            .elementAt(
                                                            index)['city'],style: TextStyle(fontSize: 15,color: Colors.black54,fontFamily: "Poppins",fontWeight: FontWeight.w400)),
                                                  ),
                                                ):Container(),
                                                Divider(),
                                                snapshot.data.documents
                                                    .elementAt(
                                                    index)['address'] !=null?ListTile(
                                                  leading: Icon(Icons.person, color: Color(0xff00AFFF),),
                                                  title: Text("Address",style: TextStyle(fontSize: 18,color: Colors.black)),
                                                  subtitle: Container(
                                                    margin:EdgeInsets.only(top:7),
                                                    child: Text(
                                                        snapshot.data.documents
                                                            .elementAt(
                                                            index)['address'],style: TextStyle(fontSize: 15,color: Colors.black54)),
                                                  ),
                                                ):Container(),
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                    )
                                ),
                                SizedBox(height: 8.0),
                              ],
                            ),
                          ),
                        ],
                      );
                    },
                  );
                } else {
                  debugPrint('Loading...');
                  return Center(
                    child: Text('Loading...'),
                  );
                }
              },
            ),
          )   : Center(child: Text("Error"))),
    );

  }



}
