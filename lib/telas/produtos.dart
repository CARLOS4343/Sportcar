import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sportcar/autenticador.dart';
import 'package:sportcar/componentes/cartao_produto.dart';
import 'package:sportcar/gerenciador_estado.dart';
import 'package:sportcar/usuario.dart';
import 'package:toast/toast.dart';

class Produtos extends StatefulWidget {
  const Produtos({super.key});

  @override
  State<StatefulWidget> createState() => _ProdutosState();
}

class _ProdutosState extends State<Produtos> {
  List<dynamic> _produtos = [];
  bool _carregandoProdutos = false;
  String _filtro = "";

  final ScrollController _controladorListaProdutos = ScrollController();
  final TextEditingController _controladorFiltro = TextEditingController();

  _ProdutosState() {
    _controladorListaProdutos.addListener(() {
      if (_controladorListaProdutos.position.pixels ==
          _controladorListaProdutos.position.maxScrollExtent) {
        _carregarProdutos();
      }
    });
  }

  @override
  void initState() {
    super.initState();

    ToastContext().init(context);

    _carregarProdutos();
  }

  Future<List<dynamic>> _acessarProdutos() async {
    final String conteudo = await rootBundle.loadString(
      "recursos/jsons/produtos.json",
    );
    final dynamic dicionario = await json.decode(conteudo);

    return dicionario["produtos"];
  }

  void _carregarProdutos() {
    setState(() {
      _carregandoProdutos = true;
    });

    _acessarProdutos().then((produtos) async {
      setState(() {
        if (_filtro.isNotEmpty) {
          _produtos = produtos
              .where(
                (p) => p["product"]["name"].toLowerCase().contains(_filtro),
              )
              .toList();
        } else {
          _produtos = List<dynamic>.from(produtos);
        }

        _carregandoProdutos = false;
      });
    });
  }

  Future<void> _atualizarProdutos() async {
    _produtos = [];
    _controladorFiltro.text = "";
    _filtro = "";

    _carregarProdutos();
  }

  void _aplicarFiltro(String filtro) {
    _filtro = filtro;
    _produtos.clear();

    _carregarProdutos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(
                top: 10,
                bottom: 10,
                left: 10,
                right: 15,
              ),
              child: TextField(
                controller: _controladorFiltro,
                onSubmitted: (filtro) {
                  _aplicarFiltro(filtro);
                },
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  suffixIcon: Icon(Icons.search),
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(right: 15),
            child: estadoApp.usuario != null
                ? IconButton(
                    onPressed: () {
                      Autenticador.logout().then(
                        (_) => setState(() {
                          setState(() {
                            estadoApp.logout();
                          });

                          Toast.show(
                            "Você foi desconectado com sucesso",
                            duration: Toast.lengthLong,
                            gravity: Toast.bottom,
                          );
                        }),
                      );
                    },
                    icon: const Icon(Icons.logout),
                  )
                : IconButton(
                    onPressed: () {
                      Autenticador.login().then(
                        (Usuario? usuario) => setState(() {
                          setState(() {
                            estadoApp.login(usuario);
                          });

                          Toast.show(
                            "Você foi conectado com sucesso",
                            duration: Toast.lengthLong,
                            gravity: Toast.bottom,
                          );
                        }),
                      );
                    },
                    icon: const Icon(Icons.login),
                  ),
          ),
        ],
      ),
      body: _carregandoProdutos
          ? Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              color: Colors.blueAccent,
              onRefresh: () => _atualizarProdutos(),
              child: GridView.builder(
                controller: _controladorListaProdutos,
                scrollDirection: Axis.vertical,
                physics: const AlwaysScrollableScrollPhysics(),
                shrinkWrap: true,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 2,
                  childAspectRatio: 0.45,
                ),
                itemCount: _produtos.length,
                itemBuilder: (context, index) {
                  return CartaoProduto(produto: _produtos[index]);
                },
              ),
            ),
    );
  }
}
