import 'package:carousel_pro/carousel_pro.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demo_app/rating.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RestaurantDetails extends StatefulWidget {
  final String  restId;

  const RestaurantDetails({Key key, this.restId}) : super(key: key);
  @override
  _RestaurantDetailsState createState() => _RestaurantDetailsState();
}

class _RestaurantDetailsState extends State<RestaurantDetails> {
  FirebaseUser user;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  List<Image> _listOfImages = <Image>[];
  List<String> imagesUrlString = <String>[];
  bool isLoading = false;

  double allRatingSum = 0.0;
 String stars = "";
 String Two;
 int averageOfRating = 0;
  String data = "https://thumbs.dreamstime.com/b/user-profile-avatar-icon-134114292.jpg";

  @override
  void initState() {
    super.initState();
    initUser();
  }

  initUser() async {
    user = await _auth.currentUser();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                  colors: [Colors.blue[800], Colors.blue[800]], begin: const FractionalOffset(0.0, 0.0), end: const FractionalOffset(0.5, 0.0), stops: [0.0, 1.0], tileMode: TileMode.clamp),
            ),
          ),
          //backgroundColor: Colors.grey[800],

          title: Text("Restaurant Detail"),
          centerTitle: true,
          leading: Container(
            //margin: EdgeInsets.only(right: 30),
            child: new IconButton(
              icon: new Icon(Icons.arrow_back),
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ),

        body: user != null
            ? Container(
          child: StreamBuilder(
            stream: Firestore.instance.collection('restaurants').where("restId", isEqualTo: widget.restId).snapshots(),
            builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasData) {
                return ListView.builder(
                  itemCount: snapshot.data.documents.length,
                  itemBuilder: (BuildContext context, int index) {
                    _listOfImages = [];

                    for (int i = 0; i < snapshot.data.documents[index].data['imagesUrls'].length; i++) {
                      imagesUrlString.add(snapshot.data.documents[index].data['imagesUrls'][i]);
                      _listOfImages.add(
                        Image.network(
                          snapshot.data.documents[index].data['imagesUrls'][i],
                          // snapshot.data.documents[index].data['Image Urls'][0],
                          //'https://previews.123rf.com/images/blueringmedia/blueringmedia1701/blueringmedia170100692/69125003-colorful-kite-flying-in-blue-sky-illustration.jpg',
                          loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent loadingProgress) {
                            if (loadingProgress == null) return child;
                            return Center(
                              child: CircularProgressIndicator(
                                value: loadingProgress.expectedTotalBytes != null ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes : null,
                              ),
                            );
                          },
                          fit: BoxFit.cover,
                        ),
                      );
                    }
                    return Column(
                      children: <Widget>[
                        Center(
                          child: Container(
                            height: 200,
                            child: Center(
                              child: Carousel(
                                boxFit: BoxFit.fill,
                                images: _listOfImages,
                                autoplay: false,
                                indicatorBgPadding: 1.0,
                                dotSize: 4.0,
                                dotColor: Colors.blue,
                                dotBgColor: Colors.transparent,
                              ),
                            ),
                          ),
                        ),

                        Container(
                          color: Colors.white,
                          margin: const EdgeInsets.symmetric(vertical: 4.0),
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.only(bottom: 8.0),
                                child: Center(
                                  child: Text(
                                    "Details",
                                    style: TextStyle(fontFamily: "Poppins", fontWeight: FontWeight.w600, fontSize: 20),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.all(15),
                                child: Card(
                                  color: Colors.grey[100],
                                  child: Column(
                                    children: <Widget>[
                                      Card(
                                        child: Container(
                                          height: 50,
                                          color: Colors.white,
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              //crossAxisAlignment: CrossAxisAlignment.center,
                                              children: <Widget>[
                                                //                             Icon(Icons.schedule,),
                                                Container(
                                                    width: 70,
                                                    child: Text(
                                                      'Title: ',
                                                      style: TextStyle(fontWeight: FontWeight.bold),
                                                    )),
                                                SizedBox(
                                                  width: 50,
                                                ),

                                                Text(
                                                  snapshot.data.documents.elementAt(index)['title'],
                                                  style: TextStyle(fontFamily: "Poppins", fontWeight: FontWeight.w500, fontSize: 12, color: Colors.grey[800]),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                      Card(
                                        child: Container(
                                          height: 50,
                                          color: Colors.white,
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              //crossAxisAlignment: CrossAxisAlignment.center,
                                              children: <Widget>[
                                                //                             Icon(Icons.schedule,),
                                                Container(
                                                    width: 70,
                                                    child: Text(
                                                      'Address: ',
                                                      style: TextStyle(fontWeight: FontWeight.bold),
                                                    )),
                                                SizedBox(
                                                  width: 50,
                                                ),

                                                Text(
                                                  snapshot.data.documents.elementAt(index)['address'],
                                                  style: TextStyle(fontFamily: "Poppins", fontWeight: FontWeight.w500, fontSize: 12, color: Colors.grey[800]),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                      Card(
                                        child: Container(
                                          height: 50,
                                          color: Colors.white,
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              children: <Widget>[
                                                //                             Icon(Icons.schedule,),
                                                Container(
                                                    width: 70,
                                                    child: Text(
                                                      'City: ',
                                                      style: TextStyle(fontWeight: FontWeight.bold),
                                                    )),
                                                SizedBox(
                                                  width: 50,
                                                ),
                                                Text(
                                                  snapshot.data.documents[index].data['city'],
                                                  style: TextStyle(fontFamily: "Poppins", fontWeight: FontWeight.w500, fontSize: 12, color: Colors.grey[800]),
                                                ),
                                                SizedBox(width: 5),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                      Card(
                                        child: Container(
                                          height: 50,
                                          color: Colors.white,
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              //crossAxisAlignment: CrossAxisAlignment.center,
                                              children: <Widget>[
                                                //                             Icon(Icons.schedule,),
                                                Container(
                                                    width: 70,
                                                    child: Text(
                                                      'Dish 1: ',
                                                      style: TextStyle(fontWeight: FontWeight.bold),
                                                    )),
                                                SizedBox(
                                                  width: 50,
                                                ),

                                                Text(
                                                   snapshot.data.documents[index].data['dish1'],
                                                  style: TextStyle(fontFamily: "Poppins", fontWeight: FontWeight.w500, fontSize: 12, color: Colors.grey[800]),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                      Card(
                                        child: Container(
                                          height: 60,
                                          color: Colors.white,
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              //crossAxisAlignment: CrossAxisAlignment.center,
                                              children: <Widget>[
                                                //                             Icon(Icons.schedule,),
                                                Container(
                                                    width: 70,
                                                    child: Text(
                                                      'Dish 2: ',
                                                      style: TextStyle(fontWeight: FontWeight.bold),
                                                    )),
                                                SizedBox(
                                                  width: 50,
                                                ),

                                                Flexible(
                                                    child: Container(
                                                        child: Text(
                                                          snapshot.data.documents[index].data['dish2'],
                                                          style: TextStyle(fontFamily: "Poppins", fontWeight: FontWeight.w500, fontSize: 12, color: Colors.grey[800]),
                                                        ))),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                      Card(
                                        child: Container(
                                          height: 50,
                                          color: Colors.white,
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              children: <Widget>[
                                                //                             Icon(Icons.schedule,),
                                                Container(
                                                    width: 70,
                                                    child: Text(
                                                      'Dish 3: ',
                                                      style: TextStyle(fontWeight: FontWeight.bold),
                                                    )),
                                                SizedBox(
                                                  width: 50,
                                                ),
                                                Text(
                                                    snapshot.data.documents[index].data['dish3'],
                                                  style: TextStyle(fontFamily: "Poppins", fontWeight: FontWeight.w500, fontSize: 12, color: Colors.grey[800]),
                                                ),
                                                SizedBox(width: 5),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                      Card(
                                        child: Container(
                                          height: 50,
                                          color: Colors.white,
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              children: <Widget>[
                                                //                             Icon(Icons.schedule,),
                                                Container(
                                                    width: 70,
                                                    child: Text(
                                                      'Dish 4: ',
                                                      style: TextStyle(fontWeight: FontWeight.bold),
                                                    )),
                                                SizedBox(
                                                  width: 50,
                                                ),
                                                Text(
                                                  snapshot.data.documents[index].data['dish4'],
                                                  style: TextStyle(fontFamily: "Poppins", fontWeight: FontWeight.w500, fontSize: 12, color: Colors.grey[800]),
                                                ),
                                                SizedBox(width: 5),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                      ListTile(
                                        leading: Icon(
                                          Icons.rate_review,
                                          color: Color(0xff00AFFF),
                                        ),
                                        title: Text(
                                          "Rating",
                                          style: TextStyle(fontSize: 18, color: Colors.black, fontFamily: "Poppins", fontWeight: FontWeight.w400),
                                        ),
                                        subtitle: Container(
                                          margin: EdgeInsets.only(top: 7),
                                          child: StreamBuilder(
                                              stream: Firestore.instance.collection("rating").where("restId", isEqualTo: widget.restId).snapshots(),
                                              builder: (BuildContext context, snapshot1) {
                                                if (snapshot1.hasData && snapshot1.data != null) {
                                                  allRatingSum = 0.0;
                                                  stars = "";
                                                  averageOfRating = 0;
                                                  Two =snapshot1.data.documents.length.toString();
                                                  if (snapshot1.data.documents.length > 0) {
                                                    for (int i = 0; i < snapshot1.data.documents.length; i++) {
                                                      allRatingSum += snapshot1.data.documents[i]['rate'].length;
                                                      print(snapshot1.data.documents[i]['rate'].length.toString());
                                                    }
                                                    averageOfRating = (allRatingSum / snapshot1.data.documents.length).round();
                                                    print("avergae + $averageOfRating");
                                                    for (int j = 0; j < averageOfRating; j++) {
                                                      stars += "⭐";
                                                    }
                                                    return Row(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Text(stars, style: TextStyle(fontSize: 18, color: Colors.black54)),
                                                        Padding(
                                                          padding: const EdgeInsets.all(4.0),
                                                          child: Text
                                                            ('/$Two', style: TextStyle(fontSize: 13, color: Colors.black54,fontFamily: "Poppins",fontWeight: FontWeight.w400 )),
                                                        ),
//
                                                      ],
                                                    );
                                                  } else {
                                                    return Text('Yet to be rated');
                                                  }
                                                } else {
                                                  return Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Text(stars, style: TextStyle(fontSize: 18, color: Colors.black54)
                                                      ),

//
                                                    ],
                                                  );
                                                }
                                              }),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(top: 25),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Container(
                                      //                    color: Colors.blue,
                                      color: Colors.indigo[300],
                                      width: MediaQuery.of(context).size.width/1.5,
                                      height: 30,
                                      child: Center(
                                        child: Text(
                                          'User Reviews',
                                          style: TextStyle(
                                            fontFamily: 'Poppins',
                                            color: Colors.white,
                                            fontSize: 20.0,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              Container(
                                margin: EdgeInsets.only(top: 20),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  //crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      'Click Icon for Reviews',
                                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                       Navigator.push(context,MaterialPageRoute(builder: (context)=> Rating(userId: user.uid, restId: snapshot.data.documents.elementAt(index)['restId'])));

                                      },
                                      child: Icon(
                                        Icons.chat,
                                        size: 28.0,
                                        color: Colors.blue[900],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
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
        )
            : Center(child: Text("Error")),
      ),
    );
  }








}
