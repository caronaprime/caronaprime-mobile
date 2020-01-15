import 'package:carona_prime/app/app_widget.dart';
import 'package:carona_prime/app/application_controller.dart';
import 'package:carona_prime/app/shared/default_url.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

void main() {
  var getIt = GetIt.I;
  getIt.registerSingleton<ApplicationController>(ApplicationController());
  getIt.registerSingleton<DefaultUrl>(DefaultUrl("https://carona-prime-9f9fb.appspot.com"));

  runApp(AppWidget());
}
