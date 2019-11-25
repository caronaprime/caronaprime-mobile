import 'package:flutter/material.dart';

class LogoCarona extends StatelessWidget {
  const LogoCarona({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: CircleAvatar(
        backgroundColor: Theme.of(context).accentColor,
        radius: 48.0,
        child: Image.asset('assets/logohd.png'),
      ),
      width: 180.0,
      height: 180.0,
      padding: const EdgeInsets.only(
          top: 15.0, bottom: 15.0, left: 15.0, right: 15.0),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        shape: BoxShape.circle,
      ),
    );
  }
}
