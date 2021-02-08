import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demo_app/restaurants/restaurant_detail.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {

  @override
  void deactivate() {
    // TODO: implement deactivate
    print("deactivate");
    super.deactivate();
  }
  FirebaseUser user;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  /*
    Dispose is called when the State object is removed, which is permanent.
    This method is where you should unsubscribe and cancel all animations, streams, etc.
    */
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
 initUser();

  }
  initUser() async {
    user = await _auth.currentUser();

    if(user!=null){
      print(user.uid);

    }
    else{
      print("userid");
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomPadding: false, //
        backgroundColor: Colors.white,

        appBar: AppBar(
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                  colors: [Colors.blue[800], Colors.blue[800]], begin: const FractionalOffset(0.0, 0.0), end: const FractionalOffset(0.5, 0.0), stops: [0.0, 1.0], tileMode: TileMode.clamp),
            ),
          ),
          title: Text('Demo Flutter App'),

          centerTitle: true,
          elevation: 0.0,
        ),

        drawer: Theme(
            data: Theme.of(context).copyWith(
                //        canvasColor: Colors.blueGrey,
                ),
            child: Drawer(
              child:  user != null ? ListView(
                padding: EdgeInsets.zero,
                children: <Widget>[
                  Container(
                    height: 120.0,
                    //width: 500,
                    child: StreamBuilder(
                        stream: Firestore.instance.collection('users').where("uid", isEqualTo: user.uid).snapshots(),

                        // ignore: missing_return
                        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                          {
                            if (snapshot.connectionState == ConnectionState.active) {
                              return ListView.builder(
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: snapshot.data.documents.length,
                                  // ignore: missing_return
                                  itemBuilder: (BuildContext context, int index) {
                                    print(user.uid);
                                    return DrawerHeader(
                                        margin: EdgeInsets.zero,
                                        padding: EdgeInsets.zero,
                                        child: Stack(children: <Widget>[
                                          Row(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              snapshot.data.documents.elementAt(index)['image'] == null
                                                  ? Padding(
                                                padding: const EdgeInsets.all(8.0),
                                                child: Container(
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
                                                          width: 80, height: 80, fit: BoxFit.fill)),
                                                ),
                                              )
                                                  : Padding(
                                                padding: const EdgeInsets.all(8.0),
                                                child: Container(
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
                                                      child: Image.network(snapshot.data.documents.elementAt(index)['image'],
                                                          loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent loadingProgress) {
                                                            if (loadingProgress == null) return child;
                                                            return Center(
                                                              child: CircularProgressIndicator(
                                                                value: loadingProgress.expectedTotalBytes != null
                                                                    ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes
                                                                    : null,
                                                              ),
                                                            );
                                                          }, width: 80, height: 80, fit: BoxFit.fill)),
                                                ),
                                              ),
                                              Row(
                                                children: [
                                                  Container(
                                                    margin: EdgeInsets.only(bottom: 50, left: 30),
                                                    child: Column(
                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                      //crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Text(
                                                          "Welcome !",
                                                          style: TextStyle(color: Colors.black38),
                                                        ),
                                                        Text(
                                                          snapshot.data.documents.elementAt(index)['displayName'],
                                                          style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),

                                        ]));
                                  });
                            } else if (snapshot.connectionState == ConnectionState.waiting) {
                              return Container(child: Center(child: CircularProgressIndicator()));

                            }
                          }
                        }),
                  ),
                  Container(
                    //margin:EdgeInsets.only(top:35),
                    height: 50,
                    child: ListTile(
                      title: Row(
                        children: <Widget>[
                          Icon(
                            Icons.add_box,
                            color: Color(0xff2470c7),
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 8.0),
                            child: Text("Add Restaurants"),
                          ),
                        ],
                      ),
                      onTap: () {
                        Navigator.pushNamed(context, '/add_restaurant');
                      },
                    ),
                  ),
                  // ignore: unrelated_type_equality_checks
                  Divider(
                    thickness: 0.5,
                    color: Colors.lightBlueAccent,
                  ),
                  Container(
                    height: 50,
                    // color: Colors.grey[800],
                    child: ListTile(
                      title: Row(
                        children: <Widget>[
                          Icon(
                            Icons.restaurant,
                            color: Color(0xff2470c7),
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 8.0),
                            child: Text("Search"),
                          ),
                        ],
                      ),
                      onTap: () {
                        Navigator.pushNamed(context, '/search_restaurant');
                      },
                    ),
                  ),
                  Divider(
                    thickness: 0.5,
                    color: Colors.lightBlueAccent,
                  ),
                  Container(
                    height: 50,
                    // color: Colors.grey[800],
                    child: ListTile(
                      title: Row(
                        children: <Widget>[
                          Icon(
                            Icons.wc,
                            color: Color(0xff2470c7),
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 8.0),
                            child: Text("My Profile"),
                          ),
                        ],
                      ),
                      onTap: () {
                        Navigator.pushNamed(context, '/my_profile');
                      },
                    ),
                  ),
                  Divider(
                    thickness: 0.5,
                    color: Colors.lightBlueAccent,
                  ),

                  Container(
                    height: 50,
                    //color: Colors.grey[800],
                    child: ListTile(
                        title: Row(
                          children: <Widget>[
                            Icon(
                              Icons.person_pin,
                              color: Color(0xff2470c7),
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 8.0),
                              child: Text("Sign Out"),
                            ),
                          ],
                        ),
                        onTap: ()
                            async {
                          await _auth.signOut();
                          Navigator.pushNamed(context, '/register');
                        }),
                  ),
                ],
              ):SizedBox.shrink(),
            )),
        body: SingleChildScrollView(
          reverse: true,
          child: GestureDetector(
            // onTap: () {
            //   FocusScope.of(context).requestFocus(FocusNode());
            // },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                margin: EdgeInsets.only(top: 10),
                child: Column(
                  children: <Widget>[
                    Container(
                      child: Center(
                        child: Text("Restaurants", style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold,color: Colors.blue),),
                      ),

                    ),
                    Container(
                      //  height: MediaQuery.of(context).size.height / 1,
                       // width: 370,
                        decoration: BoxDecoration(),
                        child: Container(
                          //margin: EdgeInsets.only(top: 20,left: 13),
                          child: Padding(
                            padding: EdgeInsets.all(20.0),
                            child: Column(
                              children: <Widget>[
                                Container(
                                  height: MediaQuery.of(context).size.height/1.5,
                                  width: double.infinity,
                                  child: StreamBuilder(
                                    stream: Firestore.instance.collection('restaurants').snapshots(),

                                    builder:
                                        (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                                      if (snapshot.hasData) {

                                        return Container(
                                          padding: EdgeInsets.all(12),
                                          child:
                                          GridView.builder(
                                            shrinkWrap: true,
                                            gridDelegate:
                                            new SliverGridDelegateWithFixedCrossAxisCount(
                                              crossAxisCount: 2,
                                              // primary: false,
                                              crossAxisSpacing: 10.0,
                                              mainAxisSpacing: 15.0,
                                              childAspectRatio: 0.8,
                                            ),
                                            itemCount: snapshot.data.documents.length,

                                            // ignore: missing_return
                                            itemBuilder: (BuildContext context, int index) {
                                              return Padding(

                                                padding: EdgeInsets.only(top: 5.0, bottom: 5.0, left: 5.0, right: 5.0),
                                                child: Card(
                                                  color: Colors.transparent,
                                                  child: ClipRRect(
                                                    borderRadius: BorderRadius.circular(10),
                                                    child: GridTile(
                                                      child: GestureDetector(
                                                        onTap: () {
                                                          Navigator.push(context, MaterialPageRoute(builder: (context)=>RestaurantDetails(restId:  snapshot.data.documents[index].documentID)));
                                                        },
                                                        child: Image.network(

                                                          snapshot.data.documents[index].data['imagesUrls'][0],
                                                          //'https://previews.123rf.com/images/blueringmedia/blueringmedia1701/blueringmedia170100692/69125003-colorful-kite-flying-in-blue-sky-illustration.jpg',
                                                          loadingBuilder: (BuildContext context, Widget child,
                                                              ImageChunkEvent loadingProgress) {
                                                            if (loadingProgress == null) return child;
                                                            return Center(
                                                              child: CircularProgressIndicator(
                                                                value: loadingProgress.expectedTotalBytes != null
                                                                    ? loadingProgress.cumulativeBytesLoaded /
                                                                    loadingProgress.expectedTotalBytes
                                                                    : null,
                                                              ),
                                                            );
                                                          },
                                                          fit: BoxFit.cover,
                                                        ),
                                                      ),
                                                      footer: Container(
                                                        decoration: BoxDecoration(
                                                          //borderRadius: BorderRadius.circular(15.0),
                                                            boxShadow: [
                                                              BoxShadow(
                                                                  color: Colors.grey.withOpacity(0.2),
                                                                  spreadRadius: 3.0,
                                                                  blurRadius: 5.0)
                                                            ],
                                                            gradient: LinearGradient(
                                                                colors: [Colors.white30, Colors.white],
                                                                begin: FractionalOffset.centerRight,
                                                                end: FractionalOffset.centerLeft)),
                                                        child: GridTileBar(
                                                          title: Text(
                                                            snapshot.data.documents[index].data['title'].toString().toUpperCase(),
                                                            textAlign: TextAlign.center,style: TextStyle(  fontSize: 13,
                                                              color: Colors.black54,fontFamily: 'Overpass'),
                                                            //style: TextStyle(fontStyle: F),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              );
                                            },
                                          ),
                                        );
                                      } else {
                                        return Center(child:CircularProgressIndicator());
                                      }
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
