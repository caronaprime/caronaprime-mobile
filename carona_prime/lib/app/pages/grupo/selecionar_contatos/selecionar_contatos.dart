import 'package:carona_prime/app/models/usuario_model.dart';
import 'package:carona_prime/app/pages/grupo/selecionar_contatos/selecionar_contatos_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobx/mobx.dart';

class SelecionarContatoPage extends StatefulWidget {
  final bool mostrarBotaoConcluir;
  final ObservableList<UsuarioModel> membros;
  const SelecionarContatoPage(this.mostrarBotaoConcluir, this.membros);

  @override
  _SelecionarContatoPageState createState() => _SelecionarContatoPageState();
}

class _SelecionarContatoPageState extends State<SelecionarContatoPage> {
  final controller = SelecionarContatosController();

  final buscarContatosTextController = TextEditingController();

  @override
  void initState() {
    super.initState();
    controller.loadContacts();
  }

  bool isNumber(String text) => '0123456789'.split('').contains(text);

  String onlyNumbers(String text) =>
      text.split('').where((c) => isNumber(c)).join('');

  String phoneNumber(String text) {
    if (text == null) return null;

    var number = onlyNumbers(text);
    if (number.length <= 11) return number;

    return number.substring(number.length - 11);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Adicionar contatos"),
      ),
      body: Center(child: Observer(
        builder: (_) {
          if (!controller.carregouContato)
            return Center(child: CircularProgressIndicator());

          return Container(
            child: controller.todosContatos == null ||
                    controller.todosContatos.isEmpty
                ? Center(child: Text("Nenhum contato disponível"))
                : Stack(
                    children: <Widget>[
                      Column(
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.all(8),
                            child: TextFormField(
                              validator: controller.textNotEmptyValidator,
                              controller: buscarContatosTextController,
                              onChanged: controller.setQuery,
                              decoration: InputDecoration(
                                  labelText: "Buscar",
                                  hintText: "Buscar",
                                  suffixIcon: Icon(Icons.search)),
                            ),
                          ),
                          Expanded(
                            child: ListView(
                              children:
                                  controller.contatosFiltrados.map((contact) {
                                var avatar = CircleAvatar(
                                  child: contact.avatar.isEmpty
                                      ? Text(contact.displayName[0])
                                      : Image.memory(contact.avatar),
                                );
                                return ListTile(
                                    title: Text(contact.displayName),
                                    subtitle: Text(contact.phones.first.value),
                                    trailing: Checkbox(
                                      value: controller.contatosSelecionados !=
                                              null &&
                                          controller.contatosSelecionados
                                                  .indexOf(contact) >=
                                              0,
                                      onChanged: (value) {
                                        if (value) {
                                          controller
                                              .adicionarContatoSelecionado(
                                                  contact);
                                        } else {
                                          controller.removerContatoSelecionado(
                                              contact);
                                        }
                                      },
                                    ),
                                    leading: avatar);
                              }).toList(),
                            ),
                          ),
                        ],
                      ),
                      widget.mostrarBotaoConcluir
                          ? Positioned(
                              bottom: 10,
                              left:
                                  (MediaQuery.of(context).size.width - 200) / 2,
                              child: Container(
                                width: 200,
                                child: RaisedButton(
                                  child: Text("Concluir"),
                                  onPressed: () {
                                    var numerosJaNoGrupo = widget.membros
                                        .map((m) => phoneNumber(m.celular))
                                        .toList();
                                    var novosContatos = controller
                                        .contatosSelecionados
                                        .where((c) => !numerosJaNoGrupo.contains(
                                            phoneNumber(c.phones.first.value))).toList();

                                    Navigator.of(context).pop(novosContatos);
                                  },
                                ),
                              ),
                            )
                          : Container(),
                    ],
                  ),
          );
        },
      )),
    );
  }
}
