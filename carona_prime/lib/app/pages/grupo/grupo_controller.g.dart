// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'grupo_controller.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$GrupoController on GrupoBase, Store {
  final _$gruposAtom = Atom(name: 'GrupoBase.grupos');

  @override
  List<GrupoModel> get grupos {
    _$gruposAtom.context.enforceReadPolicy(_$gruposAtom);
    _$gruposAtom.reportObserved();
    return super.grupos;
  }

  @override
  set grupos(List<GrupoModel> value) {
    _$gruposAtom.context.conditionallyRunInAction(() {
      super.grupos = value;
      _$gruposAtom.reportChanged();
    }, _$gruposAtom, name: '${_$gruposAtom.name}_set');
  }

  final _$GrupoBaseActionController = ActionController(name: 'GrupoBase');

  @override
  void novoGrupoFake() {
    final _$actionInfo = _$GrupoBaseActionController.startAction();
    try {
      return super.novoGrupoFake();
    } finally {
      _$GrupoBaseActionController.endAction(_$actionInfo);
    }
  }
}
