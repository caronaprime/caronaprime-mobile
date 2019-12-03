import 'package:flutter/material.dart';

class SelecionarContatosPage extends StatefulWidget {
  final String title;
  const SelecionarContatosPage({Key key, this.title = "SelecionarContatos"})
      : super(key: key);

  @override
  _SelecionarContatosPageState createState() => _SelecionarContatosPageState();
}

class _SelecionarContatosPageState extends State<SelecionarContatosPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Column(
        children: <Widget>[],
      ),
    );
  }
}
