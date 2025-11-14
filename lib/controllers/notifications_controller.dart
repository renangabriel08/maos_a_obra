import 'dart:async';
import 'package:awesome_notifications/awesome_notifications.dart'
    hide NotificationModel;
import 'package:flutter/material.dart';
import 'package:maos_a_obra/controllers/data_controller.dart';
import 'package:maos_a_obra/main.dart';
import 'package:maos_a_obra/services/notification_service.dart';
import 'package:maos_a_obra/widgets/toast.dart';
import 'package:maos_a_obra/models/notification_model.dart';

class NotificationController {
  final NotificationService notificationService;
  final MyToast myToast = MyToast();
  Timer? _timer;
  bool _firstLoad = true;

  NotificationController({NotificationService? notificationService})
    : notificationService =
          notificationService ?? NotificationService(baseUrl: baseUrl);

  void startListeningNotifications(BuildContext context) {
    _timer = Timer.periodic(const Duration(seconds: 10), (timer) async {
      await _checkForNewNotifications(context);
    });
  }

  void stopListeningNotifications() {
    _timer?.cancel();
  }

  Future<void> _checkForNewNotifications(BuildContext context) async {
    try {
      final List<NotificationModel> newNotifications =
          await notificationService.fetchNotifications() ?? [];

      if (_firstLoad) {
        // Primeira vez → só carrega, não dispara
        DataController.notifications = newNotifications;
        _firstLoad = false;
        return;
      }

      // Se veio algo novo
      if (newNotifications.length > DataController.notifications.length) {
        final ultimas = newNotifications.take(
          newNotifications.length - DataController.notifications.length,
        );

        for (var notificacao in ultimas) {
          AwesomeNotifications().createNotification(
            content: NotificationContent(
              id: notificacao.orcamento.id,
              channelKey: 'basic_channel',
              title: notificacao.titulo,
              body: notificacao.descricao,
              notificationLayout: NotificationLayout.Default,
            ),
          );
        }

        DataController.notifications = newNotifications;
      }
    } catch (e) {
      debugPrint("Erro ao verificar novas notificações: $e");
    }
  }

  Future<void> getNotifications(BuildContext context) async {
    try {
      List<NotificationModel> notifications =
          await notificationService.fetchNotifications() ?? [];

      if (notifications.isNotEmpty) {
        DataController.notifications = notifications;
      } else {
        DataController.notifications = [];
      }
    } catch (e) {
      debugPrint("Erro ao buscar notificações: $e");
      myToast.getToast("Erro ao carregar notificações");
    }
  }

  Future<void> addNotification(
    int budget,
    int remetente,
    int destinatario,
    int notificationId,
  ) async {
    String titulo = "";
    String descricao = "";

    switch (notificationId) {
      case 1: // solicitado
        titulo = "Nova solicitação de orçamento.";
        descricao =
            "${DataController.user!.name} solicitou um novo orçamento. Clique para ver detalhes.";
        break;

      case 2: // cancelado
        titulo = "Orçamento cancelado.";
        descricao =
            "${DataController.user!.name} cancelou o orçamento. Clique para ver detalhes.";
        break;

      case 3: // recusado
        titulo = "Orçamento recusado.";
        descricao =
            "${DataController.user!.name} recusou o orçamento. Clique para ver detalhes.";
        break;

      case 4: // visita_agendada
        titulo = "Visita agendada.";
        descricao =
            "${DataController.user!.name} agendou uma visita. Clique para ver detalhes.";
        break;

      case 5: // nova_data_sugerida_cliente
        titulo = "Nova data sugerida.";
        descricao =
            "${DataController.user!.name} sugeriu uma nova data para o orçamento.";
        break;

      case 6: // nova_data_sugerida_prestador
        titulo = "Nova data sugerida.";
        descricao =
            "${DataController.user!.name} sugeriu uma nova data para o orçamento.";
        break;

      case 7: // visita_realizada
        titulo = "Visita realizada.";
        descricao =
            "${DataController.user!.name} marcou a visita como realizada.";
        break;

      case 8: // orçamento_aceito
        titulo = "Orçamento aceito.";
        descricao =
            "${DataController.user!.name} aceitou o orçamento. Clique para ver detalhes.";
        break;

      case 9: // servico_realizado
        titulo = "Serviço realizado.";
        descricao =
            "${DataController.user!.name} marcou o serviço como realizado.";
        break;

      case 10: // servico_finalizado
        titulo = "Serviço concluído.";
        descricao =
            "${DataController.user!.name} marcou o orçamento como concluído.";
        break;

      case 11: // servico_avaliado
        titulo = "Serviço avaliado.";
        descricao =
            "${DataController.user!.name} avaliou o serviço prestado. Clique para ver detalhes.";
        break;

      default:
        titulo = "Notificação";
        descricao = "Você recebeu uma nova notificação.";
    }

    Map<String, dynamic> notificationData = {
      "orcamento_id": budget,
      "remetente_id": remetente,
      "destinatario_id": destinatario,
      "titulo": titulo,
      "descricao": descricao,
    };

    try {
      final success = await notificationService.addNotification(
        notificationData,
      );

      if (!success) {
        myToast.getToast("Falha ao enviar notificação");
      }
    } catch (e) {
      debugPrint("Erro ao enviar notificação: $e");
      myToast.getToast("Erro ao enviar notificação");
    }
  }
}
