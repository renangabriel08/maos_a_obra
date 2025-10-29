import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:maos_a_obra/controllers/data_controller.dart';
import 'package:maos_a_obra/models/budget_model.dart';
import 'package:maos_a_obra/widgets/toast.dart';

class BudgetService {
  final String baseUrl;
  BudgetService({required this.baseUrl});

  final MyToast toast = MyToast();

  Future<Budget?> createBudget(
    Map<String, dynamic> budgetData,
    List<File> imagens,
  ) async {
    try {
      var uri = Uri.parse('$baseUrl/orcamentos');
      var request = http.MultipartRequest('POST', uri);

      request.headers['Authorization'] = 'Bearer ${DataController.user!.token}';
      budgetData.forEach((key, value) {
        request.fields[key] = value.toString();
      });

      for (var img in imagens) {
        request.files.add(
          await http.MultipartFile.fromPath('imagens[]', img.path),
        );
      }

      var response = await request.send();

      if (response.statusCode == 200 || response.statusCode == 201) {
        var respStr = await response.stream.bytesToString();
        var jsonResp = jsonDecode(respStr);
        toast.getToast(jsonResp['message']);
        return Budget.fromJson(jsonResp['orcamento']);
      } else {
        var respStr = await response.stream.bytesToString();
        var jsonResp = jsonDecode(respStr);
        toast.getToast(jsonResp['error'] ?? 'Erro ao criar orçamento');
      }
    } catch (e) {
      debugPrint('Erro ao criar orçamento: $e');
      toast.getToast('Erro de conexão com API');
    }

    return null;
  }

  Future<List<Budget>?> fetchBudgets() async {
    try {
      final uri = Uri.parse(
        '$baseUrl/orcamentos/${DataController.user!.role}/${DataController.user!.id}',
      );
      final response = await http.get(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'authorization': "Bearer ${DataController.user!.token}",
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final String responseString = utf8.decode(response.bodyBytes);

        String fixedResponseString = responseString;
        if (responseString.isNotEmpty && responseString.trim().endsWith('}')) {
          fixedResponseString = '$responseString]';
        }

        final List<dynamic> responseBody = jsonDecode(fixedResponseString);
        return responseBody.map((e) => Budget.fromJson(e)).toList();
      }
      return null;
    } catch (e) {
      debugPrint("Erro ao buscar orçamentos: $e");
      toast.getToast("Erro de conexão com API");
    }
    return null;
  }

  Future<bool> updateBudgetStatus(int budgetId, int newStatus) async {
    try {
      final uri = Uri.parse('$baseUrl/orcamentos/$budgetId/status');
      final response = await http.patch(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${DataController.user!.token}',
        },
        body: jsonEncode({"status_id": newStatus}),
      );

      return (response.statusCode == 200 || response.statusCode == 201);
    } catch (e) {
      debugPrint("Erro ao atualizar status do orçamento: $e");
      toast.getToast("Erro de conexão com API");
    }
    return false;
  }

  Future<bool> updateBudgetDate(int budgetId, String newDate) async {
    try {
      final uri = Uri.parse('$baseUrl/budgets/$budgetId/date');
      final response = await http.put(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${DataController.user!.token}',
        },
        body: jsonEncode({'date': newDate}),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final Map<String, dynamic> responseBody = jsonDecode(
          utf8.decode(response.bodyBytes),
        );
        toast.getToast(
          responseBody['message'] ?? 'Data atualizada com sucesso',
        );
        return true;
      } else {
        final Map<String, dynamic> responseBody = jsonDecode(
          utf8.decode(response.bodyBytes),
        );
        toast.getToast(responseBody['error'] ?? 'Erro ao atualizar data');
      }
    } catch (e) {
      debugPrint("Erro ao atualizar data do orçamento: $e");
      toast.getToast("Erro de conexão com API");
    }
    return false;
  }
}
