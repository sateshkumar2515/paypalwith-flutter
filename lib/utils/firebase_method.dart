import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:videocalling/Enum/user_state.dart';
import 'package:videocalling/models/Message.dart';
import 'package:videocalling/models/contacts.dart';
import 'package:videocalling/models/user.dart';
import 'package:videocalling/ownmethod/own_method.dart';
import 'package:videocalling/provider/image_update_provider.dart';

class FirebaseMethod {

  final FirebaseAuth _auth = FirebaseAuth.instance;
  GoogleSignIn _googleSignIn = GoogleSignIn();
  static final  Firestore _firestore = Firestore.instance;

  static final CollectionReference _userCollection = _firestore.collection('users');
  StorageReference  _storageReference;

  final CollectionReference _messageCollection =
  _firestore.collection('messages');


  User user = User();

  Future<FirebaseUser> getCurrentUser() async {
    FirebaseUser currentUser = await _auth.currentUser();
    return currentUser;
  }

  Future<FirebaseUser> login() async {
    GoogleSignInAccount googleSignInAccount = await _googleSignIn.signIn();
    GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount
        .authentication;

    final AuthCredential = GoogleAuthProvider.getCredential(
        idToken: googleSignInAuthentication.idToken,
        accessToken: googleSignInAuthentication.accessToken);

    AuthResult result = await _auth.signInWithCredential(AuthCredential);
    FirebaseUser user = result.user;

    return user;
  }


  Future<bool> signOut() async {
    try {
      await _googleSignIn.disconnect();
      await _googleSignIn.signOut();

      return true;
    }catch(_){
      return false;
    }

  }

  Future<bool> authenticateUser(FirebaseUser user) async {
    QuerySnapshot result = await _firestore.collection('users').where(
        'email', isEqualTo: user.email).getDocuments();

    final List<DocumentSnapshot> docs = result.documents;

    return docs.length == 0 ? true : false;
  }

  
  Future<void> saveDataTofirebase(FirebaseUser currentUser) async {
    String userName = OwnMethod.getCurrentUsername(currentUser.email);

    user = User(
        uid: currentUser.uid,
        email: currentUser.email,
        name: currentUser.displayName,
        profilePhoto: currentUser.photoUrl,
        username: userName
    );

    _firestore.collection("users").document(currentUser.uid).setData(
        user.toMap(user));
  }


  Future<List<User>> getUserList(FirebaseUser currentUser) async {
    List<User> userList = List<User>();

    QuerySnapshot querySnapshot =  await _firestore.collection('users').getDocuments();

    for (var i=0 ; i < querySnapshot.documents.length; i++){

      if(querySnapshot.documents[i].documentID != currentUser.uid){
        userList.add(User.fromMap(querySnapshot.documents[i].data));
      }
    }
    return userList;

  }



  Future<void> addMessageToDb({Message message, User sender,User receiver})async{

    var map = message.toMap();

    await _firestore.collection("messages").document(message.senderId).collection(message.receiverId).add(map);


    addToContacts(senderId: message.senderId,receiverId: message.receiverId);

   return await _firestore.collection("messages").document(message.receiverId).collection(message.senderId).add(map);

  }

  DocumentReference getContactsDocument({String of,String forContacts }) => _userCollection.document(of).collection('contacts').document(forContacts);

  addToContacts({String senderId, String receiverId})async{

    Timestamp currentTime = Timestamp.now();

    await addToSenderContacts(senderId: senderId,receiverId : receiverId,currentTime:currentTime);
    await addToReceiverContacts(senderId : senderId, receiverId: receiverId,currentTime: currentTime);


  }


  Future<void> addToSenderContacts({String senderId,String receiverId,currentTime})async{
    DocumentSnapshot senderSnapshot = await getContactsDocument(of: senderId,forContacts: receiverId).get();

    if(!senderSnapshot.exists){
      //document doesnot exist
      Contact receiverContact = Contact(
        uid: receiverId,
        addedOn: currentTime
      );
      var receiverMap = receiverContact.toMap(receiverContact);

      await getContactsDocument(of: senderId,forContacts: receiverId).setData(receiverMap);
    }
  }


  Future<void> addToReceiverContacts({String senderId,String receiverId,currentTime})async{
    DocumentSnapshot receiverSnapshot = await getContactsDocument(of: receiverId ,forContacts: senderId).get();

    if(!receiverSnapshot.exists){
      //document doesnot exist
      Contact senderContact = Contact(
          uid: senderId,
          addedOn: currentTime
      );
      var senderMap = senderContact.toMap(senderContact);

      await getContactsDocument(of: receiverId,forContacts: senderId).setData(senderMap);
    }
  }



  Future<String>uploadImageToStorage(File image)async{
    try{
      _storageReference = FirebaseStorage.instance.ref().child('${DateTime.now().millisecondsSinceEpoch}');

      StorageUploadTask storageUploadTask = _storageReference.putFile(image);

      var url =await (await storageUploadTask.onComplete).ref.getDownloadURL();

      return url;

    }catch(e){
      print(e);
      return null;
    }
  }


  Future<User> getUserDetails()async{
    FirebaseUser currentUser = await getCurrentUser();
   DocumentSnapshot documentSnapshot =  await _userCollection.document(currentUser.uid).get();

   return User.fromMap(documentSnapshot.data);

  }

  Future<User>getUserDetailsById(id)async{
    try{

      DocumentSnapshot documentSnapshot = await _userCollection.document(id).get();

      return User.fromMap(documentSnapshot.data);
    }catch(e){
      print(e);
      return null;
    }

  }





  void uploadImage(File image,String senderId,String receiverId,ImageUpdateProvider imageUpdateProvider)async{

    imageUpdateProvider.setToLoading();

    String url = await uploadImageToStorage(image);

    imageUpdateProvider.setToIdle();

    setImageMessage(url,senderId,receiverId);
  }

  void setImageMessage(String url,String senderId,String receiverId)async{

    Message message;
    message = Message.imageMessage(
      senderId: senderId,
      receiverId: receiverId,
      type: 'image',
      timestamp: Timestamp.now(),
      photoUrl: url,
      message: 'Image'
    );

    var map = message.toImageMap();


    await _firestore.collection("messages").document(message.senderId).collection(message.receiverId).add(map);

     await _firestore.collection("messages").document(message.receiverId).collection(message.senderId).add(map);

  }


  Stream<QuerySnapshot> fetchContacts({String userId}) => _userCollection.document(userId).collection('contacts').snapshots();

  Stream<QuerySnapshot> fetchLastMessageBetween({@required String senderId,@required String receiverId}) => _messageCollection.document(senderId).collection(receiverId).orderBy('timestamp').snapshots();


  void setUserState({@required String userId, @required UserState userState}){
    int stateNum = OwnMethod.stateToNum(userState);
    _userCollection.document(userId).updateData({
      'state' : stateNum
    });
  }

  Stream<DocumentSnapshot> getUserStream({@required String uid}) =>_userCollection.document(uid).snapshots();




}