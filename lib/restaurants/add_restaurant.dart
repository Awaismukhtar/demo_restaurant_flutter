import 'dart:io';
import 'dart:typed_data';
import 'package:demo_app/Authenticate_user.dart';
import 'package:demo_app/services/database.dart';
import 'package:demo_app/models/restaurants.dart';
import 'package:demo_app/validation/validation_methods.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'dart:async';

class AddRestaurant extends StatefulWidget {

  @override
  _AddRestaurantState createState() => _AddRestaurantState();
}
class _AddRestaurantState extends State<AddRestaurant>{

bool _validate = false;
final GlobalKey<FormState> _key = new GlobalKey();
final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

List<Asset> images = List<Asset>();
List<Uint8List> _list = List<Uint8List>();
TextEditingController Title = new TextEditingController();
TextEditingController Address = new TextEditingController();
TextEditingController dish1 = new TextEditingController();
TextEditingController dish2 = new TextEditingController();
TextEditingController dish3 = new TextEditingController();
TextEditingController dish4 = new TextEditingController();
TextEditingController City = new TextEditingController();


void showInSnackBar(String value) {
  _scaffoldKey.currentState.showSnackBar(new SnackBar(content: new Text(value)));
}


  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      key: _scaffoldKey,
      body: Container(
        padding: EdgeInsets.all(16.0),
        child: Form(
          child: ListView(
            shrinkWrap: true,
            children: <Widget>[
              Center(
                child: Text(
                  "Add Restaurant",
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                ),
              ),
              Add_Restaurant(),
              Padding(
                padding: EdgeInsets.fromLTRB(0, 0, 0, 16),
              ),
            ], //:TODO: implement upload pictures
          ),
        ),
      ),
    );
  }



  Widget Add_Restaurant() {
    return Form(
      key: _key,
      autovalidate: _validate,
      child: Padding(
          padding: const EdgeInsets.fromLTRB(0.0, 20.0, 0.0, 0.0),
          child: Column(
            children: <Widget>[
              TextFormField(
                controller: Title,
                keyboardType: TextInputType.text,
                validator: validateName,
                onSaved: (String val) {
                  Title.text = val;
                },
                //  maxLength: 15,
                maxLines: 1,
                autofocus: true,
                decoration: InputDecoration(
                    prefixIcon: Icon(
                      Icons.title,
                      color: Color(0xff2470c7),
                    ),
                    //  hintText: widget.adPost.title,
                    labelText: 'Title'),
                textInputAction: TextInputAction.next,
              ),
              TextFormField(
                controller: Address,
                keyboardType: TextInputType.text,
                validator: validateName,
                onSaved: (String val) {
                  Address.text = val;
                },
                maxLines: 1,
                autofocus: true,
                decoration: InputDecoration(
                    prefixIcon: Icon(
                      Icons.location_city,
                      color: Color(0xff2470c7),
                    ),
                    labelText: 'Address'),
                textInputAction: TextInputAction.next,
                //textAlign: TextAlign,
              ),
              TextFormField(
                controller: City,
                keyboardType: TextInputType.text,
                validator: validateName,
                onSaved: (String val) {
                  City.text = val;
                },
                maxLines: 1,
                autofocus: true,
                decoration: InputDecoration(
                    prefixIcon: Icon(
                      Icons.location_city,
                      color: Color(0xff2470c7),
                    ),
                    labelText: 'City'),
                textInputAction: TextInputAction.next,
                //textAlign: TextAlign,
              ),
              TextFormField(
                controller: dish1,
                keyboardType: TextInputType.text,
                validator: validateName,
                onSaved: (String val) {
                  dish1.text = val;
                },
                maxLines: 1,
                autofocus: true,
                decoration: InputDecoration(
                    prefixIcon: Icon(
                      Icons.description,
                      color: Color(0xff2470c7),
                    ),
                    labelText: 'dish1'),
                textInputAction: TextInputAction.next,
                //textAlign: TextAlign,
              ),
              TextFormField(
                controller: dish2,
                keyboardType: TextInputType.text,
                validator: validateName,
                onSaved: (String val) {
                  dish2.text = val;
                },
                maxLines: 1,
                autofocus: true,
                decoration: InputDecoration(
                    prefixIcon: Icon(
                      Icons.description,
                      color: Color(0xff2470c7),
                    ),
                    labelText: 'dish2'),
                textInputAction: TextInputAction.next,
                //textAlign: TextAlign,
              ),
              TextFormField(
                controller: dish3,
                keyboardType: TextInputType.text,
                validator: validateName,
                onSaved: (String val) {
                  dish3.text = val;
                },
                maxLines: 1,
                autofocus: true,
                decoration: InputDecoration(
                    prefixIcon: Icon(
                      Icons.description,
                      color: Color(0xff2470c7),
                    ),
                    labelText: 'dish3'),
                textInputAction: TextInputAction.next,
                //textAlign: TextAlign,
              ),
              TextFormField(
                controller: dish4,
                keyboardType: TextInputType.text,
                validator: validateName,
                onSaved: (String val) {
                  dish4.text = val;
                },
                maxLines: 1,
                autofocus: true,
                decoration: InputDecoration(
                    prefixIcon: Icon(
                      Icons.description,
                      color: Color(0xff2470c7),
                    ),
                    labelText: 'dish4'),
                textInputAction: TextInputAction.next,
                //textAlign: TextAlign,
              ),
              UploadPropertyImages(),

              Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Container(
                      width: 200,
                      height: MediaQuery.of(context).size.height / 4,
                      child:  buildGridView(),
                    ),
                    RaisedButton(
                      child: Text("Submit"),
                      onPressed: () async {
                        print(_list.length.toString());
                        if (_key.currentState.validate() && _list.length >0) {
                          _key.currentState.save();
                              Navigator.of(context).pushNamed('/uploadingRestaurant');
                              await addRestaurant();

                              Navigator.pop(context);
                              Navigator.push(context, MaterialPageRoute(builder: (context) => Authenticate()));
                        } else {
                          setState(() {
                            showInSnackBar("Please select image");
                            _validate = true;
                          }
                          );
                        }
                      },
                      textColor: Colors.black,
                      padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                      splashColor: Colors.grey,
                    ),
                  ],
                ),
              ),
            ],
          )),
    );
  }

  Future<bool> addRestaurant() async {
    List<String> values = await GetImageReferences();
    Restaurants restaurants = new Restaurants();
    restaurants.Title = Title.text;
    restaurants.Address = Address.text;
    restaurants.dish1 = dish1.text;
    restaurants.dish2 = dish2.text;
    restaurants.dish3 = dish3.text;
    restaurants.dish4 = dish4.text;
    restaurants.Images = values;
    DataBase().add_restaurant(restaurants);

  }



  Widget buildGridView() {
    return GridView.count(
      crossAxisCount: 3,
      children: List.generate(images.length, (index) {
        Asset asset = images[index];
        return Padding(
          padding: EdgeInsets.all(8.0),
          child: ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(15)),
            child: Container(
              decoration: BoxDecoration(border: Border.all(color: Colors.blueAccent, width: 2)),
              child: AssetThumb(
                asset: asset,
                width: 300,
                height: 300,
              ),
            ),
          ),
          //  ),
        );
      }),
    );
  }

  Widget UploadPropertyImages() {
    return Container(
        child: Center(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  RaisedButton(
                    child: Text("Select Images"),
                      onPressed: () async {
                        List<Asset> asst =  await loadAssets();
                      if (asst.length == 0) {
                          showInSnackBar("No images selected");
                        }
                        else {
                        if (asst != null) {
                          _list =[];
                          print(asst.length.toString() + "asst not null");
                          asst.forEach((_image) async {
                            var _data = await _image.getByteData();
                            var compressed = await FlutterImageCompress.compressWithList(
                              _data.buffer.asUint8List(),
                              minHeight: 500,
                              minWidth: 600,
                            );
                            _list.add(Uint8List.fromList(compressed));
                            print(_list.length.toString() + "_list length in asst else");
                          });
                          showInSnackBar('Images Successfully loaded');
                        }
                      }}),
                ],
              ),
            )));
  }

// ignore: non_constant_identifier_names
  Future<List<String>> GetImageReferences() async {
    String error = "No error detected";
    List<String> urls = <String>[];

    try {
      for (var imageFile in _list) {
        await postImage(imageFile).then((downloadUrl) {
          urls.add(downloadUrl.toString());
          print("i am third line of awaiting post image");
          if (_list.length ==images.length) {
            print(urls.length.toString() + " images selected");

            return urls;

          }
        }).catchError((err) {
          print(err);
        });
      }
    } on Exception catch (e) {
      error = e.toString();
      print(error);
    }
    return urls;
  }



  Future<dynamic> postImage(Uint8List list) async {
    String fileName = DateTime.now().millisecondsSinceEpoch.toString();
    StorageReference reference = FirebaseStorage.instance.ref().child(fileName);
    StorageUploadTask uploadTask = reference.putData(list);
    StorageTaskSnapshot storageTaskSnapshot = await uploadTask.onComplete;
    print(storageTaskSnapshot.ref.getDownloadURL());
    return storageTaskSnapshot.ref.getDownloadURL();

  }

  Future<List<Asset>> loadAssets() async {
    List<Asset> resultList = List<Asset>();
    String error = "No error Detected";
    images= [];

    try {
      resultList = await MultiImagePicker.pickImages(
        maxImages: 10,
        enableCamera: true,
        selectedAssets: images,
        cupertinoOptions: CupertinoOptions(takePhotoIcon: "chats"),
        materialOptions: MaterialOptions(
          actionBarColor: "#abcdef",
          actionBarTitle: "Upload Image",
          allViewTitle: "All Photos",
          useDetailsView: false,
          selectCircleStrokeColor: "#000000",
        ),
      );

      print(resultList.length.toString() + "it is result list");
      print("loadAssets is called");
    } on Exception catch (e) {
     // error = e.toString();
      print(error.toString() + "on catch of load assest");
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) {
      print("Not mounted");
    } else {
      setState(() {
        images = resultList;
      });
    }

    return images;
  }

  // Future<bool> checkAndRequestCameraPermissions() async {
  //   PermissionStatus permission =
  //   await PermissionHandler().checkPermissionStatus(PermissionGroup.camera);
  //   if (permission != PermissionStatus.granted) {
  //     Map<PermissionGroup, PermissionStatus> permissions =
  //     await PermissionHandler().requestPermissions([PermissionGroup.camera]);
  //     return permissions[PermissionGroup.camera] == PermissionStatus.granted;
  //   } else {
  //     return true;
  //   }
  // }






  }

