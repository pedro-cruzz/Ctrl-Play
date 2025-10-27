import 'package:flutter/material.dart';
import 'package:project/core/theme/app_colors.dart';
import 'package:project/core/theme/app_text_styles.dart'; 

class Buttons extends StatelessWidget {
  final Map<String, String> filmeAtual;
  final void Function(Map<String, String>) onDetalhes;
  final void Function(Map<String, String>) onAddLista;

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
            onPressed: () => onDetalhes(filmeAtual),
            icon: const Icon(Icons.info, size: 16, color: AppColors.textLight, weight: 400),
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
            onPressed: () => onAddLista(filmeAtual),
            icon: const Icon(Icons.add, size: 16, color: AppColors.textLight, weight: 400),
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
