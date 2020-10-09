import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
//import 'package:emoji_picker/emoji_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:videocalling/Enum/view_state.dart';
import 'package:videocalling/Widgets/ChatListContainer.dart';
import 'package:videocalling/Widgets/appBar.dart';
import 'package:videocalling/Widgets/cachedImage.dart';
import 'package:videocalling/Widgets/modalTitle.dart';
import 'package:videocalling/models/Message.dart';
import 'package:videocalling/models/user.dart';
import 'package:videocalling/ownmethod/callUtils.dart';
import 'package:videocalling/ownmethod/constants.dart';
import 'package:videocalling/ownmethod/own_method.dart';
import 'package:videocalling/provider/image_update_provider.dart';
import 'package:videocalling/utils/firebase_repository.dart';
import 'package:videocalling/utils/permission.dart';

class MessageScreen extends StatefulWidget {
  final User Reciever;


  const MessageScreen({Key key, this.Reciever}) : super(key: key);

  @override
  _MessageScreenState createState() => _MessageScreenState();
}


class _MessageScreenState extends State<MessageScreen> {


  ImageUpdateProvider _imageUpdateProvider;


  FirebaseRepository _firebaseRepository = FirebaseRepository();
  bool emojiContainer= false;

  bool isWritting = false;
  User sender;
  String _currentUserId;


  ScrollController listScrolController = ScrollController();

  TextEditingController textEditingController = TextEditingController();

  FocusNode focusNode = FocusNode();

    showKeyboard()=> focusNode.requestFocus();

  hideKeyboard()=> focusNode.unfocus();

  hideemojiContainer(){
    setState(() {
      emojiContainer = false;
    });
  }


  showemojiContainer(){
    setState(() {
      emojiContainer = true;
    });
  }


    @override
    void initState(){
      super.initState();

      _firebaseRepository.getCurrentUser().then((user){
        _currentUserId = user.uid;

        setState(() {
          sender = User(
              uid: user.uid,
              name: user.displayName,
              profilePhoto: user.photoUrl
          );
        });



      });


  }

  CustomAppBar customAppBar(BuildContext context){
    return CustomAppBar(
      leading: IconButton(
        icon: Icon(Icons.arrow_back,color: Colors.black54,),onPressed: (){Navigator.pop(context);},),

        title: Text(widget.Reciever.name,style: TextStyle(color: Colors.black,fontSize: 18.0),),
        actions: [
          IconButton(
            icon: Icon(Icons.videocam,color: Colors.black54,),
            onPressed: ()async{
              await Permissions.cameraAndMicrophonePermissionsGranted() ?
              CallUtilis.dial(
                from: sender,
                to: widget.Reciever,
                context: context
              ): {};
            },
          ),
          IconButton(
            icon: Icon(Icons.phone,color: Colors.black54,),
            onPressed: (){},
          ),
        ],
    );

  }




  @override
  Widget build(BuildContext context) {

    _imageUpdateProvider = Provider.of<ImageUpdateProvider>(context);


    return Scaffold(
      backgroundColor: Colors.white,
      appBar: customAppBar(context),
      body: Column(
        children: [
          Flexible(
            child: messageList(),
          ),
          _imageUpdateProvider.getViewState == ViewState.LOADING ? Container(
            alignment: Alignment.centerRight,
            margin: EdgeInsets.only(right: 15.0),
              child: CircularProgressIndicator(),

          ) : Container(),

          chatControls(),
//          emojiContainer ? Container(child: keyEmojiContainer(),): Container()
        ],
      ),
    );
  }


//  keyEmojiContainer(){
//  return EmojiPicker(
//    bgColor: Constants.separatorColor,
//    indicatorColor: Constants.blueColor,
//    rows: 3,
//    columns: 7,
//    recommendKeywords: ["face","happy","party","sad"],
//    numRecommended: 50,
//    onEmojiSelected: (emoji,category){
//      setState(() {
//        isWritting = true;
//      });
//
//      textEditingController.text = textEditingController.text + emoji.emoji;
//    },
//  );
//  }



  Widget messageList(){
    return StreamBuilder(
      stream: Firestore.instance.collection("messages").document(_currentUserId).collection(widget.Reciever.uid).orderBy('timestamp',descending: true).snapshots(),
      builder: (context,AsyncSnapshot<QuerySnapshot>snapshot){
        if(snapshot.data == null){
          return Center(child: CircularProgressIndicator(),);
        }


        // for scroll down method.
        SchedulerBinding.instance.addPostFrameCallback((_) {
          listScrolController.animateTo(
            listScrolController.position.minScrollExtent,
            duration: Duration(milliseconds: 250),
            curve: Curves.easeInOut,
          );
        });

        return ListView.builder(
          reverse: true,
            controller: listScrolController,
            padding: EdgeInsets.all(10),
            itemCount: snapshot.data.documents.length,
            itemBuilder: (context,index){
             return ChatMessageItem(snapshot.data.documents[index]);
            });
      },
    );
  }

  sendmessage(){
    var text = textEditingController.text;

    var _message = Message(

      receiverId: widget.Reciever.uid,
      senderId: _currentUserId,
      message: text,
      timestamp: Timestamp.now(),
      type: 'text'
    );

    setState(() {
      isWritting =false;
    });


    textEditingController.text = "";

     _firebaseRepository.addMessageToDb(_message,sender,widget.Reciever);


  }

  Widget ChatMessageItem(DocumentSnapshot snapshot){

      Message message = Message.fromMap(snapshot.data);
    return Container(
      margin: EdgeInsets.symmetric(vertical: 15),
      alignment: message.senderId == _currentUserId ? Alignment.centerRight : Alignment.centerLeft ,

      child: message.receiverId == _currentUserId ? senderLayout(message) : recieverLayout(message),
    );
  }

  Widget senderLayout(Message message){
    Radius messageRadius = Radius.circular(10);

    return Container(
      margin: EdgeInsets.only(top:10),
      constraints: BoxConstraints(
        maxWidth: MediaQuery.of(context).size.width*0.65
      ),
      decoration: BoxDecoration(
        color: Constants.senderColor,
        borderRadius: BorderRadius.only(
          topLeft: messageRadius,
              topRight: messageRadius,
          bottomLeft: messageRadius
        ),
      ),
      child: Padding(
        padding: EdgeInsets.all(10),
        child: getMessage(message),
      ),
    );
  }

  getMessage(Message message){

      return  (message.type == "image") ? CachedImage(message.photoUrl,width: 250,height: 250,radius: 10,) : Text(message.message,style: TextStyle(
        color: Colors.white,fontSize: 16.0
      ),);
  }



  Widget recieverLayout(Message message){
    Radius messageRadius = Radius.circular(10);

    return Container(
      margin: EdgeInsets.only(top:10),
      constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width*0.65
      ),
      decoration: BoxDecoration(
        color: Constants.receiverColor,
        borderRadius: BorderRadius.only(
            bottomRight: messageRadius,
            topRight: messageRadius,
            bottomLeft: messageRadius
        ),
      ),
      child: Padding(
        padding: EdgeInsets.all(10),
        child: getMessage(message),
      ),
    );
  }

  pickImage({@required ImageSource source})async{
    File selectImage = await OwnMethod.pickImage(source);
    _firebaseRepository.uploadImage(image: selectImage,senderId: _currentUserId, receiverId : widget.Reciever.uid, imageUpdateProvider: _imageUpdateProvider);
  }



  Widget chatControls(){
    setWrittingTo(bool val){
      setState(() {
        isWritting = val;
      });
    }

    addMediaPhoto(context){

      showModalBottomSheet(

          context: context, builder: (context){
          return Column(
            children: [
              Container(
                padding: EdgeInsets.symmetric(vertical: 15.0),
                child: Row(
                  children: [
                    FlatButton(
                      child: Icon(
                        Icons.close
                      ),
                      onPressed: (){
                        Navigator.pop(context);

                      },
                    ),
                    Expanded(
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Contect and Tools",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                            fontWeight: FontWeight.bold
                          ),

                        ),
                      ),
                    ),

                  ],
                ),
              ),
              Flexible(
                child: ListView(
                  children: [
                    ModalTitle(
                      title: "Media",
                      subtitle: "Shares Photos and Videos",
                      icon: Icons.image,
                      onpressed: () => pickImage(source: ImageSource.gallery),
                    ),
                    ModalTitle(
                      title: "File",
                      subtitle: "Share files",
                      icon: Icons.tab,
                    ),
                    ModalTitle(
                      title: "Contacts",
                      subtitle: "Share Contacts",
                      icon: Icons.contacts,
                    ),
                    ModalTitle(
                      title: "Location",
                      subtitle: "Share a Location",
                      icon: Icons.add_location,
                    ),
                    ModalTitle(
                      title: "Schedule Call",
                      subtitle: "Arrange a skype Call and get remiders",
                      icon: Icons.schedule,
                    ),
                    ModalTitle(
                      title: "Create Poll",
                      subtitle: "Share polls",
                      icon: Icons.poll,
                    )
                  ],
                ),
              )
            ],
          );
      });
    }

  return Container(
    padding: EdgeInsets.all(10.0),
    child: Row(
      children: [
        GestureDetector(
          onTap: (){
            addMediaPhoto(context);
          },
          child: Container(
            padding: EdgeInsets.all(5),
            decoration: BoxDecoration(
              gradient: Constants.fabGradient,
              shape: BoxShape.circle
            ),
            child: Icon(Icons.add,color: Colors.white,),
          ),
        ),
        SizedBox(width: 5,),
        Expanded(
          child: Stack(
            alignment: Alignment.centerRight,
            children: [

            TextField(
              onTap: (){
                hideemojiContainer();
              },
              focusNode: focusNode,
              controller: textEditingController,
              style: TextStyle(
                  color: Colors.black
              ),
              onChanged: (value){
                (value.length>0 && value.trim() != "") ? setWrittingTo(true) :setWrittingTo(false);
              },
              decoration: InputDecoration(
                hintText: 'Type a message',
                hintStyle: TextStyle(
                    color: Colors.grey
                ),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(50.0,),
                    borderSide: BorderSide.none
                ),
                contentPadding: EdgeInsets.symmetric(horizontal: 20,vertical: 5),
                filled: true,
                fillColor: Color(0xFFF0F3F4),

              ),

            ),
            IconButton(
              onPressed: (){
                if(!emojiContainer){
                  hideKeyboard();
                  showemojiContainer();
                }else {
                  showKeyboard();
                  hideemojiContainer();
                }

              },
              icon: Icon(Icons.tag_faces,color: Colors.black54,),
            ),

          ],
          ),
        ),
        isWritting ? Container(): Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.0),
          child: Icon(Icons.record_voice_over,color: Colors.black54,),
        ),

        isWritting ? Container():GestureDetector(child: Icon(Icons.camera_alt,color: Colors.black54,),onTap: (){
          pickImage( source: ImageSource.camera,);
        },),
        isWritting ? Container(margin: EdgeInsets.only(left: 10.0),
        decoration: BoxDecoration(
          gradient: Constants.fabGradient,
          shape: BoxShape.circle,
        ),
          child: IconButton(
            icon: Icon(Icons.send,size: 15.0,color: Colors.white,),
            onPressed: (){
              sendmessage();
            },
          ),
        ) : Container()
      ],
    ),

  );
  }
}
