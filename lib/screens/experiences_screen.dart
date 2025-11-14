import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:maos_a_obra/controllers/experiences_controller.dart';
import 'package:maos_a_obra/main.dart';
import 'package:maos_a_obra/services/auth_service.dart';
import 'package:maos_a_obra/styles/style.dart';

class ExperiencesScreen extends StatefulWidget {
  const ExperiencesScreen({super.key});

  @override
  State<ExperiencesScreen> createState() => _ExperiencesScreenState();
}

class _ExperiencesScreenState extends State<ExperiencesScreen> {
  final ExperiencesController experiencesController = ExperiencesController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController experienciaController = TextEditingController();
  final ImagePicker picker = ImagePicker();
  File? imagemSelecionada;

  AuthService authService = AuthService(baseUrl: baseUrl);

  @override
  void dispose() {
    experienciaController.dispose();
    super.dispose();
  }

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await picker.pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        imagemSelecionada = File(pickedFile.path);
      });
    }
    Navigator.pop(context);
  }

  void _showImagePickerOptions() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (BuildContext context) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Escolher da galeria'),
                onTap: () => _pickImage(ImageSource.gallery),
              ),
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Tirar uma foto'),
                onTap: () => _pickImage(ImageSource.camera),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> cadastrar() async {
    if (formKey.currentState!.validate()) {
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
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
                children: [
                  Image.asset('assets/imgs/Logo.png'),
                  const SizedBox(height: 20),
                  const Text(
                    'Complete seu cadastro',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 30),

                  // Avatar para foto de perfil
                  GestureDetector(
                    onTap: _showImagePickerOptions,
                    child: CircleAvatar(
                      radius: 60,
                      backgroundColor: Colors.grey[200],
                      backgroundImage: imagemSelecionada != null
                          ? FileImage(imagemSelecionada!)
                          : null,
                      child: imagemSelecionada == null
                          ? const Icon(
                              Icons.add_a_photo,
                              size: 40,
                              color: Colors.grey,
                            )
                          : null,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Adicionar foto de perfil',
                    style: TextStyle(
                      color: Color(AppColors.azulescuro),
                      fontSize: 20,
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Campo de texto de experiência
                  TextFormField(
                    controller: experienciaController,
                    maxLines: 6,
                    decoration: AppDecorations.inputDecoration('Experiências*'),
                    validator: (v) {
                      if (v == null || v.trim().isEmpty) {
                        return "Informe sua experiência";
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 80),

                  // Botões de navegação
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Expanded(
                      //   child: ElevatedButton(
                      //     style: ElevatedButton.styleFrom(
                      //       fixedSize: Size(width, 50),
                      //       backgroundColor: Colors.white,
                      //       side: BorderSide(
                      //         color: Color(AppColors.azulescuro),
                      //         width: 2,
                      //       ),
                      //       shape: RoundedRectangleBorder(
                      //         borderRadius: BorderRadius.circular(10),
                      //       ),
                      //     ),
                      //     onPressed: () {
                      //       Navigator.pushReplacementNamed(
                      //         context,
                      //         '/Cadastro',
                      //       );
                      //     },
                      //     child: Text(
                      //       'Voltar',
                      //       style: TextStyle(
                      //         color: Color(AppColors.azulescuro),
                      //         fontSize: 16,
                      //       ),
                      //     ),
                      //   ),
                      // ),
                      // const SizedBox(width: 50),
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            fixedSize: Size(width, 50),
                            backgroundColor: Color(AppColors.roxo),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          onPressed: cadastrar,
                          child: const Text(
                            'Prosseguir',
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
