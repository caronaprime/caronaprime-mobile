import 'package:carona_prime/app/pages/novo_grupo/novo_grupo_page.dart';
import 'package:flutter/material.dart';

class GrupoPage extends StatefulWidget {
  @override
  _GrupoPageState createState() => _GrupoPageState();
}

class _GrupoPageState extends State<GrupoPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(  
        title: Text("Grupos"),
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            RaisedButton(
                onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => NovoGrupoPage())),
                child: Text("Novo Grupo")),
          ],
        ),
      ),
    );
  }
}
