import 'package:flutter/material.dart';
import 'package:sportcar/usuario.dart';

enum EmExibicao { telaProdutos, telaDetalhes }

class GerenciadorEstado extends ChangeNotifier {
  EmExibicao _exibicao = EmExibicao.telaProdutos;
  EmExibicao get exibicao => _exibicao;

  int _idProduto = -1;
  int get idProduto => _idProduto;

  Usuario? _usuario;
  Usuario? get usuario => _usuario;

bool get usuarioLogado => _usuario != null;

  void exibirProdutos() {
    _exibicao = EmExibicao.telaProdutos;

    notifyListeners();
  }

  void exibirDetalhes(int idProduto) {
    _exibicao = EmExibicao.telaDetalhes;
    _idProduto = idProduto;

    notifyListeners();
  }

  void login(Usuario? usuario) {
  _usuario = usuario;
  notifyListeners();
}

void logout() {
  _usuario = null;
  notifyListeners();
}
}

late GerenciadorEstado estadoApp;
