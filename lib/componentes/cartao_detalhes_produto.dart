import 'package:flutter/material.dart';
import 'package:sportcar/gerenciador_estado.dart';

class CartaoDetalhesProduto extends StatelessWidget {
  final dynamic produto;

  const CartaoDetalhesProduto({
    super.key,
    required this.produto,
  });

  @override
  Widget build(BuildContext context) {
    // Verifica se existe um usuário autenticado.
    final bool usuarioLogado = estadoApp.usuario != null;

    final produtoInfo = produto["product"];

    return Card(
      margin: const EdgeInsets.all(8),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Nome do carro: visível para todos.
            Text(
              produtoInfo["name"]?.toString() ?? "Carro sem nome",
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),

            const SizedBox(height: 8),

            // Descrição resumida: visível para todos.
            Text(
              produtoInfo["description"]?.toString() ??
                  "Descrição indisponível.",
              style: const TextStyle(fontSize: 14),
            ),

            const SizedBox(height: 12),

            // Dados técnicos: somente para usuários logados.
            if (usuarioLogado) ...[
              const Divider(),

              const Text(
                "Especificações técnicas",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),

              const SizedBox(height: 8),

              _construirInformacao(
                icone: Icons.speed,
                titulo: "Potência",
                valor: "${produtoInfo["potencia"] ?? "Não informada"} cv",
              ),

              const SizedBox(height: 6),

              _construirInformacao(
                icone: Icons.settings,
                titulo: "Cilindrada",
                valor:
                    "${produtoInfo["cilindrada"] ?? "Não informada"} cc",
              ),
            ] else ...[
              const SizedBox(height: 8),

              const Text(
                "Entre na sua conta para consultar as especificações "
                "técnicas deste carro.",
                style: TextStyle(
                  fontSize: 12,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],

            const Divider(),

            // Preço e curtidas: visíveis para todos.
            Row(
              children: [
                const Icon(
                  Icons.attach_money,
                  size: 20,
                ),

                Expanded(
                  child: Text(
                    "R\$ ${produtoInfo["price"] ?? "Não informado"}",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ),

                const Icon(
                  Icons.favorite_rounded,
                  color: Colors.red,
                  size: 20,
                ),

                const SizedBox(width: 5),

                Text(
                  produto["likes"]?.toString() ?? "0",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _construirInformacao({
    required IconData icone,
    required String titulo,
    required String valor,
  }) {
    return Row(
      children: [
        Icon(icone, size: 20),
        const SizedBox(width: 8),
        Text(
          "$titulo: ",
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        Expanded(
          child: Text(valor),
        ),
      ],
    );
  }
}