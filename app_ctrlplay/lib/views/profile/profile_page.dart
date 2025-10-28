import 'package:flutter/material.dart';
import 'package:project/core/theme/app_text_styles.dart';
import 'package:shared_preferences/shared_preferences.dart'; 
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

import 'package:project/views/home/widgets/movie_card.dart';

// ADICIONADO: Import para as cores do tema (para o fundo roxo)
import 'package:project/core/theme/app_colors.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  // A lista de filmes virá da API
  List<Map<String, dynamic>> _myList = [];
  bool _isLoading = true;

  // NOVAS: Variáveis para guardar os dados do usuário
  String _userName = 'Carregando...';
  String _userEmail = 'Carregando...';
  // NOVO: Variável para o caminho da imagem de perfil
  String? _imagePath;

  // Chave da API (a mesma da home_page)
  final String _apiKey = '2117046a0bb73320a252a56d49d2e10e';
  // Chave para salvar/carregar a lista no SharedPreferences
  final String _myListKey = 'my_movie_list';

  // NOVAS: Chaves do SharedPreferences (as mesmas do seu login_form.dart)
  static const _userNameKey = 'simulated_user_name';
  static const _userEmailKey = 'simulated_user_email';
  // NOVO: Chave para salvar o caminho da imagem
  static const _userImageKey = 'simulated_user_image_path';

  @override
  void initState() {
    super.initState();
    _loadMyList();
    _loadUserData(); // NOVO: Carrega os dados do usuário
  }

  // NOVO: Busca o nome, email e imagem do usuário no SharedPreferences
  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _userName = prefs.getString(_userNameKey) ?? 'Nome de Usuário';
      _userEmail = prefs.getString(_userEmailKey) ?? 'email@exemplo.com';
      _imagePath = prefs.getString(_userImageKey);
    });
  }

  // MODIFICADO: Carrega a lista do SharedPreferences e busca os filmes na API
  Future<void> _loadMyList() async {
    setState(() {
      _isLoading = true;
      _myList = []; // Limpa a lista antiga
    });

    final prefs = await SharedPreferences.getInstance();
    // 1. Busca a lista de IDs de filmes salvos
    final List<String> movieIds = prefs.getStringList(_myListKey) ?? [];

    if (movieIds.isEmpty) {
      setState(() => _isLoading = false);
      return; // A lista está vazia, não há nada para carregar
    }

    // 2. Para cada ID salvo, busca os detalhes completos do filme na API
    List<Map<String, dynamic>> tempMovies = [];
    for (String id in movieIds) {
      try {
        final movieDetails = await _fetchMovieDetails(id);
        tempMovies.add(movieDetails);
      } catch (e) {
        debugPrint('Erro ao buscar detalhes do filme $id: $e');
        // Pular este filme se der erro
      }
    }

    // 3. Atualiza o estado com os filmes carregados
    setState(() {
      _myList = tempMovies;
      _isLoading = false;
    });
  }

  // NOVO: Função para buscar os detalhes de um filme específico pelo ID
  Future<Map<String, dynamic>> _fetchMovieDetails(String movieId) async {
    final url = Uri.parse(
        'https://api.themoviedb.org/3/movie/$movieId?api_key=$_apiKey&language=pt-BR');

    final response = await http.get(url);

    if (response.statusCode == 200) {
      return json.decode(response.body) as Map<String, dynamic>;
    } else {
      throw Exception('Falha ao carregar detalhes do filme');
    }
  }

  // NOVO: Função para escolher uma imagem da galeria
  Future<void> _pickImage() async {
    final picker = ImagePicker();
    // Abre a galeria
    final XFile? pickedFile =
        await picker.pickImage(source: ImageSource.gallery);

    // Se o usuário escolher uma imagem
    if (pickedFile != null) {
      final prefs = await SharedPreferences.getInstance();
      // Salva o caminho do arquivo no SharedPreferences
      await prefs.setString(_userImageKey, pickedFile.path);
      // Atualiza o estado para exibir a nova imagem
      setState(() {
        _imagePath = pickedFile.path;
      });
    } else {
      // O usuário cancelou a seleção
    }
  }

  // Constrói o conteúdo do perfil
  Widget _buildProfileContent() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // --- SEÇÃO DE INFORMAÇÕES DO USUÁRIO (FUNDO ROXO) ---
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              children: [
                // MODIFICADO: Avatar agora é clicável e exibe a imagem
                GestureDetector(
                  onTap: _pickImage, // Chama a função para escolher imagem
                  child: CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.grey,
                    backgroundImage:
                        (_imagePath != null && _imagePath!.isNotEmpty)
                            ? FileImage(File(_imagePath!)) // Exibe a imagem do arquivo
                            : null, // Se não tiver, usa o 'child'
                    child: (_imagePath == null || _imagePath!.isEmpty)
                        ? const Icon(Icons.person,
                            size: 60, color: Colors.white)
                        : null,
                  ),
                ),
                const SizedBox(height: 16),
                // MODIFICADO: Mostra o nome do usuário carregado
                Text(
                  _userName,
                  style: AppTextStyles.title.copyWith(color: Colors.white),
                ),
                const SizedBox(height: 8),
                // MODIFICADO: Mostra o e-mail do usuário carregado
                Text(
                  _userEmail,
                  style: AppTextStyles.body.copyWith(color: Colors.white70),
                ),
                const SizedBox(height: 24),
                // Botões de ação do perfil
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        icon: const Icon(Icons.edit, size: 18),
                        label: const Text('Editar Perfil'),
                        onPressed: () {
                          // TODO: Implementar lógica de edição
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey.withOpacity(0.3),
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton.icon(
                        icon: const Icon(Icons.logout, size: 18),
                        label: const Text('Sair'),
                        onPressed: () {
                          // TODO: Implementar lógica de logout
                          Navigator.pushReplacementNamed(context, '/login');
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red.withOpacity(0.8),
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // --- SEÇÃO "MINHA LISTA" (FUNDO BRANCO) ---
          Container(
            width: double.infinity,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30),
              ),
            ),
            padding: const EdgeInsets.symmetric(vertical: 30),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Minha Lista',
                        style: AppTextStyles.title.copyWith(color: AppColors.textDark),
                      ),
                      // Botão para recarregar a lista
                      IconButton(
                        icon: const Icon(Icons.refresh, color: AppColors.textDark),
                        onPressed: _loadMyList,
                      )
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : _myList.isEmpty
                        ? _buildEmptyListMessage()
                        : _buildMovieListGrid(),
                
                const SizedBox(height: 40),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Mensagem para quando a lista está vazia
  Widget _buildEmptyListMessage() {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(32.0),
        child: Text(
          'Quando você adicionar filmes à sua lista, eles aparecerão aqui.',
          textAlign: TextAlign.center,
          style: TextStyle(color: AppColors.textDark, fontSize: 16),
        ),
      ),
    );
  }

  // Grade de filmes da "Minha Lista"
  Widget _buildMovieListGrid() {
    return GridView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      // Configurações para a Grid funcionar dentro de um SingleChildScrollView
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),

      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3, // 3 pôsteres por linha
        childAspectRatio: 0.68, // Proporção do pôster (largura / altura)
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
      ),
      itemCount: _myList.length,
      itemBuilder: (context, index) {
        final movie = _myList[index];
        // Reutiliza o MovieCard que você já criou!
        return MovieCard(filme: movie);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Meu Perfil', style: TextStyle(color: Colors.white)),
        backgroundColor: AppColors.background,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: _buildProfileContent(),
    );
  }
}