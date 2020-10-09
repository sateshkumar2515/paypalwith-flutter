import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gradient_app_bar/gradient_app_bar.dart';
import 'package:videocalling/Screens/MessaeScreen.dart';
import 'package:videocalling/Widgets/CustomTitle.dart';
import 'package:videocalling/models/user.dart';
import 'package:videocalling/ownmethod/constants.dart';
import 'package:videocalling/utils/firebase_repository.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}


class _SearchScreenState extends State<SearchScreen> {

  FirebaseRepository _repository = FirebaseRepository();
  List<User> userList;
  String qurey = "";
  TextEditingController searchController = TextEditingController();


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _repository.getCurrentUser().then((FirebaseUser guser){
      _repository.getUserList(guser).then((List<User> list){

        setState(() {
          userList = list;
        });

      });
    });
  }
  searchBar(BuildContext context){
    return GradientAppBar(
      gradient: LinearGradient(colors: [Constants.gradientColorStart,Constants.gradientColorEnd]),
      leading: IconButton(icon:  Icon(Icons.arrow_back),onPressed: ()=>Navigator.pop(context),),
      elevation: 0.0,
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight +10),
        child: Padding(
          padding: EdgeInsets.only(left: 20.0),
          child: TextField(
            controller: searchController,
            onChanged: (value){
              setState(() {
                qurey = value;
              });
            },
            cursorColor: Colors.white,
            autofocus: true,
            style: TextStyle(
              fontWeight: FontWeight.bold,
                  fontSize: 35.0,
              color: Color(0xFFECF0F1)

            ),
            decoration: InputDecoration(
              suffixIcon: IconButton(
                icon: Icon(Icons.close,color: Colors.white,),
                onPressed: () {
                    WidgetsBinding.instance.addPostFrameCallback((_) => searchController.clear());
                  },
              ),
              border: InputBorder.none,
              hintText: 'Search',
                hintStyle: TextStyle(
                fontWeight: FontWeight.bold,
                  fontSize: 30.0,
                    color: Color(0xFFECF0F1),
            )

            ),
          ),
        ),
      ),

    );

  }

  buildSuggestions(String searchText){
    final List<User> suggestionList = searchText.isEmpty ? [] : userList.where((User user) {
      String _getUserName = user.username.toLowerCase();
      String _qurey = searchText.toLowerCase();
      String name = user.name.toLowerCase();
      bool matchesUsername = _getUserName.contains(_qurey);
      bool matchesName= _getUserName.contains(_qurey);

      return (matchesUsername || matchesName);

    }).toList();
    return ListView.builder(

        itemCount: suggestionList.length,
        itemBuilder: (context,index){
        User seachedUser  = User(
          uid: suggestionList[index].uid,
          profilePhoto: suggestionList[index].profilePhoto,
          name : suggestionList[index].name,
          username: suggestionList[index].username
        );
        return CustomTitle(
          mini: false,
          onTap: (){
            Navigator.push(context, MaterialPageRoute(builder: (context)=> MessageScreen(Reciever: seachedUser,)));
          },
          leading: CircleAvatar(
            backgroundColor: Colors.grey,
            backgroundImage: NetworkImage(seachedUser.profilePhoto),
          ),
          title: Text(seachedUser.username,style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),),
          subtitle: Text(seachedUser.name,style: TextStyle(color: Colors.grey),),
        );
        }
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: searchBar(context),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: buildSuggestions(qurey),
      ),
    );
  }
}
