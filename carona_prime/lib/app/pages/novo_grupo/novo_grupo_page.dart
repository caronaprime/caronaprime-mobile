import 'package:carona_prime/app/app_module.dart';
import 'package:carona_prime/app/models/local_model.dart';
import 'package:carona_prime/app/pages/novo_grupo/mapa_viewmodel.dart';
import 'package:carona_prime/app/pages/novo_grupo/novo_grupo_bloc.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart';

class NovoGrupoPage extends StatefulWidget {
  final _bloc = AppModule.to.bloc<NovoGrupoBloc>();
  @override
  _NovoGrupoPageState createState() => _NovoGrupoPageState(_bloc);
}

class _NovoGrupoPageState extends State<NovoGrupoPage> {
  NovoGrupoBloc bloc;
  static String kGoogleApiKey = "AIzaSyDny8aAA0AA9LBWNAkNONtTwVLFJz7u6Fo";
  GoogleMapsPlaces _places = GoogleMapsPlaces(apiKey: kGoogleApiKey);

  _NovoGrupoPageState(this.bloc) {
    bloc.loadContacts("");
    bloc.loadPosicaoInicial();
  }

  @override
  Widget build(BuildContext context) {
    var list = <Widget>[
      pageSelecionarContatos(),
      pageSelecionarRota(),
      paginaDados(),
    ];
    var _pages = list;

    return Scaffold(
      appBar: AppBar(
          title: StreamBuilder<String>(
        stream: bloc.outNomeGrupo,
        initialData: "Cadastro de Grupo",
        builder: (_, snapshot) {
          return Text(snapshot.data);
        },
      )),
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

  inputsLocalizacao() {
    return Positioned(
      top: 0,
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: 170,
        child: Container(
          child: Column(
            children: <Widget>[
              modeloInput(editSelecionarPartida()),
              modeloInput(editSelecionarDestino())
            ],
          ),
        ),
      ),
    );
  }

  modeloInput(Widget child) {
    var borderRadius = BorderRadius.circular(10);
    var themeBorder =
        Theme.of(context).inputDecorationTheme.border as OutlineInputBorder;
    if (themeBorder != null) borderRadius = themeBorder.borderRadius;

    return Padding(
      padding: EdgeInsets.all(8),
      child: Container(
          decoration: BoxDecoration(
              borderRadius: borderRadius, color: Theme.of(context).accentColor),
          child: child),
    );
  }

  pageSelecionarRota() {
    return Container(
        child: Center(
      child: Stack(
        fit: StackFit.loose,
        overflow: Overflow.visible,
        children: <Widget>[mapa(), inputsLocalizacao()],
      ),
    ));
  }

  Future<LocalModel> exibirPaginaDePesquisa(Prediction p) async {
    if (p != null) {
      PlacesDetailsResponse detail =
          await _places.getDetailsByPlaceId(p.placeId);

      return LocalModel(detail.result.name, detail.result.geometry.location.lat,
          detail.result.geometry.location.lng, p.placeId);
    }
    return null;
  }

  editSelecionarDestino() {
    return StreamBuilder<LocalModel>(
      stream: bloc.outLocalDeDestino,
      builder: (context, snapshot) {
        return TextField(
          controller: bloc.localDestinoTextController,
          onTap: () async {
            Prediction p = await PlacesAutocomplete.show(
                context: context, apiKey: kGoogleApiKey);

            var _local = await exibirPaginaDePesquisa(p);
            bloc.setLocalDeDestino(_local);
            bloc.loadPointsAndMarkers();
          },
          onChanged: bloc.filtrarContatos,
          decoration: InputDecoration(
              labelText: "Selecionar Destino",
              hintText: "Selecionar Destino",
              suffixIcon: Icon(Icons.search)),
        );
      },
    );
  }

  editSelecionarPartida() {
    return StreamBuilder<LocalModel>(
      stream: bloc.outLocalDePartida,
      builder: (context, snapshot) {
        return TextField(
          controller: bloc.localPartidaTextController,
          onTap: () async {
            Prediction p = await PlacesAutocomplete.show(
                context: context, apiKey: kGoogleApiKey);

            var _local = await exibirPaginaDePesquisa(p);
            bloc.setLocalDePartida(_local);
            bloc.loadPointsAndMarkers();
          },
          onChanged: bloc.filtrarContatos,
          decoration: InputDecoration(
              labelText: "Partida",
              hintText: "Selecionar Partida",
              suffixIcon: Icon(Icons.search)),
        );
      },
    );
  }

  mapaInicial() {
    return StreamBuilder<LocalModel>(
        stream: bloc.outPosicaoInicial,
        builder: (context, snapshot) {
          if (!snapshot.hasData)
            return GoogleMap(
              mapToolbarEnabled: true,
              myLocationEnabled: true,
              myLocationButtonEnabled: true,
              initialCameraPosition:
                  CameraPosition(target: LatLng(1, 1), zoom: 12),
            );

          return GoogleMap(
            mapToolbarEnabled: true,
            myLocationEnabled: true,
            myLocationButtonEnabled: true,
            initialCameraPosition: CameraPosition(
                target: LatLng(snapshot.data.latitude, snapshot.data.longitude),
                zoom: 12),
          );
        });
  }

  ListTile listTileContact(Contact contact) {
    var avatar = CircleAvatar(
      child: contact.avatar.isEmpty
          ? Text(contact.displayName[0])
          : Image.memory(contact.avatar),
    );
    return ListTile(
        title: Text(contact.displayName),
        subtitle: Text(contact.phones.first.value),
        leading: avatar);
  }

  mapa() {
    return Container(
      child: StreamBuilder<MapaViewModel>(
          stream: bloc.outMapa,
          builder: (_, snapshot) {
            if (!snapshot.hasData || snapshot.data.markers.length == 0)
              return mapaInicial();

            return GoogleMap(
              mapToolbarEnabled: true,
              myLocationEnabled: true,
              myLocationButtonEnabled: true,
              polylines: [
                Polyline(
                  width: 5,
                  color: Colors.blue,
                    polylineId:
                        PolylineId(snapshot.data.markers.first.markerId.value),
                    points: snapshot.data.polyLinePoints)
              ].toSet(),
              initialCameraPosition: CameraPosition(
                  target: LatLng(snapshot.data.markers.first.position.latitude,
                      snapshot.data.markers.first.position.longitude),
                  zoom: 14),
              markers: snapshot.data.markers,
            );
          }),
    );
  }

  paginaDados() {
    return Container(
        child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: <Widget>[
          TextField(
            controller: bloc.nomeGrupoTextController,
            onChanged: bloc.setNomeGrupo,
            decoration: InputDecoration(labelText: "Nome"),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
                child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                StreamBuilder<LocalModel>(
                    stream: bloc.outLocalDePartida,
                    builder: (_, snapshot) {
                      if (!snapshot.hasData)
                        return Text("Origem não informada");
                      return Text("Origem: " + snapshot.data.nome);
                    }),
                StreamBuilder<LocalModel>(
                    stream: bloc.outLocalDeDestino,
                    builder: (_, snapshot) {
                      if (!snapshot.hasData)
                        return Text("Destino não informado");
                      return Text("Destino: " + snapshot.data.nome);
                    }),
              ],
            )),
          ),
          Container(
            child: Expanded(
                child: StreamBuilder<List<Contact>>(
              stream: bloc.outContatosSelecionados,
              initialData: [],
              builder: (_, snapshot) {
                return ListView(
                  children: snapshot.data.map((contact) {
                    return listTileContact(contact);
                  }).toList(),
                );
              },
            )),
          ),
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                SizedBox(
                  width: 140,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: RaisedButton(
                      color: Theme.of(context).disabledColor,
                      onPressed: () {},
                      child: Text("Cancelar"),
                    ),
                  ),
                ),
                SizedBox(
                  width: 140,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: RaisedButton(
                      onPressed: () {},
                      child: Text("Salvar"),
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    ));
  }
}
