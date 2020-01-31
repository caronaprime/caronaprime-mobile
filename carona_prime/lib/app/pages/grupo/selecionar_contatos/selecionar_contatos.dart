import 'package:carona_prime/app/pages/grupo/selecionar_contatos/selecionar_contatos_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

class SelecionarContatoPage extends StatelessWidget {
  final controller = SelecionarContatosController();
  final buscarContatosTextController = TextEditingController();

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
                : Container(
                    child: Column(
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
                                        controller.adicionarContatoSelecionado(
                                            contact);
                                      } else {
                                        controller
                                            .removerContatoSelecionado(contact);
                                      }
                                    },
                                  ),
                                  leading: avatar);
                            }).toList(),
                          ),
                        )
                      ],
                    ),
                  ),
          );
        },
      )),
    );
  }
}
