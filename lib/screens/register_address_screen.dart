import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:maos_a_obra/controllers/address_controller.dart';
import 'package:maos_a_obra/styles/style.dart';

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
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      Image.asset('assets/imgs/Logo.png'),
                      const SizedBox(height: 20),
                      Text(
                        'Insira seu endereço',
                        style: TextStyle(
                          color: Color(AppColors.cinza),
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                  TextFormField(
                    controller: cepController,
                    decoration: AppDecorations.inputDecoration('CEP*').copyWith(
                      suffixIcon: loadingCep
                          ? const Padding(
                              padding: EdgeInsets.all(10),
                              child: SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              ),
                            )
                          : null,
                    ),
                    keyboardType: TextInputType.number,
                    validator: (v) => validateField(v, 'CEP', maxLength: 8),
                    onChanged: (value) {
                      if (value.length == 8) buscarCep(value);
                    },
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: estadoController,
                          decoration: AppDecorations.inputDecoration('Estado*'),
                          validator: (v) =>
                              validateField(v, 'Estado', maxLength: 2),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: TextFormField(
                          controller: cidadeController,
                          decoration: AppDecorations.inputDecoration('Cidade*'),
                          validator: (v) =>
                              validateField(v, 'Cidade', maxLength: 100),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: bairroController,
                    decoration: AppDecorations.inputDecoration('Bairro*'),
                    validator: (v) =>
                        validateField(v, 'Bairro', maxLength: 100),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: ruaController,
                          decoration: AppDecorations.inputDecoration('Rua*'),
                          validator: (v) =>
                              validateField(v, 'Rua', maxLength: 150),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: TextFormField(
                          controller: numeroController,
                          decoration: AppDecorations.inputDecoration('Número*'),
                          validator: (v) =>
                              validateField(v, 'Número', maxLength: 10),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: complementoController,
                    decoration: AppDecorations.inputDecoration('Complemento'),
                    validator: (v) =>
                        validateField(v, 'Complemento', maxLength: 100),
                  ),
                  const SizedBox(height: 80),
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
                            Navigator.pushReplacementNamed(context, '/home');
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
                          onPressed: salvar,
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
