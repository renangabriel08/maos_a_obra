import 'package:flutter/material.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:intl/intl.dart';
import 'package:maos_a_obra/controllers/data_controller.dart';
import 'package:maos_a_obra/controllers/register_controller.dart';
import 'package:maos_a_obra/main.dart';
import 'package:maos_a_obra/models/user_type_model.dart';
import 'package:maos_a_obra/services/data_service.dart';
import 'package:maos_a_obra/styles/style.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  // Controllers / services / state
  final RegisterController registerController = RegisterController();
  final DataService dataService = DataService(baseUrl: baseUrl);

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = MaskedTextController(
    mask: '(00) 00000-0000',
  );
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final TextEditingController birthDateController = TextEditingController();
  final TextEditingController cpfController = MaskedTextController(
    mask: '000.000.000-00',
  );
  final TextEditingController cnpjController = MaskedTextController(
    mask: '00.000.000/0000-00',
  );

  UserType? userType;
  String? pessoaTipo; // "fisica" | "juridica" or null
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _isLoading = false;

  // Carrega tipos de usuário
  Future<void> initialConfigPage() async {
    DataController.tiposUsuario = await dataService.getUserTypeList() ?? [];
    if (DataController.tiposUsuario.isNotEmpty) {
      DataController.tiposUsuario = DataController.tiposUsuario.sublist(0, 2);
    }
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    initialConfigPage();
  }

  String? _validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return pessoaTipo == "juridica"
          ? 'Razão social é obrigatória'
          : 'Nome completo é obrigatório';
    }
    if (value.trim().length < 3) {
      return 'Nome deve ter no mínimo 3 caracteres';
    }
    if (pessoaTipo == "fisica" && !value.contains(' ')) {
      return 'Digite o nome completo';
    }
    return null;
  }

  String? _validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'E-mail é obrigatório';
    }
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) {
      return 'E-mail inválido';
    }
    return null;
  }

  String? _validatePhone(String? value) {
    if (value == null || value.isEmpty) {
      return 'Telefone é obrigatório';
    }
    final digitsOnly = value.replaceAll(RegExp(r'\D'), '');
    if (digitsOnly.length < 11) {
      return 'Telefone incompleto';
    }
    return null;
  }

  String? _validateCPF(String? value) {
    if (value == null || value.isEmpty) {
      return 'CPF é obrigatório';
    }
    final digitsOnly = value.replaceAll(RegExp(r'\D'), '');
    if (digitsOnly.length != 11) {
      return 'CPF deve ter 11 dígitos';
    }

    // Validação de CPF
    if (digitsOnly.split('').toSet().length == 1) {
      return 'CPF inválido';
    }

    List<int> numbers = digitsOnly.split('').map(int.parse).toList();

    // Calcula primeiro dígito verificador
    int sum = 0;
    for (int i = 0; i < 9; i++) {
      sum += numbers[i] * (10 - i);
    }
    int digit1 = 11 - (sum % 11);
    if (digit1 >= 10) digit1 = 0;

    if (numbers[9] != digit1) {
      return 'CPF inválido';
    }

    // Calcula segundo dígito verificador
    sum = 0;
    for (int i = 0; i < 10; i++) {
      sum += numbers[i] * (11 - i);
    }
    int digit2 = 11 - (sum % 11);
    if (digit2 >= 10) digit2 = 0;

    if (numbers[10] != digit2) {
      return 'CPF inválido';
    }

    return null;
  }

  String? _validateCNPJ(String? value) {
    if (value == null || value.isEmpty) {
      return 'CNPJ é obrigatório';
    }
    final digitsOnly = value.replaceAll(RegExp(r'\D'), '');
    if (digitsOnly.length != 14) {
      return 'CNPJ deve ter 14 dígitos';
    }

    // Validação básica de CNPJ
    if (digitsOnly.split('').toSet().length == 1) {
      return 'CNPJ inválido';
    }

    List<int> numbers = digitsOnly.split('').map(int.parse).toList();

    // Calcula primeiro dígito verificador
    List<int> weights1 = [5, 4, 3, 2, 9, 8, 7, 6, 5, 4, 3, 2];
    int sum = 0;
    for (int i = 0; i < 12; i++) {
      sum += numbers[i] * weights1[i];
    }
    int digit1 = sum % 11 < 2 ? 0 : 11 - (sum % 11);

    if (numbers[12] != digit1) {
      return 'CNPJ inválido';
    }

    // Calcula segundo dígito verificador
    List<int> weights2 = [6, 5, 4, 3, 2, 9, 8, 7, 6, 5, 4, 3, 2];
    sum = 0;
    for (int i = 0; i < 13; i++) {
      sum += numbers[i] * weights2[i];
    }
    int digit2 = sum % 11 < 2 ? 0 : 11 - (sum % 11);

    if (numbers[13] != digit2) {
      return 'CNPJ inválido';
    }

    return null;
  }

  String? _validateBirthDate(String? value) {
    if (value == null || value.isEmpty) {
      return 'Data de nascimento é obrigatória';
    }
    try {
      final date = DateFormat("yyyy-MM-dd").parse(value);
      final now = DateTime.now();
      final age = now.year - date.year;

      if (date.isAfter(now)) {
        return 'Data não pode ser futura';
      }
      if (age < 18) {
        return 'Você deve ter no mínimo 18 anos';
      }
      if (age > 120) {
        return 'Data inválida';
      }
    } catch (e) {
      return 'Data inválida';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Senha é obrigatória';
    }
    if (value.length < 6) {
      return 'Senha deve ter no mínimo 6 caracteres';
    }
    if (!RegExp(r'[A-Z]').hasMatch(value)) {
      return 'Senha deve conter ao menos uma letra maiúscula';
    }
    if (!RegExp(r'[a-z]').hasMatch(value)) {
      return 'Senha deve conter ao menos uma letra minúscula';
    }
    if (!RegExp(r'[0-9]').hasMatch(value)) {
      return 'Senha deve conter ao menos um número';
    }
    return null;
  }

  String? _validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Confirmação de senha é obrigatória';
    }
    if (value != passwordController.text) {
      return 'As senhas não coincidem';
    }
    return null;
  }

  // Função de registro
  Future<void> register() async {
    // Validação do tipo de pessoa
    if (pessoaTipo == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Selecione o tipo de pessoa (física ou jurídica)'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Validação do tipo de usuário
    if (userType == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Selecione o tipo de conta'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (formKey.currentState != null && !(formKey.currentState!.validate())) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor, corrija os erros no formulário'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

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
          : cnpjController.text
                .replaceAll(".", "")
                .replaceAll("/", "")
                .replaceAll("-", ""),
      "password": passwordController.text,
      "password_confirmation": confirmPasswordController.text,
      "role": userType!.description.toLowerCase(),
    };

    await registerController.register(user, context, formKey);
  }

  String capitalize(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1).toLowerCase();
  }

  // Helper para usar AppDecorations e adicionar ícones/suffix where needed
  InputDecoration _decoration(String label, {Widget? suffix, String? hint}) {
    return AppDecorations.inputDecoration(
      label,
    ).copyWith(hintText: hint, suffixIcon: suffix);
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
          padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
          child: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
                children: [
                  // Logo + título (layout do Cadastro)
                  Image.asset('assets/imgs/Logo.png'),
                  const SizedBox(height: 20),
                  Text(
                    'Criar uma conta',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(AppColors.cinza),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Botões de seleção: Pessoa física / Pessoa jurídica (aplica visual do Cadastro)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _tipoContaButton("Pessoa física", "fisica"),
                      const SizedBox(width: 10),
                      _tipoContaButton("Pessoa jurídica", "juridica"),
                    ],
                  ),

                  const SizedBox(height: 10),

                  DropdownButtonFormField<UserType>(
                    value: userType,
                    decoration: _decoration("Tipo de conta*"),
                    validator: (value) {
                      if (value == null) {
                        return 'Selecione o tipo de conta';
                      }
                      return null;
                    },
                    items: [
                      for (var type in DataController.tiposUsuario)
                        DropdownMenuItem(
                          value: type,
                          child: Text(capitalize(type.description)),
                        ),
                    ],
                    onChanged: (value) {
                      userType = value;
                      setState(() {});
                    },
                  ),

                  const SizedBox(height: 10),
                  // Nome / Razão social (texto muda conforme tipo selecionado)
                  TextFormField(
                    controller: nameController,
                    textCapitalization: TextCapitalization.words,
                    validator: _validateName,
                    decoration: _decoration(
                      (pessoaTipo == "juridica")
                          ? "Razão Social*"
                          : "Nome completo*",
                    ),
                  ),
                  const SizedBox(height: 10),

                  // E-mail
                  TextFormField(
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                    validator: _validateEmail,
                    decoration: _decoration("E-mail*"),
                  ),
                  const SizedBox(height: 10),

                  // Telefone
                  TextFormField(
                    controller: phoneController,
                    keyboardType: TextInputType.phone,
                    validator: _validatePhone,
                    decoration: _decoration("Telefone*"),
                  ),
                  const SizedBox(height: 10),

                  // Campos dinâmicos: CPF / CNPJ conforme escolha (mantendo lógica)
                  if (pessoaTipo == "fisica")
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: TextFormField(
                        controller: cpfController,
                        keyboardType: TextInputType.number,
                        validator: _validateCPF,
                        decoration: _decoration("CPF*"),
                      ),
                    ),
                  if (pessoaTipo == "juridica")
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: TextFormField(
                        controller: cnpjController,
                        keyboardType: TextInputType.number,
                        validator: _validateCNPJ,
                        decoration: _decoration("CNPJ*"),
                      ),
                    ),

                  // Data de nascimento com DatePicker
                  TextFormField(
                    controller: birthDateController,
                    readOnly: true,
                    validator: _validateBirthDate,
                    onTap: () =>
                        showDatePicker(
                          context: context,
                          firstDate: DateTime(1900),
                          lastDate: DateTime.now(),
                          initialDate: DateTime.now().subtract(
                            const Duration(days: 365 * 18),
                          ),
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
                            // Revalida o campo após seleção
                            formKey.currentState?.validate();
                          }
                          setState(() {});
                        }),
                    decoration: _decoration(
                      "Data de nascimento*",
                      suffix: Icon(
                        Icons.calendar_today,
                        color: Colors.grey[600],
                        size: 20,
                      ),
                    ),
                  ),

                  const SizedBox(height: 10),

                  // Senha
                  TextFormField(
                    controller: passwordController,
                    obscureText: _obscurePassword,
                    validator: _validatePassword,
                    decoration: _decoration(
                      "Senha*",
                      suffix: IconButton(
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
                  const SizedBox(height: 10),

                  // Confirmar senha
                  TextFormField(
                    controller: confirmPasswordController,
                    obscureText: _obscureConfirmPassword,
                    validator: _validateConfirmPassword,
                    decoration: _decoration(
                      "Confirmar senha*",
                      suffix: IconButton(
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

                  const SizedBox(height: 20),

                  // Botão Cadastrar (visual do Cadastro)
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      fixedSize: Size(width, 60),
                      backgroundColor: Color(AppColors.roxo),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
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
                            'Cadastrar',
                            style: TextStyle(color: Colors.white, fontSize: 20),
                          ),
                  ),

                  const SizedBox(height: 20),

                  // Link para login
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Já tem uma conta?',
                          style: TextStyle(
                            color: Color(AppColors.cinza),
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          ' Entrar',
                          style: TextStyle(
                            color: Color(AppColors.cinza),
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Divisor 'ou'
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: width * .4,
                        height: 2,
                        color: Color(AppColors.azulescuro),
                      ),
                      const Text('ou', style: TextStyle(fontSize: 20)),
                      Container(
                        width: width * .4,
                        height: 2,
                        color: Color(AppColors.azulescuro),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Login com Google / Microsoft (imagens)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset('assets/imgs/Google.png'),
                      const SizedBox(width: 15),
                      Image.asset('assets/imgs/Microsoft.png'),
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

  // Botão de troca Pessoa Física/Jurídica (visual do Cadastro)
  Widget _tipoContaButton(String text, String tipo) {
    bool selected = (pessoaTipo == tipo);
    return Expanded(
      child: ElevatedButton(
        onPressed: () {
          setState(() {
            pessoaTipo = tipo;
            // Limpa os campos CPF/CNPJ ao trocar
            cpfController.clear();
            cnpjController.clear();
          });
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: selected ? Color(AppColors.roxo) : Colors.white,
          side: BorderSide(
            color: selected ? Colors.transparent : Color(AppColors.azulescuro),
            width: 2,
          ),
          foregroundColor: selected
              ? Colors.white
              : Color(AppColors.azulescuro),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: Text(text),
      ),
    );
  }
}
