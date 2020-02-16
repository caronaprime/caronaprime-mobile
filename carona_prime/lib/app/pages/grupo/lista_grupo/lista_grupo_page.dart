import 'package:carona_prime/app/pages/grupo/detalhes_grupo/detalhes_grupo_page.dart';
import 'package:carona_prime/app/pages/grupo/lista_grupo/lista_grupo_controller.dart';
import 'package:carona_prime/app/pages/grupo/novo_grupo/novo_grupo_page.dart';
import 'package:carona_prime/app/shared/widgets/default_drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class ListaGrupoPage extends StatefulWidget {
  @override
  _ListaGrupoPageState createState() => _ListaGrupoPageState();
}

class _ListaGrupoPageState extends State<ListaGrupoPage> {
  @override
  void initState() {
    controller.carregarGrupos();
    super.initState();
  }

  final controller = ListaGrupoController();
  List<String> items = [];
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: DefaultDrawer(),
      appBar: AppBar(
        title: Text("Grupos"),
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

        return SmartRefresher(
          enablePullDown: true,
          header: MaterialClassicHeader(),
          footer: CustomFooter(
            builder: (BuildContext context, LoadStatus mode) {
              Widget body;
              if (mode == LoadStatus.idle) {
                body = Text("Puxe para atualizar");
              } else if (mode == LoadStatus.loading) {
                body = CircularProgressIndicator();
              } else if (mode == LoadStatus.failed) {
                body = Text("Atualização falhou. Clique para tentar novamente");
              } else if (mode == LoadStatus.canLoading) {
                body = Text("Pronto para carregar mais");
              } else {
                body = Text("Sem mais registros");
              }
              return Container(
                height: 55.0,
                child: Center(child: body),
              );
            },
          ),
          controller: _refreshController,
          onRefresh: () async {
            await controller.carregarGrupos();
            _refreshController.refreshCompleted();
          },
          onLoading: () async {
            await controller.carregarGrupos();
            _refreshController.loadComplete();
          },
          child: ListView(
            children: controller.gruposResponse
                .map((grupo) => ListTile(
                      onTap: () => Navigator.of(context).push<bool>(
                          MaterialPageRoute(
                              builder: (context) =>
                                  DetalhesGrupoPage(grupo.id))),
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
          ),
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
