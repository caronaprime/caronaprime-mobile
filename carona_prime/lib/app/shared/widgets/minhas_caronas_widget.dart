import 'package:carona_prime/app/models/carona_model.dart';
import 'package:carona_prime/app/pages/oferecer_carona_page/oferecer_carona_page.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MinhasCaronasWidget extends StatelessWidget {
  final List<CaronaModel> caronas;
  final int oferecerCaronasAoGrupoId;
  final void Function(int caronaId) onDesistirDaCarona;
  final GlobalKey<ScaffoldState> scaffoldKey;

  const MinhasCaronasWidget(
      {@required this.caronas,
      @required this.onDesistirDaCarona,
      @required this.scaffoldKey,
      this.oferecerCaronasAoGrupoId = 0});

  String descricaoData(DateTime data) {
    final _formatter = DateFormat('dd/MM/yyyy');
    DateTime now = DateTime.now();
    var diferenca = DateTime(data.year, data.month, data.day)
        .difference(DateTime(now.year, now.month, now.day))
        .inDays;
    if (diferenca == 0) return "Hoje";
    if (diferenca == 1) return "Amanhã";

    return _formatter.format(data);
  }

  @override
  Widget build(BuildContext context) {
    if (caronas == null || caronas.length == 0)
      return Center(
        child: Text("Você ainda não aceitou nenhum convite de carona"),
      );
    return Container(
      child: Stack(
        children: <Widget>[
          Column(
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
                                      style: Theme.of(context).textTheme.title),
                                  Text(
                                    "${descricaoData(caronas[index].data)}, às ${caronas[index].hora}:${caronas[index].minuto}h",
                                    style: TextStyle(
                                        color: Theme.of(context).accentColor,
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
                        child: IconButton(
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
                                          Navigator.of(context).pop(),
                                    ),
                                    FlatButton(
                                      child: Text("Sim"),
                                      onPressed: () async {
                                        await onDesistirDaCarona(
                                            caronas[index].id);
                                        if (Navigator.of(context).canPop()) {
                                          Navigator.of(context).pop();
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
                      onPressed: () =>
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (_) => OferecerCaronaPage(
                                    grupoId: oferecerCaronasAoGrupoId,
                                    scaffoldKey: scaffoldKey,
                                  ))),
                    ),
                  ),
                )
              : Container()
        ],
      ),
    );
  }
}
