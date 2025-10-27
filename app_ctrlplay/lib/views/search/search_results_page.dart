import 'package:flutter/material.dart';
import 'package:project/views/home/widgets/movie_card.dart';
import 'package:project/core/theme/app_colors.dart';
import 'package:project/core/theme/app_text_styles.dart';

class SearchResultsPage extends StatelessWidget {
  // 1. Corrigido: Agora aceita a lista de mapas dinâmicos da API
  final List<Map<String, dynamic>> filmes;
  final String query;

  const SearchResultsPage({
    super.key,
    required this.filmes,
    required this.query,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Resultados para "$query"'),
        backgroundColor: AppColors.background,
      ),
      backgroundColor: Colors.black, // Fundo preto para o grid
      body: filmes.isEmpty
          ? const Center(
              child: Text(
                'Nenhum filme encontrado',
                style: AppTextStyles
                    .body, // Seria bom ter um estilo para texto claro
              ),
            )
          : GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3, // três colunas
                mainAxisSpacing: 16, // espaço vertical
                crossAxisSpacing: 16, // espaço horizontal
                // 2. Ajustado: O MovieCard agora controla a própria altura/aspecto
                childAspectRatio: 0.65,
              ),
              itemCount: filmes.length,
              itemBuilder: (context, index) {
                final filme = filmes[index];
                // 3. Correto: Passa o Map<String, dynamic> para o MovieCard
                return MovieCard(filme: filme);
              },
            ),
    );
  }
}
