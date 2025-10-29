import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:carousel_slider/carousel_slider.dart';

class PortfolioScreen extends StatefulWidget {
  const PortfolioScreen({super.key});

  @override
  State<PortfolioScreen> createState() => _PortfolioScreenState();
}

class _PortfolioScreenState extends State<PortfolioScreen> {
  final TextEditingController _descricaoController = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  final List<File> _images = [];

  /// Abre a galeria para selecionar múltiplas imagens
  Future<void> _pickImages() async {
    final List<XFile> pickedFiles = await _picker.pickMultiImage();
    if (pickedFiles.isNotEmpty) {
      setState(() {
        _images.addAll(pickedFiles.map((file) => File(file.path)).toList());
      });
    }
  }

  /// Modal perguntando se deseja adicionar outro serviço
  void _showAddServiceDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          contentPadding: const EdgeInsets.all(20),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Deseja adicionar mais um serviço ao seu portfólio?",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      side: const BorderSide(color: Colors.black54),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                      _descricaoController.clear();
                      _images.clear();
                      setState(() {});
                    },
                    child: const Text(
                      "Adicionar",
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                      // Aqui você poderia salvar os dados em backend/local
                    },
                    child: const Text("Enviar"),
                  ),
                ],
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
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const SizedBox(height: 10),

              // Logo e título
              Column(
                children: const [
                  Icon(Icons.handyman, size: 60, color: Colors.blueAccent),
                  SizedBox(height: 12),
                  Text(
                    "Adicione um serviço ao seu portfólio",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // Botão Carregar arquivos de mídia
              OutlinedButton.icon(
                onPressed: _pickImages,
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 14,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  side: const BorderSide(color: Colors.black54),
                ),
                icon: const Icon(Icons.upload, color: Colors.blueAccent),
                label: const Text(
                  "Carregar arquivos de mídia",
                  style: TextStyle(color: Colors.black87),
                ),
              ),

              const SizedBox(height: 20),

              // Carrossel de imagens
              if (_images.isNotEmpty)
                CarouselSlider(
                  options: CarouselOptions(
                    height: 180,
                    enlargeCenterPage: true,
                    enableInfiniteScroll: false,
                  ),
                  items: _images.map((file) {
                    return ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.file(file, fit: BoxFit.cover, width: 1000),
                    );
                  }).toList(),
                ),

              const SizedBox(height: 20),

              // Campo descrição
              TextField(
                controller: _descricaoController,
                maxLines: 3,
                decoration: InputDecoration(
                  labelText: "Descrição do serviço",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Texto explicativo
              const Text(
                "O registro de fotos dos serviços realizados contribui para aumentar suas chances de aprovação e atrair mais clientes.",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 13, color: Colors.black54),
              ),

              const SizedBox(height: 20),

              // Botões Pular e Adicionar serviço
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        side: const BorderSide(color: Colors.black54),
                      ),
                      onPressed: () {},
                      child: const Text(
                        "Pular",
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueAccent,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: _showAddServiceDialog,
                      child: const Text("Adicionar serviço"),
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
