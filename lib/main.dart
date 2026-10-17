import 'package:flutter/material.dart';
import 'package:sportcar/gerenciador_estado.dart';
import 'package:sportcar/telas/detalhes.dart';
import 'package:sportcar/telas/produtos.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const Sportcar());
}

class Sportcar extends StatelessWidget {
  const Sportcar({super.key});

  // This widget is the root of your application.
  

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => GerenciadorEstado(),
      child: MaterialApp(
        title: 'SportCar',
        theme: ThemeData(
      colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.green,
      ),
      useMaterial3: true,
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),
    ),
        home: const TelaPrincipal(),
      ),
    );
  }
}

class TelaPrincipal extends StatefulWidget {
  const TelaPrincipal({super.key});

  @override
  State<TelaPrincipal> createState() => _TelaPrincipalState();
}

class _TelaPrincipalState extends State<TelaPrincipal> {
  @override
  Widget build(BuildContext context) {
    estadoApp = context.watch<GerenciadorEstado>();

    Widget tela = const SizedBox.shrink();
    if (estadoApp.exibicao == EmExibicao.telaProdutos) {
      tela = Produtos();
    } else if (estadoApp.exibicao == EmExibicao.telaDetalhes) {
      tela = Detalhes();
    }

    return tela;
  }
}
