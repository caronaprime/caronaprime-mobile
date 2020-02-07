import 'package:carona_prime/app/application_controller.dart';
import 'package:carona_prime/app/models/carona_model.dart';
import 'package:carona_prime/app/pages/oferecer_carona_page/oferecer_carona_page.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class ProximasViagensWidget extends StatelessWidget {
  final List<CaronaModel> caronas;
  final int oferecerCaronasAoGrupoId;
  final void Function(int caronaId) onDesistirDaCarona;
  final void Function(int grupoId) onCompartilharCarona;
  final GlobalKey<ScaffoldState> scaffoldKey;

  const ProximasViagensWidget(
      {@required this.caronas,
      @required this.onDesistirDaCarona,
      @required this.scaffoldKey,
      @required this.onCompartilharCarona,
      this.oferecerCaronasAoGrupoId = 0});

  @override
  Widget build(BuildContext context) {
    final applicationController = GetIt.I.get<ApplicationController>();
    return Container(
      child: Stack(
        children: <Widget>[
          (caronas == null || caronas.length == 0)
              ? Center(
                  child:
                      Text("Você ainda não aceitou nenhum convite de carona"),
                )
              : Column(
                  children: <Widget>[
                    Expanded(
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: caronas.length,
                        itemBuilder: (_, index) => Stack(
                          children: <Widget>[
                            Container(
                              height: 150,
                              child: Card(
                                elevation: 2,
                                shape: caronas[index].motorista.id !=
                                        applicationController.usuarioLogado.id
                                    ? null
                                    : RoundedRectangleBorder(
                                        side: BorderSide(
                                            color:
                                                Theme.of(context).primaryColor,
                                            width: 1),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                child: Center(
                                    child: Column(
                                  children: <Widget>[
                                    Expanded(
                                        child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: <Widget>[
                                        Text(
                                            "Motorista: ${caronas[index].motorista.nome}",
                                            style: Theme.of(context)
                                                .textTheme
                                                .title),
                                        Text(
                                          "${applicationController.descricaoData(caronas[index].data)}, às ${caronas[index].hora.toString().padLeft(2, '0')}:${caronas[index].minuto.toString().padLeft(2, '0')}h",
                                          style: TextStyle(
                                              color:
                                                  Theme.of(context).accentColor,
                                              fontSize: 18),
                                        )
                                      ],
                                    )),
                                  ],
                                )),
                              ),
                            ),
                            Positioned(
                              top: 20,
                              right: 10,
                              child: caronas[index].motorista.id ==
                                      applicationController.usuarioLogado.id
                                  ? Container()
                                  : IconButton(
                                      icon: Icon(Icons.delete),
                                      onPressed: () => showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              title: Text(
                                                  "Tem certeza que deseja desistir desta carona?"),
                                              actions: <Widget>[
                                                FlatButton(
                                                  child: Text("Não"),
                                                  onPressed: () =>
                                                      Navigator.of(context)
                                                          .pop(),
                                                ),
                                                FlatButton(
                                                  child: Text("Sim"),
                                                  onPressed: () async {
                                                    await onDesistirDaCarona(
                                                        caronas[index].id);
                                                    if (Navigator.of(context)
                                                        .canPop()) {
                                                      Navigator.of(context)
                                                          .pop();
                                                    }
                                                  },
                                                )
                                              ],
                                            );
                                          }),
                                    ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
          oferecerCaronasAoGrupoId > 0
              ? Positioned(
                  bottom: 10,
                  left: (MediaQuery.of(context).size.width - 200) / 2,
                  child: Container(
                    width: 200,
                    child: RaisedButton(
                      child: Text("Oferecer Caronas"),
                      onPressed: () async {
                        var compartilhou =
                            await Navigator.of(context).push(MaterialPageRoute(
                                builder: (_) => OferecerCaronaPage(
                                      grupoId: oferecerCaronasAoGrupoId,
                                      scaffoldKey: scaffoldKey,
                                    )));
                        if (compartilhou == true) {
                          onCompartilharCarona(oferecerCaronasAoGrupoId);
                        }
                      },
                    ),
                  ),
                )
              : Container()
        ],
      ),
    );
  }
}
