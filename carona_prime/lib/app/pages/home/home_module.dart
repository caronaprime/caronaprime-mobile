import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:carona_prime/app/pages/welcome/welcome_page.dart';
import 'package:flutter/material.dart';

class HomeModule extends ModuleWidget {
  @override
  List<Bloc> get blocs => [];

  @override
  List<Dependency> get dependencies => [];

  @override
  Widget get view => WelcomePage();

  static Inject get to => Inject<HomeModule>.of();
}
