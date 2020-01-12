import 'package:carona_prime/app/pages/inicio/inicio_controller.dart';
import 'package:carona_prime/app/pages/termos_uso/termos_uso_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutube/flutube.dart';

class TermosUsoPage extends StatelessWidget {
  final PageController pageController;
  final InicioController inicioController;
  TermosUsoPage(this.inicioController, this.pageController);

  final controller = TermosUsoController();

  @override
  Widget build(BuildContext context) {
    var esconder = pageController == null || inicioController == null;
    return Scaffold(
      appBar: AppBar(
        title: Text("Termos de Uso"),
      ),
      bottomNavigationBar: esconder
          ? BottomAppBar()
          : BottomAppBar(
              child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Observer(builder: (_) {
                  var textStyle = TextStyle(color: Colors.white);

                  if (controller.aceito)
                    return FlatButton(
                        child: Text(
                          'Prosseguir',
                          style: textStyle,
                        ),
                        onPressed: () {
                          int nextIndex = 2;
                          pageController.animateToPage(nextIndex,
                              duration: Duration(milliseconds: 300),
                              curve: Curves.decelerate);
                          inicioController.setPageIndex(nextIndex);
                        });

                  return FlatButton(
                    child: Text(
                      "Aceite os termso de uso",
                      style: textStyle,
                    ),
                    onPressed: null,
                  );
                })
              ],
            )),
      body: Container(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: ListView(
            children: <Widget>[
              Text(
                "O aplicativo Carona Prime é um " +
                    "aplicativo que deve permitir criar grupos " +
                    "privados de carona com base na lista de contatos" +
                    " do usuário, ou seja, o usuário pode criar mais de " +
                    "um grupo no App com base no trajeto, visando " +
                    "facilitar a prática de caronas entre conhecidos",
                style: Theme.of(context).textTheme.body2,
              ),
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Center(
                  child: Text("Termos de Uso",
                      style: Theme.of(context).textTheme.title),
                ),
              ),
              Text(
                  "Pontos importantes sobre o uso e funcionamento do aplicativo"),
              FluTube(
                'https://www.youtube.com/watch?v=lkF0TQJO0bA&list=PLOU2XLYxmsIL0pH0zWe_ZOHgGhZ7UasUE',
                aspectRatio: 16 / 9,
                autoPlay: false,
                looping: false,
                onVideoStart: () {},
                onVideoEnd: () {},
              ),
              esconder
                  ? Container()
                  : Observer(
                      builder: (_) => CheckboxListTile(
                            title: Text("Aceito"),
                            controlAffinity: ListTileControlAffinity.trailing,
                            value: controller.aceito,
                            onChanged: controller.setAceito,
                          ))
            ],
          ),
        ),
      ),
    );
  }
}
