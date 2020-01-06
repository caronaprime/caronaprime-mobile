import 'package:flutter/material.dart';

class NotificacoesPage extends StatefulWidget {
  final String title;
  const NotificacoesPage({Key key, this.title = "Notificações"})
      : super(key: key);

  @override
  _NotificacoesPageState createState() => _NotificacoesPageState();
}

class _NotificacoesPageState extends State<NotificacoesPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: ListView(
        children: <Widget>[
          conviteWidget(
              "Patrícia esta te convidando para participar do grupo X",
              "origem: - destino:"),
          conviteWidget("José te adicionou como administrador do grupo Y",
              "origem: - destino:"),
          conviteWidget("Maria quer participar do grupo Z", ""),
          conviteWidget("Maria quer participar do grupo O", "")
        ],
      ),
    );
  }

  conviteWidget(String titulo, String descricao) {
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
