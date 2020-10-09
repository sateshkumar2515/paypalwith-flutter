import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:videocalling/Screens/LoginScreen.dart';
import 'package:videocalling/Widgets/appBar.dart';
import 'package:videocalling/Widgets/cachedImage.dart';
import 'package:videocalling/Widgets/shimmer_logo.dart';
import 'package:videocalling/models/user.dart';
import 'package:videocalling/provider/userProvider.dart';
import 'package:videocalling/utils/firebase_method.dart';
import 'package:videocalling/utils/firebase_repository.dart';

class UserDetailsContainer extends StatelessWidget {
  FirebaseRepository _firebaseRepository = FirebaseRepository();



  @override
  Widget build(BuildContext context) {

    signout()async{
      final bool isLoggedOut =  await _firebaseRepository.signOut();

      if(isLoggedOut){
        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>LoginScreen()), (Route<dynamic> route) => false);
    }
    }


    return Container(
      margin: EdgeInsets.only(top: 25.0),
      child: Column(
        children: [
          CustomAppBar(
            leading: IconButton(
              icon: Icon(Icons.arrow_back),
              color: Colors.black,
              onPressed: ()=> Navigator.pop(context),
            ),
            centerTitle: true,
            title: ShimmerLogo(),
            actions: [
              FlatButton(
                onPressed: ()=> signout(),
                child: Text(
                  'Sign Out',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 12.0,
                  ),
                ),
              ),
            ],

          ),
          userDetailedBody(),
        ],
      ),
    );
  }
}



class userDetailedBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final UserProvider userProvider = Provider.of<UserProvider>(context);
    final User user = userProvider.getUser;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20,vertical: 20),
      child: Row(
        children: [
          CachedImage(
            user.profilePhoto,
            isRound: true,
            radius: 50.0,
          ),
          SizedBox(
            width: 15.0,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(user.name,style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18.0,
                color: Colors.black
              ),),
              SizedBox(
                height: 10.0,
              ),
              Text(user.email,
              style: TextStyle(
                fontSize: 14.0,
                color: Colors.black
              ),)
            ],
          )
        ],
      ),

      
    );
  }
}
