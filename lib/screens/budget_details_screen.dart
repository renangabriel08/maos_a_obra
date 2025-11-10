import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:intl/intl.dart';
import 'package:maos_a_obra/controllers/data_controller.dart';
import 'package:maos_a_obra/controllers/budget_controller.dart';
import 'package:maos_a_obra/controllers/notifications_controller.dart';
import 'package:maos_a_obra/main.dart';
import 'package:maos_a_obra/models/budget_model.dart';

class BudgetDetailsScreen extends StatefulWidget {
  const BudgetDetailsScreen({super.key});

  @override
  State<BudgetDetailsScreen> createState() => _BudgetDetailsScreenState();
}

class _BudgetDetailsScreenState extends State<BudgetDetailsScreen> {
  final BudgetController budgetController = BudgetController();
  final NotificationController notificationController =
      NotificationController();
  DateTime? selectedDate;
  TimeOfDay? selectedTime;
  final TextEditingController orcamentoController = TextEditingController();

  // Mapeamento dos IDs de status
  static const int STATUS_SOLICITADO = 1;
  static const int STATUS_CANCELADO = 2;
  static const int STATUS_RECUSADO = 3;
  static const int STATUS_VISITA_AGENDADA = 4;
  static const int STATUS_NOVA_DATA_SUGERIDA_CLIENTE = 5;
  static const int STATUS_NOVA_DATA_SUGERIDA_PRESTADOR = 6;
  static const int STATUS_VISITA_REALIZADA = 7;
  static const int STATUS_ORCAMENTO_ACEITO = 8;
  static const int STATUS_SERVICO_REALIZADO = 9;
  static const int STATUS_SERVICO_FINALIZADO = 10;
  static const int STATUS_SERVICO_AVALIADO = 11;

  @override
  void dispose() {
    orcamentoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Budget budget = DataController.selectedBudget!;
    final bool isCliente = DataController.user!.role == 'cliente';

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        title: const Text(
          "Detalhes do Orçamento",
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.indigo.shade100,
                        width: 2,
                      ),
                    ),
                    child: CircleAvatar(
                      radius: 32,
                      backgroundImage: NetworkImage(
                        budget.cliente.imagePath ??
                            "https://i.pravatar.cc/150?img=1",
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          budget.cliente.name,
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 18,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(
                              Icons.location_on,
                              size: 14,
                              color: Colors.grey[600],
                            ),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                "${budget.address.city}, ${budget.address.state}",
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 2),
                        Text(
                          budget.address.street,
                          style: TextStyle(
                            color: Colors.grey[500],
                            fontSize: 13,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.amber.shade50,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.star, color: Colors.amber, size: 16),
                        const SizedBox(width: 4),
                        Text(
                          "-",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: Colors.grey[700],
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            const Text(
              "Descrição do serviço",
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 16,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Text(
                budget.descricao ?? "Sem descrição",
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.grey[700],
                  height: 1.5,
                ),
              ),
            ),
            const SizedBox(height: 20),

            if (budget.valor == null) ...[
              const Text(
                "Data e horário sugerido pelo cliente",
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.04),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.access_time,
                      size: 20,
                      color: Colors.indigo[700],
                    ),
                    const SizedBox(width: 12),
                    Text(
                      budget.data != null
                          ? DateFormat(
                              "dd/MM/yyyy 'às' HH:mm",
                            ).format(budget.data!)
                          : "Não informado",
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.indigo[700],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
            ] else ...[
              const Text(
                "Proposta de Orçamento",
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.04),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade50,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: Column(
                        children: [
                          const Text(
                            "Valor do Serviço",
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.black54,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            "R\$ ${budget.valor!.toStringAsFixed(2).replaceAll('.', ',')}",
                            style: TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color: Colors.indigo.shade700,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      "Justificativa",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade50,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: Text(
                        budget.justificativa ?? "Sem justificativa fornecida",
                        style: TextStyle(
                          fontSize: 14,
                          color: budget.justificativa != null
                              ? Colors.black87
                              : Colors.black45,
                          height: 1.5,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
            ],

            if (budget.imagens.isNotEmpty) ...[
              const Text(
                "Fotos da área do serviço a se realizar",
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 8),
              SizedBox(
                height: 200,
                child: CarouselSlider(
                  items: [
                    for (var img in budget.imagens)
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: Image.network(
                            '$imgUrl/${img.path}',
                            width: double.infinity,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade200,
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Center(
                                  child: Icon(
                                    Icons.image_outlined,
                                    size: 50,
                                    color: Colors.grey[400],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                  ],
                  options: CarouselOptions(
                    height: 200,
                    aspectRatio: 16 / 9,
                    viewportFraction: 0.8,
                    initialPage: 0,
                    enableInfiniteScroll: false,
                    reverse: false,
                    autoPlay: false,
                    enlargeCenterPage: true,
                    enlargeFactor: 0.3,
                    scrollDirection: Axis.horizontal,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        padding: const EdgeInsets.all(16),
        child: SafeArea(child: _buildActionButtons(context, budget, isCliente)),
      ),
    );
  }

  Widget _buildActionButtons(
    BuildContext context,
    Budget budget,
    bool isCliente,
  ) {
    final int status = budget.status.id;

    if (isCliente) {
      return _buildClienteButtons(context, budget, status);
    } else {
      return _buildPrestadorButtons(context, budget, status);
    }
  }

  Widget _buildClienteButtons(BuildContext context, Budget budget, int status) {
    switch (status) {
      case STATUS_SOLICITADO: // solicitado
      case STATUS_VISITA_AGENDADA: // visita_agendada
        return SizedBox(
          height: 50,
          child: OutlinedButton(
            onPressed: () => _cancelBudget(context, budget),
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.red,
              side: const BorderSide(color: Colors.red, width: 1.5),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              "Cancelar",
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
            ),
          ),
        );

      case STATUS_NOVA_DATA_SUGERIDA_PRESTADOR: // nova_data_sugerida_prestador
        return _buildThreeButtons(
          context,
          budget,
          onReject: () => _rejectBudget(context, budget),
          onSuggest: () => _showSuggestNewDateModal(context, budget),
          onAccept: () => _acceptNewDate(context, budget),
        );

      case STATUS_VISITA_REALIZADA: // visita_realizada
        return _buildSingleButton(
          context,
          "Verificar Orçamento",
          Colors.indigo,
          () => _showBudgetDetailsModal(context, budget),
        );

      case STATUS_SERVICO_REALIZADO: // servico_realizado
        return _buildSingleButton(
          context,
          "Finalizar Serviço",
          Colors.indigo,
          () => _finishService(context, budget),
        );

      case STATUS_SERVICO_FINALIZADO: // servico_finalizado
        return _buildSingleButton(
          context,
          "Avaliar Prestador",
          Colors.indigo,
          () {
            DataController.selectedBudget = budget;
            Navigator.pushNamed(context, '/assessment');
          },
        );

      case STATUS_CANCELADO: // cancelado
      case STATUS_RECUSADO: // recusado
      case STATUS_NOVA_DATA_SUGERIDA_CLIENTE: // nova_data_sugerida_cliente
      case STATUS_SERVICO_AVALIADO: // servico_avaliado
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildPrestadorButtons(
    BuildContext context,
    Budget budget,
    int status,
  ) {
    switch (status) {
      case STATUS_SOLICITADO: // solicitado
        if (budget.valor != null) {
          // Orçamento já enviado - apenas recusar ou aceitar
          return Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: 50,
                  child: OutlinedButton(
                    onPressed: () => _rejectBudget(context, budget),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.red,
                      side: const BorderSide(color: Colors.red, width: 1.5),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      "Recusar",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: SizedBox(
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () => _acceptBudgetWithValue(context, budget),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.indigo,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      "Aceitar",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        } else {
          // Sem orçamento - mostra todas as opções
          return _buildThreeButtons(
            context,
            budget,
            onReject: () => _rejectBudget(context, budget),
            onSuggest: () => _showSuggestNewDateModal(context, budget),
            onAccept: () => _acceptBudget(context, budget),
          );
        }

      case STATUS_NOVA_DATA_SUGERIDA_CLIENTE: // nova_data_sugerida_cliente
        return _buildThreeButtons(
          context,
          budget,
          onReject: () => _rejectBudget(context, budget),
          onSuggest: () => _showSuggestNewDateModal(context, budget),
          onAccept: () => _acceptNewDate(context, budget),
        );

      case STATUS_VISITA_AGENDADA: // visita_agendada
        return Row(
          children: [
            Expanded(
              child: SizedBox(
                height: 50,
                child: OutlinedButton(
                  onPressed: () => budget.data == null
                      ? _rejectBudget(context, budget)
                      : _cancelBudget(context, budget),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.red,
                    side: const BorderSide(color: Colors.red, width: 1.5),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    budget.data == null ? "Recusar" : "Cancelar",
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: SizedBox(
                height: 50,
                child: ElevatedButton(
                  onPressed: () => _showSendBudgetModal(context, budget),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.indigo,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    budget.data == null
                        ? "Enviar orçamento"
                        : "Confirmar visita",
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
                  ),
                ),
              ),
            ),
          ],
        );

      case STATUS_ORCAMENTO_ACEITO:
        return _buildSingleButton(
          context,
          "Serviço Realizado",
          Colors.indigo,
          () => _markServiceDone(context, budget),
        );

      case STATUS_VISITA_REALIZADA:
      case STATUS_CANCELADO: // cancelado
      case STATUS_RECUSADO: // recusado
      case STATUS_NOVA_DATA_SUGERIDA_PRESTADOR: // nova_data_sugerida_prestador
      case STATUS_SERVICO_REALIZADO: // servico_realizado
      case STATUS_SERVICO_FINALIZADO: // servico_finalizado
      case STATUS_SERVICO_AVALIADO: // servico_avaliado
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildSingleButton(
    BuildContext context,
    String label,
    Color color,
    VoidCallback onPressed,
  ) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
        ),
      ),
    );
  }

  Widget _buildThreeButtons(
    BuildContext context,
    Budget budget, {
    required VoidCallback onReject,
    required VoidCallback onSuggest,
    required VoidCallback onAccept,
  }) {
    return Row(
      children: [
        Expanded(
          child: SizedBox(
            height: 50,
            child: OutlinedButton(
              onPressed: onReject,
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.red,
                side: const BorderSide(color: Colors.red, width: 1.5),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                "Recusar",
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
              ),
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: SizedBox(
            height: 50,
            child: OutlinedButton(
              onPressed: onSuggest,
              style: OutlinedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                "Sugerir nova data",
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
              ),
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: SizedBox(
            height: 50,
            child: ElevatedButton(
              onPressed: onAccept,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.indigo,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                "Aceitar",
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _acceptBudgetWithValue(BuildContext context, Budget budget) async {
    final bool? confirm = await _showConfirmDialog(
      context,
      "Aceitar Orçamento",
      "Tem certeza que deseja aceitar este orçamento?",
    );

    if (confirm == true) {
      await budgetController.updateBudgetStatus(
        budget.id,
        STATUS_VISITA_AGENDADA,
        context,
      );
      await notificationController.addNotification(
        budget.id,
        budget.prestador.id,
        budget.cliente.id,
        STATUS_VISITA_AGENDADA,
      );
      _refreshAndPop(context);
    }
  }

  void _cancelBudget(BuildContext context, Budget budget) async {
    final bool? confirm = await _showConfirmDialog(
      context,
      "Cancelar Orçamento",
      "Tem certeza que deseja cancelar este orçamento?",
    );

    if (confirm == true) {
      await budgetController.updateBudgetStatus(
        budget.id,
        STATUS_CANCELADO,
        context,
      );
      await notificationController.addNotification(
        budget.id,
        budget.cliente.id,
        budget.prestador.id,
        STATUS_CANCELADO,
      );

      _refreshAndPop(context);
    }
  }

  void _rejectBudget(BuildContext context, Budget budget) async {
    final bool? confirm = await _showConfirmDialog(
      context,
      "Recusar Orçamento",
      "Tem certeza que deseja recusar este orçamento?",
    );

    if (confirm == true) {
      await budgetController.updateBudgetStatus(
        budget.id,
        STATUS_RECUSADO,
        context,
      );
      await notificationController.addNotification(
        budget.id,
        budget.prestador.id,
        budget.cliente.id,
        STATUS_RECUSADO,
      );
      _refreshAndPop(context);
    }
  }

  void _acceptBudget(BuildContext context, Budget budget) async {
    final bool? confirm = await _showConfirmDialog(
      context,
      "Aceitar Orçamento",
      "Tem certeza que deseja aceitar este orçamento?",
    );

    if (confirm == true) {
      await budgetController.updateBudgetStatus(
        budget.id,
        STATUS_VISITA_AGENDADA,
        context,
      );
      await notificationController.addNotification(
        budget.id,
        budget.prestador.id,
        budget.cliente.id,
        STATUS_VISITA_AGENDADA,
      );
      _refreshAndPop(context);
    }
  }

  void _acceptNewDate(BuildContext context, Budget budget) async {
    final bool? confirm = await _showConfirmDialog(
      context,
      "Aceitar Nova Data",
      "Tem certeza que deseja aceitar a nova data sugerida?",
    );

    if (confirm == true) {
      await budgetController.updateBudgetStatus(
        budget.id,
        STATUS_VISITA_AGENDADA,
        context,
      );

      final bool isCliente = DataController.user!.role == 'cliente';
      await notificationController.addNotification(
        budget.id,
        isCliente ? budget.cliente.id : budget.prestador.id,
        isCliente ? budget.prestador.id : budget.cliente.id,
        STATUS_VISITA_AGENDADA,
      );
      _refreshAndPop(context);
    }
  }

  void _markServiceDone(BuildContext context, Budget budget) async {
    final bool? confirm = await _showConfirmDialog(
      context,
      "Serviço Realizado",
      "Confirma que o serviço foi realizado?",
    );

    if (confirm == true) {
      await budgetController.updateBudgetStatus(
        budget.id,
        STATUS_SERVICO_REALIZADO,
        context,
      );
      await notificationController.addNotification(
        budget.id,
        budget.prestador.id,
        budget.cliente.id,
        STATUS_SERVICO_REALIZADO,
      );
      _refreshAndPop(context);
    }
  }

  void _finishService(BuildContext context, Budget budget) async {
    final bool? confirm = await _showConfirmDialog(
      context,
      "Finalizar Serviço",
      "Tem certeza que deseja finalizar este serviço?",
    );

    if (confirm == true) {
      await budgetController.updateBudgetStatus(
        budget.id,
        STATUS_SERVICO_FINALIZADO,
        context,
      );
      await notificationController.addNotification(
        budget.id,
        budget.cliente.id,
        budget.prestador.id,
        STATUS_SERVICO_FINALIZADO,
      );

      Navigator.pop(context);
      Navigator.pushReplacementNamed(context, '/assessment');
    }
  }

  void _acceptBudgetProposal(BuildContext context, Budget budget) async {
    final bool? confirm = await _showConfirmDialog(
      context,
      "Aceitar Orçamento",
      "Tem certeza que deseja aceitar este orçamento?",
    );

    if (confirm == true) {
      await budgetController.updateBudgetStatus(
        budget.id,
        STATUS_ORCAMENTO_ACEITO,
        context,
      );
      await notificationController.addNotification(
        budget.id,
        budget.cliente.id,
        budget.prestador.id,
        STATUS_ORCAMENTO_ACEITO,
      );
      _refreshAndPop(context);
    }
  }

  void _rejectBudgetProposal(BuildContext context, Budget budget) async {
    final bool? confirm = await _showConfirmDialog(
      context,
      "Recusar Orçamento",
      "Tem certeza que deseja recusar este orçamento?",
    );

    if (confirm == true) {
      await budgetController.updateBudgetStatus(
        budget.id,
        STATUS_CANCELADO,
        context,
      );
      await notificationController.addNotification(
        budget.id,
        budget.cliente.id,
        budget.prestador.id,
        STATUS_CANCELADO,
      );
      _refreshAndPop(context);
    }
  }

  void _showSuggestNewDateModal(BuildContext context, Budget budget) {
    selectedDate = null;
    selectedTime = null;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              title: const Text(
                "Sugerir Nova Data",
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  InkWell(
                    onTap: () async {
                      final DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime.now(),
                        lastDate: DateTime.now().add(const Duration(days: 365)),
                      );
                      if (pickedDate != null) {
                        setModalState(() {
                          selectedDate = pickedDate;
                        });
                      }
                    },
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                        vertical: 16,
                        horizontal: 12,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.calendar_today,
                            color: Colors.indigo,
                            size: 20,
                          ),
                          const SizedBox(width: 12),
                          Text(
                            selectedDate != null
                                ? DateFormat("dd/MM/yyyy").format(selectedDate!)
                                : "Selecionar data",
                            style: TextStyle(
                              color: selectedDate != null
                                  ? Colors.black87
                                  : Colors.grey,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  InkWell(
                    onTap: () async {
                      final TimeOfDay? pickedTime = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.now(),
                      );
                      if (pickedTime != null) {
                        setModalState(() {
                          selectedTime = pickedTime;
                        });
                      }
                    },
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                        vertical: 16,
                        horizontal: 12,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.access_time,
                            color: Colors.indigo,
                            size: 20,
                          ),
                          const SizedBox(width: 12),
                          Text(
                            selectedTime != null
                                ? selectedTime!.format(context)
                                : "Selecionar horário",
                            style: TextStyle(
                              color: selectedTime != null
                                  ? Colors.black87
                                  : Colors.grey,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text(
                    "Fechar",
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                ),
                ElevatedButton(
                  onPressed: selectedDate != null && selectedTime != null
                      ? () {
                          _confirmNewDate(context, budget);
                        }
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.indigo,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text("Confirmar"),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showSendBudgetModal(BuildContext context, Budget budget) {
    final MoneyMaskedTextController valorController = MoneyMaskedTextController(
      decimalSeparator: ',',
      thousandSeparator: '.',
      leftSymbol: 'R\$ ',
    );
    final TextEditingController descricaoController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Text(
            "Enviar Orçamento",
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: valorController,
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                decoration: InputDecoration(
                  labelText: "Valor do serviço",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  hintText: "R\$ 0,00",
                ),
              ),

              const SizedBox(height: 16),
              TextField(
                controller: descricaoController,
                maxLines: 4,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  hintText: "Justifique seu orçamento...",
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                "Cancelar",
                style: TextStyle(color: Colors.grey[600]),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                if (valorController.text.isNotEmpty &&
                    descricaoController.text.isNotEmpty) {
                  Navigator.of(context).pop();
                  _confirmVisitAndSendBudget(
                    context,
                    budget,
                    valorController.numberValue,
                    descricaoController.text,
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Preencha todos os campos"),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.indigo,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text("Enviar"),
            ),
          ],
        );
      },
    );
  }

  void _confirmVisitAndSendBudget(
    BuildContext context,
    Budget budget,
    double valor,
    String justificativa,
  ) async {
    await budgetController.updateBudgetStatus(
      budget.id,
      STATUS_VISITA_REALIZADA,
      context,
    );

    await notificationController.addNotification(
      budget.id,
      budget.prestador.id,
      budget.cliente.id,
      STATUS_VISITA_REALIZADA,
    );

    await budgetController.updateBudgetValue(
      budget.id,
      valor,
      justificativa,
      context,
    );

    _refreshAndPop(context);
  }

  void _showBudgetDetailsModal(BuildContext context, Budget budget) {
    double valorOrcamento = budget.valor ?? 0.0;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.indigo.shade50,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  Icons.receipt_long,
                  color: Colors.indigo.shade700,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                "Proposta de Orçamento",
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
              ),
            ],
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "O prestador enviou a seguinte proposta:",
                  style: TextStyle(fontSize: 14, color: Colors.black54),
                ),
                const SizedBox(height: 20),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.indigo.shade50, Colors.indigo.shade100],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.indigo.shade200, width: 2),
                  ),
                  child: Column(
                    children: [
                      const Text(
                        "Valor do Serviço",
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.black54,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "R\$ ${valorOrcamento.toStringAsFixed(2).replaceAll('.', ',')}",
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.indigo.shade700,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  "Justificativa",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade50,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: Text(
                    budget.justificativa ?? "Sem justificativa fornecida",
                    style: TextStyle(
                      fontSize: 14,
                      color: budget.justificativa != null
                          ? Colors.black87
                          : Colors.black45,
                      height: 1.5,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.amber.shade50,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.amber.shade200),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.info_outline,
                        color: Colors.amber.shade700,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      const Expanded(
                        child: Text(
                          "Deseja aceitar esta proposta?",
                          style: TextStyle(fontSize: 13, color: Colors.black87),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          actions: [
            OutlinedButton.icon(
              onPressed: () {
                Navigator.of(context).pop();
                _rejectBudgetProposal(context, budget);
              },
              icon: const Icon(Icons.close, size: 18),
              label: const Text("Recusar"),
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.red.shade700,
                side: BorderSide(color: Colors.red.shade700, width: 1.5),
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.of(context).pop();
                _acceptBudgetProposal(context, budget);
              },
              icon: const Icon(Icons.check, size: 18),
              label: const Text("Aceitar"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.indigo.shade600,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                elevation: 2,
              ),
            ),
          ],
          actionsAlignment: MainAxisAlignment.spaceBetween,
        );
      },
    );
  }

  void _confirmNewDate(BuildContext context, Budget budget) async {
    if (selectedDate != null && selectedTime != null) {
      final DateTime combinedDateTime = DateTime(
        selectedDate!.year,
        selectedDate!.month,
        selectedDate!.day,
        selectedTime!.hour,
        selectedTime!.minute,
      );

      final String formattedDate = DateFormat(
        "yyyy-MM-dd HH:mm:ss",
      ).format(combinedDateTime);

      Navigator.of(context).pop();

      final bool isCliente = DataController.user!.role == 'cliente';
      final int newStatus = isCliente
          ? STATUS_NOVA_DATA_SUGERIDA_CLIENTE
          : STATUS_NOVA_DATA_SUGERIDA_PRESTADOR;

      await budgetController.updateBudgetDate(
        budget.id,
        formattedDate,
        context,
      );

      await budgetController.updateBudgetStatus(budget.id, newStatus, context);
      await notificationController.addNotification(
        budget.id,
        isCliente ? budget.cliente.id : budget.prestador.id,
        isCliente ? budget.prestador.id : budget.cliente.id,
        newStatus,
      );

      _refreshAndPop(context);
    }
  }

  Future<bool?> _showConfirmDialog(
    BuildContext context,
    String title,
    String message,
  ) {
    return showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
          content: Text(message, style: TextStyle(color: Colors.grey[700])),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(
                "Cancelar",
                style: TextStyle(color: Colors.grey[600]),
              ),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(true),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.indigo,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text("Confirmar"),
            ),
          ],
        );
      },
    );
  }

  void _refreshAndPop(BuildContext context) {
    try {
      Navigator.pop(context);
      DataController.pagina.value++;
      DataController.pagina.value--;
      setState(() {});
    } catch (e) {
      debugPrint("Não foi possível navegar");
    }
  }
}
