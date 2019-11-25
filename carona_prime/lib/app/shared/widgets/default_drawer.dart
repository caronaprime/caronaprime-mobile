import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class DefaultDrawer extends StatelessWidget {
  const DefaultDrawer({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: <Widget>[
          UserAccountsDrawerHeader(
            //TODO colocar informaçoes de login
            accountEmail: Text("teste@teste.com"),
            accountName: Text("Nome Sobrenome"),
            currentAccountPicture: CircleAvatar(
              child: Text("CP"),
            ),
          ),
          ListTile(leading: Icon(Icons.settings), title: Text("Configurações"), subtitle: Text("asdf")),
          ListTile(leading: Icon(FontAwesomeIcons.map), title: Text("Mapa"), subtitle: Text("Configurações de mapas")),
          ListTile(leading: Icon(FontAwesomeIcons.doorOpen), title: Text("Sair")),          
        ],
      ),
    );
  }
}
