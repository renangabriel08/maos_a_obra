import 'package:maos_a_obra/models/address_model.dart';
import 'package:maos_a_obra/models/budget_model.dart';
import 'package:maos_a_obra/models/post_model.dart';
import 'package:maos_a_obra/models/specialty_model.dart';

class User {
  final int id;
  final String? token;
  final String name;
  final String email;
  final String? phone;
  final String? cpf;
  final DateTime? birthDate;
  String? imagePath;
  final String? cnpj;
  String? experiencia;
  final String role;
  List<Address> addresses;
  List<Specialty> specialties;
  List<Budget> budgets;
  List<Post> posts;
  bool isActive;

  User({
    required this.id,
    required this.token,
    required this.name,
    required this.email,
    this.phone,
    this.cpf,
    this.birthDate,
    this.imagePath,
    this.cnpj,
    this.experiencia,
    required this.role,
    this.addresses = const [],
    this.specialties = const [],
    this.budgets = const [],
    this.posts = const [],
    required this.isActive,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      token: json['token'],
      name: json['name'],
      email: json['email'],
      phone: json['phone'],
      cpf: json['cpf'],
      birthDate: json['birthDate'] != null
          ? DateTime.parse(json['birthDate'])
          : null,
      imagePath: json['imagePath'],
      cnpj: json['cnpj'],
      experiencia: json['experiencia'],
      role: json['role'],
      addresses:
          (json['addresses'] as List<dynamic>?)
              ?.map((e) => Address.fromJson(e))
              .toList() ??
          [],
      specialties:
          (json['specialties'] as List<dynamic>?)
              ?.map((e) => Specialty.fromJson(e))
              .toList() ??
          [],
      budgets:
          (json['budgets'] as List<dynamic>?)
              ?.map((e) => Budget.fromJson(e))
              .toList() ??
          [],
      posts:
          (json['posts'] as List<dynamic>?)
              ?.map((e) => Post.fromJson(e))
              .toList() ??
          [],
      isActive: json['isActive'] == 1,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'token': token,
      'name': name,
      'email': email,
      'phone': phone,
      'cpf': cpf,
      'birthDate': birthDate?.toIso8601String(),
      'imagePath': imagePath,
      'cnpj': cnpj,
      'experiencia': experiencia,
      'role': role,
      'addresses': addresses.map((e) => e.toJson()).toList(),
      'specialties': specialties.map((e) => e.toJson()).toList(),
      'budgets': budgets.map((e) => e.toJson()).toList(),
      'posts': posts.map((e) => e.toJson()).toList(),
      'isActive': isActive,
    };
  }
}
