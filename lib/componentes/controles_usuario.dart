import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

class ControlesUsuario extends StatelessWidget {
  final dynamic produto;

  final bool usuarioLogado;
  final bool usuarioCurtiu;

  final void Function() onCurtiu;
  final void Function() onDescurtiu;

  const ControlesUsuario({
    super.key,

    required this.produto,
    required this.usuarioLogado,
    required this.usuarioCurtiu,

    required this.onCurtiu,
    required this.onDescurtiu,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        usuarioLogado
            ? IconButton(
                onPressed: () {
                  if (usuarioCurtiu) {
                    onDescurtiu();
                  } else {
                    onCurtiu();
                  }
                },
                icon: Icon(
                  usuarioCurtiu ? Icons.favorite : Icons.favorite_border,
                ),
                color: Colors.red,
                iconSize: 32,
              )
            : const SizedBox.shrink(),
        IconButton(
          onPressed: () {
            final texto =
                '${produto["product"]["name"]} por R\$ ${produto["product"]["price"].toString()} disponível no Melhores Marcas.\n\n\nBaixe o Melhores Marcas na PlayStore!';
            SharePlus.instance.share(
              ShareParams(title: "Sportcar", text: texto),
            );
          },
          icon: const Icon(Icons.share),
          color: Colors.blue,
          iconSize: 26,
        ),
      ],
    );
  }
}
