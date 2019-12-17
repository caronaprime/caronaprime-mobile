import 'package:carona_prime/app/app_module.dart';
import 'package:carona_prime/app/models/local_model.dart';
import 'package:carona_prime/app/pages/novo_grupo/grupo_viewmodel.dart';
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
    return StreamBuilder<GrupoViewModel>(
        stream: bloc.outGrupo,
        initialData: GrupoViewModel(),
        builder: (_, snapshot) {
          return Scaffold(
            appBar: AppBar(title: Text(snapshot.data.nome)),
            body: Container(
                child: <Widget>[
              pageSelecionarContatos(snapshot.data),
              pageSelecionarRota(snapshot.data),
              paginaDados(snapshot.data),
            ].elementAt(snapshot.data.pageIndex)),
            bottomNavigationBar: BottomNavigationBar(
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
              currentIndex: snapshot.data.pageIndex,
            ),
          );
        });
  }

  pageSelecionarContatos(GrupoViewModel grupo) {
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
                              checkColor: Theme.of(context).primaryColor,
                              value: grupo.contatosSelecionados != null &&
                                  grupo.contatosSelecionados.indexOf(contact) >=
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
                    ),
                  )
                ],
              ),
            ),
    );
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

  pageSelecionarRota(GrupoViewModel grupo) {
    return Container(
        child: Center(
      child: Stack(
        fit: StackFit.loose,
        overflow: Overflow.visible,
        children: <Widget>[mapa(grupo), inputsLocalizacao()],
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

  mapaInicial(GrupoViewModel grupo) {
    return grupo != null
        ? GoogleMap(
            mapToolbarEnabled: true,
            myLocationEnabled: true,
            myLocationButtonEnabled: true,
            initialCameraPosition:
                CameraPosition(target: LatLng(1, 1), zoom: 12),
          )
        : GoogleMap(
            mapToolbarEnabled: true,
            myLocationEnabled: true,
            myLocationButtonEnabled: true,
            initialCameraPosition: CameraPosition(
                target: LatLng(grupo.posicaoInicial.latitude,
                    grupo.posicaoInicial.longitude),
                zoom: 12),
          );
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

  mapa(GrupoViewModel grupo) {
    return Container(
        child: grupo.markers != null || grupo.markers.length == 0
            ? mapaInicial(grupo)
            : GoogleMap(
                mapToolbarEnabled: true,
                myLocationEnabled: true,
                myLocationButtonEnabled: true,
                polylines: [
                  Polyline(
                      width: 5,
                      color: Theme.of(context).primaryColor,
                      polylineId:
                          PolylineId(grupo.markers.first.markerId.value),
                      points: grupo.polyLinePoints)
                ].toSet(),
                initialCameraPosition: CameraPosition(
                    target: LatLng(grupo.markers.first.position.latitude,
                        grupo.markers.first.position.longitude),
                    zoom: 14),
                markers: grupo.markers,
              ));
  }

  paginaDados(GrupoViewModel grupo) {
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
                grupo.localDePartida == null
                    ? Text("Origem não informada")
                    : Text("Origem: " + grupo.localDePartida.nome),
                grupo.localDeDestino == null
                    ? Text("Destino não informado")
                    : Text("Destino: " + grupo.localDeDestino.nome)
              ],
            )),
          ),
          Container(
            child: Expanded(
                child: ListView(
              children: grupo.contatosSelecionados.map((contact) {
                return listTileContact(contact);
              }).toList(),
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
