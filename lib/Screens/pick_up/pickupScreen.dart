import 'package:flutter/material.dart';
import 'package:videocalling/Screens/callScreens.dart';
import 'package:videocalling/Widgets/cachedImage.dart';
import 'package:videocalling/models/call.dart';
import 'package:videocalling/utils/callsMethod.dart';
import 'package:videocalling/utils/permission.dart';


class pickupScreen extends StatelessWidget {

  final Call call;

  final CallMethods callmethods = CallMethods();

   pickupScreen({@required this.call,});



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(vertical: 100),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Incomming",style: TextStyle(
              fontSize: 30.0
            ),),
            SizedBox(
              height: 50.0,
            ),
            CachedImage(call.callerPic,
              isRound: true,
              radius: 180,

            ),
            SizedBox(
              height: 15.0,
            ),
            Text(call.callerName,style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20.0,
            ),),
            SizedBox(height: 75,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: Icon(Icons.call_end,color: Colors.redAccent,),
                  onPressed: () async{
                    await callmethods.endCall(call);
                  },
                ),
                SizedBox(
                  width: 25.0,
                ),
                IconButton(
                  icon: Icon(Icons.call),
                  color: Colors.green,
                  onPressed: ()async{
                   await Permissions.cameraAndMicrophonePermissionsGranted() ? Navigator.push(context, MaterialPageRoute(builder: (context)=>CallScreen(call:call))) : {};
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
