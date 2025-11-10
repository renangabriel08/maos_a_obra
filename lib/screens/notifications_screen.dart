import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:maos_a_obra/controllers/data_controller.dart';
import 'package:maos_a_obra/controllers/notifications_controller.dart';
import 'package:maos_a_obra/models/notification_model.dart';
import 'package:maos_a_obra/styles/style.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  final NotificationController notificationController =
      NotificationController();

  bool _isLoading = true;
  int selectedTab = 0; // 0 = Não respondidos, 1 = Respondidos

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

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F7),
      appBar: AppBar(
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : notificacoes.isEmpty
          ? const Center(child: Text("Nenhuma notificação encontrada"))
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Abas
                Container(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Row(
                    children: [
                      _tabButton(
                        "Não respondidos: ${_countByStatus(notificacoes, false)}",
                        0,
                      ),
                      _tabButton(
                        "Respondidos: ${_countByStatus(notificacoes, true)}",
                        1,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 8),

                // Lista de notificações
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: _loadNotifications,
                    child: ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      itemCount: notificacoes.length,
                      itemBuilder: (context, index) {
                        final notificacao = notificacoes[index];

                        // Filtro por aba
                        // final isRespondida = notificacao.respondida ?? false;
                        final isRespondida = false;
                        if (selectedTab == 0 && isRespondida) {
                          return const SizedBox.shrink();
                        }
                        if (selectedTab == 1 && !isRespondida) {
                          return const SizedBox.shrink();
                        }

                        final dataFormatada = DateFormat(
                          "dd/MM/yyyy HH:mm",
                        ).format(notificacao.created_at);

                        return Card(
                          color: Colors.white,
                          elevation: 0,
                          margin: const EdgeInsets.symmetric(vertical: 4),
                          child: ListTile(
                            onTap: () {
                              DataController.selectedBudget =
                                  notificacao.orcamento;
                              Navigator.pushNamed(context, '/budgetDetails');
                            },
                            leading: const CircleAvatar(
                              backgroundImage: NetworkImage(
                                "https://i.pravatar.cc/100?img=1",
                              ),
                            ),
                            title: Text(
                              notificacao.titulo,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  notificacao.descricao,
                                  style: const TextStyle(color: Colors.black),
                                ),
                              ],
                            ),
                            trailing: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: const [
                                Icon(Icons.info_outline, color: Colors.grey),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
    );
  }

  /// Retorna a contagem de notificações respondidas ou não
  int _countByStatus(List<NotificationModel> list, bool respondida) {
    // return list.where((n) => (n.respondida ?? false) == respondida).length;
    return 10;
  }

  /// Botão das abas superiores
  Widget _tabButton(String label, int index) {
    final selected = selectedTab == index;
    return Expanded(
      child: InkWell(
        borderRadius: BorderRadius.circular(30),
        onTap: () => setState(() => selectedTab = index),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: selected ? const Color(AppColors.roxo) : Colors.transparent,
            borderRadius: BorderRadius.circular(30),
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: TextStyle(
              color: selected ? Colors.white : Colors.black87,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}
