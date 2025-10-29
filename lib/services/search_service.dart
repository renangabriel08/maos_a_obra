import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:maos_a_obra/models/user_model.dart';

class SearchService {
  final String baseUrl;

  SearchService({required this.baseUrl});

  Future<List<User>?> buscarPrestadores({
    String? city,
    String? especialidade,
  }) async {
    try {
      String url = "$baseUrl/buscarPrestador";
      if (city != null && city.isNotEmpty) {
        url += "/$city";
      }
      if (especialidade != null && especialidade.isNotEmpty) {
        url += "/$especialidade";
      }

      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => User.fromJson(json)).toList();
      } else {
        return [];
      }
    } catch (e) {
      return [];
    }
  }
}
