import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerLogo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      width: 50,
      child: Shimmer.fromColors(child: Text('Profile'), baseColor: Colors.white, highlightColor: Colors.black),
    );
  }
}
