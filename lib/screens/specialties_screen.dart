import 'package:flutter/material.dart';
import 'package:maos_a_obra/controllers/data_controller.dart';
import 'package:maos_a_obra/controllers/specialties_controller.dart';
import 'package:maos_a_obra/main.dart';
import 'package:maos_a_obra/services/data_service.dart';
import 'package:maos_a_obra/models/specialty_model.dart';
import 'package:maos_a_obra/styles/style.dart';

class SpecialtiesScreen extends StatefulWidget {
  const SpecialtiesScreen({super.key});

  @override
  State<SpecialtiesScreen> createState() => _SpecialtiesScreenState();
}

class _SpecialtiesScreenState extends State<SpecialtiesScreen> {
  final DataService _dataService = DataService(baseUrl: baseUrl);
  final SpecialtiesController specialtiesController = SpecialtiesController();
  final List<Specialty> _selecionadas = [];

  bool _loading = true;

  String capitalize(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1).toLowerCase();
  }

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
        DataController.especialidades = especialidades ?? [];
        _loading = false;
      });
    } catch (e) {
      setState(() => _loading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Erro ao carregar especialidades")),
      );
    }
  }

  void _toggleSelecionada(Specialty esp) {
    setState(() {
      if (_selecionadas.contains(esp)) {
        _selecionadas.remove(esp);
      } else {
        _selecionadas.add(esp);
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
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: _loading
            ? const Center(child: CircularProgressIndicator())
            : Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 20),
                    Image.asset('assets/imgs/Logo.png'),
                    const SizedBox(height: 20),
                    Text(
                      " Quais são suas \n especialidades?",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color(AppColors.azulescuro),
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    Expanded(
                      child: GridView.builder(
                        itemCount: DataController.especialidades.length,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              crossAxisSpacing: 12,
                              mainAxisSpacing: 12,
                              childAspectRatio: 1.1,
                            ),
                        itemBuilder: (context, index) {
                          final esp = DataController.especialidades[index];
                          final selecionada = _selecionadas.contains(esp);

                          // Ícones padrões com fallback genérico
                          final icones = [
                            Icons.dry_cleaning,
                            Icons.settings,
                            Icons.design_services,
                            Icons.construction,
                            Icons.brush,
                            Icons.chair,
                            Icons.cleaning_services,
                            Icons.window,
                            Icons.sports_soccer,
                            Icons.water_damage,
                            Icons.more_horiz,
                          ];
                          final icon = icones[index % icones.length];

                          return GestureDetector(
                            onTap: () => _toggleSelecionada(esp),
                            child: Column(
                              children: [
                                CircleAvatar(
                                  radius: 30,
                                  backgroundColor: selecionada
                                      ? Color(AppColors.roxo)
                                      : Colors.grey[200],
                                  child: Icon(
                                    icon,
                                    color: selecionada
                                        ? Colors.white
                                        : Colors.black87,
                                    size: 28,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  capitalize(esp.name),
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              fixedSize: Size(width, 50),
                              backgroundColor: Colors.white,
                              side: BorderSide(
                                color: Color(AppColors.azulescuro),
                                width: 2,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            onPressed: () {
                              Navigator.pushReplacementNamed(
                                context,
                                '/Completecadastro',
                              );
                            },
                            child: Text(
                              'Voltar',
                              style: TextStyle(
                                color: Color(AppColors.azulescuro),
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 50),
                        Expanded(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              fixedSize: Size(width, 50),
                              backgroundColor: Color(AppColors.roxo),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            onPressed: _salvar,
                            child: const Text(
                              'Prosseguir',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
