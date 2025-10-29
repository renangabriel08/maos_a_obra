import 'package:flutter/cupertino.dart';
import 'package:maos_a_obra/controllers/data_controller.dart';
import 'package:maos_a_obra/main.dart';
import 'package:maos_a_obra/services/auth_service.dart';
import 'package:maos_a_obra/widgets/toast.dart';

class RegisterController {
  AuthService authService;
  MyToast myToast = MyToast();

  RegisterController({AuthService? authService})
    : authService = authService ?? AuthService(baseUrl: baseUrl);

  Future<void> register(
    Map<String, dynamic> userData,
    BuildContext context,
    GlobalKey<FormState> formKey,
  ) async {
    if (formKey.currentState!.validate()) {
      DataController.user = await authService.register(userData);

      if (DataController.user != null) {
        Navigator.pushNamed(context, '/address');
        myToast.getToast("Cadastro realizado com sucesso");
      } else {
        myToast.getToast("Erro ao realizar cadastro");
      }
    } else {
      myToast.getToast("Preencha todos os campos corretamente");
    }
  }
}
