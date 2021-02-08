import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demo_app/models/restaurants.dart';
import 'package:demo_app/models/user.dart';

class DataBase{
  String data = "https://thumbs.dreamstime.com/b/user-profile-avatar-icon-134114292.jpg";
  final Firestore _firestore = Firestore.instance;
  Future<String> createUser(User user) async{
    String retVal ='error';
    try{
      await _firestore.collection('users').document(user.uid).setData({
        'displayName' : user.displayName,
        'phoneNumber' : user.phoneNumber,
        'uid':user.uid,
        'avatarUrl':data,
        'UserType' : "user",
        'accountCreated' : Timestamp.now(),

      });
      print("success new user added in firebase!");
      retVal='Success';
    }
    catch(e)
    {
      print(e);
    }
    return retVal;
  }

  Future<String> updateUser(User user) async{
    String retVal ='error';
    try{
      await _firestore.collection('users').document(user.uid).updateData({
        'displayName' : user.displayName,
        'uid':user.uid,
        'avatarUrl':data,
        'UserType' : "user",

      });
      print("success new user updated in firebase!");
      retVal='Success';
    }
    catch(e)
    {
      print(e);
    }
    return retVal;
  }

  Future<bool> checkUser(String uid) async{
    DocumentSnapshot _docSnapshot =  await _firestore.collection("users").document(uid).get();
    if(_docSnapshot.data !=null){
      return true;
    }
    else{
      return false;
    }


  }


  void add_restaurant(Restaurants restaurants)async {
    await _firestore.collection('restaurants').add({
      'title': restaurants.Title,
      'address': restaurants.Address,
      'city': restaurants.City.toUpperCase(),
      'imagesUrls': restaurants.Images,
      'dish1': restaurants.dish1,
      'dish2': restaurants.dish2,
      'dish3': restaurants.dish3,
      'dish4': restaurants.dish4,

    }).then((value) {
      _firestore.collection("restaurants").document(value.documentID).setData({
        "restId": value.documentID,
      }, merge: true).then((_) {
        print("success!" + value.documentID);
      });
    });
  }


}