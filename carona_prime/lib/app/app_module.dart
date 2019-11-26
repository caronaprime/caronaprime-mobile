import 'package:carona_prime/app/pages/grupo/grupo_bloc.dart';
import 'package:carona_prime/app/pages/novo_grupo/novo_grupo_bloc.dart';
import 'package:carona_prime/app/pages/map/map_bloc.dart';
import 'package:carona_prime/app/pages/login/login_bloc.dart';
import 'package:carona_prime/app/pages/login_mode/login_mode_bloc.dart';
import 'package:carona_prime/app/pages/welcome/welcome_bloc.dart';
import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:carona_prime/app/app_widget.dart';
import 'package:carona_prime/app/app_bloc.dart';

class AppModule extends ModuleWidget {
  @override
  List<Bloc> get blocs => [
        Bloc((i) => GrupoBloc()),
        Bloc((i) => NovoGrupoBloc()),
        Bloc((i) => MapBloc()),
        Bloc((i) => LoginModeBloc()),
        Bloc((i) => LoginBloc()),
        Bloc((i) => WelcomeBloc()),
        Bloc((i) => AppBloc()),
      ];

  @override
  List<Dependency> get dependencies => [];

  @override
  Widget get view => AppWidget();

  static Inject get to => Inject<AppModule>.of();
}
