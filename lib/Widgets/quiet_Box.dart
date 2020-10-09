import 'package:flutter/material.dart';
import 'package:videocalling/Screens/SearchScreen.dart';
import 'package:videocalling/ownmethod/constants.dart';

class QuietBox extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal:25),
        child: Container(

          padding: EdgeInsets.symmetric(vertical: 35.0,horizontal: 25.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text('This is where all the contacts are listed',
              textAlign: TextAlign.center,
                style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 30
              ),),
              SizedBox(
                height: 25.0,
              ),
              Text(
                'Search for your friends and family to start calling or chatting with them',
                textAlign: TextAlign.center,
                style: TextStyle(
                  letterSpacing: 1.2,
                  fontWeight: FontWeight.normal,
                  fontSize: 18.0
                ),
              ),
              SizedBox(
                height: 25.0,
              ),
              FlatButton(
                color: Constants.lightBlueColor,
                child: Text('START SEARCHING',style: TextStyle(color: Colors.white),),
                  onPressed: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context)=> SearchScreen()));
                  },
              )

            ],
          ),
        ),
      ),

    );
  }
}
