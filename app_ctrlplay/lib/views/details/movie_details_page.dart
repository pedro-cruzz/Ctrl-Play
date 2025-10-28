import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart'
    as http; // Para fazer a chamada de API do trailer
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import 'package:shared_preferences/shared_preferences.dart';

// Corrigindo o caminho do import (ajuste se o seu for diferente)
import 'package:project/core/theme/app_colors.dart';

// ADICIONADO: Importa seu widget StarRating de um arquivo separado
import 'package:project/views/details/widgets/start_rating.dart';

// REMOVIDOS: Imports para os widgets de botão refatorados
// import 'package:project/views/details/widgets/trailer_button.dart';
// import 'package:project/views/details/widgets/my_list_button.dart';
// import 'package:project/views/details/widgets/submit_rating_button.dart';


class MovieDetailPage extends StatefulWidget {
  final Map<String, dynamic> filme;

  const MovieDetailPage({super.key, required this.filme});

  @override
  State<MovieDetailPage> createState() => _MovieDetailPageState();
}

class _MovieDetailPageState extends State<MovieDetailPage> {
  String? _trailerKey;
  bool _isLoadingTrailer = true;

  bool _isPlayingTrailer = false;
  YoutubePlayerController? _youtubeController;

  final String _apiKey = '2117046a0bb73320a252a56d49d2e10e';

  // --- Lógica para "Minha Lista" ---
  bool _isAddedToList = false;
  bool _isLoadingList = true; // Para o loading do botão "Minha Lista"
  final String _myListKey = 'my_movie_list'; // A mesma chave da profile_page

  // --- Lógica para "Dar Nota" ---
  double _userRating = 0.0; // Guarda a nota que o usuário seleciona

  @override
  void initState() {
    super.initState();
    _fetchTrailer();
    _checkIfMovieIsAdded(); // Verifica o estado da "Minha Lista"
  }

  @override
  void dispose() {
    _youtubeController?.dispose();
    super.dispose();
  }

  // Verifica no SharedPreferences se este filme já foi salvo
  Future<void> _checkIfMovieIsAdded() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> movieIds = prefs.getStringList(_myListKey) ?? [];
    
    final movieId = widget.filme['id']?.toString();
    if (movieId == null) return;

    setState(() {
      _isAddedToList = movieIds.contains(movieId);
      _isLoadingList = false;
    });
  }

  // Adiciona ou remove o filme da lista no SharedPreferences
  Future<void> _toggleMyList() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> movieIds = prefs.getStringList(_myListKey) ?? [];
    
    final movieId = widget.filme['id']?.toString();
    if (movieId == null) return;

    setState(() {
      _isLoadingList = true; // Mostra o loading
    });

    String message;
    if (_isAddedToList) {
      // Já está na lista, então REMOVE
      movieIds.remove(movieId);
      message = 'Removido da Minha Lista';
    } else {
      // Não está na lista, então ADICIONA
      movieIds.add(movieId);
      message = 'Adicionado à Minha Lista';
    }

    // Salva a lista atualizada
    await prefs.setStringList(_myListKey, movieIds);

    // Atualiza o estado do botão
    setState(() {
      _isAddedToList = !_isAddedToList;
      _isLoadingList = false;
    });

    // Mostra um aviso rápido
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: _isAddedToList ? AppColors.accent : Colors.grey[700],
        duration: const Duration(seconds: 2),
      ),
    );
  }


  Future<void> _fetchTrailer() async {
    try {
      final movieId = widget.filme['id'];
      if (movieId == null) {
        setState(() => _isLoadingTrailer = false);
        return;
      }

      final url = Uri.parse(
          'https://api.themoviedb.org/3/movie/$movieId/videos?api_key=$_apiKey&language=pt-BR');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List results = data['results'];

        final officialTrailer = results.firstWhere(
          (video) =>
              video['type'] == 'Trailer' && video['site'] == 'YouTube',
          orElse: () => null,
        );

        String? keyToLoad;

        if (officialTrailer != null) {
          keyToLoad = officialTrailer['key'];
        } else {
          final anyVideo = results.firstWhere(
            (video) => video['site'] == 'YouTube',
            orElse: () => null,
          );
          if (anyVideo != null) {
            keyToLoad = anyVideo['key'];
          }
        }

        // --- OTIMIZAÇÃO APLICADA AQUI ---
        if (keyToLoad != null) {
          // 1. Inicializa o controller IMEDIATAMENTE.
          _youtubeController = YoutubePlayerController(
            initialVideoId: keyToLoad,
            flags: const YoutubePlayerFlags(
              autoPlay: false, // 2. Começa pausado (para pré-carregar)
              mute: false,
            ),
          );

          setState(() {
            _trailerKey = keyToLoad;
            _isLoadingTrailer = false;
          });
        } else {
          // Não achou vídeo
          setState(() => _isLoadingTrailer = false);
        }
        // --- FIM DA OTIMIZAÇÃO ---

      } else {
        setState(() => _isLoadingTrailer = false);
      }
    } catch (e) {
      debugPrint('Erro ao buscar trailer: $e');
      setState(() => _isLoadingTrailer = false);
    }
  }

  // Esta função agora INICIA o player
  void _playTrailer() {
    if (_youtubeController == null) return;

    // O player já existe, apenas damos "play"
    _youtubeController!.play();
    setState(() {
      _isPlayingTrailer = true;
    });
  }

  // Helper que constrói ou o Banner (Imagem) ou o Player (Vídeo)
  Widget _buildBannerOrPlayer() {
    // Se _isPlayingTrailer for verdadeiro E o controller existir, mostre o player
    if (_isPlayingTrailer && _youtubeController != null) {
      return AspectRatio(
        aspectRatio: 16 / 9,
        child: YoutubePlayer(
          controller: _youtubeController!,
          showVideoProgressIndicator: true,
          progressIndicatorColor: Colors.red,
          // Quando o vídeo acabar, volte para a imagem do banner
          onEnded: (metaData) {
            setState(() {
              _isPlayingTrailer = false;
              // Não damos dispose, apenas paramos e voltamos ao início
              // para que o usuário possa tocar de novo se quiser.
              _youtubeController!.pause();
              _youtubeController!.seekTo(Duration.zero);
            });
          },
        ),
      );
    }

    // Caso contrário, mostre o banner de imagem padrão
    final posterPath = widget.filme['poster_path'] as String?;
    final imageUrl = (posterPath != null && posterPath.isNotEmpty)
        ? "https://image.tmdb.org/t/p/w500$posterPath"
        : null;

    return Stack(
      alignment: Alignment.bottomLeft,
      children: [
        AspectRatio(
          aspectRatio: 16 / 9,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(0),
            child: imageUrl != null
                ? Image.network(
                    imageUrl,
                    fit: BoxFit.cover,
                    width: double.infinity,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: Colors.black,
                        child: const Center(
                          child:
                              Icon(Icons.error, color: Colors.white, size: 40),
                        ),
                      );
                    },
                  )
                : Container(
                    color: Colors.black,
                    child: const Center(
                      child: Icon(Icons.movie_creation_outlined,
                          color: Colors.white, size: 60),
                    ),
                  ),
          ),
        ),
        Container(
          height: 100,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              // MODIFICADO: Usa a cor de fundo do app no gradiente
              colors: [AppColors.background, Colors.transparent],
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
            ),
          ),
        ),
      ],
    );
  }

  // Função para o botão "Dar Nota"
  void _submitRating() {
    if (_userRating == 0.0) {
      // Se o usuário não deu nota, mostre um aviso
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Por favor, selecione uma nota de 1 a 5 estrelas primeiro.'),
          backgroundColor: Colors.red[700],
          duration: const Duration(seconds: 3),
        ),
      );
      return;
    }

    // Lógica para "capturar" a nota
    // TODO: Salvar a nota no SharedPreferences ou Firebase
    debugPrint('Nota do usuário capturada: $_userRating estrelas para o filme ${widget.filme['id']}');

    // Feedback para o usuário
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Obrigado pela sua nota de $_userRating estrelas!'),
        backgroundColor: AppColors.accent,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // REMOVIDO: Cor da Netflix
    // const Color netflixBlack = Color(0xFF141414);

    String overview = widget.filme['overview'] as String? ?? '';
    if (overview.isEmpty) {
      overview = 'Sem descrição disponível.';
    }

    return WillPopScope(
      onWillPop: () async {
        // Se o trailer estiver tocando, o botão "voltar" deve
        // parar o trailer, e NÃO fechar a página.
        if (_isPlayingTrailer) {
          setState(() {
            _isPlayingTrailer = false;
            _youtubeController!.pause();
          });
          return false; // Impede que a página feche
        }
        // Se o trailer não estiver tocando, feche a página normally.
        return true;
      },
      child: Scaffold(
        // MODIFICADO: Fundo com a cor do App
        backgroundColor: AppColors.background,
        appBar: AppBar(
          // MODIFICADO: Fundo com a cor do App
          backgroundColor: AppColors.background,
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
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // --- BANNER COM GRADIENTE OU PLAYER ---
              _buildBannerOrPlayer(), // O widget que faz a troca

              const SizedBox(height: 16),

              // --- TÍTULO ---
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  widget.filme['title'] as String? ?? 'Sem título',
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
                      (widget.filme['vote_average'] as num? ?? 0.0)
                          .toStringAsFixed(1),
                      style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 15),
                    ),
                    const SizedBox(width: 16),
                    Text(
                      (widget.filme['release_date'] as String? ?? '....')
                          .split('-')
                          .first,
                      style:
                          const TextStyle(color: Colors.white70, fontSize: 15),
                    ),
                    const SizedBox(width: 16),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 4, vertical: 1),
                      decoration: BoxDecoration(
                        color: Colors.grey.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(2),
                      ),
                      child: const Text(
                        'HD',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              
              // --- BOTÃO TRAILER (CÓDIGO RETORNADO AO ARQUIVO) ---
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: ElevatedButton.icon(
                  icon: _isLoadingTrailer
                      ? Container(
                          width: 24,
                          height: 24,
                          padding: const EdgeInsets.all(2.0),
                          child: const CircularProgressIndicator(
                            color: Colors.white, // MODIFICADO
                            strokeWidth: 3,
                          ),
                        )
                      : Icon(
                          _trailerKey != null
                              ? Icons.play_arrow
                              : Icons.play_disabled,
                          color: Colors.white, // MODIFICADO
                          size: 28),
                  label: Text(
                    _isLoadingTrailer
                        ? 'Buscando Trailer...'
                        : (_trailerKey != null
                            ? 'Ver Trailer'
                            : 'Trailer Indisponível'),
                    style: const TextStyle(
                      color: Colors.white, // MODIFICADO
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onPressed: _trailerKey != null ? _playTrailer : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.accent, // MODIFICADO
                    disabledBackgroundColor: Colors.grey[500], // MODIFICADO
                    minimumSize: const Size(double.infinity, 45),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 12),

              // --- BOTÃO MINHA LISTA (CÓDIGO RETORNADO AO ARQUIVO) ---
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: ElevatedButton.icon(
                  icon: _isLoadingList
                      ? Container( // Loading para o botão
                          width: 24,
                          height: 24,
                          padding: const EdgeInsets.all(2.0),
                          child: const CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 3,
                          ),
                        )
                      : Icon(
                          _isAddedToList ? Icons.check : Icons.add, // Ícone de Check ou Add
                          color: Colors.white,
                          size: 28,
                        ),
                  label: Text(
                    _isAddedToList ? 'Remover da Lista' : 'Minha Lista',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onPressed: _isLoadingList ? null : _toggleMyList,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary, // MODIFICADO
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
                  initialRating: _userRating, // Usa a variável de estado
                  maxStars: 5,
                  onRatingChanged: (rating) {
                    setState(() {
                      _userRating = rating;
                    });
                  },
                ),
              ),

              // BOTÃO "DAR NOTA" (CÓDIGO RETORNADO AO ARQUIVO)
              const SizedBox(height: 12),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.send, color: Colors.white, size: 20),
                  label: const Text(
                    'Dar Nota',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onPressed: _submitRating, // Chama a nova função
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary, // MODIFICADO
                    minimumSize: const Size(double.infinity, 45),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // --- DESCRIÇÃO ---
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  overview, // Usa a variável tratada
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
      ),
    );
  }
}

