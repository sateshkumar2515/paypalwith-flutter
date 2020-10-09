import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:videocalling/Widgets/CustomTitle.dart';
import 'package:videocalling/Widgets/contact_view.dart';
import 'package:videocalling/Widgets/quiet_Box.dart';
import 'package:videocalling/models/contacts.dart';
import 'package:videocalling/models/user.dart';
import 'package:videocalling/ownmethod/constants.dart';
import 'package:videocalling/provider/userProvider.dart';
import 'package:videocalling/utils/firebase_method.dart';
import 'package:videocalling/utils/firebase_repository.dart';

class ChatListContainer extends StatelessWidget {

  final FirebaseMethod _firebaseMethod = FirebaseMethod();


  @override
  Widget build(BuildContext context) {
  final UserProvider userProvider = Provider.of<UserProvider>(context);
  return


    Container(
      child: StreamBuilder<QuerySnapshot>(
        stream: _firebaseMethod.fetchContacts(userId: userProvider.getUser.uid),
        builder: (context, snapshot) {
          if(snapshot.hasData){
            var docList = snapshot.data.documents;
            if(docList.isEmpty){
              return QuietBox();
            }return ListView.builder(

              padding: EdgeInsets.all(10.0),
              itemCount:  docList.length,
              itemBuilder: (context,index){
                Contact contact = Contact.fromMap(docList[index].data);

                return ContactView(contact);
              },
            );
          }
          return Center(child: Container(
            child: CircularProgressIndicator(),
          ),);

        }
      )
  );
  }
}
