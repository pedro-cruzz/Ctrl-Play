import 'package:flutter/material.dart';
import 'package:project/views/home/widgets/movie_card.dart';
import 'package:project/core/theme/app_colors.dart';
import 'package:project/core/theme/app_text_styles.dart';

class SearchResultsPage extends StatelessWidget {
  final List<Map<String, String>> filmes;
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
        backgroundColor: AppColors.background ,
      ),
      backgroundColor: Colors.black,
      body: filmes.isEmpty
          ? const Center(
              child: Text(
                'Nenhum filme encontrado',
                style: AppTextStyles.body,
              ),
            )
          : GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3, // três colunas
                mainAxisSpacing: 16, // espaço vertical
                crossAxisSpacing: 16, // espaço horizontal
                childAspectRatio: 0.65, // altura x largura do card
              ),
              itemCount: filmes.length,
              itemBuilder: (context, index) {
                final filme = filmes[index];
                return MovieCard(filme: filme);
              },
            ),
    );
  }
}
