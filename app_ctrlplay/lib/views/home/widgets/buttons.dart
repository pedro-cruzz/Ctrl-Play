import 'package:flutter/material.dart';
import 'package:project/core/theme/app_colors.dart';
import 'package:project/core/theme/app_text_styles.dart';

class Buttons extends StatelessWidget {
  // 1. Corrigido: Agora aceita o mapa dinâmico da API
  final Map<String, dynamic> filmeAtual;
  // 2. Corrigido: A função de callback também espera o mapa dinâmico
  final void Function(Map<String, dynamic>) onDetalhes;
  // 3. Corrigido: A função de callback também espera o mapa dinâmico
  final void Function(Map<String, dynamic>) onAddLista;

  const Buttons({
    super.key,
    required this.filmeAtual,
    required this.onDetalhes,
    required this.onAddLista,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Botão Detalhes
        SizedBox(
          width: 120, // largura fixa para ambos
          child: ElevatedButton.icon(
            // Agora está passando o Map<String, dynamic> corretamente
            onPressed: () => onDetalhes(filmeAtual),
            icon: const Icon(
              Icons.info,
              size: 16,
              color: AppColors.textLight,
              weight: 400,
            ),
            label: const Text('Detalhes', style: AppTextStyles.button),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.accent,
              foregroundColor: AppColors.textLight,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            ),
          ),
        ),

        const SizedBox(width: 16), // espaço entre os botões
        // Botão Lista
        SizedBox(
          width: 120, // mesma largura
          child: ElevatedButton.icon(
            // Agora está passando o Map<String, dynamic> corretamente
            onPressed: () => onAddLista(filmeAtual),
            icon: const Icon(
              Icons.add,
              size: 16,
              color: AppColors.textLight,
              weight: 400,
            ),
            label: const Text('Lista', style: AppTextStyles.button),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.background,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            ),
          ),
        ),
      ],
    );
  }
}
