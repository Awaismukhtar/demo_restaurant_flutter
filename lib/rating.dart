import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Rating extends StatefulWidget {
  final String userId;
  final String restId;

  Rating({
    this.userId,
    this.restId
  });

  final DateTime timestamp = DateTime.now();

  @override
  RatingState createState() => RatingState();
}

class RatingState extends State<Rating> {

  String data = "https://thumbs.dreamstime.com/b/user-profile-avatar-icon-134114292.jpg";

  @override
  void initState() {
    super.initState();
    print(widget.userId.toString());
  }

  @override
  void dispose() {
    super.dispose();
  }

  var items = ['⭐', '⭐⭐', '⭐⭐⭐', '⭐⭐⭐⭐', '⭐⭐⭐⭐⭐'];
  TextEditingController name = new TextEditingController();
  GlobalKey<FormState> _key = new GlobalKey();
  bool _validate = false;

  String userName;


  TextEditingController commentController = TextEditingController();
  final TextEditingController _controller = new TextEditingController();


  buildComments() {
    return StreamBuilder(
        stream:Firestore.instance.collection("rating").where("restId", isEqualTo: widget.restId).snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return CircularProgressIndicator();
          }
          List<Comment> comments = [];
          snapshot.data.documents.forEach((doc) {
            comments.add(Comment.fromDocument(doc));
          });
          return ListView(
            children: comments,
          );
        });
  }


  addRating() async{
    print("in add  comment");
    try {
      await Firestore.instance.collection("rating").document(widget.userId).setData({
        "username": userName,
        "comment": commentController.text,
        "time": widget.timestamp,
        "avatarUrl": data,
        "userId": widget.userId,
        "restId":widget.restId,
        'rate': _controller.text,
      });
      print("Success rating added");
      print(_controller.text.length.toString());

    }catch(e){
      print(e.toString());
    }

    commentController.clear();
  }


  @override
  Widget build(BuildContext context) {

    return SafeArea(
      child: Form(
        key: _key,
        autovalidate: _validate,
        child:
        Scaffold(
          body: StreamBuilder(
              stream: Firestore.instance.collection('users').where("uid",isEqualTo: widget.userId).snapshots(),
              // ignore: missing_return
              builder: (BuildContext context, snapshot) {
                if (snapshot.hasData) {
                  print(snapshot.data.documents.length.toString());
                  return  ListView.builder(
                      shrinkWrap: true,
                      itemCount: snapshot.data.documents.length,
                      padding: const EdgeInsets.only(top: 5.0),
                      itemBuilder: (context, int index) {
                        userName = snapshot.data.documents[index]['displayName'];
                        return Column(
                          children: <Widget>[
                            // ignore: unrelated_type_equality_checks
                            Container(alignment: Alignment.center,
                                height: 410, child: buildComments()),
                            //  Divider(),
                          Container(
                              height: 200,
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Card(
                                  child: Column(
                                    children: [
                                      Container(
                                        margin: EdgeInsets.only(left: 16, right: 110),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            IntrinsicWidth(
                                              child: TextFormField(
                                                maxLines: 1,
                                                controller: _controller,
                                                keyboardType: TextInputType.text,
                                                readOnly: true,
                                                autofocus: false,
                                                decoration: InputDecoration(
                                                  hintText: "Give Stars",
                                                ),
                                              ),
                                            ),

                                            PopupMenuButton<String>(
                                              icon: const Icon(Icons.arrow_drop_down),
                                              onSelected: (String value) {
                                                _controller.text = value;
                                              },
                                              itemBuilder: (BuildContext context) {
                                                return items.map<PopupMenuItem<String>>((String value) {
                                                  return new PopupMenuItem(child: new Text(value), value: value);
                                                }).toList();
                                              },
                                            ),
                                          ],
                                        ),
                                      ),
                                      ListTile(
                                        title: TextFormField(
                                          controller: commentController,
                                          decoration: InputDecoration(labelText: "Write a comment..."),
                                        ),
                                        trailing: OutlineButton(
                                          onPressed: () async{
                                            FocusScope.of(context).requestFocus(new FocusNode());
                                            if (_key.currentState.validate()) {
                                              _key.currentState.save();
                                              addRating();

                                            } else {
                                              setState(() {
                                                _validate =true;
                                              });
                                            }
                                          },

                                          // addComment,
                                          borderSide: BorderSide.none,
                                          child: Text("Post"),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
                      });
                }
                return Container();
              }),
        ),
      ),
    );
  }
}

class Comment extends StatelessWidget {
  final String username;
  final String userId;
  final String avatarUrl;
  final String comment;
  final String rating;
  final Timestamp timestamp;

  Comment({
    this.username,
    this.userId,
    this.avatarUrl,
    this.comment,
    this.rating,
    this.timestamp,
  });

  factory Comment.fromDocument(DocumentSnapshot doc) {
    return Comment(
      username: doc['username'],
      userId: doc['userId'],
      comment: doc['comment'],
      rating: doc['rate'],
      timestamp: doc['time'],
      avatarUrl: doc['avatarUrl'],
    );
  }

  @override
  Widget build(BuildContext context) {
    var formattedDate2 = DateFormat.yMMMd().format(timestamp.toDate());

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(9.0),
          child: Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 5),
            child: Row(
              children: <Widget>[
                Container(
                  child: CircleAvatar(
                  //  backgroundImage: CachedNetworkImageProvider(avatarUrl.toString()),
                    backgroundImage: NetworkImage(avatarUrl.toString()),
                    radius: 23.0,
                  ),
                  decoration: new BoxDecoration(
                    shape: BoxShape.circle,
                    border: new Border.all(
                      color: Color(0xff00AFFF),
                      width: 2.0,
                    ),
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        username,
                        style: TextStyle(fontFamily: "Poppins", fontWeight: FontWeight.w500, fontSize: 16, color: Colors.black),
                      ),
                      Text(
                        comment,
                        maxLines: 3,
                        //overflow:TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontFamily: "Poppins",
                          fontWeight: FontWeight.w400,
                          fontSize: 13,
                        ),
                      )
                    ],
                  ),
                ),
                Column(
                  children: [
                    Container(
                        margin: EdgeInsets.only(left: 80),
                        child: Text(
                          rating,
                          style: TextStyle(fontSize: 12),
                        )),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 80),
                      child: Text(
                        " " + formattedDate2.toString(),
                        style: TextStyle(color: Colors.grey[700]),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.only(right: 30),
          child: Divider(
            height: 0.0,
            color: Colors.black38,
            indent: 33.0,
            endIndent: 10.0,
          ),
        ),
      ],
    );
  }
}
