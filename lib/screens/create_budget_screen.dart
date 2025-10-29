import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:maos_a_obra/controllers/data_controller.dart';
import 'package:maos_a_obra/controllers/budget_controller.dart';
import 'package:maos_a_obra/routes/app_routes.dart';
import 'package:maos_a_obra/screens/register_address_screen.dart';

class CreateBudgetScreen extends StatefulWidget {
  const CreateBudgetScreen({super.key});

  @override
  State<CreateBudgetScreen> createState() => _CreateBudgetScreenState();
}

class _CreateBudgetScreenState extends State<CreateBudgetScreen> {
  final TextEditingController descricaoController = TextEditingController();
  final TextEditingController dataController = TextEditingController();
  final TextEditingController horarioController = TextEditingController();
  final TextEditingController observacoesController = TextEditingController();

  final ImagePicker _picker = ImagePicker();
  List<File> imagens = [];

  String? disponibilidade;
  DateTime? dataSelecionada;
  String? horarioSelecionado;

  final _formKey = GlobalKey<FormState>();
  final BudgetController _budgetController = BudgetController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    DataController.selectedAddress = DataController.user!.addresses.first;
  }

  Future<void> pickImages() async {
    final pickedFiles = await _picker.pickMultiImage();
    if (pickedFiles.isNotEmpty) {
      setState(() {
        imagens = pickedFiles.map((e) => File(e.path)).toList();
      });
    }
  }

  Future<void> selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 1)),
      firstDate: DateTime.now().add(const Duration(days: 1)),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        dataSelecionada = picked;
        dataController.text = DateFormat('dd/MM/yyyy').format(picked);
      });
    }
  }

  Future<void> selectHorario() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (picked != null) {
      setState(() {
        final now = DateTime.now();
        final dt = DateTime(
          now.year,
          now.month,
          now.day,
          picked.hour,
          picked.minute,
        );
        horarioSelecionado = DateFormat.Hm().format(dt);
        horarioController.text = horarioSelecionado!;
      });
    }
  }

  Future<void> enviarFormulario() async {
    if (!_formKey.currentState!.validate() ||
        disponibilidade == null ||
        dataSelecionada == null ||
        horarioSelecionado == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Preencha todos os campos corretamente")),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // Combinar data e horário
      final dataHorario = DateTime(
        dataSelecionada!.year,
        dataSelecionada!.month,
        dataSelecionada!.day,
        int.parse(horarioSelecionado!.split(':')[0]),
        int.parse(horarioSelecionado!.split(':')[1]),
      );

      // Montar dados do orçamento
      Map<String, dynamic> budgetData = {
        'descricao': descricaoController.text,
        'visita': disponibilidade == 'sim' ? 1 : 0,
        'data': dataHorario.toIso8601String(),
        'observacoes': observacoesController.text.isNotEmpty
            ? observacoesController.text
            : null,
        'address_id': DataController.selectedAddress!.id,
        'cliente_id': DataController.user!.id,
        'prestador_id': DataController.selectedUser!.id,
        'status_id': 1,
      };

      Map<String, dynamic> notificationData = {
        "remetente_id": DataController.user!.id,
        "destinatario_id": DataController.selectedUser!.id,
        "titulo": "Nova solicitação de orçamento.",
        "descricao":
            "${DataController.user!.name} solicitou um novo orçamento. Clique para ver detalhes.",
      };

      await _budgetController.createBudget(
        budgetData,
        notificationData,
        context,
        _formKey,
        imagens,
      );

      _clearForm();
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Erro inesperado: $e")));
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _clearForm() {
    descricaoController.clear();
    dataController.clear();
    horarioController.clear();
    observacoesController.clear();
    setState(() {
      imagens.clear();
      disponibilidade = null;
      dataSelecionada = null;
      horarioSelecionado = null;
      DataController.selectedAddress = DataController.user!.addresses.first;
    });
  }

  void _showAddressSelector() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        final addresses = DataController.user!.addresses;

        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  "Selecione um endereço",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              Flexible(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: addresses.length,
                  itemBuilder: (context, index) {
                    final address = addresses[index];
                    return ListTile(
                      leading: const Icon(Icons.location_on),
                      title: Text(address.street),
                      subtitle: Text(
                        "${address.city} - ${address.state}, CEP: ${address.zipCode}",
                      ),
                      onTap: () {
                        setState(() {
                          DataController.selectedAddress = address;
                        });
                        Navigator.pop(context);
                      },
                    );
                  },
                ),
              ),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.add, color: Colors.green),
                title: const Text(
                  "Cadastrar novo endereço",
                  style: TextStyle(color: Colors.green),
                ),
                onTap: () async {
                  Navigator.pop(context);
                  AppRoutes.ultimaRota = '/createBudget';
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const RegisterAddressScreen(),
                    ),
                  );

                  setState(() {});
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Realizar orçamento")),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: descricaoController,
                decoration: const InputDecoration(
                  labelText: "Descrição",
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Por favor, insira uma descrição';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Upload fotos
              Row(
                children: [
                  ElevatedButton.icon(
                    onPressed: _isLoading ? null : pickImages,
                    icon: const Icon(Icons.photo),
                    label: const Text("Selecionar Fotos"),
                  ),
                  const SizedBox(width: 10),
                  Text("${imagens.length} imagens"),
                ],
              ),
              const SizedBox(height: 16),

              // Disponibilidade
              const Text(
                "Disponibilidade para visita:",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
              Row(
                children: [
                  Radio<String>(
                    value: "sim",
                    groupValue: disponibilidade,
                    onChanged: _isLoading
                        ? null
                        : (val) => setState(() => disponibilidade = val),
                  ),
                  const Text("Sim"),
                  Radio<String>(
                    value: "nao",
                    groupValue: disponibilidade,
                    onChanged: _isLoading
                        ? null
                        : (val) => setState(() => disponibilidade = val),
                  ),
                  const Text("Não"),
                ],
              ),
              if (disponibilidade == null)
                const Padding(
                  padding: EdgeInsets.only(left: 16.0),
                  child: Text(
                    "Selecione uma opção",
                    style: TextStyle(color: Colors.red, fontSize: 12),
                  ),
                ),
              const SizedBox(height: 16),

              // Data
              TextFormField(
                controller: dataController,
                readOnly: true,
                onTap: _isLoading ? null : selectDate,
                decoration: const InputDecoration(
                  labelText: "Data da visita",
                  border: OutlineInputBorder(),
                  suffixIcon: Icon(Icons.calendar_today),
                ),
                validator: (value) {
                  if (dataSelecionada == null) {
                    return 'Por favor, selecione uma data';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Horário
              TextFormField(
                controller: horarioController,
                readOnly: true,
                onTap: _isLoading ? null : selectHorario,
                decoration: const InputDecoration(
                  labelText: "Horário",
                  border: OutlineInputBorder(),
                  suffixIcon: Icon(Icons.access_time),
                ),
                validator: (value) {
                  if (horarioSelecionado == null) {
                    return 'Por favor, selecione um horário';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Endereço selecionado
              GestureDetector(
                onTap: _isLoading ? null : _showAddressSelector,
                child: Card(
                  child: ListTile(
                    leading: const Icon(Icons.location_on),
                    title: Text(DataController.selectedAddress!.street),
                    subtitle: Text(
                      "${DataController.selectedAddress!.city} - ${DataController.selectedAddress!.state}, CEP: ${DataController.selectedAddress!.zipCode}",
                    ),
                    trailing: const Icon(Icons.arrow_drop_down),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              TextFormField(
                controller: observacoesController,
                decoration: const InputDecoration(
                  labelText: "Observações (opcional)",
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 20),

              // Botão enviar
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : enviarFormulario,
                  child: _isLoading
                      ? const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            ),
                            SizedBox(width: 10),
                            Text("Enviando..."),
                          ],
                        )
                      : const Text("Enviar Solicitação"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    descricaoController.dispose();
    dataController.dispose();
    horarioController.dispose();
    observacoesController.dispose();
    super.dispose();
  }
}
