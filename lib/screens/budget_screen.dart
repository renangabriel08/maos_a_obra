import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:maos_a_obra/controllers/data_controller.dart';
import 'package:maos_a_obra/controllers/budget_controller.dart';

class BudgetScreen extends StatefulWidget {
  const BudgetScreen({super.key});

  @override
  State<BudgetScreen> createState() => _BudgetScreenState();
}

class _BudgetScreenState extends State<BudgetScreen> {
  final BudgetController budgetController = BudgetController();
  bool loading = true;

  startApp() async {
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
  void initState() {
    startApp();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final budgets = DataController.orcamentos.reversed.toList();

    return loading
        ? const Center(child: CircularProgressIndicator())
        : RefreshIndicator(
            onRefresh: () async {
              await budgetController.getBudgets(context);
              setState(() {});
            },
            child: budgets.isEmpty
                ? const Center(child: Text("Nenhum orçamento disponível"))
                : ListView.builder(
                    padding: const EdgeInsets.all(12),
                    itemCount: budgets.length,
                    itemBuilder: (context, index) {
                      final budget = budgets[index];
                      return Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: ListTile(
                          onTap: () {
                            DataController.selectedBudget = budget;
                            Navigator.pushNamed(context, '/budgetDetails');
                          },
                          leading: const Icon(
                            Icons.assignment,
                            color: Colors.orange,
                          ),
                          title: Text(
                            budget.cliente.name,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (budget.descricao != null)
                                Text(budget.descricao!),
                              const SizedBox(height: 4),
                            ],
                          ),
                          trailing: SizedBox(
                            width: 110,
                            child: Row(
                              children: [
                                Icon(
                                  budget.visita == true
                                      ? Icons.check_circle
                                      : Icons.cancel,
                                  color: budget.visita == true
                                      ? Colors.green
                                      : Colors.red,
                                  size: 16,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  budget.status.descricao.toString(),
                                  style: const TextStyle(fontSize: 12),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          );
  }
}
