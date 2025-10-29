import 'package:flutter/material.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:intl/intl.dart';
import 'package:maos_a_obra/controllers/data_controller.dart';
import 'package:maos_a_obra/controllers/register_controller.dart';
import 'package:maos_a_obra/main.dart';
import 'package:maos_a_obra/models/user_type_model.dart';
import 'package:maos_a_obra/services/data_service.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  RegisterController registerController = RegisterController();
  DataService dataService = DataService(baseUrl: baseUrl);

  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = MaskedTextController(
    mask: '(00) 00000-0000',
  );
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  TextEditingController birthDateController = TextEditingController();
  TextEditingController cpfController = MaskedTextController(
    mask: '000.000.000-00',
  );
  TextEditingController cnpjController = MaskedTextController(
    mask: '00.000.000/0000-00',
  );

  UserType? userType;
  String? pessoaTipo;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _isLoading = false;

  Future<void> register() async {
    setState(() => _isLoading = true);
    Map<String, dynamic> user = {
      "name": nameController.text,
      "email": emailController.text,
      "phone": phoneController.text
          .replaceAll("(", "")
          .replaceAll(")", "")
          .replaceAll(" ", "")
          .replaceAll("-", ""),
      "birthDate": birthDateController.text,
      "cpf": cpfController.text.isEmpty
          ? null
          : cpfController.text.replaceAll(".", "").replaceAll("-", ""),
      "cnpj": cnpjController.text.isEmpty
          ? null
          : cnpjController.text.replaceAll(".", "").replaceAll("/", ""),
      "password": passwordController.text,
      "password_confirmation": confirmPasswordController.text,
      "role": userType!.description.toLowerCase(),
    };

    await registerController.register(user, context, formKey);
    if (mounted) setState(() => _isLoading = false);
  }

  String capitalize(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1).toLowerCase();
  }

  initialConfigPage() async {
    DataController.tiposUsuario = await dataService.getUserTypeList() ?? [];
    userType = DataController.tiposUsuario.first;
    setState(() {});
  }

  @override
  void initState() {
    initialConfigPage();
    super.initState();
  }

  InputDecoration _buildInputDecoration({
    required String label,
    required IconData icon,
    String? hint,
    Widget? suffixIcon,
  }) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      prefixIcon: Icon(icon, color: Colors.grey[600]),
      suffixIcon: suffixIcon,
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey[200]!),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.blue[600]!, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.red),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(24),
              color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back),
                        onPressed: () =>
                            Navigator.pushReplacementNamed(context, "/login"),
                        style: IconButton.styleFrom(
                          backgroundColor: Colors.grey[100],
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Criar conta',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey[900],
                              ),
                            ),
                            Text(
                              'Preencha os dados abaixo',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Form
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Form(
                  key: formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Tipo de usuário
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.blue[50],
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.blue[100]!),
                        ),
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.person_outline,
                                  color: Colors.blue[700],
                                  size: 20,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'Tipo de conta',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.blue[900],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            DropdownButtonFormField<UserType>(
                              value: userType,
                              decoration: _buildInputDecoration(
                                label: "Tipo de usuário",
                                icon: Icons.badge_outlined,
                              ),
                              items: [
                                for (var type in DataController.tiposUsuario)
                                  DropdownMenuItem(
                                    value: type,
                                    child: Text(capitalize(type.description)),
                                  ),
                              ],
                              onChanged: (value) {
                                userType = value!;
                                pessoaTipo = null;
                                setState(() {});
                              },
                            ),
                            if (userType != null &&
                                userType!.description.toLowerCase() !=
                                    "cliente") ...[
                              const SizedBox(height: 12),
                              DropdownButtonFormField<String>(
                                value: pessoaTipo,
                                decoration: _buildInputDecoration(
                                  label: "Tipo de pessoa",
                                  icon: Icons.business_outlined,
                                ),
                                items: const [
                                  DropdownMenuItem(
                                    value: "fisica",
                                    child: Text("Pessoa Física"),
                                  ),
                                  DropdownMenuItem(
                                    value: "juridica",
                                    child: Text("Pessoa Jurídica"),
                                  ),
                                ],
                                onChanged: (value) {
                                  pessoaTipo = value;
                                  setState(() {});
                                },
                              ),
                            ],
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Documentos
                      if (pessoaTipo == "fisica" ||
                          (userType != null &&
                              userType!.description.toLowerCase() == "cliente"))
                        Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: TextFormField(
                            controller: cpfController,
                            keyboardType: TextInputType.number,
                            decoration: _buildInputDecoration(
                              label: "CPF",
                              icon: Icons.badge_outlined,
                              hint: "000.000.000-00",
                            ),
                          ),
                        ),
                      if (pessoaTipo == "juridica" &&
                          userType!.description.toLowerCase() == "prestador")
                        Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: TextFormField(
                            controller: cnpjController,
                            keyboardType: TextInputType.number,
                            decoration: _buildInputDecoration(
                              label: "CNPJ",
                              icon: Icons.business_outlined,
                              hint: "00.000.000/0000-00",
                            ),
                          ),
                        ),

                      // Nome
                      TextFormField(
                        controller: nameController,
                        textCapitalization: TextCapitalization.words,
                        decoration: _buildInputDecoration(
                          label:
                              (userType != null &&
                                  userType!.description.toLowerCase() !=
                                      "cliente" &&
                                  pessoaTipo == "juridica")
                              ? "Razão Social"
                              : "Nome completo",
                          icon: Icons.person_outline,
                          hint: "Digite seu nome",
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Email
                      TextFormField(
                        controller: emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: _buildInputDecoration(
                          label: "E-mail",
                          icon: Icons.email_outlined,
                          hint: "seu@email.com",
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Telefone
                      TextFormField(
                        controller: phoneController,
                        keyboardType: TextInputType.phone,
                        decoration: _buildInputDecoration(
                          label: "Telefone",
                          icon: Icons.phone_outlined,
                          hint: "(00) 00000-0000",
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Data de nascimento
                      TextFormField(
                        controller: birthDateController,
                        readOnly: true,
                        onTap: () =>
                            showDatePicker(
                              context: context,
                              firstDate: DateTime(1900),
                              lastDate: DateTime.now(),
                              initialDate: DateTime.now(),
                              builder: (context, child) {
                                return Theme(
                                  data: Theme.of(context).copyWith(
                                    colorScheme: ColorScheme.light(
                                      primary: Colors.blue[600]!,
                                    ),
                                  ),
                                  child: child!,
                                );
                              },
                            ).then((value) {
                              if (value != null) {
                                birthDateController.text = DateFormat(
                                  "yyyy-MM-dd",
                                ).format(value);
                              }
                              setState(() {});
                            }),
                        decoration: _buildInputDecoration(
                          label: "Data de nascimento",
                          icon: Icons.cake_outlined,
                          hint: "DD/MM/AAAA",
                          suffixIcon: Icon(
                            Icons.calendar_today,
                            color: Colors.grey[600],
                            size: 20,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Senha
                      TextFormField(
                        controller: passwordController,
                        obscureText: _obscurePassword,
                        decoration: _buildInputDecoration(
                          label: "Senha",
                          icon: Icons.lock_outline,
                          hint: "Mínimo 6 caracteres",
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscurePassword
                                  ? Icons.visibility_off_outlined
                                  : Icons.visibility_outlined,
                              color: Colors.grey[600],
                            ),
                            onPressed: () => setState(
                              () => _obscurePassword = !_obscurePassword,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Confirmar senha
                      TextFormField(
                        controller: confirmPasswordController,
                        obscureText: _obscureConfirmPassword,
                        decoration: _buildInputDecoration(
                          label: "Confirmar senha",
                          icon: Icons.lock_outline,
                          hint: "Digite a senha novamente",
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscureConfirmPassword
                                  ? Icons.visibility_off_outlined
                                  : Icons.visibility_outlined,
                              color: Colors.grey[600],
                            ),
                            onPressed: () => setState(
                              () => _obscureConfirmPassword =
                                  !_obscureConfirmPassword,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 32),

                      // Botão Cadastrar
                      SizedBox(
                        height: 56,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue[600],
                            foregroundColor: Colors.white,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onPressed: _isLoading ? null : register,
                          child: _isLoading
                              ? const SizedBox(
                                  height: 24,
                                  width: 24,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2.5,
                                  ),
                                )
                              : const Text(
                                  "Criar conta",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Link para login
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Já tem uma conta? ',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 15,
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pushReplacementNamed(context, "/login");
                            },
                            style: TextButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 4,
                              ),
                              minimumSize: const Size(0, 0),
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                            child: Text(
                              'Entrar',
                              style: TextStyle(
                                color: Colors.blue[600],
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
