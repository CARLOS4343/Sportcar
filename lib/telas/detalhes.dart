import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sportcar/componentes/cartao_comentario.dart';
import 'package:sportcar/componentes/cartao_detalhes_produto.dart';
import 'package:sportcar/componentes/controles_usuario.dart';
import 'package:sportcar/gerenciador_estado.dart';
import 'package:page_view_dot_indicator/page_view_dot_indicator.dart';
import 'package:toast/toast.dart';
import 'package:provider/provider.dart';

class Detalhes extends StatefulWidget {
  const Detalhes({super.key});

  @override
  State<StatefulWidget> createState() {
    return _DetalhesState();
  }
}

class _DetalhesState extends State<Detalhes> {
  dynamic _produto;

  List<dynamic> _comentarios = [];
  bool _carregandoComentarios = false;

  bool _curtiu = false;

  final TextEditingController _controladorNovoComentario =
      TextEditingController();
  final ScrollController _controladorListaProdutos = ScrollController();

  late PageController _controladorSlides;
  late int _slideSelecionado;

  @override
  void initState() {
    super.initState();

    ToastContext().init(context);

    _iniciarSlides();
    _carregarProduto();
    _carregarComentarios();
  }

  void _iniciarSlides() {
    _slideSelecionado = 0;
    _controladorSlides = PageController(initialPage: _slideSelecionado);
  }

  Future<dynamic> _acessarProduto(int idProduto) async {
    final String conteudo = await rootBundle.loadString(
      "recursos/jsons/produtos.json",
    );
    final dynamic dicionario = await json.decode(conteudo);

    final produto = dicionario["produtos"].firstWhere(
      (p) => p["_id"] == idProduto,
    );

    return produto;
  }

  void _carregarProduto() {
    _acessarProduto(estadoApp.idProduto).then(
      (produto) => {
        setState(() {
          _produto = produto;
        }),
      },
    );
  }

  Future<List<dynamic>> _acessarComentarios() async {
    final String conteudo = await rootBundle.loadString(
      "recursos/jsons/comentarios.json",
    );
    final dynamic dicionario = await json.decode(conteudo);

    return dicionario["comentarios"];
  }

  void _carregarComentarios() {
    setState(() {
      _carregandoComentarios = true;
    });

    _acessarComentarios().then((comentarios) {
      setState(() {
        _comentarios = comentarios
            .where((c) => c["productId"] == _produto["_id"])
            .toList();

        _carregandoComentarios = false;
      });
    });
  }

  Widget _exibirMensagemComentariosInexistentes() {
    return const Expanded(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.comment, size: 26),
            Text("não existem comentários", style: TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }

  Widget _exibirComentarios() {
    return _carregandoComentarios
        ? Center(child: CircularProgressIndicator())
        : Expanded(
            child: ListView.builder(
              controller: _controladorListaProdutos,
              scrollDirection: Axis.vertical,
              physics: const AlwaysScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: _comentarios.length,
              itemBuilder: (context, index) {
                final comentario = _comentarios[index];
                bool usuarioLogadoComentou =
                    estadoApp.usuario != null &&
                    estadoApp.usuario!.email == comentario["user"]["email"];

                return SizedBox(
                  height: 90,
                  child: Dismissible(
                    key: UniqueKey(),
                    direction: usuarioLogadoComentou
                        ? DismissDirection.endToStart
                        : DismissDirection.none,
                    background: Container(
                      alignment: Alignment.centerRight,
                      child: const Padding(
                        padding: EdgeInsets.only(right: 12.0),
                        child: Icon(Icons.delete, color: Colors.red),
                      ),
                    ),
                    child: CartaoComentario(
                      comentario: comentario,
                      somenteLeitura: !usuarioLogadoComentou,
                    ),
                    confirmDismiss: (direction) async {
                      return await showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            content: const Text("Deseja apagar o comentário?"),
                            actions: [
                              TextButton(
                                onPressed: () =>
                                    Navigator.of(context).pop(false),
                                child: const Text("NÃO"),
                              ),
                              TextButton(
                                onPressed: () =>
                                    Navigator.of(context).pop(true),
                                child: const Text("SIM"),
                              ),
                            ],
                          );
                        },
                      );
                    },
                    onDismissed: (direction) {
                      setState(() {
                        _comentarios.removeAt(index);
                      });
                    },
                  ),
                );
              },
            ),
          );
  }

  void _adicionarComentario(String conteudo) {
    setState(() {
      _comentarios.insert(0, {
        "_id": _comentarios.length + 1,
        "productId": _produto["_id"],
        "user": {
          "userId": "1",
          "email": estadoApp.usuario?.email,
          "name": estadoApp.usuario?.nome,
        },
        "datetime": DateTime.now().toString(),
        "content": conteudo,
      });
    });

    Toast.show(
      "comentário adicionado",
      duration: Toast.lengthLong,
      gravity: Toast.bottom,
    );
  }

  void _onCurtiuDescurtiu() {
    setState(() {
      _curtiu = !_curtiu;
    });

    Toast.show(
      _curtiu ? "obrigado pela avaliação" : "avaliação removida",
      duration: Toast.lengthLong,
      gravity: Toast.bottom,
    );
  }

  Widget _exibirProduto() {
    bool usuarioLogado = estadoApp.usuario != null;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Row(
          children: [
            Row(
              children: [
                Image.asset("recursos/imagens/logo.jpeg", width: 38),
                Padding(
                  padding: const EdgeInsets.only(left: 10.0, bottom: 5.0),
                  child: Text(
                    _produto["company"]["name"],
                    style: const TextStyle(fontSize: 15),
                  ),
                ),
              ],
            ),
            const Spacer(),
            GestureDetector(
              onTap: () {
                estadoApp.exibirProdutos();
              },
              child: const Icon(Icons.arrow_back, size: 30),
            ),
          ],
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 230,
            child: Stack(
              children: [
                PageView.builder(
                  itemCount: 3,
                  controller: _controladorSlides,
                  onPageChanged: (slide) {
                    setState(() {
                      _slideSelecionado = slide;
                    });
                  },
                  itemBuilder: (context, pagePosition) {
                    return Image.asset(
                    _produto["product"]["image"] ?? "recursos/imagens/rolls.webp",
                    fit: BoxFit.cover,
                    width: double.infinity,
                  );
                  },
                ),
                Align(
                  alignment: Alignment.topRight,
                  child: ControlesUsuario(
                    produto: _produto,
                    usuarioCurtiu: _curtiu,
                    usuarioLogado: usuarioLogado,

                    onCurtiu: _onCurtiuDescurtiu,
                    onDescurtiu: _onCurtiuDescurtiu,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: PageViewDotIndicator(
              currentItem: _slideSelecionado,
              count: 3,
              unselectedColor: Colors.black26,
              selectedColor: Colors.blue,
              duration: const Duration(milliseconds: 200),
              boxShape: BoxShape.circle,
            ),
          ),
          CartaoDetalhesProduto(produto: _produto),
          const Center(
            child: Text(
              "Comentários",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
          ),
          usuarioLogado
              ? Padding(
                  padding: const EdgeInsets.all(6.0),
                  child: TextField(
                    controller: _controladorNovoComentario,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      enabledBorder: const OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.black87,
                          width: 0.0,
                        ),
                      ),
                      border: const OutlineInputBorder(),
                      hintStyle: const TextStyle(fontSize: 14),
                      hintText: 'Digite aqui seu comentário...',
                      suffixIcon: GestureDetector(
                        onTap: () {
                          _adicionarComentario(_controladorNovoComentario.text);
                        },
                        child: const Icon(Icons.send, color: Colors.black87),
                      ),
                    ),
                  ),
                )
              : const SizedBox.shrink(),
          _comentarios.isNotEmpty
              ? _exibirComentarios()
              : _exibirMensagemComentariosInexistentes(),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool usuarioLogado =
    context.watch<GerenciadorEstado>().usuarioLogado;
    Widget detalhes = SizedBox.expand(
      child: Container(
        color: Colors.white,
        child: const Center(child: CircularProgressIndicator()),
      ),
    );

    if (_produto != null) {
      detalhes = _exibirProduto();
    }

    return detalhes;
  }
}
