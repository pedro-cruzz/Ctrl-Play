import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'movie_card.dart';
import 'package:project/core/theme/app_text_styles.dart';

class CarrosselFilmes extends StatelessWidget {
  final String titulo;
  final List<Map<String, String>> filmes;
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
            final filme = filmes[index];
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
