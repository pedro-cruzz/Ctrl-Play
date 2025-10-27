import 'package:flutter/material.dart';
import 'package:project/views/details/movie_details_page.dart';

class MovieCard extends StatefulWidget {
  // 1. Corrigido: Agora aceita o mapa dinâmico da API
  final Map<String, dynamic> filme;

  const MovieCard({super.key, required this.filme});

  @override
  State<MovieCard> createState() => _MovieCardState();
}

class _MovieCardState extends State<MovieCard> {
  bool _isHovered = false; // controla o hover do mouse

  @override
  Widget build(BuildContext context) {
    // 2. Corrigido: Pega o 'poster_path' do mapa
    final String posterPath = widget.filme['poster_path'] as String? ?? '';
    final String imageUrl = posterPath.isNotEmpty
        ? 'https://image.tmdb.org/t/p/w500$posterPath'
        : '';

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: () {
          // 3. Corrigido: A navegação agora passa o mapa dinâmico
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => MovieDetailPage(filme: widget.filme),
            ),
          );
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
          transform: _isHovered
              ? (Matrix4.identity()..scale(1.08)) // zoom leve no hover
              : Matrix4.identity(),
          margin: const EdgeInsets.symmetric(
            horizontal: 1.5,
          ), // proximidade estilo Netflix
          width: 155,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(6),
            // 4. Corrigido: Usa a 'imageUrl' e trata o caso de estar vazia
            child: imageUrl.isEmpty
                ? Container(
                    color: Colors.grey[850], // Fundo escuro para o fallback
                    child: const Center(
                      child: Icon(
                        Icons.movie_creation_outlined,
                        color: Colors.white54,
                      ),
                    ),
                  )
                : Image.network(
                    imageUrl, // Usa a URL construída
                    fit: BoxFit.cover,
                    width: double.infinity,

                    // 5. Corrigido: Cálculo de altura mais simples
                    // A altura será controlada pelo 'height' do CarouselOptions
                    // no widget pai (CarrosselFilmes). Remover altura fixa daqui.
                    loadingBuilder: (context, child, progress) {
                      if (progress == null) return child;
                      return const Center(
                        child: CircularProgressIndicator(color: Colors.white),
                      );
                    },
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: Colors.grey[850],
                        child: const Center(
                          child: Icon(
                            Icons.error_outline,
                            color: Colors.white54,
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ),
      ),
    );
  }
}
