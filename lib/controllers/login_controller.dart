import 'package:flutter/cupertino.dart';
import 'package:maos_a_obra/controllers/data_controller.dart';
import 'package:maos_a_obra/main.dart';
import 'package:maos_a_obra/services/auth_service.dart';
import 'package:maos_a_obra/widgets/toast.dart';

class LoginController {
  AuthService authService;
  MyToast myToast = MyToast();

  LoginController({AuthService? authService})
    : authService = authService ?? AuthService(baseUrl: baseUrl);

  Future<void> login(
    String email,
    String password,
    GlobalKey<FormState> formKey,
    BuildContext context,
  ) async {
    if (formKey.currentState!.validate()) {
      DataController.user = await authService.login(email, password);

      if (DataController.user != null) {
        DataController.user?.addresses =
            await authService.getAddressByUserId() ?? [];

        if (DataController.user!.role == "cliente" &&
            DataController.user!.isActive) {
          if (DataController.user!.addresses.isEmpty) {
            Navigator.pushNamed(context, '/address');
          } else {
            DataController.pagina.value = 0;
            Navigator.pushNamedAndRemoveUntil(
              context,
              '/home',
              (route) => false,
            );
          }
        }

        if (DataController.user!.role == "prestador") {
          if (DataController.user!.addresses.isEmpty) {
            Navigator.pushNamed(context, '/address');
          } else if (DataController.user!.experiencia == null) {
            Navigator.pushNamed(context, '/experiences');
          } else if (DataController.user!.specialties.isEmpty) {
            Navigator.pushNamed(context, '/specialties');
          } else {
            if (DataController.user!.isActive) {
              DataController.pagina.value = 0;
              Navigator.pushNamed(context, '/home');
            } else {
              myToast.getToast("Seu cadastro está em análise");
            }
          }
        }
      } else {
        myToast.getToast("Email ou senha incorretos");
      }
    } else {
      myToast.getToast("Preencha todos os campos corretamente");
    }
  }
}
