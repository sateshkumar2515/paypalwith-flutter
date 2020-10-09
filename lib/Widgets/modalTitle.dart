import 'package:flutter/material.dart';
import 'package:videocalling/Widgets/CustomTitle.dart';
import 'package:videocalling/ownmethod/constants.dart';


class ModalTitle extends StatelessWidget {
    final String title;
    final String subtitle;
    final IconData icon;
    final Function onpressed;

  const ModalTitle({Key key, this.title, this.subtitle, this.icon, this.onpressed}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15.0),
      child: CustomTitle(
        onTap: onpressed,
        mini: false,
        leading: Container(
          margin: EdgeInsets.only(right: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: Constants.receiverColor
          ),
          padding: EdgeInsets.all(10),
          child: Icon(
            icon,
            color: Colors.grey,
            size: 38,
          ),
        ),
        subtitle: Text(subtitle,style: TextStyle(

          color: Constants.greyColor,
          fontSize: 14.0,
        ),),
        title: Text(title,style: TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.black,
          fontSize: 18.0
        ),),
      ),


    );
  }
}
