import 'package:carona_prime/app/pages/inicio/inicio_controller.dart';
import 'package:carona_prime/app/pages/termos_uso/termos_uso_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:video_player/video_player.dart';

class TermosUsoPage extends StatefulWidget {
  final PageController pageController;
  final InicioController inicioController;
  TermosUsoPage(this.inicioController, this.pageController);

  @override
  _TermosUsoPageState createState() => _TermosUsoPageState();
}

class _TermosUsoPageState extends State<TermosUsoPage> {
  final controller = TermosUsoController();

  VideoPlayerController _videoPlayerController;
  Future<void> _initializeVideoPlayerFuture;

  @override
  void initState() {    
    _videoPlayerController =
        VideoPlayerController.asset('assets/pontosimportantes.mp4');
    _initializeVideoPlayerFuture = _videoPlayerController.initialize();
    _videoPlayerController.setLooping(true);
    super.initState();
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var esconder =
        widget.pageController == null || widget.inicioController == null;

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
                          widget.pageController.animateToPage(nextIndex,
                              duration: Duration(milliseconds: 300),
                              curve: Curves.decelerate);
                          widget.inicioController.setPageIndex(nextIndex);
                        });

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
                    child: Text("Termos de Uso",
                        style: Theme.of(context).textTheme.title)),
              ),
              Text(
                "O aplicativo Carona Prime é um aplicativo feito para facilitar a prática de caronas entre " +
                    "conhecidos se utilizando de grupos de mensagem criados por um motorista com uma rota" +
                    "estabelecida no grupo. É um aplicativo " +
                    "que não tem fins lucrativos, visando a carona entre " +
                    "amigos que já estejam na sua lista de contatos do celular.",
                style: Theme.of(context).textTheme.body2,
              ),
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Center(
                  child: Text("Pontos Importantes",
                      style: Theme.of(context).textTheme.title),
                ),
              ),
              Text(
                  " - Estes Termos de Uso regem o seu acesso e uso a esse aplicativo como pessoa física. \n" +
                      " - O Carona Prime não se responsabiliza por caronas dadas através de indicações de terceiros, ressaltando que o objetivo é caronas entre conhecidos que já se encontram na sua agenda de contatos. \n" +
                      " - Os grupos são criados com base na sua agenda telefônica do seu aparelho mobile. \n" +
                      " - Não é possível adicionar contatos diretamente no grupo. Devendo estar cadastrados na agenda telefônica do usuário. \n" +
                      " - O app não se responsabiliza por acidentes que possam ocorrer enquanto o usuário estiver de caroneiro com um motorista, sendo de total responsabilidade do caroneiro aceitar a carona. \n" +
                      " - O Carona Prime também não se responsabiliza pela documentação do carro do motorista, bem como se o seguro do mesmo cobre o transporte de terceiros. \n" +
                      " - O Carona Prime utilizará do GPS do seu aparelho mobile para detectar e traçar a rota que será utilizada no momento de criação dos grupos. \n" +
                      " - O Carona Prime não se responsabiliza por rotas bloqueadas que não estejam à mostra no GPS. \n" +
                      " - O usuário tem total liberdade para sair dos grupos. \n" +
                      " - Para que o aplicativo funcione corretamente, é importante que haja conexão com internet. \n",
                  style: Theme.of(context).textTheme.body2),
              GestureDetector(
                onTap: () => setState(() {
                  if (_videoPlayerController.value.isPlaying) {
                    _videoPlayerController.pause();
                  } else {
                    _videoPlayerController.play();
                  }
                }),
                child: FutureBuilder(
                  future: _initializeVideoPlayerFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      return AspectRatio(
                        aspectRatio: _videoPlayerController.value.aspectRatio,
                        child: VideoPlayer(_videoPlayerController),
                      );
                    } else {
                      return Center(child: CircularProgressIndicator());
                    }
                  },
                ),
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
