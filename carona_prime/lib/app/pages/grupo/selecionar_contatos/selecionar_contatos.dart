import 'package:carona_prime/app/application_controller.dart';
import 'package:carona_prime/app/models/usuario_model.dart';
import 'package:carona_prime/app/pages/grupo/selecionar_contatos/selecionar_contatos_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';
import 'package:mobx/mobx.dart';

class SelecionarContatoPage extends StatefulWidget {
  final bool mostrarBotaoConcluir;
  final ObservableList<UsuarioModel> membros;
  final bool paginaCompleta;

  const SelecionarContatoPage(
      {@required this.mostrarBotaoConcluir,
      @required this.membros,
      @required this.paginaCompleta});

  @override
  _SelecionarContatoPageState createState() => _SelecionarContatoPageState();
}

class _SelecionarContatoPageState extends State<SelecionarContatoPage> {
  final controller = SelecionarContatosController();
  final applicationController = GetIt.I.get<ApplicationController>();
  final buscarContatosTextController = TextEditingController();

  @override
  void initState() {
    super.initState();
    controller.loadContacts();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.paginaCompleta) {
      return Scaffold(
        appBar: AppBar(
          title: Text("Selecionar Contatos"),
        ),
        body: body(),
      );
    }

    return body();
  }

  Widget body() {
    return Center(
      child: Observer(
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
                                String numero = "";
                                if (contact.phones == null ||
                                    contact.phones.isEmpty)
                                  numero = "sem número";
                                else
                                  numero = contact.phones.first.value;
                                return ListTile(
                                    title: Text(contact.displayName),
                                    subtitle: Text(numero),
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
                                    List<String> numerosJaNoGrupo =
                                        List<String>();
                                    if (widget.membros != null) {
                                      numerosJaNoGrupo = widget.membros
                                          .map((m) => applicationController
                                              .phoneNumber(m.celular))
                                          .toList();
                                    }
                                    var novosContatos = controller
                                        .contatosSelecionados
                                        .where((c) {
                                      String numero = "";
                                      if (c.phones == null || c.phones.isEmpty)
                                        numero = "sem número";
                                      else
                                        numero = c.phones.first.value;

                                      return !numerosJaNoGrupo.contains(
                                          applicationController
                                              .phoneNumber(numero));
                                    }).toList();

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
      ),
    );
  }
}
