import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:videocalling/Screens/HomeScreem.dart';
import 'package:videocalling/Screens/LoginScreen.dart';
import 'package:videocalling/Screens/SearchScreen.dart';
import 'package:videocalling/provider/image_update_provider.dart';
import 'package:videocalling/provider/userProvider.dart';
import 'package:videocalling/utils/firebase_method.dart';
import 'package:videocalling/utils/firebase_repository.dart';
import 'package:provider/provider.dart';
void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  FirebaseRepository _firebaseRepository = FirebaseRepository();


  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_)=>ImageUpdateProvider(),),
        ChangeNotifierProvider(create: (_)=>UserProvider(),),

      ],
      child: MaterialApp(
        initialRoute: '/',
        routes: {
          '/SearchScreen' : (context)=> SearchScreen(),
        },
        debugShowCheckedModeBanner: false,
          title: 'Video Calling',
          theme: ThemeData(

            primarySwatch: Colors.blue,
            visualDensity: VisualDensity.adaptivePlatformDensity,
          ),
          home: FutureBuilder(
            future: _firebaseRepository.getCurrentUser(),
            builder: (context,AsyncSnapshot<FirebaseUser>snapshot){
              if(snapshot.hasData){
                return HomeScreen();
              }else{
                return LoginScreen();

              }

            },
          )
      ),
    );
  }
}
