import 'package:flutter/material.dart';
import 'package:videocalling/ownmethod/constants.dart';

class CustomTitle extends StatelessWidget {

  final Widget leading;
  final Widget title;
  final Widget icon;
  final Widget subtitle;
  final Widget traling;
  final EdgeInsets margin;
  final bool mini;
  final GestureTapCallback onTap;
  final GestureLongPressCallback onLongPress;

  const CustomTitle({Key key, this.leading, this.title, this.icon, this.subtitle, this.traling, this.margin, this.mini, this.onTap, this.onLongPress}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      onLongPress: onLongPress,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: mini ? 10 : 0),
        margin: margin,
        child: Row(
          children: [
            leading,
            Expanded(
              child: Container(
                margin: EdgeInsets.only(left: mini? 10 : 15),
                padding: EdgeInsets.symmetric(vertical: mini?3 :20),
                decoration: BoxDecoration(
                  border: Border(
                  bottom : BorderSide(
                    width: 1.2,

                    color: Colors.grey[400],
                    )
                  )
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        title,
                        SizedBox(
                          height: 5,
                        ),
                        Row(
                          children: [
                            icon ?? Container(),
                            subtitle
                          ],
                        ),
                      ],
                    ),
                    traling ??Container(),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
