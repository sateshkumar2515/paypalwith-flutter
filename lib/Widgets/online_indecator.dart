import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image/image.dart';
import 'package:videocalling/Enum/user_state.dart';
import 'package:videocalling/models/user.dart';
import 'package:videocalling/ownmethod/own_method.dart';
import 'package:videocalling/utils/firebase_method.dart';

class OnlineIndicator extends StatelessWidget {

  final String uid;
  FirebaseMethod firebaseMethod = FirebaseMethod();

  OnlineIndicator({this.uid});

  @override
  Widget build(BuildContext context) {

    getColor(int state){
      switch(OwnMethod.numToState(state)){

        case UserState.Offline: return Colors.red;
        case UserState.Online: return Colors.green;
        default:return Colors.orange;

      }
    }



    return StreamBuilder<DocumentSnapshot>(
      stream:firebaseMethod.getUserStream(uid: uid),
      builder: (context,snapshot){
        User user;
        if(snapshot.hasData && snapshot.data.data != null){
          user = User.fromMap(snapshot.data.data);
        }
        return Container(
          width: 10,
          height: 10,
          margin: EdgeInsets.only(right: 8,top: 8),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: getColor(user?.state)
          ),
        );
      },
    );
  }
}
