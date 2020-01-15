import 'package:carona_prime/app/pages/inicio/inicio_controller.dart';
import 'package:carona_prime/app/pages/politica_privacidade/politica_privacidade_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

class PoliticaPrivacidadePage extends StatelessWidget {
  final controller = PoliticaPrivacidadeController();

  final PageController pageController;
  final InicioController inicioController;
  PoliticaPrivacidadePage(this.inicioController, this.pageController);

  @override
  Widget build(BuildContext context) {
    var esconder = pageController == null || inicioController == null;
    return Scaffold(
      appBar: AppBar(
        title: Text("Políticas de Privacidade"),
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

                  if (!esconder) {
                    if (controller.aceitoArmazenamento &&
                        controller.aceitoUsoDeInformacoes)
                      return FlatButton(
                          child: Text(
                            'Prosseguir',
                            style: textStyle,
                          ),
                          onPressed: () {
                            int nextIndex = 3;
                            pageController.animateToPage(nextIndex,
                                duration: Duration(milliseconds: 300),
                                curve: Curves.decelerate);
                            inicioController.setPageIndex(nextIndex);
                          });
                  }

                  return FlatButton(
                    child: Text(
                      "Aceite os termos de uso",
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
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                  child: Text("Uso de Informações",
                      style: Theme.of(context).textTheme.title),
                ),
              ),
              Observer(
                  builder: (_) => termos(
                      context,
                      "Nenhuma informação pessoal fornecida ao aplicativo" +
                          "será divulgada publicamente (númer de telefone, agenda de contatos, ect).",
                      controller?.aceitoUsoDeInformacoes ?? true,
                      controller?.setAceitoUsoDeInformacoes)),
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Center(
                  child: Text("Armazenamento de Dados",
                      style: Theme.of(context).textTheme.title),
                ),
              ),
              Observer(
                  builder: (_) => termos(
                      context,
                      "Seus dados ficarão armazenados no Servidor da Google," +
                          "Eles ficarão armazenados pelo período de 6 meses",
                      controller?.aceitoArmazenamento ?? true,
                      controller?.setAceitoArmazenamento)),
            ],
          ),
        ),
      ),
    );
  }

  termos(BuildContext context, String texto, bool value,
      void Function(bool) onchanged) {
    var esconder = pageController == null || inicioController == null;
    return Column(children: <Widget>[
      Container(
        decoration: BoxDecoration(
            border: Border.all(color: Theme.of(context).primaryColor)),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            texto,
            style: Theme.of(context).textTheme.body2,
          ),
        ),
      ),
      esconder
          ? Container()
          : CheckboxListTile(
              value: value,
              onChanged: onchanged,
              title: Text("Aceito"),
            )
    ]);
  }
}
