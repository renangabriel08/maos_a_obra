import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:maos_a_obra/controllers/address_controller.dart';

class RegisterAddressScreen extends StatefulWidget {
  const RegisterAddressScreen({super.key});

  @override
  State<RegisterAddressScreen> createState() => _RegisterAddressScreenState();
}

class _RegisterAddressScreenState extends State<RegisterAddressScreen> {
  AddressController addressController = AddressController();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  TextEditingController cepController = TextEditingController();
  TextEditingController estadoController = TextEditingController();
  TextEditingController cidadeController = TextEditingController();
  TextEditingController bairroController = TextEditingController();
  TextEditingController ruaController = TextEditingController();
  TextEditingController numeroController = TextEditingController();
  TextEditingController complementoController = TextEditingController();

  bool loadingCep = false;

  @override
  void dispose() {
    cepController.dispose();
    estadoController.dispose();
    cidadeController.dispose();
    bairroController.dispose();
    ruaController.dispose();
    numeroController.dispose();
    complementoController.dispose();
    super.dispose();
  }

  String? validateField(String? value, String fieldName, {int? maxLength}) {
    if (value == null || value.trim().isEmpty) {
      return 'O campo $fieldName é obrigatório';
    }
    if (maxLength != null && value.length > maxLength) {
      return 'Máximo de $maxLength caracteres';
    }
    return null;
  }

  Future<void> buscarCep(String cep) async {
    if (cep.length != 8) return;

    setState(() => loadingCep = true);

    try {
      final response = await http.get(
        Uri.parse('https://viacep.com.br/ws/$cep/json/'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data['erro'] == true) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text('CEP não encontrado!')));
        } else {
          setState(() {
            ruaController.text = data['logradouro'] ?? '';
            bairroController.text = data['bairro'] ?? '';
            cidadeController.text = data['localidade'] ?? '';
            estadoController.text = data['uf'] ?? '';
          });
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Erro ao buscar CEP!')));
    } finally {
      setState(() => loadingCep = false);
    }
  }

  Future<void> salvar() async {
    if (formKey.currentState!.validate()) {
      Map<String, dynamic> address = {
        'zipCode': cepController.text,
        'state': estadoController.text,
        'city': cidadeController.text,
        'district': bairroController.text,
        'street': ruaController.text,
        'number': numeroController.text,
        'complement': complementoController.text,
      };

      await addressController.registerAddress(address, context, formKey);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Cadastro de Endereço')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: cepController,
                decoration: InputDecoration(
                  labelText: 'CEP',
                  suffixIcon: loadingCep
                      ? const Padding(
                          padding: EdgeInsets.all(10),
                          child: SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),
                        )
                      : null,
                ),
                keyboardType: TextInputType.number,
                validator: (v) => validateField(v, 'CEP', maxLength: 8),
                onFieldSubmitted: (value) => buscarCep(value),
                onChanged: (value) {
                  if (value.length == 8) {
                    buscarCep(value);
                  }
                },
              ),
              TextFormField(
                controller: estadoController,
                decoration: const InputDecoration(labelText: 'Estado (UF)'),
                validator: (v) => validateField(v, 'Estado', maxLength: 2),
              ),
              TextFormField(
                controller: cidadeController,
                decoration: const InputDecoration(labelText: 'Cidade'),
                validator: (v) => validateField(v, 'Cidade', maxLength: 100),
              ),
              TextFormField(
                controller: bairroController,
                decoration: const InputDecoration(labelText: 'Bairro'),
                validator: (v) => validateField(v, 'Bairro', maxLength: 100),
              ),
              TextFormField(
                controller: ruaController,
                decoration: const InputDecoration(labelText: 'Rua'),
                validator: (v) => validateField(v, 'Rua', maxLength: 150),
              ),
              TextFormField(
                controller: numeroController,
                decoration: const InputDecoration(labelText: 'Número'),
                validator: (v) => validateField(v, 'Número', maxLength: 10),
              ),
              TextFormField(
                controller: complementoController,
                decoration: const InputDecoration(labelText: 'Complemento'),
                validator: (v) =>
                    validateField(v, 'Complemento', maxLength: 100),
              ),
              const SizedBox(height: 20),
              ElevatedButton(onPressed: salvar, child: const Text('Salvar')),
            ],
          ),
        ),
      ),
    );
  }
}
