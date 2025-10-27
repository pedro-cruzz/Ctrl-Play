import 'dart:convert';
import 'package:http/http.dart' as http;

class TMDBService {
  final String apiKey = '2117046a0bb73320a252a56d49d2e10e';
  final String baseUrl = 'https://api.themoviedb.org/3';

  // Buscar filmes populares
  Future<List<Map<String, String>>> fetchPopularMovies() async {
    final url = Uri.parse('$baseUrl/movie/popular?api_key=$apiKey&language=pt-BR&page=1');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List results = data['results'];
      
      // Mapear os dados para o formato que usamos no MovieCard
      return results.map<Map<String, String>>((movie) {
        return {
          'titulo': movie['title'] ?? '',
          'filme': 'https://image.tmdb.org/t/p/w500${movie['backdrop_path'] ?? movie['poster_path']}',
          'descricao': movie['overview'] ?? '',
          'data': movie['release_date'] ?? '',
          'atores': '', // o elenco pode ser buscado com outra requisição
          'genero': '', // o gênero também precisa de outra requisição
        };
      }).toList();
    } else {
      throw Exception('Falha ao carregar filmes');
    }
  }
}
