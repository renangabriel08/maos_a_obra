import 'package:flutter/cupertino.dart';
import 'package:maos_a_obra/main.dart';
import 'package:maos_a_obra/services/auth_service.dart';
import 'package:maos_a_obra/widgets/toast.dart';

class ExperiencesController {
  AuthService authService;
  MyToast myToast = MyToast();

  ExperiencesController({AuthService? authService})
    : authService = authService ?? AuthService(baseUrl: baseUrl);

  Future<void> registerExperiences(
    Map<String, dynamic> experiences,
    BuildContext context,
    GlobalKey<FormState> formKey,
  ) async {
    if (formKey.currentState!.validate()) {
      bool success = await authService.registerExperiences(experiences);

      if (success) {
        Navigator.pushNamed(context, '/specialties');
        myToast.getToast("Experiência e foto cadastrados com sucesso");
      } else {
        myToast.getToast("Erro ao cadastrar experiência e foto");
      }
    } else {
      myToast.getToast("Preencha todos os campos corretamente");
    }
  }
}
