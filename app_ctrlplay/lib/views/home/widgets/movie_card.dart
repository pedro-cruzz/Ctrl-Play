import 'package:flutter/material.dart';
import '../../details/movie_details_page.dart';

class MovieCard extends StatefulWidget {
  final Map<String, String> filme;

  const MovieCard({super.key, required this.filme});

  @override
  State<MovieCard> createState() => _MovieCardState();
}

class _MovieCardState extends State<MovieCard> {
  bool _isHovered = false; // controla o hover do mouse

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: () {
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
            child: Image.network(
              widget.filme['filme']!,
              fit: BoxFit.cover,
              width: double.infinity,
              height:
                  MediaQuery.of(context).size.width *
                  0.35 *
                  (9 / 16), // ex: 16:9

              loadingBuilder: (context, child, progress) {
                if (progress == null) return child;
                return const Center(
                  child: CircularProgressIndicator(color: Colors.white),
                );
              },
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  color: Colors.grey,
                  child: const Center(
                    child: Icon(Icons.error, color: Colors.white),
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
