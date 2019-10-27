import 'package:flutter/material.dart';

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
          ListTile(title: Text("Configurações"), subtitle: Text("asdf")),
          ListTile(title: Text("Sair")),          
        ],
      ),
    );
  }
}
