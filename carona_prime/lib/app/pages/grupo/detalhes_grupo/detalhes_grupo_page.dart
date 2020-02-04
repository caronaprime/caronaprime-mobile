import 'package:carona_prime/app/models/usuario_model.dart';
import 'package:carona_prime/app/pages/grupo/detalhes_grupo/detalhes_grupo_controller.dart';
import 'package:carona_prime/app/pages/grupo/selecionar_contatos/selecionar_contatos.dart';
import 'package:carona_prime/app/shared/widgets/minhas_caronas_widget.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:intl/intl.dart';
import 'package:mobx/mobx.dart';

class DetalhesGrupoPage extends StatelessWidget {
  DetalhesGrupoPage(this.grupoId);
  final int grupoId;
  final _controller = DetalhesGrupoController();
  final _vagasDisponiveis = [1, 2, 3, 4, 5, 6];
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    _controller.carregarGrupo(grupoId);
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
            title: Observer(builder: (_) => Text(_controller.nomeDoGrupo))),
        body: Observer(
            builder: (_) => Container(
                    child: <Widget>[
                  pageCaronasDisponiveis(context),
                  MinhasCaronasWidget(
                    scaffoldKey: _scaffoldKey,
                    caronas: _controller.caronas,
                    oferecerCaronasAoGrupoId: grupoId,
                    onDesistirDaCarona: (caronaId) => print(caronaId),
                  ),
                  pageMembros(context, _controller.membros)
                ].elementAt(_controller.pageIndex))),
        bottomNavigationBar: Observer(
          builder: (_) => BottomNavigationBar(
            items: <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.departure_board),
                title: Text('Caronas Disponíveis'),
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.directions_car),
                title: Text('Minhas Caronas'),
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.group),
                title: Text('Membros'),
              ),
            ],
            onTap: _controller.setPageIndex,
            currentIndex: _controller.pageIndex,
          ),
        ),
        floatingActionButton: Observer(
            builder: (_) =>
                _controller.pageIndex == 2 && _controller.usuarioEhAdministrador
                    ? FloatingActionButton(
                        child: Icon(Icons.add),
                        onPressed: () async {
                          var retorno = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SelecionarContatoPage(
                                      true, _controller.membros)));
                          if (retorno is List<Contact>) {
                            var usuarios = retorno
                                .map((c) => UsuarioModel(
                                    c.displayName, c.phones.first.value))
                                .toList();
                            _controller.adicionarContatos(usuarios, grupoId);
                          }
                        },
                      )
                    : Container()));
  }

  pageCaronasDisponiveis(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          height: 60,
          child: Center(
              child: Text(
                  _controller.partida?.nome != null &&
                          _controller.destino?.nome != null
                      ? "Origem: ${_controller.partida?.nome} - Destino: ${_controller.destino?.nome}"
                      : "Origem e Destino não informados",
                  style: Theme.of(context).textTheme.title)),
        ),
        Observer(
          builder: (_) => Expanded(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: _controller.caronas.length,
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
                          Text(
                              "Convite de ${_controller.caronas[index].motorista.nome}",
                              style: Theme.of(context).textTheme.title),
                          Text(
                            "Vagas Disponíveis: ${_controller.caronas[index].totalVagas}",
                            style: TextStyle(
                                color: Theme.of(context).accentColor,
                                fontSize: 18),
                          ),
                          Text(
                            "Saindo às ${_controller.caronas[index].hora}:${_controller.caronas[index].minuto}h",
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
                                    color: Theme.of(context)
                                        .textTheme
                                        .body1
                                        .color),
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
        ),
      ],
    );
  }

  pageOferecerCarona(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          height: 60,
          child: Center(
              child: Text(
                  _controller.partida?.nome != null &&
                          _controller.destino?.nome != null
                      ? "Origem: ${_controller.partida?.nome} - Destino: ${_controller.destino?.nome}"
                      : "Origem e Destino não informados",
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
                        checked: _controller.carroAdaptado,
                        iconData: Icons.accessible,
                        onTap: () => _controller
                            .setCarroAdaptado(!_controller.carroAdaptado)),
                  ),
                  Observer(
                      builder: (_) => opcaoAdicionalButton(
                            "Porta-malas livre",
                            context,
                            checked: _controller.portaMalasLivre,
                            iconData: Icons.shopping_cart,
                            onTap: () => _controller.setPortaMalasLivre(
                                !_controller.portaMalasLivre),
                          ))
                ],
              )),
              Column(
                children: <Widget>[
                  Text("Vagas disponíveis",
                      style: TextStyle(color: Theme.of(context).accentColor)),
                  Observer(
                      builder: (_) => DropdownButton(
                            value: _controller.vagasDisponiveis,
                            onChanged: (i) => _controller.setVagasDisponiveis,
                            items: _vagasDisponiveis
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
                    onChanged: (value) {
                      if (value == null) {
                        _controller.setHora(null);
                      } else {
                        _controller.setHora(
                            TimeOfDay(hour: value.hour, minute: value.minute));
                      }
                    },
                    onShowPicker: (context, currentValue) async {
                      TimeOfDay time = await showTimePicker(
                        context: context,
                        initialTime:
                            _controller.hora ?? TimeOfDay(hour: 00, minute: 00),
                        builder: (BuildContext context, Widget child) {
                          return MediaQuery(
                            data: MediaQuery.of(context)
                                .copyWith(alwaysUse24HourFormat: true),
                            child: child,
                          );
                        },
                      );
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
                        builder: (_) => _controller.domingo
                            ? Text("Domingo")
                            : Container()),
                    Observer(
                        builder: (_) => _controller.segunda
                            ? Text("Segunda-feira")
                            : Container()),
                    Observer(
                        builder: (_) => _controller.terca
                            ? Text("Terça-feira")
                            : Container()),
                    Observer(
                        builder: (_) => _controller.quarta
                            ? Text("Quarta-feira")
                            : Container()),
                    Observer(
                        builder: (_) => _controller.quinta
                            ? Text("Quinta-feira")
                            : Container()),
                    Observer(
                        builder: (_) => _controller.sexta
                            ? Text("Sexta-feira")
                            : Container()),
                    Observer(
                        builder: (_) =>
                            _controller.sabado ? Text("Sábado") : Container()),
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
              AnimatedContainer(
                duration: Duration(milliseconds: 500),
                width: _controller.compartilhando ? 90 : 200,
                child: RaisedButton(
                  child: _controller.compartilhando
                      ? CircularProgressIndicator(backgroundColor: Colors.white)
                      : Text("Compartilhar Carona"),
                  onPressed: () async {
                    var sucesso = await _controller.compartilharCarona(grupoId);
                    if (sucesso)
                      _scaffoldKey.currentState.showSnackBar(SnackBar(
                        content: Text("Oferta de carona criada com sucesso"),
                      ));
                  },
                ),
              )
            ],
          ),
        )
      ],
    );
  }

  pageMembros(BuildContext context, ObservableList<UsuarioModel> membros) {
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
                  ),
                  trailing: !_controller.usuarioEhAdministrador
                      ? null
                      : IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () {
                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text(
                                        "Tem certeza que deseja remover ${membro.nome} do grupo?"),
                                    actions: <Widget>[
                                      FlatButton(
                                        child: Text("Não"),
                                        onPressed: () =>
                                            Navigator.of(context).pop(),
                                      ),
                                      FlatButton(
                                        child: Text("Sim"),
                                        onPressed: () async {
                                          await _controller.removerMembro(
                                              membro.id, grupoId);
                                          if (Navigator.of(context).canPop()) {
                                            Navigator.of(context).pop();
                                          }
                                        },
                                      )
                                    ],
                                  );
                                });
                          },
                        ),
                ))
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
                        value: _controller.repetirSemanalmente,
                        onChanged: (_) => _controller.setRepetirSemanalmente(
                            !_controller.repetirSemanalmente)),
                  ),
                  Observer(
                      builder: (_) => checkBoxLabel(
                          label: "Domingo",
                          value: _controller.domingo,
                          onChanged: (_) =>
                              _controller.setDomingo(!_controller.domingo))),
                  Observer(
                      builder: (_) => checkBoxLabel(
                          label: "Segunda-Feira",
                          value: _controller.segunda,
                          onChanged: (_) =>
                              _controller.setSegunda(!_controller.segunda))),
                  Observer(
                      builder: (_) => checkBoxLabel(
                          label: "Terça-Feira",
                          value: _controller.terca,
                          onChanged: (_) =>
                              _controller.setTerca(!_controller.terca))),
                  Observer(
                      builder: (_) => checkBoxLabel(
                          label: "Quarta-Feira",
                          value: _controller.quarta,
                          onChanged: (_) =>
                              _controller.setQuarta(!_controller.quarta))),
                  Observer(
                      builder: (_) => checkBoxLabel(
                          label: "Quinta-Feira",
                          value: _controller.quinta,
                          onChanged: (_) =>
                              _controller.setQuinta(!_controller.quinta))),
                  Observer(
                      builder: (_) => checkBoxLabel(
                          label: "Sexta-Feira",
                          value: _controller.sexta,
                          onChanged: (_) =>
                              _controller.setSexta(!_controller.sexta))),
                  Observer(
                      builder: (_) => checkBoxLabel(
                          label: "Sábado",
                          value: _controller.sabado,
                          onChanged: (_) =>
                              _controller.setSabado(!_controller.sabado))),
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
