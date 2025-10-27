import 'package:flutter/material.dart';

class MovieDetailPage extends StatelessWidget {
  final Map<String, String> filme;

  const MovieDetailPage({super.key, required this.filme});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF250046),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      extendBodyBehindAppBar: true, // deixa o banner atrás da appbar
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Banner grande
            AspectRatio(
              aspectRatio: 16 / 9, // mantém proporção estilo Netflix
              child: ClipRRect(
                borderRadius: BorderRadius.circular(0),
                child: Image.network(
                  filme['filme']!,
                  fit: BoxFit.cover,
                  width: double.infinity,
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

            const SizedBox(height: 20),

            // Título do filme
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                filme['titulo'] ?? 'Sem título',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            const SizedBox(height: 12),

            // Data de lançamento
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'Lançamento: ${filme['data'] ?? 'Desconhecida'}',
                style: const TextStyle(color: Colors.white70, fontSize: 16),
              ),
            ),

            const SizedBox(height: 12),

            // Descrição
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                filme['descricao'] ?? 'Sem descrição disponível.',
                style: const TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
