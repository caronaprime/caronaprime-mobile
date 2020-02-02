import 'package:carona_prime/app/models/grupo_model.dart';
import 'package:carona_prime/app/models/oferta_carona_model.dart';
import 'package:carona_prime/app/shared/default_url.dart';
import 'package:carona_prime/app/shared/responses/lista_grupos_response.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';

class GrupoRepository {
  var urlDefault = GetIt.I.get<DefaultUrl>();
  var dio = Dio();

  Future<bool> sairDoGrupo(int grupoId, int usuarioId) async {
    try {
      var response = await dio.post(urlDefault.url + '/grupos/sair',
          data: {"grupoId": grupoId, "usuarioId": usuarioId});
      return (response.statusCode >= 200 && response.statusCode < 300);      
    } catch (e) {
      return false; 
    }
  }

  Future<List<ListaGruposResponse>> getGrupos(int usuarioId) async {
    try {
      var response =
          await dio.get(urlDefault.url + "/usuarios/$usuarioId/grupos");
      var grupos = List<ListaGruposResponse>();
      for (var grupoJson in response.data) {
        var grupo = ListaGruposResponse.fromJson(grupoJson);
        grupos.add(grupo);
      }
      return grupos;
    } catch (e) {
      return null;
    }
  }

  Future<GrupoModel> getGrupo(int grupoId) async {
    if (grupoId > 0) {
      try {
        var response = await dio.get(urlDefault.url + "/grupos/$grupoId");
        var grupo = GrupoModel.fromJson(response.data);
        return grupo;
      } catch (e) {
        return null;
      }
    }
    return null;
  }

  Future<int> postGrupo(GrupoModel grupo) async {
    try {
      var json = grupo.toJson();
      var response = await dio.post(urlDefault.url + "/grupos", data: json);
      return response.statusCode;
    } on DioError catch (e) {
      print(e.message);
      return e.response.statusCode;
    }
  }

  Future<int> compartilharCarona(OfertaCaronaModel carona) async {
    try {
      var json = carona.toJson();
      var response = await dio
          .post(urlDefault.url + '/grupos/compartilhar-carona', data: json);
      return response.statusCode;
    } on DioError catch (e) {
      print(e.message);
      return e.response.statusCode;
    }
  }
}
