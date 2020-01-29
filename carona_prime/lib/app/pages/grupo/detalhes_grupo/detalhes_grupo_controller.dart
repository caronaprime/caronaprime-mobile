import 'package:carona_prime/app/models/local_model.dart';
import 'package:carona_prime/app/models/usuario_model.dart';
import 'package:carona_prime/app/shared/repositories/grupo_repository.dart';
import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';

part 'detalhes_grupo_controller.g.dart';

class DetalhesGrupoController = DetalhesGrupoBase
    with _$DetalhesGrupoController;

abstract class DetalhesGrupoBase with Store {
  var _repository = GrupoRepository();

  @observable
  int pageIndex = 0;

  @observable
  bool carroAdaptado = false;

  @observable
  bool portaMalasLivre = true;

  @observable
  int vagasDisponiveis = 4;

  @observable
  TimeOfDay hora = TimeOfDay(hour: 10, minute: 0);

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
        m.usuario?.nome ?? "Nome não informado", m.usuario?.celular));
    membros.clear();
    membros.addAll(
        grupoMembros.where((t) => t.celular != null && t.celular.isNotEmpty));
    partida = grupo.partida;
    destino = grupo.destino;
  }

  @computed
  String get horarioString {
    return "${hora.hour}:${hora.minute}";
  }
}
