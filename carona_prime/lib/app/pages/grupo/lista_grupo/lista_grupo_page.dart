import 'package:carona_prime/app/pages/grupo/detalhes_grupo/detalhes_grupo_page.dart';
import 'package:carona_prime/app/pages/grupo/lista_grupo/lista_grupo_controller.dart';
import 'package:carona_prime/app/pages/grupo/novo_grupo/novo_grupo_page.dart';
import 'package:carona_prime/app/pages/notificacoes/notificacoes_page.dart';
import 'package:carona_prime/app/shared/widgets/default_drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

class ListaGrupoPage extends StatelessWidget {
  final controller = ListaGrupoController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: DefaultDrawer(),
      appBar: AppBar(
        title: Text("Grupos"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.notifications),
            onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => NotificacoesPage())),
          )
        ],
      ),
      body: Observer(builder: (_) {
        if (controller.grupos == null || controller.grupos.length == 0)
          return Center(
            child: Text("Você ainda não participa de nenhum grupo"),
          );
        return ListView(
          children: controller.grupos
              .map((grupo) => ListTile(
                    onTap: () => Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => DetalhesGrupoPage())),
                    title: Text(grupo.nome),
                    subtitle:
                        Text("${grupo.partida.nome} - ${grupo.destino.nome}"),
                  ))
              .toList(),
        );
      }),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => NovoGrupoPage())),
      ),
    );
  }
}
