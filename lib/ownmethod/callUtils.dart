import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:videocalling/Screens/callScreens.dart';
import 'package:videocalling/models/call.dart';
import 'package:videocalling/models/user.dart';
import 'package:videocalling/utils/callsMethod.dart';

class CallUtilis{

  static final CallMethods calMethods = CallMethods();

  static dial({User from, User to, context})async{
    Call call = Call(
      callerId: from.uid,
      callerName: from.name,
      callerPic: from.profilePhoto,
      receiverId: to.uid,
      receiverName: to.name,
      receiverPic: to.profilePhoto,
      channelId: Random().nextInt(1000).toString(),

    );

    bool callMade = await calMethods.makeCall(call);
    call.hasDialled = true;

    if(callMade){
      
      Navigator.push(context, MaterialPageRoute(builder: (context)=> CallScreen(call: call,)));
      
    }
  }

}