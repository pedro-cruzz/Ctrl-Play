import 'package:flutter/material.dart';

// Corrigindo o caminho do import
import 'package:project/core/theme/app_colors.dart';

class MovieDetailPage extends StatelessWidget {
  final Map<String, dynamic> filme;

  const MovieDetailPage({super.key, required this.filme});

  @override
  Widget build(BuildContext context) {
    // Cor de fundo principal da Netflix
    const Color netflixBlack = Color(0xFF141414);
    // Cor do botão secundário (Minha Lista)
    final Color netflixGrey = Colors.grey.withOpacity(0.3);

    return Scaffold(
      backgroundColor: netflixBlack,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: const Icon(Icons.cast),
            onPressed: () {
              // Ação de Cast
            },
          ),
        ],
      ),
      // extendBodyBehindAppBar: true, // Removido, não é essencial para o banner estático
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- BANNER COM GRADIENTE (Continua sendo a imagem) ---
            Stack(
              alignment: Alignment.bottomLeft,
              children: [
                // Imagem do Banner
                AspectRatio(
                  aspectRatio: 16 / 9,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(0),
                    child: Image.network(
                      "https://image.tmdb.org/t/p/w500${filme['poster_path'] as String? ?? ''}",
                      fit: BoxFit.cover,
                      width: double.infinity,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: Colors.black,
                          child: const Center(
                            child: Icon(
                              Icons.error,
                              color: Colors.white,
                              size: 40,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                // Gradiente "Fade"
                Container(
                  height: 100, // Altura do gradiente
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [netflixBlack, Colors.transparent],
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // --- TÍTULO ---
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                filme['title'] as String? ?? 'Sem título',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  shadows: [
                    Shadow(
                      offset: Offset(1.0, 1.0),
                      blurRadius: 3.0,
                      color: Colors.black54,
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 12),

            // --- INFORMAÇÕES (NOTA TMDB, ANO, ETC.) ---
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Icon(Icons.star, color: AppColors.starRating, size: 18),
                  const SizedBox(width: 4),
                  Text(
                    (filme['vote_average'] as num? ?? 0.0).toStringAsFixed(1),
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Text(
                    (filme['release_date'] as String? ?? '....')
                        .split('-')
                        .first,
                    style: const TextStyle(color: Colors.white70, fontSize: 15),
                  ),
                  const SizedBox(width: 16),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 4,
                      vertical: 1,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(2),
                    ),
                    child: const Text(
                      'HD',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // --- BOTÃO TRAILER (antigo "Assistir") ---
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: ElevatedButton.icon(
                icon: const Icon(
                  Icons.play_arrow,
                  color: Colors.black,
                  size: 28,
                ),
                label: const Text(
                  'Ver Trailer', // Texto alterado para "Ver Trailer"
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onPressed: () {
                  // TODO: Implementar lógica para abrir o trailer (ex: YouTube)
                  // Você precisaria de um pacote como 'url_launcher'
                  // e a URL do trailer, que viria de outra chamada à API do TMDB
                  // (ex: /movie/{movie_id}/videos)
                  debugPrint('Abrir trailer do filme: ${filme['title']}');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 45),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 12),

            // --- BOTÃO MINHA LISTA ---
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: ElevatedButton.icon(
                icon: const Icon(Icons.add, color: Colors.white, size: 28),
                label: const Text(
                  'Minha Lista',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onPressed: () {
                  // TODO: Implementar lógica para adicionar/remover da lista
                  debugPrint('Adicionar à lista: ${filme['title']}');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: netflixGrey,
                  minimumSize: const Size(double.infinity, 45),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
              ),
            ),

            // WIDGET DE RATING (para o *usuário* avaliar)
            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: StarRating(
                initialRating: 0.0, // Começa com 0
                maxStars: 5,
                onRatingChanged: (rating) {
                  debugPrint('Nova nota do usuário: $rating');
                },
              ),
            ),
            const SizedBox(height: 24),

            // --- DESCRIÇÃO ---
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                filme['overview'] as String? ?? 'Sem descrição disponível.',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  height: 1.4,
                ),
              ),
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}

// SEU WIDGET 'StarRating'
class StarRating extends StatefulWidget {
  final double initialRating;
  final int maxStars;
  final void Function(double)? onRatingChanged;

  const StarRating({
    super.key,
    this.initialRating = 0,
    this.maxStars = 5,
    this.onRatingChanged,
  });

  @override
  State<StarRating> createState() => _StarRatingState();
}

class _StarRatingState extends State<StarRating> {
  late double _currentRating;

  @override
  void initState() {
    super.initState();
    _currentRating = widget.initialRating;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(widget.maxStars, (index) {
        final starIndex = index + 1;
        return GestureDetector(
          onTap: () {
            setState(() {
              _currentRating = starIndex.toDouble();
            });
            if (widget.onRatingChanged != null) {
              widget.onRatingChanged!(_currentRating);
            }
          },
          child: Icon(
            starIndex <= _currentRating ? Icons.star : Icons.star_border,
            color: AppColors.starRating,
            size: 32,
          ),
        );
      }),
    );
  }
}
