import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demo_app/restaurants/restaurant_detail.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SearchRestaurant extends StatefulWidget {

  @override
  _SearchRestaurantState createState() => _SearchRestaurantState();
}

class _SearchRestaurantState extends State<SearchRestaurant> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String searchTxt;
  String Two;

  TextEditingController addController = TextEditingController();
  FirebaseUser user;

  ScrollController _scrollController = ScrollController();
  Firestore firestore = Firestore.instance;
  List<DocumentSnapshot> restaurants = [];
  bool isLoading = false;
  int documentLimit = 5;
  DocumentSnapshot lastDocument;
  StreamController<List<DocumentSnapshot>> _controller = StreamController<List<DocumentSnapshot>>.broadcast();

  Stream<List<DocumentSnapshot>> get _streamController => _controller.stream;

  @override
  void dispose() {
    super.dispose();
    _controller.close();
  }

  @override
  void initState() {
    super.initState();
    initUser();
  }

  initUser() async {
    user = await _auth.currentUser();
    _scrollController.addListener(() {
      double maxScroll = _scrollController.position.maxScrollExtent;
      double currentScroll = _scrollController.position.pixels;
      double delta = MediaQuery.of(context).size.height * 0.20;
      if (maxScroll - currentScroll <= delta) {
        getrestaurants();
        print("in add scroll listnr");
      }
    });
    setState(() {});
  }


  getrestaurants() async {
    if (isLoading) {
      print(isLoading.toString());
      return;
    }
    setState(() {
      isLoading = true;
    });
    QuerySnapshot querySnapshot;

    if (lastDocument == null) {
      print("First if lastdocument is null");
      if (searchTxt != null && searchTxt != '') {
          querySnapshot = await firestore.collection('restaurants').where('city', isEqualTo: searchTxt).orderBy('title',descending: false).limit(documentLimit).getDocuments();
        print("search text is  not null "+querySnapshot.documents.length.toString());
      }

    } else {
      print("First else lastdocument is not null");
      if (searchTxt != null && searchTxt != '') {
        querySnapshot = await firestore
            .collection('restaurants').where('city', isEqualTo: searchTxt).orderBy('title',descending: false)
            .startAfterDocument(lastDocument)
            .limit(documentLimit)
            .getDocuments();

        print("in else lastdocumetn  search text is not null");
      }
    }
    print("out of else");

    if (querySnapshot.documents.isEmpty) {
      print('No More restaurants');
      setLoading(false);
      return;
    }

    print(querySnapshot.documents.length.toString() + "before the lastdocumetn line ");

    lastDocument = querySnapshot.documents[querySnapshot.documents.length - 1];
    restaurants.addAll(querySnapshot.documents);
    _controller.sink.add(restaurants);

    setLoading(false);

  }

  void setLoading([bool value = false]) => setState(() {
    isLoading = value;
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("List of Restaurants"),
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                  colors: [Colors.blue[800], Colors.blue[800]], begin: const FractionalOffset(0.0, 0.0), end: const FractionalOffset(0.5, 0.0), stops: [0.0, 1.0], tileMode: TileMode.clamp),
            ),
          ),
          centerTitle: true,
        ),
        body: user != null
            ? Column(
          children: <Widget>[
            Expanded(
              child: Column(
                children: <Widget>[
                  Container(
                   padding: EdgeInsets.fromLTRB(5, 10, 5, 5),
                    margin: EdgeInsets.only(top: 15),
                    decoration: BoxDecoration(
                      color: Colors.indigo.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: TextFormField(
                      controller: addController,
                      onChanged: (val) {
                        setState(() {
                          searchTxt = val.toUpperCase();
                        });
                      },
                      style: TextStyle(
                        fontFamily: "Poppins",
                        color: Colors.black87,
                        fontWeight: FontWeight.w500,
                        fontSize: 14.0,
                        //letterSpacing: 2.0,
                      ),
                      decoration: InputDecoration(
                        suffixIcon: IconButton(
                            icon: Icon(Icons.search),
                            onPressed: () {
                              if(searchTxt !=null && searchTxt !=''){
                                print(searchTxt);
                                lastDocument = null;
                                restaurants.clear();
                                print(lastDocument.toString() + "here is clear");
                                print(searchTxt);
                                getrestaurants();
                              }}),
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        labelText: 'Search By City',
                        hintStyle: TextStyle(color: Colors.grey[700],fontSize: 20,),
                      ),
                    ),
                  ),
                  Expanded(
                    child: StreamBuilder<List<DocumentSnapshot>>(
                        stream: _streamController,
                        // ignore: missing_return
                        builder: (BuildContext context, snapshot) {
                          // ignore: missing_return

                          if (snapshot.hasError) {
                            return Text('We got an error ${snapshot.hasError}');
                          }
                          switch (snapshot.connectionState) {
                            case ConnectionState.waiting:
                              return SizedBox(
                                child: Center(
                                  child: Text('Search Restaurant by typing above'),
                                ),
                              );
                            case ConnectionState.none:
                              return SizedBox(
                                child: Text('Oops,No data'),
                              );
                            case ConnectionState.done:
                              return SizedBox(
                                child: Text('We are done'),
                              );
                            default:
                              if (snapshot.hasData) {
                                return ListView.builder(
                                  controller: _scrollController,
                                  //  reverse: true,
                                  itemCount: snapshot.data.length,
                                  itemBuilder: (BuildContext context, int index) {
                                    return Container(
                                        child: Column(
                                          children: <Widget>[
                                            Padding(
                                              padding: const EdgeInsets.all(10.0),
                                              child: Container(
                                                width: MediaQuery.of(context).size.width,
                                                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                                                child: GestureDetector(
                                                  onTap: () {
                                                    Navigator.pushReplacement(context, MaterialPageRoute(builder:(context)=>RestaurantDetails(restId: snapshot.data.elementAt(index).documentID)));
                                                  },
                                                  child: Card(

                                                    elevation: 5,
                                                    shape: RoundedRectangleBorder(
                                                      borderRadius: BorderRadius.circular(0.0),
                                                    ),
                                                    child: Container(
                                                      margin: EdgeInsets.only(
                                                        top: 12.5,
                                                      ),
                                                      decoration: BoxDecoration(color: Colors.white),
                                                      width: MediaQuery.of(context).size.width,
                                                      padding: EdgeInsets
                                                          .symmetric(horizontal: 7, vertical: 5),
                                                      child: Row(
                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: <Widget>[
                                                          Row(
                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                            children: <Widget>[
                                                              snapshot.data.elementAt(index)['imagesUrls'][0] != null
                                                                  ? Container(
                                                                margin: EdgeInsets.only(top: 3),
                                                                decoration: new BoxDecoration(
                                                                  shape: BoxShape.circle,
                                                                  border: new Border.all(
                                                                    color: Color(0xff0286D0),
                                                                    width: 1.0,
                                                                  ),
                                                                ),
                                                                width: 70.0,
                                                                height: 70.0,
                                                                //color: Colors.green,

                                                                child: CircleAvatar(
                                                                  //backgroundColor: Colors.green,
                                                                  //foregroundColor: Colors.green,
                                                                  //backgroundImage: AssetImage('assets/1.jpg'),
                                                                  //backgroundImage: NetworkImage(snapshot.data['image']),
                                                                  backgroundImage: NetworkImage(snapshot.data.elementAt(index)['imagesUrls'][0]),
                                                                ),
                                                              )
                                                                  : Container(
                                                                width: 70.0,
                                                                height: 70.0,
                                                                //color: Colors.green,
                                                                margin: EdgeInsets.only(
                                                                  right: 12.5,
                                                                ),
                                                                child: CircleAvatar(
                                                                  //backgroundColor: Colors.green,
                                                                  //foregroundColor: Colors.green,
                                                                  //backgroundImage: AssetImage('assets/1.jpg'),
                                                                  //backgroundImage: NetworkImage(snapshot.data['image']),
                                                                  backgroundImage: NetworkImage("https://thumbs.dreamstime.com/b/user-profile-avatar-icon-134114292.jpg"),
                                                                  //Image.network(snapshot.data['url'],),
                                                                ),
                                                              ),

                                                              Container(
                                                                margin: EdgeInsets.only(
                                                                  top: 5.5,
                                                                ),
                                                                child: Column(
                                                                  //crossAxisAlignment: CrossAxisAlignment.start,
                                                                  //mainAxisAlignment: MainAxisAlignment.end,
                                                                  children: <Widget>[
                                                                    Padding(
                                                                      padding: const EdgeInsets.only(top: 8,),
                                                                      child: Text(
                                                                        snapshot.data.elementAt(index)['title'],
                                                                        //   snapshot.data.documents.elementAt(index)['displayName'],

                                                                        style: TextStyle(
                                                                          fontFamily: 'Poppins',
                                                                          color: Colors.black,
                                                                          fontSize: 12.0,
                                                                          fontWeight: FontWeight.w700,
                                                                        ),
                                                                      ),
                                                                    ),

                                                                  ],
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                          Column(
                                                            children: [
                                                              Container(
//                                                                  margin:
//                                                            EdgeInsets.only(top: 5),
                                                                child: Padding(
                                                                  padding: const EdgeInsets.all(2.0),
                                                                  child: FlatButton(
                                                                    color: Color(0xff00AFFF),
                                                                    onPressed: () {
                                                                      Navigator.pushReplacement(context, MaterialPageRoute(builder:(context)=>RestaurantDetails(restId: snapshot.data.elementAt(index).documentID)));
                                                                    },
                                                                    child: Text('Visit',
                                                                        style: TextStyle(
                                                                          color: Colors.white,
                                                                          fontWeight: FontWeight.bold,
                                                                          fontSize: 12,
                                                                        )),
                                                                    shape: RoundedRectangleBorder(
                                                                        side: BorderSide(
                                                                          //        color: Colors.grey[500],
                                                                            color: Color(0xff00AFFF),
                                                                            width: 1.5,
                                                                            style: BorderStyle.solid),
                                                                        borderRadius: BorderRadius.circular(10)),
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
                                            )
                                          ],
                                        ));
                                  },
                                );
                              }
                          }
                        }),
                  ),
                  isLoading
                      ? Container(
                    width: MediaQuery.of(context).size.width,
                    padding: EdgeInsets.all(5),
                    color: Colors.blue,
                    child: Text(
                      'Loading',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )
                      : Container(),
                ],
              ),
            ),
          ],
        )
            : Center(child: Text("Error")),
      ),
    );
  }
}
