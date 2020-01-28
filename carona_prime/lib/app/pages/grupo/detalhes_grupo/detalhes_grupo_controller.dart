import 'package:carona_prime/app/models/usuario_model.dart';
import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';

part 'detalhes_grupo_controller.g.dart';

class DetalhesGrupoController = DetalhesGrupoBase
    with _$DetalhesGrupoController;

abstract class DetalhesGrupoBase with Store {
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
  ObservableList<UsuarioModel> membros = [
    UsuarioModel("Riquelminho Gaucho", "999423412349"),
    UsuarioModel("Cristiano Messi", "6599942002"),
    UsuarioModel("Lionel Ronaldo", "6623450403"),
  ].asObservable();

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

  @computed
  String get horarioString {
    return "${hora.hour}:${hora.minute}";
  }
}
