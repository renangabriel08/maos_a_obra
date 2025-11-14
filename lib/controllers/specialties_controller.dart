import 'package:flutter/cupertino.dart';
import 'package:maos_a_obra/controllers/data_controller.dart';
import 'package:maos_a_obra/main.dart';
import 'package:maos_a_obra/models/specialty_model.dart';
import 'package:maos_a_obra/services/auth_service.dart';
import 'package:maos_a_obra/widgets/toast.dart';

class SpecialtiesController {
  AuthService authService;
  MyToast myToast = MyToast();

  SpecialtiesController({AuthService? authService})
    : authService = authService ?? AuthService(baseUrl: baseUrl);

  Future<void> registerSpecialties(
    List<Specialty> specialties,
    BuildContext context,
  ) async {
    if (specialties.isNotEmpty) {
      DataController.user!.specialties =
          await authService.registerSpecialties(specialties) ?? [];

      if (DataController.user!.specialties.isNotEmpty) {
        Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
        myToast.getToast("Cadastro finalizado com sucesso");
      } else {
        myToast.getToast("Erro ao finalizar cadastro");
      }
    } else {
      myToast.getToast("Preencha todos os campos corretamente");
    }
  }
}
