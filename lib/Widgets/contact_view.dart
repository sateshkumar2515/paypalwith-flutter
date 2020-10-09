import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:videocalling/Screens/ChatScreen.dart';
import 'package:videocalling/Screens/MessaeScreen.dart';
import 'package:videocalling/Widgets/CustomTitle.dart';
import 'package:videocalling/Widgets/LastMessageContainer.dart';
import 'package:videocalling/Widgets/cachedImage.dart';
import 'package:videocalling/Widgets/online_indecator.dart';
import 'package:videocalling/models/contacts.dart';
import 'package:videocalling/models/user.dart';
import 'package:videocalling/ownmethod/constants.dart';
import 'package:videocalling/provider/userProvider.dart';
import 'package:videocalling/utils/firebase_method.dart';

class ContactView extends StatelessWidget {

  final Contact contact;

  final FirebaseMethod _firebaseMethod = FirebaseMethod();

  ContactView(this.contact);



  @override
  Widget build(BuildContext context) {
    return FutureBuilder<User>(
      future: _firebaseMethod.getUserDetailsById(contact.uid),
      builder: (context,snapshot){
        if(snapshot.hasData){
          User user = snapshot.data;

          return ViewLayout(contact: user,);

        }
        return Center(child: Container(
          child: CircularProgressIndicator(),
        ),);
      },

    );
  }
}


class ViewLayout extends StatelessWidget {
  final User contact;
  final FirebaseMethod _firebaseMethod = FirebaseMethod();

   ViewLayout({this.contact});

  @override
  Widget build(BuildContext context) {

    final UserProvider userProvider = Provider.of<UserProvider>(context);


    return CustomTitle(
      mini: false,
      onTap: (){
        Navigator.push(context, MaterialPageRoute(builder: (context)=>MessageScreen(Reciever: contact,)));
      },
      title: Text(contact?.name ?? "..",style: TextStyle(color: Colors.black, fontFamily: "Arial",fontSize: 15.0),),
      subtitle: Text('..'),
      //LastMessageContainer(stream: _firebaseMethod.fetchLastMessageBetween(senderId: userProvider.getUser.uid, receiverId: contact.uid)),
      leading: Container(
        constraints: BoxConstraints(maxHeight: 55,maxWidth: 50),
        child: Stack(
          children: [
//            CircleAvatar(
//              maxRadius: 30.0,
//              backgroundColor: Colors.grey,
//              backgroundImage: NetworkImage("https://cdn.designbump.com/wp-content/uploads/2014/06/cute_doll_pictures-e1481217326463.jpg"),
//
//            ),
          CachedImage(
            contact.profilePhoto,
            radius: 80.0,
            isRound: true,
          ),
           OnlineIndicator(uid: contact.uid,)

          ],
        ),
      ),
    );
  }
}

