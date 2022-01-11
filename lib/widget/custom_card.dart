import 'package:flutter/material.dart';

class CustomCard extends StatelessWidget {
  final Widget? widget;
  const CustomCard({
    Key? key,
    this.widget,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
      clipBehavior: Clip.hardEdge,
      margin: const EdgeInsets.only(left: 10, right: 10),
      child: widget,
    );
  }
}
