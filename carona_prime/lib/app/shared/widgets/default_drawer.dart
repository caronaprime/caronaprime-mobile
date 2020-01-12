import 'package:carona_prime/app/application_controller.dart';
import 'package:carona_prime/app/pages/perguntas_frequentes/perguntas_frequentes_page.dart';
import 'package:carona_prime/app/pages/politica_privacidade/politica_privacidade_page.dart';
import 'package:carona_prime/app/pages/termos_uso/termos_uso_page.dart';
import 'package:flutter/material.dart';
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
          ListTile(leading: Icon(Icons.settings), title: Text("Configurações")),
          ListTile(
              leading: Icon(Icons.assignment),
              title: Text("Termos de Uso"),
              onTap: () => Navigator.of(context).push(MaterialPageRoute(
                  builder: (_) => TermosUsoPage(null, null)))),
          ListTile(
            leading: Icon(Icons.lock),
            title: Text("Política de Privacidade"),
            onTap: () => Navigator.of(context).push(MaterialPageRoute(
                builder: (_) => PoliticaPrivacidadePage(null, null))),
          ),
          ListTile(
            leading: Icon(Icons.help),
            title: Text("Perguntas Frequentes"),
            onTap: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => PerguntasFrequentesPage())),
          ),
          ListTile(
            leading: Icon(Icons.exit_to_app),
            title: Text("Sair"),
            onTap: applicationController.deslogar,
          )
        ],
      ),
    );
  }
}
