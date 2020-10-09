import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:videocalling/Screens/HomeScreem.dart';
import 'package:videocalling/ownmethod/constants.dart';
import 'package:videocalling/utils/firebase_repository.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  FirebaseRepository _repository = FirebaseRepository();
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body:  Stack(
          children: [
            Center(child: LoginButton()),
            isLoading ? Center(child: CircularProgressIndicator(
              backgroundColor: Colors.blueGrey,

            )) : Container(),
          ],),
    );
  }

  Widget LoginButton(){
    return Padding(
      padding: const EdgeInsets.all(35.0),
      child: Shimmer.fromColors(
        baseColor: Colors.white,
        highlightColor: Colors.black,
        child: FlatButton(
          child: Text("Login",style: TextStyle(
              color: Colors.black,
              fontSize: 35.0,
              fontWeight: FontWeight.w900,
              letterSpacing: 1.2
          ),),
          onPressed: ()=>createLogin(),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0)
          ),
        ),
      ),
    );
  }


  void createLogin(){

    setState(() {
      isLoading = true;
    });


    _repository.loginUser().then((FirebaseUser user) {
      if(user!= null){
        authenticateUser(user);

      }else{
        print("Failed to login with google");
      }

    });

  }
  
  
  void authenticateUser(FirebaseUser user){
    setState(() {
      isLoading = false;
    });
    _repository.authenticateUser(user).then((value){
      if(value){
        _repository.saveDataTofirebase(user).then((value){
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>HomeScreen()));
        });

      }else {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>HomeScreen()));

    }
    });
  }


}
