import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:maos_a_obra/controllers/data_controller.dart';
import 'package:maos_a_obra/models/notification_model.dart';
import 'package:maos_a_obra/widgets/toast.dart';

class NotificationService {
  final String baseUrl;
  NotificationService({required this.baseUrl});

  final MyToast toast = MyToast();

  Future<bool> addNotification(Map<String, dynamic> notificationData) async {
    try {
      final uri = Uri.parse('$baseUrl/notificacoes');
      final response = await http.post(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'authorization': 'Bearer ${DataController.user!.token}',
        },
        body: jsonEncode(notificationData),
      );

      return (response.statusCode == 200 || response.statusCode == 201);
    } catch (e) {
      return false;
    }
  }

  Future<List<NotificationModel>?> fetchNotifications() async {
    try {
      final uri = Uri.parse(
        '$baseUrl/notificacoes/destinatario/${DataController.user!.id}',
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

        return responseBody.map((e) => NotificationModel.fromJson(e)).toList();
      } else {
        final Map<String, dynamic> responseBody = jsonDecode(
          utf8.decode(response.bodyBytes),
        );
        toast.getToast(responseBody['error'] ?? "Erro desconhecido");
      }
    } catch (e) {
      debugPrint("Erro ao buscar notificações: $e");
      toast.getToast("Erro de conexão com API");
    }
    return null;
  }
}
