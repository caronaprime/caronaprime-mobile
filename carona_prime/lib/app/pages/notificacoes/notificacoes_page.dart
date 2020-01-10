import 'package:carona_prime/app/pages/notificacoes/notificacoes_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

class NotificacoesPage extends StatelessWidget {
  final controller = NotificacoesController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Notificações"),
        ),
        body: Observer(
            builder: (_) => ListView(
                children: controller.notificacoes
                    .map((n) => conviteWidget(context, n.titulo, n.descricao))
                    .toList())));
  }

  Widget conviteWidget(BuildContext context, String titulo, String descricao) {
    return Container(
      height: 200,
      child: Card(
        elevation: 2,
        child: Center(
            child: Column(
          children: <Widget>[
            Expanded(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Text(titulo, style: Theme.of(context).textTheme.title),
                Text(
                  descricao,
                  style: TextStyle(
                      color: Theme.of(context).accentColor, fontSize: 18),
                ),
              ],
            )),
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  FlatButton(
                    child: Text(
                      "RECUSAR",
                      style: TextStyle(
                          color: Theme.of(context).textTheme.body1.color),
                    ),
                    onPressed: () => print("recusar"),
                  ),
                  FlatButton(
                    child: Text("ACEITAR!"),
                    onPressed: () => print("Quero carona"),
                  )
                ],
              ),
            )
          ],
        )),
      ),
    );
  }
}
