import 'package:flutter/material.dart';
import 'package:videocalling/Widgets/ChatListContainer.dart';
import 'package:videocalling/Widgets/appBar.dart';
import 'package:videocalling/Widgets/userCircle.dart';

class ChatScreen extends StatelessWidget {


  CustomAppBar customAppBar(BuildContext context){
    return CustomAppBar(
      centerTitle: true,
      title: userCircle(),
      leading: IconButton(icon :  Icon(Icons.notifications_none,color: Colors.black,),onPressed: (){},),
      actions: [
        IconButton(icon:Icon(Icons.search,color: Colors.black,),onPressed: (){
          Navigator.pushNamed(context, '/SearchScreen');
        }),
        IconButton(icon:Icon(Icons.more_vert,color: Colors.black,),onPressed: (){}),


      ],

    );

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: customAppBar(context),
      floatingActionButton: FloatingActionButton(
        onPressed: (){},
        child: IconButton(
          icon: Icon(Icons.edit,color: Colors.white,),
        ),

      ),
      body: ChatListContainer(),




    );
  }
}


