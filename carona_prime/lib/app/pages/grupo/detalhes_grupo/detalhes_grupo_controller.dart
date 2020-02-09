import 'package:carona_prime/app/application_controller.dart';
import 'package:carona_prime/app/models/carona_model.dart';
import 'package:carona_prime/app/models/local_model.dart';
import 'package:carona_prime/app/models/usuario_model.dart';
import 'package:carona_prime/app/shared/repositories/grupo_repository.dart';
import 'package:get_it/get_it.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mobx/mobx.dart';

part 'detalhes_grupo_controller.g.dart';

class DetalhesGrupoController = DetalhesGrupoBase
    with _$DetalhesGrupoController;

abstract class DetalhesGrupoBase with Store {
  var _repository = GrupoRepository();
  var applicationController = GetIt.I.get<ApplicationController>();

  @observable
  ObservableList<LatLng> polyLinePoints = ObservableList<LatLng>();

  @observable
  ObservableList<Marker> markers = ObservableList<Marker>();


  @observable
  String nomeDoGrupo = "";

  @observable
  bool usuarioEhAdministrador = false;

  @observable
  int pageIndex = 0;

  @observable
  LocalModel partida;

  @observable
  LocalModel destino;

  @observable
  ObservableList<UsuarioModel> membros = ObservableList<UsuarioModel>();

  @observable
  ObservableList<CaronaModel> caronas = ObservableList<CaronaModel>();

  @observable
  ObservableList<CaronaModel> proximasViagens = ObservableList<CaronaModel>();

  @action
  void setPageIndex(int newPageIndex) => pageIndex = newPageIndex;

  @action
  Future<bool> adicionarContatos(
      List<UsuarioModel> contatos, int grupoId) async {
    if (contatos.length > 0) {
      var retorno = await _repository.adicionarMembros(contatos, grupoId);
      if (retorno) carregarGrupo(grupoId);

      return retorno;
    }
    return false;
  }

  @action
  Future carregarGrupo(int grupoId) async {
    var grupo = await _repository.getGrupo(grupoId);
    if (grupo != null) {
      nomeDoGrupo = grupo.nome;
      var grupoMembros = grupo.membros.map((m) => UsuarioModel(
          m.usuario?.nome ?? "Nome não informado", m.usuario?.celular,
          id: m.usuario.id));
      membros.clear();
      membros.addAll(grupoMembros.where((t) =>
          t.celular != null &&
          t.celular.isNotEmpty &&
          t.id != applicationController.usuarioLogado.id));
      caronas.clear();
      caronas.addAll(grupo.caronas.where((c) =>
          c.usuarioId != applicationController.usuarioLogado.id &&
          !c.respostas.any(
              (r) => r.usuarioId == applicationController.usuarioLogado.id)));
      partida = grupo.partida;
      destino = grupo.destino;
      usuarioEhAdministrador = grupo.membros.any((m) =>
          m.administrador &&
          m.usuario.id == applicationController.usuarioLogado.id);

      var polys = grupo.latLongs.map((l) => LatLng(l.latitude, l.longitude)).toList();
      polyLinePoints.clear();
      polyLinePoints.addAll(polys);     

      markers.add(Marker(markerId: MarkerId(grupo.partida.placeId), position: LatLng(grupo.partida.latitude, grupo.partida.longitude)));
      markers.add(Marker(markerId: MarkerId(grupo.destino.placeId), position: LatLng(grupo.destino.latitude, grupo.destino.longitude)));

      await _carregarProximasViagens(grupoId);
    }
  }

  Future _carregarProximasViagens(int grupoId) async {
    var resposta = await _repository.getProximasViagens(
        applicationController.usuarioLogado.id, grupoId);
    if (resposta != null) {
      proximasViagens.clear();
      proximasViagens.addAll(resposta);
    }
  }

  @action
  Future<bool> desistirDaCarona(int caronaId) async {
    print("implementar");
    return true;
  }

  @action
  Future<bool> removerMembro(int usuarioId, int grupoId) async {
    var removeu = await _repository.sairDoGrupo(grupoId, usuarioId);
    if (removeu) await carregarGrupo(grupoId);

    return removeu;
  }

  @action
  Future<bool> recusarCarona(int caronaId, int grupoId) async {
    var sucesso = await _repository.recusarCarona(
        applicationController.usuarioLogado.id, caronaId);
    if (sucesso) await carregarGrupo(grupoId);

    return sucesso;
  }

  @action
  Future<bool> aceitarCarona(int caronaId, int grupoId) async {
    var sucesso = await _repository.aceitarCarona(
        applicationController.usuarioLogado.id, caronaId);
    if (sucesso) await carregarGrupo(grupoId);

    return sucesso;
  }
}
