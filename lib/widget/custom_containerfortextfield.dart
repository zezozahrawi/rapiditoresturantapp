import 'package:flutter/material.dart';

class CostumContainerTextField extends StatelessWidget {
  Widget cutomTextFeildChild;
  double height;
  CostumContainerTextField(
      {Key? key, required this.height, required this.cutomTextFeildChild})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      margin: const EdgeInsets.only(left: 40, right: 40),
      child: cutomTextFeildChild,
    );
  }
}
