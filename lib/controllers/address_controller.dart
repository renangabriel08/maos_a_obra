import 'package:flutter/cupertino.dart';
import 'package:maos_a_obra/controllers/data_controller.dart';
import 'package:maos_a_obra/main.dart';
import 'package:maos_a_obra/models/address_model.dart';
import 'package:maos_a_obra/routes/app_routes.dart';
import 'package:maos_a_obra/services/auth_service.dart';
import 'package:maos_a_obra/widgets/toast.dart';

class AddressController {
  AuthService authService;
  MyToast myToast = MyToast();

  AddressController({AuthService? authService})
    : authService = authService ?? AuthService(baseUrl: baseUrl);

  Future<void> registerAddress(
    Map<String, dynamic> addressData,
    BuildContext context,
    GlobalKey<FormState> formKey,
  ) async {
    if (formKey.currentState!.validate()) {
      Address? address = await authService.registerAddress(addressData);

      if (address != null) {
        DataController.user!.addresses.add(address);

        if (DataController.user!.role == "prestador") {
          Navigator.pushNamed(context, '/experiences');
        } else {
          if (AppRoutes.ultimaRota == "/createBudget") {
            DataController.selectedAddress = address;
            Navigator.pop(context);
          } else if (AppRoutes.ultimaRota == "/addresses") {
            Navigator.pop(context);
          } else {
            Navigator.pushNamed(context, '/login');
          }
        }

        myToast.getToast("Endereço cadastrado com sucesso");
      } else {
        myToast.getToast("Erro ao cadastrar endereço");
      }
    } else {
      myToast.getToast("Preencha todos os campos corretamente");
    }
  }
}
