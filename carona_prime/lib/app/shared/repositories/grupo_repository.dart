import 'package:carona_prime/app/shared/default_url.dart';
import 'package:carona_prime/app/shared/responses/lista_grupos_response.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';

class GrupoRepository {
  Future<List<ListaGruposResponse>> getGrupos() async {
    var dioClient = GetIt.I.get<DefaultUrl>();
    var dio = Dio();
    var response = await dio.get(dioClient.url + "/grupos");
    var grupos = List<ListaGruposResponse>();
    for (var grupo in response.data["grupos"]) {
      grupos.add(ListaGruposResponse.fromJson(grupo));
    }
    return grupos;
  }
}
