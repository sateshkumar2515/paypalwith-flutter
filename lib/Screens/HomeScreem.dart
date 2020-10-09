import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';
import 'package:videocalling/Enum/user_state.dart';
import 'package:videocalling/Screens/ChatScreen.dart';
import 'package:videocalling/Screens/pick_up/pickupLayout.dart';
import 'package:videocalling/Screens/pick_up/pickupScreen.dart';
import 'package:videocalling/provider/userProvider.dart';
import 'package:videocalling/utils/firebase_method.dart';
import 'package:videocalling/utils/firebase_repository.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {

  FirebaseRepository _firebaseRepository = FirebaseRepository();
  FirebaseMethod _firebaseMethod = FirebaseMethod();

  PageController pageController;
  int _page= 0;

  UserProvider userProvider;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    SchedulerBinding.instance.addPersistentFrameCallback((_) async{
      userProvider = Provider.of<UserProvider>(context,listen: false);
     await userProvider.refreshUser();

      _firebaseMethod.setUserState(userId: userProvider.getUser.uid, userState: UserState.
      Offline);
    });

    WidgetsBinding.instance.addObserver(this);

    pageController = PageController();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state){

    String currentUserId = (userProvider != null && userProvider.getUser !=null ) ?userProvider.getUser.uid : "";
    super.didChangeAppLifecycleState(state);

    switch(state){
      case AppLifecycleState.resumed :
        currentUserId != null ? _firebaseMethod.setUserState(userId: currentUserId, userState: UserState.Online) : print("resumed State");

        break;
      case AppLifecycleState.inactive :

        currentUserId != null ? _firebaseMethod.setUserState(userId: currentUserId, userState: UserState.
        Offline) : print("Inactive State");


        break;

      case AppLifecycleState.paused :

        currentUserId != null ? _firebaseMethod.setUserState(userId: currentUserId, userState: UserState.Waiting) : print("paused State");

        break;

      case AppLifecycleState.detached :

        currentUserId != null ? _firebaseMethod.setUserState(userId: currentUserId, userState: UserState.
        Offline) : print("detached State");


        break;



    }





  }



  void onPageChanged(int page){
    setState(() {
      _page = page;
    });

  }

  void navigationTapped(int page){
    pageController.jumpToPage(page);
  }



  @override
  Widget build(BuildContext context) {
    return PickupLayout(
      scaffold: Scaffold(
          backgroundColor: Colors.white,
          body: PageView(
            children: [
              Container(child: ChatScreen(),),
              Center(child: Text('Calls Log'),),
              Center(child: Text('Contact Screen'),),
            ],
            controller: pageController,
            onPageChanged: onPageChanged,

            physics: NeverScrollableScrollPhysics(),
          ),
          bottomNavigationBar: Container(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 0.0),
              child: CupertinoTabBar(

                  backgroundColor: Colors.white,
                  items: [
                    BottomNavigationBarItem(
                      icon: Icon(Icons.chat,color: (_page ==0) ? Colors.blue : Colors.grey,),
                      title: Text('Chats',style: TextStyle(fontSize: 10.0,color: (_page==0) ? Colors.blue : Colors.grey),)
                    ),

                    BottomNavigationBarItem(
                        icon: Icon(Icons.call,color: (_page ==1) ? Colors.blue : Colors.grey,),
                        title: Text('Calls',style: TextStyle(fontSize: 10.0,color: (_page==1) ? Colors.blue : Colors.grey),)
                    ),

                    BottomNavigationBarItem(
                        icon: Icon(Icons.contacts,color: (_page ==2) ? Colors.blue : Colors.grey,),
                        title: Text('Contacts',style: TextStyle(fontSize: 10.0,color: (_page==2) ? Colors.blue : Colors.grey),)
                    ),
                  ],
                  currentIndex: _page,
                onTap: navigationTapped,




              ),
            ),
          ),

      ),
    );
  }
}
