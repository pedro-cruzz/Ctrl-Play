import 'dart:async';
import 'package:flutter/material.dart';
import 'package:project/core/theme/app_colors.dart';
import 'package:project/views/home/widgets/buttons.dart';
import 'package:project/views/details/movie_details_page.dart';

class MovieBanner extends StatefulWidget {
  // 1. Corrigido: Agora aceita a lista de mapas dinâmicos da API
  final List<Map<String, dynamic>> banners;

  const MovieBanner({super.key, required this.banners});

  @override
  State<MovieBanner> createState() => _MovieBannerState();
}

class _MovieBannerState extends State<MovieBanner> {
  int _currentIndex = 0;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    if (widget.banners.isNotEmpty) {
      _timer = Timer.periodic(const Duration(seconds: 5), (timer) {
        setState(() {
          _currentIndex = (_currentIndex + 1) % widget.banners.length;
        });
      });
    }
  }

  @override
  void dispose() {
    if (widget.banners.isNotEmpty) {
      _timer.cancel();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.banners.isEmpty) {
      return Container(
        height: 360,
        decoration: BoxDecoration(
          color: AppColors.background2,
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Center(child: CircularProgressIndicator()),
      );
    }

    // 'filmeAtual' agora é um Map<String, dynamic>
    final filmeAtual = widget.banners[_currentIndex];

    return Container(
      height: 360, // altura do banner
      width: double.infinity,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
      child: Stack(
        children: [
          // Banners com fade
          ...widget.banners.asMap().entries.map((entry) {
            final index = entry.key;
            final banner = entry.value; // 'banner' é um Map<String, dynamic>

            // 2. Corrigido: Usa 'backdrop_path' para banners
            final String imagePath =
                banner['backdrop_path'] as String? ??
                banner['poster_path'] as String? ??
                '';
            final String imageUrl = imagePath.isNotEmpty
                ? 'https://image.tmdb.org/t/p/w780$imagePath' // w780 é um bom tamanho para banner
                : '';

            return AnimatedOpacity(
              duration: const Duration(seconds: 1),
              opacity: _currentIndex == index ? 1.0 : 0.0,
              child: imageUrl.isEmpty
                  ? Container(color: Colors.black) // Fallback
                  : Image.network(
                      imageUrl, // 3. Corrigido: Usa a URL construída
                      width: double.infinity,
                      height: 360,
                      fit: BoxFit.cover, // BoxFit.cover é melhor para banners
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return const Center(
                          child: CircularProgressIndicator(
                            color: AppColors.textLight,
                          ),
                        );
                      },
                      errorBuilder: (context, error, stackTrace) =>
                          Container(color: Colors.black),
                    ),
            );
          }).toList(),

          // Sobreposição de gradiente
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(
                8,
              ), // Adicionado aos gradientes
              gradient: LinearGradient(
                colors: [
                  Colors.black.withOpacity(0.6),
                  Colors.transparent,
                  Colors.transparent,
                  Colors.black.withOpacity(0.8),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                stops: const [0.0, 0.4, 0.6, 1.0], // Ajuste fino do gradiente
              ),
            ),
          ),

          // Botões sobrepostos
          Positioned(
            bottom: 20,
            left: 16,
            right: 16,
            child: Center(
              child: Buttons(
                // 4. Corrigido: Passa o 'filmeAtual' (Map<String, dynamic>)
                filmeAtual: filmeAtual,
                onDetalhes: (filme) {
                  // 'filme' aqui é o Map<String, dynamic>
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => MovieDetailPage(filme: filme),
                    ),
                  );
                },
                onAddLista: (filme) {
                  // 'filme' aqui é o Map<String, dynamic>
                  print('Adicionar ${filme['title']} à lista');
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
