import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:videocalling/models/Message.dart';
import 'package:videocalling/models/user.dart';
import 'package:videocalling/provider/image_update_provider.dart';
import 'package:videocalling/utils/firebase_method.dart';

class FirebaseRepository{

  FirebaseMethod _firebaseMethod = FirebaseMethod();

  Future<FirebaseUser> getCurrentUser() => _firebaseMethod.getCurrentUser();

  Future<FirebaseUser> loginUser()=> _firebaseMethod.login();

  Future<bool> authenticateUser(FirebaseUser user) => _firebaseMethod.authenticateUser(user);

  Future<void> saveDataTofirebase(FirebaseUser user)=>_firebaseMethod.saveDataTofirebase(user);

  Future<bool> signOut() => _firebaseMethod.signOut();

  Future<User> getUserDetails()=>_firebaseMethod.getUserDetails();
  
  Future<List<User>> getUserList(FirebaseUser fUser)=> _firebaseMethod.getUserList(fUser);


  Future<void>addMessageToDb(Message massage,User sender,User receiver) => _firebaseMethod.addMessageToDb(message: massage,sender: sender,receiver: receiver);


  void uploadImage({
    @required File image,
    @required String senderId,
    @required String receiverId,
    @required ImageUpdateProvider imageUpdateProvider
  })=> _firebaseMethod.uploadImage(
    image,senderId,receiverId,imageUpdateProvider
  );


}

