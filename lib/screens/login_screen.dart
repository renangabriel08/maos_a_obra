import 'package:flutter/material.dart';
import 'package:maos_a_obra/controllers/login_controller.dart';
import 'package:maos_a_obra/styles/style.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final LoginController loginController = LoginController();
  final TextEditingController email = TextEditingController();
  final TextEditingController senha = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  bool _obscurePassword = true;
  bool _isLoading = false;

  Future<void> logar() async {
    setState(() => _isLoading = true);
    await loginController.login(email.text, senha.text, formKey, context);
    if (mounted) setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(backgroundColor: Colors.white, elevation: 0),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: formKey,
              child: Column(
                children: [
                  // Logo
                  Image.asset('assets/imgs/Logo.png'),
                  const SizedBox(height: 24),

                  // Título
                  Text(
                    'Entrar',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Color(AppColors.cinza),
                    ),
                  ),
                  const SizedBox(height: 40),

                  // Campo de e-mail
                  TextFormField(
                    controller: email,
                    keyboardType: TextInputType.emailAddress,
                    decoration: AppDecorations.inputDecoration(
                      'E-mail',
                    ).copyWith(prefixIcon: const Icon(Icons.email_outlined)),
                  ),
                  const SizedBox(height: 12),

                  // Campo de senha
                  TextFormField(
                    controller: senha,
                    obscureText: _obscurePassword,
                    decoration: AppDecorations.inputDecoration('Senha')
                        .copyWith(
                          prefixIcon: const Icon(Icons.lock_outline),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscurePassword
                                  ? Icons.visibility_off_outlined
                                  : Icons.visibility_outlined,
                              color: Colors.grey[600],
                            ),
                            onPressed: () {
                              setState(
                                () => _obscurePassword = !_obscurePassword,
                              );
                            },
                          ),
                        ),
                  ),

                  const SizedBox(height: 5),

                  // Esqueceu a senha
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/forgoPassword');
                      },
                      child: Text(
                        'Esqueceu a senha?',
                        style: TextStyle(
                          color: Color(AppColors.cinza),
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 5),

                  // Botão de login
                  SizedBox(
                    width: width,
                    height: 60,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(AppColors.roxo),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: _isLoading
                          ? null
                          : () async {
                              await logar();
                            },
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
                              'Entrar',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                              ),
                            ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Botão de cadastro
                  TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/register');
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Não tem uma conta?',
                          style: TextStyle(
                            color: Color(AppColors.cinza),
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          ' Cadastrar',
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

                  // Divisor
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

                  // Login com outras plataformas
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
}
