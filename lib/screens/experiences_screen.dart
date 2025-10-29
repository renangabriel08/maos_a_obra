import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:maos_a_obra/controllers/experiences_controller.dart';
import 'package:maos_a_obra/main.dart';
import 'package:maos_a_obra/services/auth_service.dart';

class ExperiencesScreen extends StatefulWidget {
  const ExperiencesScreen({super.key});

  @override
  State<ExperiencesScreen> createState() => _ExperiencesScreenState();
}

class _ExperiencesScreenState extends State<ExperiencesScreen> {
  ExperiencesController experiencesController = ExperiencesController();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final experienciaController = TextEditingController();
  File? imagemSelecionada;

  AuthService authService = AuthService(baseUrl: baseUrl);

  @override
  void dispose() {
    experienciaController.dispose();
    super.dispose();
  }

  Future<void> tirarFoto() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
      setState(() {
        imagemSelecionada = File(pickedFile.path);
      });
    }
  }

  Future<void> cadastrar() async {
    Map<String, dynamic> experiences = {
      "image": imagemSelecionada,
      "experiencia": experienciaController.text,
    };

    await experiencesController.registerExperiences(
      experiences,
      context,
      formKey,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Cadastro de Experiência")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: experienciaController,
                decoration: const InputDecoration(
                  labelText: "Experiência",
                  border: OutlineInputBorder(),
                ),
                validator: (v) {
                  if (v == null || v.trim().isEmpty) {
                    return "Informe sua experiência";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              imagemSelecionada != null
                  ? Image.file(imagemSelecionada!, height: 200)
                  : const Text("Nenhuma foto selecionada"),
              const SizedBox(height: 10),
              ElevatedButton.icon(
                onPressed: tirarFoto,
                icon: const Icon(Icons.camera_alt),
                label: const Text("Tirar Foto"),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: cadastrar,
                child: const Text("Cadastrar"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
