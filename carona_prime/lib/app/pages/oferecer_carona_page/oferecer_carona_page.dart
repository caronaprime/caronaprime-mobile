import 'package:carona_prime/app/pages/oferecer_carona_page/oferecer_carona_controller.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:intl/intl.dart';

class OferecerCaronaPage extends StatelessWidget {
  final _controller = OferecerCaronaController();
  final _vagasDisponiveis = [1, 2, 3, 4, 5, 6];

  final GlobalKey<ScaffoldState> scaffoldKey;
  final int grupoId;
  OferecerCaronaPage({@required this.scaffoldKey, @required this.grupoId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Compartilhar Carona")),
      body: Column(
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
                          labelStyle: Theme.of(context)
                              .inputDecorationTheme
                              .labelStyle),
                      format: DateFormat("HH:mm"),
                      onChanged: (value) {
                        if (value == null) {
                          _controller.setHora(null);
                        } else {
                          _controller.setHora(TimeOfDay(
                              hour: value.hour, minute: value.minute));
                        }
                      },
                      onShowPicker: (context, currentValue) async {
                        TimeOfDay time = await showTimePicker(
                          context: context,
                          initialTime: _controller.hora ??
                              TimeOfDay(hour: 00, minute: 00),
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
                          builder: (_) => _controller.sabado
                              ? Text("Sábado")
                              : Container()),
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
                Container(
                  width: 200,
                  child: RaisedButton(
                    child: Text("Compartilhar Carona"),
                    onPressed: () async {
                      var sucesso =
                          await _controller.compartilharCarona(grupoId);
                      if (sucesso)
                        scaffoldKey.currentState.showSnackBar(SnackBar(
                          content: Text("Oferta de carona criada com sucesso"),
                        ));
                    },
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
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

  checkBoxLabel({String label, bool value, Function(bool) onChanged}) =>
      Row(children: <Widget>[
        Checkbox(
          value: value,
          onChanged: onChanged,
        ),
        Text(label)
      ]);
}
