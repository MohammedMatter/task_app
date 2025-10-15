import 'package:flutter/material.dart';

// ignore: must_be_immutable
class ListTileSettings extends StatelessWidget {
  String? label;
  IconData? icon;
  ListTileSettings({
    required this.icon,
    required this.label,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return ListTile(
      leading: Icon(
        icon,
        color: Colors.blue,
        size: width * 0.06,
      ),
      title: Text(
        label!,
        style: TextStyle(fontSize: width * 0.04),
      ),
      trailing: Icon(
        Icons.arrow_forward_ios_outlined,
        size: width * 0.04,
      ),
      contentPadding: EdgeInsets.symmetric(
        horizontal: width * 0.04,
        vertical: height * 0.005,
      ),
    );
  }
}
