import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';

class LoginBloc extends BlocBase {
  var phoneController = TextEditingController();


  @override
  void dispose() {
    super.dispose();
  }
}
