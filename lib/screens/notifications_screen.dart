import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:maos_a_obra/controllers/data_controller.dart';
import 'package:maos_a_obra/controllers/notifications_controller.dart';
import 'package:maos_a_obra/models/notification_model.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  final NotificationController notificationController =
      NotificationController();

  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadNotifications();
  }

  Future<void> _loadNotifications() async {
    await notificationController.getNotifications(context);
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<NotificationModel> notificacoes = DataController.notifications;

    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (notificacoes.isEmpty) {
      return const Center(child: Text("Nenhuma notificação encontrada"));
    }

    return RefreshIndicator(
      onRefresh: _loadNotifications,
      child: ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: notificacoes.length,
        itemBuilder: (context, index) {
          NotificationModel notificacao = notificacoes[index];
          final dataFormatada = DateFormat(
            "dd/MM/yyyy HH:mm",
          ).format(notificacao.created_at);

          return Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListTile(
              onTap: () {
                DataController.selectedBudget = notificacao.orcamento;
                Navigator.pushNamed(context, '/budgetDetails');
              },
              leading: const Icon(Icons.notifications, color: Colors.blue),
              title: Text(
                notificacao.titulo,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(notificacao.descricao),
                  const SizedBox(height: 4),
                  Text(
                    dataFormatada,
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
