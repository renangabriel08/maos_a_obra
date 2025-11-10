import 'package:maos_a_obra/models/address_model.dart';
import 'package:maos_a_obra/models/image_model.dart';
import 'package:maos_a_obra/models/status_model.dart';
import 'package:maos_a_obra/models/user_model.dart';

class Budget {
  final int id;
  final String? descricao;
  final bool? visita;
  final DateTime? data;
  final String? observacoes;
  final double? valor;
  final String? justificativa;
  final User cliente;
  final User prestador;
  final Address address;
  final List<ImageModel> imagens;
  final Status status;

  Budget({
    required this.id,
    this.descricao,
    this.visita,
    this.data,
    this.observacoes,
    this.valor,
    this.justificativa,
    required this.cliente,
    required this.prestador,
    required this.address,
    this.imagens = const [],
    required this.status,
  });

  factory Budget.fromJson(Map<String, dynamic> json) {
    return Budget(
      id: json['id'],
      descricao: json['descricao'],
      visita: json['visita'].toString() == "1",
      data: json['data'] != null ? DateTime.parse(json['data']) : null,
      observacoes: json['observacoes'],
      valor: json['valor'] != null
          ? double.parse(json['valor'].toString())
          : null,
      justificativa: json['justificativa'],
      cliente: User.fromJson(json['cliente']),
      prestador: User.fromJson(json['prestador']),
      address: Address.fromJson(json['endereco']),
      imagens: json['imagens'] != null
          ? (json['imagens'] as List)
                .map((i) => ImageModel.fromJson(i))
                .toList()
          : [],
      status: Status.fromJson(json['status']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'descricao': descricao,
      'visita': visita,
      'data': data?.toIso8601String(),
      'observacoes': observacoes,
      'valor': valor,
      'justificativa': justificativa,
      'cliente': cliente.toJson(),
      'prestador': prestador.toJson(),
      'endereco': address.toJson(),
      'imagens': imagens.map((i) => i.toJson()).toList(),
      'status': status.toJson(),
    };
  }
}
