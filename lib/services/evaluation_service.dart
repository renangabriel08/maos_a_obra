import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:maos_a_obra/controllers/data_controller.dart';
import 'package:maos_a_obra/models/evaluation_model.dart';
import 'package:maos_a_obra/widgets/toast.dart';

class EvaluationService {
  final String baseUrl = 'http://10.91.226.85:8000/api';
  final MyToast toast = MyToast();

  Future<bool> submitEvaluation(
    int orcamentoId,
    int nota,
    String feedback,
  ) async {
    try {
      var response = await http.post(
        Uri.parse('$baseUrl/avaliacoes'),
        headers: {
          'Authorization': 'Bearer ${DataController.user!.token}',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'orcamento_id': orcamentoId,
          'nota': nota,
          'feedback': feedback,
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        var jsonResp = jsonDecode(response.body);
        toast.getToast(jsonResp['message']);
        return true;
      } else {
        var jsonResp = jsonDecode(response.body);
        toast.getToast(jsonResp['error'] ?? 'Erro ao enviar avaliação');
        return false;
      }
    } catch (e) {
      debugPrint('Erro ao enviar avaliação: $e');
      toast.getToast('Erro de conexão com API');
      return false;
    }
  }

  Future<Map<String, dynamic>?> getEvaluationsByProvider(int providerId) async {
    try {
      var response = await http.get(
        Uri.parse('$baseUrl/prestadores/$providerId/avaliacoes'),
        headers: {'Authorization': 'Bearer ${DataController.user!.token}'},
      );

      if (response.statusCode == 200) {
        var jsonResp = jsonDecode(response.body);
        List<Evaluation> evaluations = (jsonResp['data']['avaliacoes'] as List)
            .map((e) => Evaluation.fromJson(e))
            .toList();

        return {
          'evaluations': evaluations,
          'statistics': jsonResp['data']['estatisticas'],
        };
      } else {
        var jsonResp = jsonDecode(response.body);
        toast.getToast(jsonResp['error'] ?? 'Erro ao buscar avaliações');
        return null;
      }
    } catch (e) {
      debugPrint('Erro ao buscar avaliações: $e');
      toast.getToast('Erro de conexão com API');
      return null;
    }
  }
}
