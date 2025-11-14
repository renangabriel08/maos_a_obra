import 'package:flutter/material.dart';
import 'package:maos_a_obra/controllers/budget_controller.dart';
import 'package:maos_a_obra/controllers/data_controller.dart';
import 'package:maos_a_obra/controllers/evaluation_controller.dart';
import 'package:maos_a_obra/widgets/toast.dart';

class AssessmentScreen extends StatefulWidget {
  const AssessmentScreen({super.key});

  @override
  State<AssessmentScreen> createState() => _AssessmentScreenState();
}

class _AssessmentScreenState extends State<AssessmentScreen> {
  int rating = 0;
  final TextEditingController feedbackController = TextEditingController();
  final BudgetController budgetController = BudgetController();
  final EvaluationController evaluationController = EvaluationController();
  MyToast myToast = MyToast();

  void _setRating(int value) {
    setState(() {
      rating = value;
    });
  }

  Future<void> _submitFeedback() async {
    await budgetController.updateBudgetStatus(
      DataController.selectedBudget!.id,
      11,
      context,
    );

    await evaluationController.submitEvaluation(
      DataController.selectedBudget!.id,
      rating,
      feedbackController.text,
      context,
    );

    Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text("Avaliar ${DataController.selectedBudget!.prestador.name}"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            const SizedBox(height: 12),
            const Text(
              "O que você achou do serviço realizado pelo prestador?",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),

            // estrelas
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: List.generate(5, (index) {
                return IconButton(
                  icon: Icon(
                    index < rating ? Icons.star : Icons.star_border,
                    color: Colors.amber,
                    size: 32,
                  ),
                  onPressed: () => _setRating(index + 1),
                );
              }),
            ),

            const SizedBox(height: 20),
            // const Text(
            //   "Compartilhe fotos do serviço concluído",
            //   style: TextStyle(fontWeight: FontWeight.bold),
            // ),
            // const SizedBox(height: 8),

            // // botão de upload
            // OutlinedButton.icon(
            //   onPressed: () {
            //     // aqui depois pode chamar o ImagePicker
            //   },
            //   icon: const Icon(Icons.upload, color: Colors.indigo),
            //   label: const Text("Carregar arquivos de mídia"),
            //   style: OutlinedButton.styleFrom(
            //     minimumSize: const Size(double.infinity, 50),
            //     side: const BorderSide(color: Colors.indigo),
            //     foregroundColor: Colors.indigo,
            //   ),
            // ),

            // const SizedBox(height: 20),
            const Text(
              "Conte-nos sobre serviço",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),

            // textarea
            TextField(
              controller: feedbackController,
              maxLines: 4,
              decoration: InputDecoration(
                hintText:
                    "O que você achou do serviço finalizado pelo prestador?",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),

            const SizedBox(height: 24),

            // botão enviar
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _submitFeedback,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.indigo,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text("Enviar", style: TextStyle(fontSize: 16)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
