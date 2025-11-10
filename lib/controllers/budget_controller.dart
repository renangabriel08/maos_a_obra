import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:maos_a_obra/controllers/data_controller.dart';
import 'package:maos_a_obra/main.dart';
import 'package:maos_a_obra/services/budget_service.dart';
import 'package:maos_a_obra/services/notification_service.dart';
import 'package:maos_a_obra/widgets/toast.dart';
import 'package:maos_a_obra/models/budget_model.dart';

class BudgetController {
  BudgetService budgetService;
  int? lastCreatedBudgetId;
  MyToast myToast = MyToast();
  NotificationService notificationService = NotificationService(
    baseUrl: baseUrl,
  );

  BudgetController({BudgetService? budgetService})
    : budgetService = budgetService ?? BudgetService(baseUrl: baseUrl);

  Future<void> createBudget(
    Map<String, dynamic> budgetData,
    Map<String, dynamic> notificationData,
    BuildContext context,
    GlobalKey<FormState> formKey,
    List<File> images,
  ) async {
    if (formKey.currentState!.validate()) {
      Budget? budget = await budgetService.createBudget(budgetData, images);

      if (budget != null) {
        lastCreatedBudgetId = budget.id;
        notificationData["orcamento_id"] = budget.id;

        await notificationService.addNotification(notificationData);
        myToast.getToast("Orçamento criado com sucesso");
        Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
      } else {
        myToast.getToast("Erro ao criar orçamento");
      }
    } else {
      myToast.getToast("Preencha todos os campos corretamente");
    }
  }

  Future<void> getBudgets(BuildContext context) async {
    try {
      List<Budget> budgets = await budgetService.fetchBudgets() ?? [];
      if (budgets.isNotEmpty) {
        DataController.orcamentos = budgets;
      } else {
        myToast.getToast("Nenhum orçamento encontrado");
      }
    } catch (e) {
      debugPrint("Erro ao buscar orçamentos: $e");
      myToast.getToast("Erro ao carregar orçamentos");
    }
  }

  Future<void> updateBudgetStatus(
    int budgetId,
    int status,
    BuildContext context,
  ) async {
    try {
      bool success = await budgetService.updateBudgetStatus(budgetId, status);

      if (success) {
        myToast.getToast("Status atualizado com sucesso");
        await getBudgets(context);
      } else {
        myToast.getToast("Erro ao atualizar status");
      }
    } catch (e) {
      debugPrint("Erro ao atualizar status: $e");
      myToast.getToast("Erro inesperado");
    }
  }

  Future<void> updateBudgetDate(
    int budgetId,
    String formattedDate,
    BuildContext context,
  ) async {
    try {
      bool success = await budgetService.updateBudgetDate(
        budgetId,
        formattedDate,
      );

      if (success) {
        myToast.getToast("Data atualizada com sucesso");
        await getBudgets(context);
      } else {
        myToast.getToast("Erro ao atualizar data");
      }
    } catch (e) {
      debugPrint("Erro ao atualizar data: $e");
      myToast.getToast("Erro inesperado");
    }
  }

  Future<void> updateBudgetValue(
    int budgetId,
    double valor,
    String justificativa,
    BuildContext context,
  ) async {
    bool success = await budgetService.updateBudgetValue(
      budgetId,
      valor,
      justificativa,
    );

    if (success) {
      myToast.getToast("Orçamento atualizado com sucesso");
    } else {
      myToast.getToast("Erro ao atualizar orçamento");
    }
  }
}
