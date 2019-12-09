import 'package:carona_prime/app/app_module.dart';
import 'package:carona_prime/app/pages/novo_grupo/novo_grupo_bloc.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';

class NovoGrupoPage extends StatefulWidget {
  final _bloc = AppModule.to.bloc<NovoGrupoBloc>();
  @override
  _NovoGrupoPageState createState() => _NovoGrupoPageState(_bloc);
}

class _NovoGrupoPageState extends State<NovoGrupoPage> {
  NovoGrupoBloc bloc;
  _NovoGrupoPageState(this.bloc) {
    bloc.loadContacts("");
  }

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context);
    var list = <Widget>[
      pageSelecionarContatos(),
      Container(
          child: Text('Index 2: School'),
          width: mediaQuery.size.width,
          height: mediaQuery.size.height),
      Container(
        child: Text("Index 3: teste"),
        width: mediaQuery.size.width,
        height: mediaQuery.size.height,
      )
    ];
    var _pages = list;

    return Scaffold(
      appBar: AppBar(
        title: Text("teste"),
      ),
      body: StreamBuilder<int>(
        initialData: 0,
        stream: bloc.outPageIndex,
        builder: (context, snapshot) =>
            Container(child: _pages.elementAt(snapshot.data)),
      ),
      bottomNavigationBar: StreamBuilder(
        initialData: 0,
        stream: bloc.outPageIndex,
        builder: (context, snapshot) => BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.contacts),
              title: Text('Contatos'),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.map),
              title: Text('Rotas'),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.create),
              title: Text('Dados'),
            ),
          ],
          onTap: bloc.setIndex,
          currentIndex: snapshot.data,
        ),
      ),
    );
  }

  pageSelecionarContatos() {
    return Container(
        child: StreamBuilder<Iterable<Contact>>(
      initialData: [],
      stream: bloc.outContatosFiltrados,
      builder: (_, snapshot) {
        if (!snapshot.hasData)
          return Center(child: Text("Nenhum contato disponível"));

        return Container(
          child: Column(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.all(8),
                child: TextField(
                  onChanged: bloc.filtrarContatos,
                  decoration: InputDecoration(
                      labelText: "Buscar",
                      hintText: "Buscar",
                      suffixIcon: Icon(Icons.search)),
                ),
              ),
              Expanded(
                  child: StreamBuilder<List<Contact>>(
                stream: bloc.outContatosSelecionados,
                initialData: [],
                builder: (_, snapContatosSelecionados) {
                  return ListView(
                    children: snapshot.data.map((contact) {
                      var avatar = CircleAvatar(
                        child: contact.avatar.isEmpty
                            ? Text(contact.displayName[0])
                            : Image.memory(contact.avatar),
                      );
                      return ListTile(
                          title: Text(contact.displayName),
                          subtitle: Text(contact.phones.first.value),
                          trailing: Checkbox(
                            checkColor: Theme.of(context).primaryColor,
                            value: snapContatosSelecionados.hasData &&
                                snapContatosSelecionados.data
                                        .indexOf(contact) >=
                                    0,
                            onChanged: (value) {
                              if (value) {
                                bloc.adicionarContatoSelecionado(contact);
                              } else {
                                bloc.removerContatoSelecionado(contact);
                              }
                            },
                          ),
                          leading: avatar);
                    }).toList(),
                  );
                },
              ))
            ],
          ),
        );
      },
    ));
  }
}
