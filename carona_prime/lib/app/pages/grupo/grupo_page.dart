import 'package:carona_prime/app/app_module.dart';
import 'package:carona_prime/app/models/grupo_model.dart';
import 'package:carona_prime/app/pages/grupo/detalhes_grupo/detalhes_grupo_page.dart';
import 'package:carona_prime/app/pages/grupo/grupo_bloc.dart';
import 'package:carona_prime/app/shared/widgets/default_drawer.dart';
import 'package:flutter/material.dart';

class GrupoPage extends StatefulWidget {
  @override
  _GrupoPageState createState() => _GrupoPageState();
}

class _GrupoPageState extends State<GrupoPage> {
  final bloc = AppModule.to.bloc<GrupoBloc>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: DefaultDrawer(),
      appBar: AppBar(
        title: Text("Grupos"),
      ),
      body: StreamBuilder<List<GrupoModel>>(
          stream: bloc.outListaGrupos,
          builder: (_, snapshot) {
            if (!snapshot.hasData)
              return Container(
                child: Center(
                    child: Text("Você ainda não participa de nenhum grupo")),
              );

            var grupos = snapshot.data;
            return ListView(
              children: grupos
                  .map((grupo) => ListTile(
                        onTap: () => Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (context) => DetalhesGrupoPage())),
                        title: Text(grupo.nome),
                        subtitle: Text(
                            "${grupo.partida.nome} - ${grupo.destino.nome}"),
                      ))
                  .toList(),
            );
          }),
      //   floatingActionButton: FloatingActionButton(
      //     child: Icon(Icons.add),
      //     onPressed: () => Navigator.of(context)
      //         .push(MaterialPageRoute(builder: (context) => NovoGrupoPage())),
      //   ),
      // );
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: bloc.novoGrupoFake,
      ),
    );
  }
}
