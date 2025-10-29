import 'package:flutter/material.dart';
import 'package:maos_a_obra/controllers/data_controller.dart';
import 'package:maos_a_obra/models/user_model.dart';
import 'package:maos_a_obra/services/search_service.dart';
import 'package:maos_a_obra/widgets/toast.dart';
import 'package:maos_a_obra/main.dart';

class SearchController {
  final SearchService searchService;
  final MyToast myToast = MyToast();

  SearchController({SearchService? searchService})
      : searchService = searchService ?? SearchService(baseUrl: baseUrl);

  Future<void> buscarPrestadores({
    String? city,
    String? especialidade,
    required BuildContext context,
  }) async {
    try {
      final List<User>? prestadores =
          await searchService.buscarPrestadores(city: city, especialidade: especialidade);

      if (prestadores != null && prestadores.isNotEmpty) {
        DataController.resultadosBusca = prestadores;
      } else {
        DataController.resultadosBusca = [];
        myToast.getToast("Nenhum prestador encontrado");
      }
    } catch (e) {
      debugPrint("Erro ao buscar prestadores: $e");
      myToast.getToast("Erro ao buscar prestadores");
    }
  }
}
