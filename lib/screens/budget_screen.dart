import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:maos_a_obra/controllers/data_controller.dart';
import 'package:maos_a_obra/controllers/budget_controller.dart';
import 'package:maos_a_obra/main.dart';
import 'package:maos_a_obra/models/budget_model.dart';
import 'package:maos_a_obra/screens/budget_details_screen.dart';
import 'package:maos_a_obra/styles/animacoes.dart';
import 'package:maos_a_obra/styles/style.dart';

class BudgetScreen extends StatefulWidget {
  const BudgetScreen({super.key});

  @override
  State<BudgetScreen> createState() => _BudgetScreenState();
}

class _BudgetScreenState extends State<BudgetScreen> {
  final BudgetController budgetController = BudgetController();
  bool loading = true;
  String? selectedFilter;

  // Mapa de filtros com labels amigáveis
  final Map<String?, String> filters = {
    null: "Todos",
    "solicitado": "Solicitado",
    "cancelado": "Cancelado",
    "recusado": "Recusado",
    "visita_agendada": "Visita Agendada",
    "nova_data_sugerida_cliente": "Nova Data - Cliente",
    "nova_data_sugerida_prestador": "Nova Data - Prestador",
    "visita_confirmada": "Visita Confirmada",
    "visita_realizada": "Visita Realizada",
    "servico_realizado": "Serviço Realizado",
    "servico_finalizado": "Serviço Finalizado",
    "servico_avaliado": "Serviço Avaliado",
  };

  @override
  void initState() {
    startApp();
    super.initState();
  }

  Future<void> startApp() async {
    await budgetController.getBudgets(context);
    loading = false;
    setState(() {});
  }

  String formatDate(DateTime? date) {
    if (date == null) return "-";
    final diff = DateTime.now().difference(date);
    if (diff.inMinutes < 60) return "${diff.inMinutes} min atrás";
    if (diff.inHours < 24) return "${diff.inHours} h atrás";
    return DateFormat("dd/MM/yyyy HH:mm").format(date);
  }

  @override
  Widget build(BuildContext context) {
    final budgets = DataController.orcamentos.reversed.toList();
    final filteredBudgets = _getFilteredBudgets(budgets);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F7),
      appBar: AppBar(
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        title: const Text(
          "Orçamentos",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                const SizedBox(height: 8),
                _buildFilters(),
                const SizedBox(height: 12),
                Expanded(
                  child: filteredBudgets.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.search_off,
                                size: 64,
                                color: Colors.grey.shade400,
                              ),
                              const SizedBox(height: 16),
                              Text(
                                "Nenhum orçamento encontrado",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                            ],
                          ),
                        )
                      : RefreshIndicator(
                          onRefresh: () async {
                            await budgetController.getBudgets(context);
                            setState(() {});
                          },
                          child: ListView.builder(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            itemCount: filteredBudgets.length,
                            itemBuilder: (context, index) {
                              final budget = filteredBudgets[index];
                              return _buildBudgetCard(budget);
                            },
                          ),
                        ),
                ),
              ],
            ),
    );
  }

  /// Filtra os orçamentos conforme o status selecionado
  List<Budget> _getFilteredBudgets(List<Budget> budgets) {
    if (selectedFilter == null) {
      return budgets;
    }

    return budgets.where((budget) {
      final status = budget.status.descricao.toLowerCase().replaceAll(' ', '_');
      return status == selectedFilter;
    }).toList();
  }

  /// Constrói o filtro horizontal superior
  Widget _buildFilters() {
    return SizedBox(
      height: 36,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        itemCount: filters.length,
        itemBuilder: (context, index) {
          final filterKey = filters.keys.elementAt(index);
          final filterLabel = filters[filterKey]!;
          final selected = selectedFilter == filterKey;

          return GestureDetector(
            onTap: () => setState(() => selectedFilter = filterKey),
            child: Container(
              margin: const EdgeInsets.only(right: 8),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: selected ? const Color(AppColors.roxo) : Colors.white,
                border: Border.all(
                  color: selected
                      ? const Color(AppColors.roxo)
                      : Colors.grey.shade400,
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                filterLabel,
                style: TextStyle(
                  color: selected ? Colors.white : Colors.black,
                  fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
                  fontSize: 13,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  /// Constrói o card de orçamento, estilizado como no layout
  Widget _buildBudgetCard(Budget budget) {
    return GestureDetector(
      onTap: () {
        DataController.selectedBudget = budget;
        NavigationHelper.navigateTo(
          context,
          const BudgetDetailsScreen(),
          type: TransitionType.fadeSlide,
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 5),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 24,
              backgroundImage: NetworkImage(
                '$imgUrl/${budget.imagens.first.path}',
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
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    "${budget.address.city}, ${budget.address.state}",
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    budget.descricao ?? "Sem descrição",
                    style: const TextStyle(color: Colors.black, fontSize: 13),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            _buildStatusChip(budget.status.descricao, budget.data),
          ],
        ),
      ),
    );
  }

  /// Cria um chip de status com cor baseada no tipo
  Widget _buildStatusChip(String status, DateTime? data) {
    Color backgroundColor;
    Color textColor;
    String displayStatus = status;

    // Verifica se é visita_agendada com data null
    if (status.toLowerCase() == "visita_agendada" && data == null) {
      displayStatus = "Serviço solicitado sem visita";
    } else if (status.toLowerCase() == "visita_realizada" && data == null) {
      displayStatus = "Orçamento solicitado";
    } else {
      // Formata o status: substitui _ por espaço e capitaliza primeira letra
      displayStatus = status
          .replaceAll('_', ' ')
          .split(' ')
          .map(
            (word) => word.isEmpty
                ? ''
                : word[0].toUpperCase() + word.substring(1).toLowerCase(),
          )
          .join(' ');
    }

    final statusLower = status.toLowerCase();

    if (statusLower.contains("visita_agendada") ||
        statusLower.contains("visita_confirmada") ||
        statusLower.contains("visita confirmada")) {
      backgroundColor = Colors.green.shade50;
      textColor = Colors.green.shade700;
    } else if (statusLower.contains("cancelado") ||
        statusLower.contains("recusado")) {
      backgroundColor = Colors.red.shade50;
      textColor = Colors.red.shade700;
    } else if (statusLower.contains("servico_finalizado") ||
        statusLower.contains("servico_avaliado") ||
        statusLower.contains("visita_realizada")) {
      backgroundColor = Colors.blue.shade50;
      textColor = Colors.blue.shade700;
    } else if (statusLower.contains("nova_data_sugerida") ||
        statusLower.contains("solicitado") ||
        statusLower.contains("servico_realizado")) {
      backgroundColor = Colors.orange.shade50;
      textColor = Colors.orange.shade700;
    } else {
      backgroundColor = Colors.grey.shade100;
      textColor = Colors.grey.shade700;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        displayStatus,
        style: TextStyle(
          color: textColor,
          fontSize: 11,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
