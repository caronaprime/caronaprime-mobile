import 'package:carona_prime/app/application_controller.dart';
import 'package:carona_prime/app/models/local_model.dart';
import 'package:carona_prime/app/models/oferta_carona_model.dart';
import 'package:carona_prime/app/models/usuario_model.dart';
import 'package:carona_prime/app/shared/repositories/grupo_repository.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:mobx/mobx.dart';

part 'detalhes_grupo_controller.g.dart';

class DetalhesGrupoController = DetalhesGrupoBase
    with _$DetalhesGrupoController;

abstract class DetalhesGrupoBase with Store {
  var _repository = GrupoRepository();
  var applicationController = GetIt.I.get<ApplicationController>();

  @observable
  bool usuarioEhAdministrador = false;

  @observable
  int pageIndex = 0;

  @observable
  bool carroAdaptado = false;

  @observable
  bool portaMalasLivre = true;

  @observable
  int vagasDisponiveis = 4;

  @observable
  TimeOfDay hora;

  @observable
  bool domingo = false;

  @observable
  bool segunda = true;

  @observable
  bool terca = true;

  @observable
  bool quarta = true;

  @observable
  bool quinta = true;

  @observable
  bool sexta = true;

  @observable
  bool sabado = false;

  @observable
  bool repetirSemanalmente = true;

  @observable
  LocalModel partida;

  @observable
  LocalModel destino;

  @observable
  bool compartilhando = false;

  @observable
  ObservableList<UsuarioModel> membros = ObservableList<UsuarioModel>();

  @action
  void setPortaMalasLivre(bool value) => portaMalasLivre = value;

  @action
  void setCarroAdaptado(bool value) => carroAdaptado = value;

  @action
  void setVagasDisponiveis(int value) => vagasDisponiveis = value;

  @action
  void setRepetirSemanalmente(bool value) => repetirSemanalmente = value;

  @action
  void setDomingo(bool value) => domingo = value;

  @action
  void setSegunda(bool value) => segunda = value;

  @action
  void setTerca(bool value) => terca = value;

  @action
  void setQuarta(bool value) => quarta = value;

  @action
  void setQuinta(bool value) => quinta = value;

  @action
  void setSexta(bool value) => sexta = value;

  @action
  void setSabado(bool value) => sabado = value;

  @action
  void setPageIndex(int newPageIndex) => pageIndex = newPageIndex;

  @action
  void setHora(TimeOfDay value) => hora = value;

  @action
  Future carregarGrupo(int grupoId) async {
    var grupo = await _repository.getGrupo(grupoId);
    var grupoMembros = grupo.membros.map((m) => UsuarioModel(
        m.usuario?.nome ?? "Nome não informado", m.usuario?.celular,
        id: m.usuario.id));
    membros.clear();
    membros.addAll(grupoMembros.where((t) =>
        t.celular != null &&
        t.celular.isNotEmpty &&
        t.id != applicationController.usuarioLogado.id));
    partida = grupo.partida;
    destino = grupo.destino;
    usuarioEhAdministrador = grupo.membros.any((m) =>
        m.administrador &&
        m.usuario.id == applicationController.usuarioLogado.id);
  }

  @action
  void setCompartilhando(bool value) => compartilhando = value;

  bool tudoPreenchido() =>
      vagasDisponiveis > 0 && hora != null && algumDiaEscolhido();

  bool algumDiaEscolhido() =>
      domingo || segunda || terca || quarta || quinta || sexta || sabado;

  @action
  Future<bool> compartilharCarona(int grupoId) async {
    if (!compartilhando) {
      if (tudoPreenchido()) {
        compartilhando = true;
        var carona = OfertaCaronaModel()
          ..portaMalasLivre = portaMalasLivre
          ..carroAdaptado = carroAdaptado
          ..domingo = domingo
          ..segunda = segunda
          ..terca = terca
          ..quarta = quarta
          ..quinta = quinta
          ..sexta = sexta
          ..sabado = sabado
          ..totalVagas = vagasDisponiveis
          ..hora = hora.hour
          ..minuto = hora.minute
          ..grupoId = grupoId
          ..usuarioId = applicationController.usuarioLogado.id;

        print("implementar usuarioId");

        var statusCode = await _repository.compartilharCarona(carona);
        compartilhando = false;
        return statusCode >= 200 && statusCode < 300;
      }
    }
    return false;
  }

  @action
  Future<bool> removerMembro(int usuarioId, int grupoId) async {
    var removeu = await _repository.sairDoGrupo(grupoId, usuarioId);
    if (removeu) await carregarGrupo(grupoId);

    return removeu;
  }

  @computed
  String get horarioString {
    return "${hora.hour}:${hora.minute}";
  }
}
