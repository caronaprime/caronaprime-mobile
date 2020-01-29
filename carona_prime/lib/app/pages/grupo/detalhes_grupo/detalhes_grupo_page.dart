import 'package:carona_prime/app/models/usuario_model.dart';
import 'package:carona_prime/app/pages/grupo/detalhes_grupo/detalhes_grupo_controller.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:intl/intl.dart';
import 'package:mobx/mobx.dart';

class DetalhesGrupoPage extends StatelessWidget {
  DetalhesGrupoPage(this.grupoId);
  final int grupoId;
  final controller = DetalhesGrupoController();
  final vagasDisponiveis = [1, 2, 3, 4, 5, 6];

  @override
  Widget build(BuildContext context) {
    controller.carregarGrupo(grupoId);
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
          height: 60,
          child: Center(
              child: Text(
                  controller.partida?.nome != null &&
                          controller.destino?.nome != null
                      ? "Origem: ${controller.partida?.nome} - Destino:${controller.destino?.nome}"
                      : "Origem e Destino não informados",
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
                  Observer(
                    builder: (_) => opcaoAdicionalButton(
                        "Carro Adaptado", context,
                        checked: controller.carroAdaptado,
                        iconData: Icons.accessible,
                        onTap: () => controller
                            .setCarroAdaptado(!controller.carroAdaptado)),
                  ),
                  Observer(
                      builder: (_) => opcaoAdicionalButton(
                            "Porta-malas livre",
                            context,
                            checked: controller.portaMalasLivre,
                            iconData: Icons.shopping_cart,
                            onTap: () => controller.setPortaMalasLivre(
                                !controller.portaMalasLivre),
                          ))
                ],
              )),
              Column(
                children: <Widget>[
                  Text("Vagas disponíveis",
                      style: TextStyle(color: Theme.of(context).accentColor)),
                  Observer(
                      builder: (_) => DropdownButton(
                            value: controller.vagasDisponiveis,
                            onChanged: (i) => controller.setVagasDisponiveis,
                            items: vagasDisponiveis
                                .map((n) => DropdownMenuItem(
                                    child: Text(n.toString()), value: n))
                                .toList(),
                          )),
                ],
              ),
              Container(
                width: 150,
                child: DateTimeField(
                    decoration: InputDecoration(
                        border: Theme.of(context).inputDecorationTheme.border,
                        contentPadding: Theme.of(context)
                            .inputDecorationTheme
                            .contentPadding,
                        labelStyle:
                            Theme.of(context).inputDecorationTheme.labelStyle),
                    format: DateFormat("HH:mm"),
                    onShowPicker: (context, currentValue) async {
                      TimeOfDay time = await showTimePicker(
                        context: context,
                        initialTime:
                            controller.hora ?? TimeOfDay(hour: 00, minute: 00),
                        builder: (BuildContext context, Widget child) {
                          return MediaQuery(
                            data: MediaQuery.of(context)
                                .copyWith(alwaysUse24HourFormat: true),
                            child: child,
                          );
                        },
                      );
                      if (time != null) controller.setHora(time);
                      return DateTimeField.convert(time);
                    }),
              ),
              GestureDetector(
                onTap: () => mostrarDialogoDias(context),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Text("Dias"),
                    Observer(
                        builder: (_) =>
                            controller.domingo ? Text("Domingo") : Container()),
                    Observer(
                        builder: (_) => controller.segunda
                            ? Text("Segunda-feira")
                            : Container()),
                    Observer(
                        builder: (_) => controller.terca
                            ? Text("Terça-feira")
                            : Container()),
                    Observer(
                        builder: (_) => controller.quarta
                            ? Text("Quarta-feira")
                            : Container()),
                    Observer(
                        builder: (_) => controller.quinta
                            ? Text("Quinta-feira")
                            : Container()),
                    Observer(
                        builder: (_) => controller.sexta
                            ? Text("Sexta-feira")
                            : Container()),
                    Observer(
                        builder: (_) =>
                            controller.sabado ? Text("Sábado") : Container()),
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
                  Observer(
                    builder: (_) => checkBoxLabel(
                        label: "Repetir Semanalmente",
                        value: controller.repetirSemanalmente,
                        onChanged: (_) => controller.setRepetirSemanalmente(
                            !controller.repetirSemanalmente)),
                  ),
                  Observer(
                      builder: (_) => checkBoxLabel(
                          label: "Domingo",
                          value: controller.domingo,
                          onChanged: (_) =>
                              controller.setDomingo(!controller.domingo))),
                  Observer(
                      builder: (_) => checkBoxLabel(
                          label: "Segunda-Feira",
                          value: controller.segunda,
                          onChanged: (_) =>
                              controller.setSegunda(!controller.segunda))),
                  Observer(
                      builder: (_) => checkBoxLabel(
                          label: "Terça-Feira",
                          value: controller.terca,
                          onChanged: (_) =>
                              controller.setTerca(!controller.terca))),
                  Observer(
                      builder: (_) => checkBoxLabel(
                          label: "Quarta-Feira",
                          value: controller.quarta,
                          onChanged: (_) =>
                              controller.setQuarta(!controller.quarta))),
                  Observer(
                      builder: (_) => checkBoxLabel(
                          label: "Quinta-Feira",
                          value: controller.quinta,
                          onChanged: (_) =>
                              controller.setQuinta(!controller.quinta))),
                  Observer(
                      builder: (_) => checkBoxLabel(
                          label: "Sexta-Feira",
                          value: controller.sexta,
                          onChanged: (_) =>
                              controller.setSexta(!controller.sexta))),
                  Observer(
                      builder: (_) => checkBoxLabel(
                          label: "Sábado",
                          value: controller.sabado,
                          onChanged: (_) =>
                              controller.setSabado(!controller.sabado))),
                ],
              ),
            ),
            actions: <Widget>[
              FlatButton(
                  textTheme: ButtonTextTheme.primary,
                  child: Text("Ok"),
                  onPressed: () => Navigator.of(context).pop()),
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
                textAlign: TextAlign.center,
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
