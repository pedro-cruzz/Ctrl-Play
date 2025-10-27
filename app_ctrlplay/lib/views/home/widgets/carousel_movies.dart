import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
// Importa o MovieCard, que também vamos corrigir
import 'movie_card.dart';
import 'package:project/core/theme/app_text_styles.dart';

class CarrosselFilmes extends StatelessWidget {
  final String titulo;
  // 1. Corrigido para aceitar os dados originais da API
  final List<Map<String, dynamic>> filmes;

  const CarrosselFilmes({
    super.key,
    required this.titulo,
    required this.filmes,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Text(titulo, style: AppTextStyles.body),
        ),
        const SizedBox(height: 16),
        CarouselSlider.builder(
          itemCount: filmes.length,
          itemBuilder: (context, index, realIndex) {
            // 'filme' é o Map<String, dynamic> completo
            final filme = filmes[index];

            // 2. Correção Principal:
            // Passamos o mapa *inteiro* para o MovieCard,
            // não apenas a URL da imagem.
            return MovieCard(filme: filme);
          },
          options: CarouselOptions(
            height: 250,
            enlargeCenterPage: false,
            viewportFraction: 0.35,
            autoPlay: false,
            enableInfiniteScroll: true,
            padEnds: false,
            scrollPhysics: const BouncingScrollPhysics(),
          ),
        ),
      ],
    );
  }
}
