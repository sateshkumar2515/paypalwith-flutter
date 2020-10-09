import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:videocalling/Widgets/user_details_container.dart';
import 'package:videocalling/models/user.dart';
import 'package:videocalling/ownmethod/constants.dart';
import 'package:videocalling/ownmethod/own_method.dart';
import 'package:videocalling/provider/userProvider.dart';

class userCircle extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final UserProvider userProvider = Provider.of<UserProvider>(context);

    return GestureDetector(
      onTap: ()=> showModalBottomSheet(context: context,
          builder: (context)=>UserDetailsContainer(),isDismissible: true,backgroundColor: Colors.white),
      child: Container(
        height: 40.0,
        width: 40.0,
        decoration: BoxDecoration(
          borderRadius :BorderRadius.circular(50.0),
          color: Color(0xFFECF0F1),
        ),
        child: Stack(
          children: [
            Align(
              alignment: Alignment.center,
              child: Text(OwnMethod.getInitials(userProvider.getUser.name),style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 13.0,
                  color: Colors.lightBlue
              ),),
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: Container(
                width: 12.0,
                height: 12.0,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                        color: Colors.white,
                        width: 2
                    ),
                    color: Constants.onlineDotColor
                ),
              ),
            )
          ],
        ),

      ),
    );
  }
}