import 'package:carona_prime/app/app_module.dart';
import 'package:carona_prime/app/models/local_model.dart';
import 'package:carona_prime/app/pages/novo_grupo/novo_grupo_bloc.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart';

class NovoGrupoPage extends StatefulWidget {
  @override
  _NovoGrupoPageState createState() => _NovoGrupoPageState();
}

class _NovoGrupoPageState extends State<NovoGrupoPage> {
  static String kGoogleApiKey = "AIzaSyDny8aAA0AA9LBWNAkNONtTwVLFJz7u6Fo";
  GoogleMapsPlaces _places = GoogleMapsPlaces(apiKey: kGoogleApiKey);
  final bloc = AppModule.to.bloc<NovoGrupoBloc>();

  @override
  void initState() {
    bloc.loadContacts("");
    bloc.loadPosicaoInicial();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: StreamBuilder<String>(
            stream: bloc.outNomeGrupo,
            builder: (_, snapshot) =>
                Text(snapshot.hasData ? snapshot.data : "Novo Grupo")),
      ),
      body: StreamBuilder<int>(
          stream: bloc.outPageIndex,
          initialData: 0,
          builder: (_, snapshot) {
            return Container(
                child: <Widget>[
              pageSelecionarContatos(),
              pageSelecionarRota(),
              paginaDados(),
            ].elementAt(snapshot.data));
          }),
      bottomNavigationBar: StreamBuilder<int>(
          stream: bloc.outPageIndex,
          initialData: 0,
          builder: (_, snapshot) {
            return BottomNavigationBar(
              items: <BottomNavigationBarItem>[
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
            );
          }),
    );
  }

  pageSelecionarContatos() {
    return StreamBuilder<SelecionarContatosViewModel>(
        stream: bloc.outSelecionarContatosViewModel,
        builder: (context, snapshot) {
          if (!snapshot.hasData) return Container();

          var grupo = snapshot.data;
          return Container(
            child: grupo.contatosFiltrados == null
                ? Center(child: Text("Nenhum contato disponível"))
                : Container(
                    child: Column(
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.all(8),
                          child: TextField(
                            controller: bloc.buscarContatosTextController,
                            onChanged: bloc.filtrarContatos,
                            decoration: InputDecoration(
                                labelText: "Buscar",
                                hintText: "Buscar",
                                suffixIcon: Icon(Icons.search)),
                          ),
                        ),
                        Expanded(
                          child: ListView(
                            children: grupo.contatosFiltrados.map((contact) {
                              var avatar = CircleAvatar(
                                child: contact.avatar.isEmpty
                                    ? Text(contact.displayName[0])
                                    : Image.memory(contact.avatar),
                              );
                              return ListTile(
                                  title: Text(contact.displayName),
                                  subtitle: Text(contact.phones.first.value),
                                  trailing: Checkbox(
                                    value: grupo.contatosSelecionados != null &&
                                        grupo.contatosSelecionados
                                                .indexOf(contact) >=
                                            0,
                                    onChanged: (value) {
                                      if (value) {
                                        bloc.adicionarContatoSelecionado(
                                            contact);
                                      } else {
                                        bloc.removerContatoSelecionado(contact);
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
        });
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
              borderRadius: borderRadius, color: Theme.of(context).backgroundColor),
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
    return TextField(
      controller: bloc.localDestinoTextController,
      onTap: () async {
        Prediction p = await PlacesAutocomplete.show(
            context: context, apiKey: kGoogleApiKey);

        var _local = await exibirPaginaDePesquisa(p);
        if (_local != null) {
          bloc.setLocalDeDestino(_local);
          bloc.loadPointsAndMarkers();
        }
      },
      decoration: InputDecoration(
          labelText: "Selecionar Destino",
          hintText: "Selecionar Destino",
          suffixIcon: Icon(Icons.search)),
    );
  }

  editSelecionarPartida() {
    return TextField(
      controller: bloc.localPartidaTextController,
      onTap: () async {
        Prediction p = await PlacesAutocomplete.show(
            context: context, apiKey: kGoogleApiKey);

        var _local = await exibirPaginaDePesquisa(p);
        if (_local != null) {
          bloc.setLocalDePartida(_local);
          bloc.loadPointsAndMarkers();
        }
      },
      decoration: InputDecoration(
          labelText: "Partida",
          hintText: "Selecionar Partida",
          suffixIcon: Icon(Icons.search)),
    );
  }

  mapaInicial() {
    return StreamBuilder<LocalModel>(
        stream: bloc.outPosicaoInicial,
        builder: (_, snapshot) {
          if (!snapshot.hasData)
            return GoogleMap(
              mapToolbarEnabled: true,
              myLocationEnabled: true,
              myLocationButtonEnabled: true,
              initialCameraPosition:
                  CameraPosition(target: LatLng(1, 1), zoom: 12),
            );

          var posicaoInicial = snapshot.data;
          return GoogleMap(
            mapToolbarEnabled: true,
            myLocationEnabled: true,
            myLocationButtonEnabled: true,
            initialCameraPosition: CameraPosition(
                target:
                    LatLng(posicaoInicial.latitude, posicaoInicial.longitude),
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
    return StreamBuilder<MapaViewModel>(
        stream: bloc.outMapaViewModel,
        builder: (_, snapshot) {
          if ((!snapshot.hasData) ||
              (snapshot.data.markers == null ||
                  snapshot.data.markers.length == 0)) return mapaInicial();

          var mapaViewModel = snapshot.data;
          return Container(
              child: GoogleMap(
            mapToolbarEnabled: true,
            myLocationEnabled: true,
            myLocationButtonEnabled: true,
            polylines: [
              Polyline(
                  width: 5,
                  color: Theme.of(context).primaryColor,
                  polylineId:
                      PolylineId(mapaViewModel.markers.first.markerId.value),
                  points: mapaViewModel.polyLinePoints)
            ].toSet(),
            initialCameraPosition: CameraPosition(
                target: LatLng(mapaViewModel.markers.first.position.latitude,
                    mapaViewModel.markers.first.position.longitude),
                zoom: 14),
            markers: mapaViewModel.markers,
          ));
        });
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
                StreamBuilder<String>(
                    stream: bloc.outNomeLocalPartida,
                    builder: (_, snapshot) => !snapshot.hasData
                        ? Text("Origem não informada")
                        : Text("Origem: ${snapshot.data}")),
                StreamBuilder<String>(
                    stream: bloc.outNomeLocalDestino,
                    builder: (_, snapshot) => !snapshot.hasData
                        ? Text("Destino não informado")
                        : Text("Destino: ${snapshot.data}")),
              ],
            )),
          ),
          Container(
            child: Expanded(
                child: StreamBuilder<SelecionarContatosViewModel>(
                    stream: bloc.outSelecionarContatosViewModel,
                    builder: (_, snapshot) {
                      if (!snapshot.hasData) return Container();

                      var contatosSelecionados =
                          snapshot.data.contatosSelecionados;
                      return ListView(
                        children: contatosSelecionados.map((contact) {
                          return listTileContact(contact);
                        }).toList(),
                      );
                    })),
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
                      onPressed: bloc.cancelar,
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
