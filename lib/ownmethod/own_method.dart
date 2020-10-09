  import 'dart:io';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image/image.dart' as Im;
import 'package:path_provider/path_provider.dart';
import 'package:videocalling/Enum/user_state.dart';

class OwnMethod{

  static getCurrentUsername(String email){
    return "Live:${email.split('@')[0]}";

  }


  static String getInitials(String name){
    List<String> nameSplit = name.split(' ');
    String firstNameInitial = nameSplit[0][0];
    String secondNameInitial = nameSplit[1][0];

    return firstNameInitial + secondNameInitial;
  }


  static Future<File> pickImage(@required ImageSource source) async{
   File selectedImage =  await ImagePicker.pickImage(source: source);
    return compressImage(selectedImage);
  }

  static Future<File> compressImage(File imageToCompress)async{
    final temp = await getTemporaryDirectory();
    final path = temp.path;
    int random = Random().nextInt(10000);
    Im.Image image = Im.decodeImage(imageToCompress.readAsBytesSync());
    Im.copyResize(image,width: 500,height: 500);
    return File('$path/img_$random.jpg')..writeAsBytesSync(Im.encodeJpg(image,quality: 85));
    
  }


  static int stateToNum(UserState userState){

    switch(userState) {
      case UserState.Offline :
        return 0;

      case UserState.Online :
        return 1;

      default :
        return 2;
    }
  }

  static UserState numToState(int number){
    switch(number) {
      case 0 : return UserState.Offline;
      case 1 : return UserState.Online;
      default : UserState.Waiting;


    }

  }

  }