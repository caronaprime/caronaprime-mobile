import 'package:carona_prime/app/models/grupo_model.dart';
import 'package:carona_prime/app/shared/default_url.dart';
import 'package:carona_prime/app/shared/responses/lista_grupos_response.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';

class GrupoRepository {
  var dioClient = GetIt.I.get<DefaultUrl>();
  var dio = Dio();

  Future<List<ListaGruposResponse>> getGrupos() async {
    try {
      var response = await dio.get(dioClient.url + "/grupos");
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
        var response = await dio.get(dioClient.url + "/grupos/$grupoId");
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
      var response = await dio.post(dioClient.url + "/grupos", data: json);
      return response.statusCode;
    } on DioError catch (e) {
      print(e.message);
      return e.response.statusCode;
    }
  }
}
