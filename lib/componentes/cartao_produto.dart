import 'package:flutter/material.dart';
import 'package:sportcar/gerenciador_estado.dart';

class CartaoProduto extends StatelessWidget {
  final dynamic produto;

  const CartaoProduto({
    super.key,
    required this.produto,
  });

  @override
  Widget build(BuildContext context) {
    final bool usuarioLogado = estadoApp.usuario != null;

    final produtoInfo = produto["product"];

    return GestureDetector(
      onTap: () {
        estadoApp.exibirDetalhes(produto["_id"]);
      },
      child: Card(
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Imagem do carro: todos podem visualizar.
            Image.asset(
              produtoInfo["image"] ?? "recursos/imagens/rolls.webp",
              width: double.infinity,
              height: 200,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return const SizedBox(
                  width: double.infinity,
                  height: 200,
                  child: Center(
                    child: Icon(
                      Icons.directions_car,
                      size: 60,
                      color: Colors.grey,
                    ),
                  ),
                );
              },
            ),

            // Fabricante.
            Padding(
              padding: const EdgeInsets.all(10),
              child: Text(
                produto["company"]["name"].toString(),
                style: const TextStyle(fontSize: 14),
              ),
            ),

            // Nome do carro: todos podem visualizar.
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                produtoInfo["name"]?.toString() ?? "Nome não disponível",
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            // Visitantes veem uma apresentação resumida.
            if (!usuarioLogado)
              Padding(
                padding: const EdgeInsets.all(10),
                child: Text(
                  produtoInfo["description"]?.toString() ??
                      "Descrição não disponível",
                  style: const TextStyle(fontSize: 14),
                ),
              ),

            // Usuários autenticados veem os detalhes técnicos.
            if (usuarioLogado) ...[
              Padding(
                padding: const EdgeInsets.all(10),
                child: Text(
                  produtoInfo["description"]?.toString() ??
                      "Descrição não disponível",
                  style: const TextStyle(fontSize: 13),
                ),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Text(
                  "Potência: ${produtoInfo["potencia"] ?? "Não informada"} cavalos",
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(10),
                child: Text(
                  "Cilindrada: ${produtoInfo["cilindrada"] ?? "Não informada"}",
                ),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Text(
                  "Preço: R\$ ${produtoInfo["price"] ?? "Não informado"}",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],

            // Curtidas: todos podem visualizar.
            Padding(
              padding: const EdgeInsets.all(10),
              child: Row(
                children: [
                  const Icon(
                    Icons.favorite,
                    color: Colors.red,
                    size: 20,
                  ),
                  const SizedBox(width: 5),
                  Text(
                    produto["likes"]?.toString() ?? "0",
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}