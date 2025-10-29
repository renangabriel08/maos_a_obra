import 'package:flutter/material.dart';
import 'package:maos_a_obra/controllers/data_controller.dart';
import 'package:maos_a_obra/controllers/specialties_controller.dart';
import 'package:maos_a_obra/main.dart';
import 'package:maos_a_obra/services/data_service.dart';
import 'package:maos_a_obra/models/specialty_model.dart';

class SpecialtiesScreen extends StatefulWidget {
  const SpecialtiesScreen({super.key});

  @override
  State<SpecialtiesScreen> createState() => _SpecialtiesScreenState();
}

class _SpecialtiesScreenState extends State<SpecialtiesScreen> {
  final DataService _dataService = DataService(baseUrl: baseUrl);
  SpecialtiesController specialtiesController = SpecialtiesController();

  final List<Specialty> _selecionadas = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _carregarEspecialidades();
  }

  Future<void> _carregarEspecialidades() async {
    setState(() => _loading = true);
    try {
      final especialidades = await _dataService.getSpecialtyList();
      await _dataService.getStatusList();
      setState(() {
        DataController.especialidades = especialidades!;
        _loading = false;
      });
    } catch (e) {
      setState(() => _loading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Erro ao carregar especialidades")),
      );
    }
  }

  void _toggleSelecionada(Specialty esp, bool? value) {
    setState(() {
      if (value == true) {
        _selecionadas.add(esp);
      } else {
        _selecionadas.remove(esp);
      }
    });
  }

  void _salvar() {
    if (_selecionadas.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Selecione pelo menos uma especialidade")),
      );
      return;
    }

    specialtiesController.registerSpecialties(_selecionadas, context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Selecionar Especialidades")),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                ...DataController.especialidades.map(
                  (esp) => CheckboxListTile(
                    title: Text(esp.name),
                    value: _selecionadas.contains(esp),
                    onChanged: (value) => _toggleSelecionada(esp, value),
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(onPressed: _salvar, child: const Text("Salvar")),
              ],
            ),
    );
  }
}
