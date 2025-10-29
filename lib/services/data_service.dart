import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:maos_a_obra/models/specialty_model.dart';
import 'package:maos_a_obra/models/status_model.dart';
import 'package:maos_a_obra/models/user_type_model.dart';
import 'package:maos_a_obra/widgets/toast.dart';

class DataService {
  final String baseUrl;
  DataService({required this.baseUrl});

  final MyToast toast = MyToast();

  Future<List<Status>?> getStatusList() async {
    try {
      final uri = Uri.parse('$baseUrl/statuses');
      final response = await http.get(
        uri,
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        List<dynamic> responseBody = jsonDecode(
          utf8.decode(response.bodyBytes),
        );

        return responseBody.map((e) => Status.fromJson(e)).toList();
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  Future<List<UserType>?> getUserTypeList() async {
    try {
      final uri = Uri.parse('$baseUrl/userTypes');
      final response = await http.get(
        uri,
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final List<dynamic> responseBody = jsonDecode(
          utf8.decode(response.bodyBytes),
        );

        return responseBody
            .map(
              (e) => UserType.fromJson({
                'id': responseBody.indexOf(e),
                'description': e,
              }),
            )
            .toList();
      } else {
        final Map<String, dynamic> responseBody = jsonDecode(
          utf8.decode(response.bodyBytes),
        );
        toast.getToast(responseBody['error']);
      }
    } catch (e) {
      debugPrint("Erro na conexão com API (UserType): $e");
      toast.getToast("Erro de conexão com API");
    }
    return null;
  }

  Future<List<Specialty>?> getSpecialtyList() async {
    try {
      final uri = Uri.parse('$baseUrl/specialties');
      final response = await http.get(
        uri,
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final List<dynamic> responseBody = jsonDecode(
          utf8.decode(response.bodyBytes),
        );
        return responseBody.map((e) => Specialty.fromJson(e)).toList();
      } else {
        toast.getToast("Erro ${response.statusCode} ao buscar especialidades");
      }
    } catch (e) {
      debugPrint("Erro na conexão com API (Specialty): $e");
      toast.getToast("Erro de conexão com API");
    }
    return null;
  }
}
