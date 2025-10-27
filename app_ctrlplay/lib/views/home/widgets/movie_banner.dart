import 'dart:async';
import 'package:flutter/material.dart';
import 'package:project/core/theme/app_colors.dart';
import 'package:project/views/home/widgets/buttons.dart';
import 'package:project/views/details/movie_details_page.dart';

class MovieBanner extends StatefulWidget {
  final List<Map<String, String>> banners;

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
    _timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      setState(() {
        _currentIndex = (_currentIndex + 1) % widget.banners.length;
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.banners.isEmpty) {
      return Container(
        height: 360,
        color: AppColors.background2,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
        child: const Center(child: CircularProgressIndicator()),
      );
    }

    final filmeAtual = widget.banners[_currentIndex];

    return Container(
      height: 360, // altura do banner
      width: double.infinity,
      decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                ),
      child: Stack(
        children: [
          // Banners com fade
          ...widget.banners.asMap().entries.map((entry) {
            final index = entry.key;
            final banner = entry.value;

            return AnimatedOpacity(
              duration: const Duration(seconds: 1),
              opacity: _currentIndex == index ? 1.0 : 0.0,
              child: Image.network(
                banner['filme']!,
                width: double.infinity,
                height: 360,
                fit: BoxFit.fitHeight,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return const Center(
                    child: CircularProgressIndicator(color: AppColors.textLight),
                  );
                },
              ),
            );
          }).toList(),

          // Sobreposição de gradiente
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.black.withOpacity(0.6),
                  Colors.transparent,
                  Colors.black.withOpacity(0.7),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
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
                filmeAtual: filmeAtual,
                onDetalhes: (filme) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => MovieDetailPage(filme: filme),
                    ),
                  );
                },
                onAddLista: (filme) {
                  print('Adicionar ${filme['filme']} à lista');
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
