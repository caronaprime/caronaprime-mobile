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
    controller.carregarGrupos();
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
        if (controller.gruposResponse == null ||
            controller.gruposResponse.length == 0)
          return Center(
              child: Observer(
            builder: (_) => controller.consultou
                ? Text("Você ainda não participa de nenhum grupo")
                : CircularProgressIndicator(),
          ));

        return ListView(
          children: controller.gruposResponse
              .map((grupo) => ListTile(
                    onTap: () => Navigator.of(context).push<bool>(
                        MaterialPageRoute(
                            builder: (context) => DetalhesGrupoPage(grupo.id))),
                    trailing: IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text(
                                    "Tem certeza que deseja sair do do grupo ${grupo.nome}?"),
                                actions: <Widget>[
                                  FlatButton(
                                    child: Text("Não"),
                                    onPressed: () =>
                                        Navigator.of(context).pop(),
                                  ),
                                  FlatButton(
                                    child: Text("Sim"),
                                    onPressed: () async {
                                      await controller.sairDoGrupo(grupo.id);
                                      if (Navigator.of(context).canPop()) {
                                        Navigator.of(context).pop();
                                      }
                                    },
                                  )
                                ],
                              );
                            });
                      },
                    ),
                    title: Text(grupo.nome),
                    subtitle:
                        Text("${grupo.partida.nome} - ${grupo.destino.nome}"),
                  ))
              .toList(),
        );
      }),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () async {
          var inseriu = await Navigator.of(context).push<bool>(
              MaterialPageRoute(builder: (context) => NovoGrupoPage()));
          if (inseriu != null && inseriu) controller.carregarGrupos();
        },
      ),
    );
  }
}
