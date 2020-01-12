import 'package:carona_prime/app/application_controller.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get_it/get_it.dart';

class DefaultDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var applicationController = GetIt.I.get<ApplicationController>();
    return Drawer(
      child: ListView(
        children: <Widget>[
          UserAccountsDrawerHeader(
            accountEmail: Text("teste@teste.com"),
            accountName: Text("Nome Sobrenome"),
            currentAccountPicture: CircleAvatar(
              child: Text("CP"),
            ),
          ),
          ListTile(
              leading: Icon(Icons.settings),
              title: Text("Configurações"),
              subtitle: Text("asdf")),
          ListTile(
              leading: Icon(FontAwesomeIcons.map),
              title: Text("Mapa"),
              subtitle: Text("Configurações de mapas")),
          ListTile(
            leading: Icon(FontAwesomeIcons.doorOpen),
            title: Text("Sair"),
            onTap: applicationController.deslogar,
          ),
        ],
      ),
    );
  }
}
