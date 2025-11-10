import 'package:flutter/material.dart';
import 'package:maos_a_obra/controllers/data_controller.dart';
import 'package:maos_a_obra/models/evaluation_model.dart';
import 'package:maos_a_obra/services/evaluation_service.dart';
import 'package:maos_a_obra/widgets/toast.dart';

class EvaluationController {
  final EvaluationService evaluationService = EvaluationService();
  final MyToast myToast = MyToast();

  List<Evaluation> evaluations = [];
  Map<String, dynamic> statistics = {};

  Future<void> submitEvaluation(
    int orcamentoId,
    int nota,
    String feedback,
    BuildContext context,
  ) async {
    bool success = await evaluationService.submitEvaluation(
      orcamentoId,
      nota,
      feedback,
    );

    if (success) {
      myToast.getToast("Avaliação enviada com sucesso");
      Navigator.pop(context);
    } else {
      myToast.getToast("Erro ao enviar avaliação");
    }
  }

  Future<void> getEvaluationsByProvider(
    int providerId,
    BuildContext context,
  ) async {
    var result = await evaluationService.getEvaluationsByProvider(providerId);

    if (result != null) {
      evaluations = result['evaluations'];
      statistics = result['statistics'];

      DataController.selectedUser!.nota = statistics['media'];
      DataController.selectedUser!.orcamentos = statistics['total'];
    } else {
      myToast.getToast("Erro ao carregar avaliações");
    }
  }
}
