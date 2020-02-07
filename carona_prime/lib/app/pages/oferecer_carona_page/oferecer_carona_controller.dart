import 'package:carona_prime/app/application_controller.dart';
import 'package:carona_prime/app/models/local_model.dart';
import 'package:carona_prime/app/models/oferta_carona_model.dart';
import 'package:carona_prime/app/shared/repositories/grupo_repository.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:mobx/mobx.dart';
part 'oferecer_carona_controller.g.dart';

class OferecerCaronaController = OferecerCaronaBase
    with _$OferecerCaronaController;

abstract class OferecerCaronaBase with Store {
  var _repository = GrupoRepository();
  var applicationController = GetIt.I.get<ApplicationController>();

  @observable
  bool carregou = false;

  @observable
  LocalModel partida;

  @observable
  LocalModel destino;

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
  void setHora(TimeOfDay value) => hora = value;

  @action
  Future<bool> carregarOfertaCarona(int grupoId) async {
    var retorno = await _repository.carregarOfertaCarona(
        grupoId, applicationController.usuarioLogado.id);
    carregou = true;
    if (retorno != null) {
      carroAdaptado = retorno.carroAdaptado;
      portaMalasLivre = retorno.portaMalasLivre;
      domingo = retorno.domingo;
      segunda = retorno.segunda;
      terca = retorno.terca;
      quarta = retorno.quarta;
      quinta = retorno.quinta;
      sexta = retorno.sexta;
      sabado = retorno.sabado;
      hora = TimeOfDay(hour: retorno.hora, minute: retorno.minuto);
      vagasDisponiveis = retorno.totalVagas;

      return true;
    }
    return false;
  }

  @action
  Future<bool> compartilharCarona(int grupoId) async {
    if (tudoPreenchido()) {
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
        ..repertirSemanalmente = repetirSemanalmente
        ..usuarioId = applicationController.usuarioLogado.id;

      var statusCode = await _repository.compartilharCarona(carona);
      return statusCode >= 200 && statusCode < 300;
    }

    return false;
  }

  bool tudoPreenchido() =>
      vagasDisponiveis > 0 && hora != null && algumDiaEscolhido();

  bool algumDiaEscolhido() =>
      domingo || segunda || terca || quarta || quinta || sexta || sabado;
}
