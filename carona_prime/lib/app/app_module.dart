import 'package:carona_prime/app/pages/notificacoes/notificacoes_bloc.dart';
import 'package:carona_prime/app/pages/grupo/novo_grupo/novo_grupo_bloc.dart';
import 'package:carona_prime/app/pages/selecionar_contatos/selecionar_contatos_bloc.dart';
import 'package:carona_prime/app/pages/welcome/welcome_bloc.dart';
import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:carona_prime/app/app_widget.dart';
import 'package:carona_prime/app/app_bloc.dart';

class AppModule extends ModuleWidget {
  @override
  List<Bloc> get blocs => [
        Bloc((i) => NotificacoesBloc()),
        Bloc((i) => NovoGrupoBloc()),
        Bloc((i) => SelecionarContatosBloc()),        
        Bloc((i) => SelecionarContatosBloc()),  
        Bloc((i) => WelcomeBloc()),
        Bloc((i) => AppBloc())
      ];

  @override
  List<Dependency> get dependencies => [];

  @override
  Widget get view => AppWidget();

  static Inject get to => Inject<AppModule>.of();
}
