import 'package:carona_prime/app/app_module.dart';
import 'package:carona_prime/app/models/local_model.dart';
import 'package:carona_prime/app/pages/map/map_page.dart';
import 'package:carona_prime/app/pages/novo_grupo/novo_grupo_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:google_maps_webservice/places.dart';

class NovoGrupoPage extends StatefulWidget {
  @override
  _NovoGrupoPageState createState() => _NovoGrupoPageState();
}

class _NovoGrupoPageState extends State<NovoGrupoPage> {
  static String kGoogleApiKey = "AIzaSyDny8aAA0AA9LBWNAkNONtTwVLFJz7u6Fo";
  GoogleMapsPlaces _places = GoogleMapsPlaces(apiKey: kGoogleApiKey);
  var _bloc = AppModule.to.bloc<NovoGrupoBloc>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Novo Grupo"),
      ),
      body: Column(
        children: <Widget>[
          StreamBuilder(
            stream: _bloc.outLocalDePartida,
            builder: (context, snapshot) {
              return Text(snapshot.data.toString());
            },
          ),
          StreamBuilder(
            stream: _bloc.outLocalDeDestino,
            builder: (context, snapshot) {
              return Text(snapshot.data.toString());
            },
          ),
          RaisedButton(
            onPressed: () async {
              Prediction p = await PlacesAutocomplete.show(
                  context: context, apiKey: kGoogleApiKey);

              var _local = await exibirPaginaDePesquisa(p);
              _bloc.setLocalDePartida(_local);
            },
            child: Text('Local de Partida'),
          ),
          RaisedButton(
            onPressed: () async {
              Prediction p = await PlacesAutocomplete.show(
                  context: context, apiKey: kGoogleApiKey);

              var _local = await exibirPaginaDePesquisa(p);
              _bloc.setLocalDeDestino(_local);
            },
            child: Text('Local de Destino'),
          ),
          RaisedButton(
            onPressed: () => Navigator.of(context).push(MaterialPageRoute(
                builder: (context) =>
                    MapPage(_bloc.localDePartida, _bloc.localDeDestino))),
            child: Text("Ver Mapa"),
          )
        ],
      ),
    );
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
}
