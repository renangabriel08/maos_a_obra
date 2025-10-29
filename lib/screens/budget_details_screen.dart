import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
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

  @override
  Widget build(BuildContext context) {
    final Budget budget = DataController.selectedBudget!;
    final bool isCliente = DataController.user!.role == 'cliente';

    return Scaffold(
      appBar: AppBar(
        title: const Text("Detalhes do Orçamento"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ===== Cabeçalho: Cliente =====
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundImage: NetworkImage(
                    budget.cliente.imagePath ??
                        "https://i.pravatar.cc/150?img=1",
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
                          fontSize: 18,
                        ),
                      ),
                      Text(
                        "${budget.address.city}, ${budget.address.state}",
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        budget.address.street,
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  children: [
                    const Icon(Icons.star, color: Colors.amber, size: 18),
                    const SizedBox(width: 4),
                    Text(
                      "-",
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),

            // ===== Descrição =====
            const Text(
              "Descrição do serviço",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(budget.descricao ?? "Sem descrição"),
            ),
            const SizedBox(height: 20),

            // ===== Data sugerida =====
            const Text(
              "Data e horário sugerido pelo cliente",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 8),
            Text(
              budget.data != null
                  ? DateFormat("dd/MM/yyyy HH:mm").format(budget.data!)
                  : "Não informado",
              style: const TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 20),

            // ===== Fotos =====
            if (budget.imagens.isNotEmpty) ...[
              const Text(
                "Fotos da área do serviço a se realizar",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 8),
              SizedBox(
                height: 150,
                child: CarouselSlider(
                  items: [
                    for (var img in budget.imagens)
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.network(
                          '$imgUrl/${img.path}',
                          width: double.infinity,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              height: 400,
                              decoration: BoxDecoration(
                                color: Colors.grey.shade300,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Center(
                                child: Icon(
                                  Icons.image,
                                  size: 50,
                                  color: Colors.grey,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                  ],
                  options: CarouselOptions(
                    height: 400,
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

      // ===== Botões de ação =====
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16),
        child: _buildActionButtons(context, budget, isCliente),
      ),
    );
  }

  Widget _buildActionButtons(
    BuildContext context,
    Budget budget,
    bool isCliente,
  ) {
    final int status = budget.status.id;

    // ==== STATUS que não exibem nada ====
    if (status == 5 || status == 6 || status == 8) {
      // 5: recusado, 6: cancelado, 8: avaliado
      return const SizedBox.shrink();
    }

    // ==== Cliente ====
    if (isCliente) {
      if (status == 1) {
        // solicitado
        return SizedBox(
          width: double.infinity,
          child: OutlinedButton(
            onPressed: () => _cancelBudget(context, budget),
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.red,
              side: const BorderSide(color: Colors.red),
            ),
            child: const Text("Cancelar"),
          ),
        );
      } else if (status == 3) {
        // nova_data_sugerida_pelo_prestador
        return Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: () => _cancelBudget(context, budget),
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.red,
                  side: const BorderSide(color: Colors.red),
                ),
                child: const Text("Cancelar"),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: OutlinedButton(
                onPressed: () => _showSuggestNewDateModal(context, budget),
                child: const Text("Sugerir nova data"),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: ElevatedButton(
                onPressed: () => _acceptBudget(context, budget),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.indigo,
                  foregroundColor: Colors.white,
                ),
                child: const Text("Aceitar"),
              ),
            ),
          ],
        );
      } else if (status == 2) {
        // nova_data_sugerida_pelo_cliente
        return SizedBox(
          width: double.infinity,
          child: OutlinedButton(
            onPressed: () => _cancelBudget(context, budget),
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.red,
              side: const BorderSide(color: Colors.red),
            ),
            child: const Text("Cancelar"),
          ),
        );
      } else if (status == 4) {
        // aceito → serviço concluído
        return SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () => _finishBudget(context, budget),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.indigo,
              foregroundColor: Colors.white,
            ),
            child: const Text("Serviço concluído"),
          ),
        );
      } else if (status == 7) {
        // concluído → avaliar prestador
        return SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {
              DataController.selectedBudget = budget;
              Navigator.pushNamed(context, '/assessment');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.indigo,
              foregroundColor: Colors.white,
            ),
            child: const Text("Avaliar prestador"),
          ),
        );
      }
    }
    // ==== Prestador ====
    else {
      if (status == 1) {
        // solicitado
        return Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: () => _rejectBudget(context, budget),
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.red,
                  side: const BorderSide(color: Colors.red),
                ),
                child: const Text("Recusar"),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: OutlinedButton(
                onPressed: () => _showSuggestNewDateModal(context, budget),
                child: const Text("Sugerir nova data"),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: ElevatedButton(
                onPressed: () => _acceptBudget(context, budget),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.indigo,
                  foregroundColor: Colors.white,
                ),
                child: const Text("Aceitar"),
              ),
            ),
          ],
        );
      } else if (status == 2) {
        // nova_data_sugerida_pelo_cliente
        return Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: () => _rejectBudget(context, budget),
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.red,
                  side: const BorderSide(color: Colors.red),
                ),
                child: const Text("Recusar"),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: OutlinedButton(
                onPressed: () => _showSuggestNewDateModal(context, budget),
                child: const Text("Sugerir nova data"),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: ElevatedButton(
                onPressed: () => _acceptBudget(context, budget),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.indigo,
                  foregroundColor: Colors.white,
                ),
                child: const Text("Aceitar"),
              ),
            ),
          ],
        );
      } else if (status == 3) {
        // nova_data_sugerida_pelo_prestador
        return Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: () => _rejectBudget(context, budget),
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.red,
                  side: const BorderSide(color: Colors.red),
                ),
                child: const Text("Recusar"),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: ElevatedButton(
                onPressed: () => _acceptBudget(context, budget),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.indigo,
                  foregroundColor: Colors.white,
                ),
                child: const Text("Aceitar"),
              ),
            ),
          ],
        );
      } else if (status == 7) {
        // concluído → avaliar cliente
        return SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {
              DataController.selectedBudget = budget;
              Navigator.pushNamed(context, '/assessment');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.indigo,
              foregroundColor: Colors.white,
            ),
            child: const Text("Avaliar cliente"),
          ),
        );
      }
    }

    return const SizedBox.shrink(); // fallback
  }

  void _cancelBudget(BuildContext context, Budget budget) async {
    final bool? confirm = await _showConfirmDialog(
      context,
      "Cancelar Orçamento",
      "Tem certeza que deseja cancelar este orçamento?",
    );

    if (confirm == true) {
      await budgetController.updateBudgetStatus(budget.id, 6, context);
      await notificationController.addNotification(
        budget.id,
        budget.cliente.id,
        budget.prestador.id,
        6,
      );
      Navigator.pop(context);
      DataController.pagina.value++;
      DataController.pagina.value--;

      setState(() {});
    }
  }

  void _rejectBudget(BuildContext context, Budget budget) async {
    final bool? confirm = await _showConfirmDialog(
      context,
      "Recusar Orçamento",
      "Tem certeza que deseja recusar este orçamento?",
    );

    if (confirm == true) {
      await budgetController.updateBudgetStatus(budget.id, 5, context);
      await notificationController.addNotification(
        budget.id,
        budget.prestador.id,
        budget.cliente.id,
        5,
      );
      Navigator.pop(context);
      DataController.pagina.value++;
      DataController.pagina.value--;

      setState(() {});
    }
  }

  void _acceptBudget(BuildContext context, Budget budget) async {
    final bool? confirm = await _showConfirmDialog(
      context,
      "Aceitar Orçamento",
      "Tem certeza que deseja aceitar este orçamento?",
    );

    if (confirm == true) {
      await budgetController.updateBudgetStatus(budget.id, 4, context);
      await notificationController.addNotification(
        budget.id,
        budget.prestador.id,
        budget.cliente.id,
        4,
      );
      Navigator.pop(context);
      DataController.pagina.value++;
      DataController.pagina.value--;

      setState(() {});
    }
  }

  void _finishBudget(BuildContext context, Budget budget) async {
    final bool? confirm = await _showConfirmDialog(
      context,
      "Finalizar Orçamento",
      "Tem certeza que deseja finalizar este orçamento?",
    );

    if (confirm == true) {
      await budgetController.updateBudgetStatus(budget.id, 7, context);
      await notificationController.addNotification(
        budget.id,
        budget.cliente.id,
        budget.prestador.id,
        7,
      );
      Navigator.pop(context);
      DataController.pagina.value++;
      DataController.pagina.value--;

      setState(() {});
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
              title: const Text("Sugerir Nova Data"),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Campo de Data
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
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.calendar_today, color: Colors.grey),
                          const SizedBox(width: 12),
                          Text(
                            selectedDate != null
                                ? DateFormat("dd/MM/yyyy").format(selectedDate!)
                                : "Selecionar data",
                            style: TextStyle(
                              color: selectedDate != null
                                  ? Colors.black
                                  : Colors.grey,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Campo de Horário
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
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.access_time, color: Colors.grey),
                          const SizedBox(width: 12),
                          Text(
                            selectedTime != null
                                ? selectedTime!.format(context)
                                : "Selecionar horário",
                            style: TextStyle(
                              color: selectedTime != null
                                  ? Colors.black
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
                  child: const Text("Fechar"),
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

      Navigator.of(context).pop(); // Fecha o modal

      await budgetController.updateBudgetDate(
        budget.id,
        formattedDate,
        context,
      );
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
          title: Text(title),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text("Cancelar"),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(true),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.indigo,
                foregroundColor: Colors.white,
              ),
              child: const Text("Confirmar"),
            ),
          ],
        );
      },
    );
  }
}
