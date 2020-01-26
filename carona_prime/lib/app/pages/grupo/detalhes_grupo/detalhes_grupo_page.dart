import 'package:carona_prime/app/models/usuario_model.dart';
import 'package:carona_prime/app/pages/grupo/detalhes_grupo/detalhes_grupo_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobx/mobx.dart';

class DetalhesGrupoPage extends StatelessWidget {
  DetalhesGrupoPage(this.grupoId);
  final int grupoId;
  final controller = DetalhesGrupoController();
  final vagasDisponiveis = [1, 2, 3, 4, 5, 6];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Nome do Grupo")),
      body: Observer(
          builder: (_) => Container(
                  child: <Widget>[
                pageCaronasDisponiveis(context),
                pageOferecerCarona(context),
                pageMembros(controller.membros)
              ].elementAt(controller.pageIndex))),
      bottomNavigationBar: Observer(
        builder: (_) => BottomNavigationBar(
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.departure_board),
              title: Text('Caronas Disponíveis'),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.directions_car),
              title: Text('Oferecer Carona'),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.group),
              title: Text('Membros'),
            ),
          ],
          onTap: controller.setPageIndex,
          currentIndex: controller.pageIndex,
        ),
      ),
    );
  }

  pageCaronasDisponiveis(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          height: 40,
          child: Center(
              child: Text("Origem: - Destino: ",
                  style: Theme.of(context).textTheme.title)),
        ),
        Expanded(
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: 15,
            itemBuilder: (_, index) => Container(
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
                        Text("Convite de Patrícia",
                            style: Theme.of(context).textTheme.title),
                        Text(
                          "Vagas Disponíveis: 4",
                          style: TextStyle(
                              color: Theme.of(context).accentColor,
                              fontSize: 18),
                        ),
                        Text(
                          "Saindo às 09:00h",
                          style: TextStyle(
                              color: Theme.of(context).accentColor,
                              fontSize: 18),
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
                                  color:
                                      Theme.of(context).textTheme.body1.color),
                            ),
                            onPressed: () => print("recusar"),
                          ),
                          FlatButton(
                            child: Text("QUERO CARONA!"),
                            onPressed: () => print("Quero carona"),
                          )
                        ],
                      ),
                    )
                  ],
                )),
              ),
            ),
          ),
        ),
      ],
    );
  }

  pageOferecerCarona(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          height: 40,
          child: Center(
              child: Text("Origem: - Destino: ",
                  style: Theme.of(context).textTheme.title)),
        ),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Container(
                  child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  opcaoAdicionalButton("Carro Adaptado", context,
                      checked: true,
                      iconData: Icons.accessible,
                      onTap: () => print("Implementar")),
                  opcaoAdicionalButton("Porta-malas livre", context,
                      checked: false,
                      iconData: Icons.shopping_cart,
                      onTap: () => print("Implementar"))
                ],
              )),
              Column(
                children: <Widget>[
                  Text("Vagas disponíveis",
                      style: TextStyle(color: Theme.of(context).accentColor)),
                  DropdownButton(
                    onChanged: (i) => print(i),
                    items: vagasDisponiveis
                        .map((n) => DropdownMenuItem(
                            child: Text(n.toString()), value: n))
                        .toList(),
                  ),
                ],
              ),
              GestureDetector(
                onTap: () => mostrarDialogoDias(context),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Text("Horário: 10:00h",
                        style: TextStyle(color: Theme.of(context).accentColor)),
                    Text("Dias"),
                    Text("Segunda-feira"),
                    Text("Terça-feira"),
                    Text("Quarta-feira"),
                    Text("Quinta-feira"),
                  ],
                ),
              ),
            ],
          ),
        ),
        Container(
          alignment: Alignment.bottomCenter,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              FlatButton(
                child: Text("Cancelar",
                    style: TextStyle(
                        color: Theme.of(context).textTheme.body1.color)),
                onPressed: () => print("implementar"),
              ),
              FlatButton(
                child: Text("Compartilhar Carona!"),
                onPressed: () => print("implementar"),
              )
            ],
          ),
        )
      ],
    );
  }

  pageMembros(ObservableList<UsuarioModel> membros) {
    if (membros == null || membros.isEmpty)
      return Center(
        child: Container(
          child: Text("Grupo sem membros"),
        ),
      );

    return ListView(
        children: membros
            .map((membro) => ListTile(
                title: Text(membro.nome),
                subtitle: Text(membro.celular),
                leading: CircleAvatar(
                  child: Text(membro.nome[0]),
                )))
            .toList());
  }

  checkBoxLabel({String label, bool value, Function(bool) onChanged}) =>
      Row(children: <Widget>[
        Checkbox(
          value: value,
          onChanged: onChanged,
        ),
        Text(label)
      ]);

  void mostrarDialogoDias(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext builderContext) {
          return AlertDialog(
            title: Text("Escolha os dias"),
            content: Container(
              child: Column(
                children: <Widget>[
                  checkBoxLabel(
                      label: "Marcar Todos",
                      value: true,
                      onChanged: (_) => print("asdf")),
                  checkBoxLabel(
                      label: "Domingo",
                      value: true,
                      onChanged: (_) => print("asdf")),
                  checkBoxLabel(
                      label: "Segunda-Feira",
                      value: true,
                      onChanged: (_) => print("asdf")),
                  checkBoxLabel(
                      label: "Terça-Feira",
                      value: true,
                      onChanged: (_) => print("asdf")),
                  checkBoxLabel(
                      label: "Quarta-Feira",
                      value: true,
                      onChanged: (_) => print("asdf")),
                  checkBoxLabel(
                      label: "Quinta-Feira",
                      value: true,
                      onChanged: (_) => print("asdf")),
                  checkBoxLabel(
                      label: "Sexta-Feira",
                      value: true,
                      onChanged: (_) => print("asdf")),
                  checkBoxLabel(
                      label: "Sábado",
                      value: true,
                      onChanged: (_) => print("asdf")),
                ],
              ),
            ),
            actions: <Widget>[
              FlatButton(
                  textTheme: ButtonTextTheme.primary,
                  child: Text("Fechar"),
                  onPressed: () => Navigator.of(context).pop()),
              FlatButton(
                  textTheme: ButtonTextTheme.primary,
                  child: Text("Ok"),
                  onPressed: () => print("implementar")),
            ],
          );
        });
  }

  opcaoAdicionalButton(String label, BuildContext context,
      {bool checked = false, IconData iconData, Function() onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
          decoration: BoxDecoration(
            color: checked
                ? Theme.of(context).accentColor
                : Theme.of(context).backgroundColor,
            borderRadius: BorderRadius.all(Radius.circular(5)),
          ),
          height: 100,
          width: 100,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(
                iconData,
                color: checked
                    ? Theme.of(context).backgroundColor
                    : Theme.of(context).textTheme.body1.color,
                size: 50,
              ),
              Text(
                label,
                style: TextStyle(
                  color: checked
                      ? Theme.of(context).backgroundColor
                      : Theme.of(context).textTheme.body1.color,
                ),
              )
            ],
          )),
    );
  }
}
