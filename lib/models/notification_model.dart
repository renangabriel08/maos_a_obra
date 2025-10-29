import 'package:maos_a_obra/models/budget_model.dart';
import 'package:maos_a_obra/models/user_model.dart';

class NotificationModel {
  final int id;
  final DateTime created_at;
  final String descricao;
  final String titulo;
  final User remetente;
  final User destinatario;
  final Budget orcamento;

  NotificationModel({
    required this.id,
    required this.created_at,
    required this.descricao,
    required this.titulo,
    required this.remetente,
    required this.destinatario,
    required this.orcamento,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id'],
      created_at: DateTime.parse(json['created_at']),
      descricao: json['descricao'],
      titulo: json['titulo'],
      remetente: User.fromJson(json['remetente']),
      destinatario: User.fromJson(json['destinatario']),
      orcamento: Budget.fromJson(json['orcamento']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'created_at': created_at.toIso8601String(),
      'descricao': descricao,
      'titulo': titulo,
      'remetente': remetente.toJson(),
      'destinatario': destinatario.toJson(),
      'orcamento': orcamento.toJson(),
    };
  }
}
