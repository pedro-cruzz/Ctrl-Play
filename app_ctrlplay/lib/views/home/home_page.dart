import 'package:flutter/material.dart';
import 'package:project/views/home/widgets/movie_banner.dart' as mb;
import 'package:project/views/home/widgets/carousel_movies.dart';
import 'package:project/views/search/widgets/search_bar.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:project/core/theme/app_colors.dart';
import 'package:project/views/search/search_results_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Map<String, dynamic>> destaqueFilmes = [];
  List<Map<String, dynamic>> filmesPopulares = [];
  bool isLoading = true;

  final String apiKey = '2117046a0bb73320a252a56d49d2e10e';
  final String baseUrl = 'https://api.themoviedb.org/3';

  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    carregarFilmes();
  }

  Future<void> carregarFilmes() async {
    try {
      final urlPopulares = Uri.parse(
        '$baseUrl/movie/popular?api_key=$apiKey&language=pt-BR&page=1',
      );
      final responsePopulares = await http.get(urlPopulares);

      if (responsePopulares.statusCode == 200) {
        final data = json.decode(responsePopulares.body);
        final List results = data['results'];

        setState(() {
          // 2. Mapeamento corrigido:
          // Agora, estamos pegando o mapa *original* da API e apenas
          // convertendo-o para o tipo correto.
          filmesPopulares = results
              .map((movie) => movie as Map<String, dynamic>)
              .toList();

          destaqueFilmes = filmesPopulares.take(4).toList();
          isLoading = false;
        });
      } else {
        throw Exception('Falha ao carregar filmes');
      }
    } catch (e) {
      print('Erro ao buscar filmes: $e');
      setState(() => isLoading = false);
    }
  }

  // Função de busca que abre a página de resultados
  Future<void> buscarFilmes(String query) async {
    if (query.isEmpty) return;

    final url = Uri.parse(
      '$baseUrl/search/movie?api_key=$apiKey&language=pt-BR&query=$query&page=1',
    );

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List results = data['results'];

        // 3. Correção também aplicada aqui
        final filmesEncontrados = results
            .map((movie) => movie as Map<String, dynamic>)
            .toList();

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) =>
                SearchResultsPage(filmes: filmesEncontrados, query: query),
          ),
        );
      } else {
        print('Erro ao buscar filmes: ${response.statusCode}');
      }
    } catch (e) {
      print('Erro na pesquisa: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        // ... (resto do seu código build) ...
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.only(left: 16),
          child: Image.asset('assets/logo.png', height: 30, width: 20),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: AppColors.icons),
            onPressed: () {
              buscarFilmes(_searchController.text);
            },
          ),
          const Padding(
            padding: EdgeInsets.only(right: 16),
            child: Icon(Icons.person, color: AppColors.icons),
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                children: [
                  // Seção roxa
                  Container(
                    width: double.infinity,
                    color: AppColors.background,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 20,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        mb.MovieBanner(banners: destaqueFilmes),
                        const SizedBox(height: 24),
                        SearchBarWidget(
                          controller: _searchController,
                          onSearch: (query) => buscarFilmes(query),
                        ),
                      ],
                    ),
                  ),

                  // Seção branca
                  Container(
                    color: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 30,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CarrosselFilmes(
                          titulo: 'Em destaque',
                          filmes: destaqueFilmes,
                        ),
                        const SizedBox(height: 24),
                        CarrosselFilmes(
                          titulo: 'Populares',
                          filmes: filmesPopulares,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
