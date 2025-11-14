import 'package:flutter/foundation.dart';
import 'package:maos_a_obra/models/address_model.dart';
import 'package:maos_a_obra/models/budget_model.dart';
import 'package:maos_a_obra/models/notification_model.dart';
import 'package:maos_a_obra/models/post_model.dart';
import 'package:maos_a_obra/models/specialty_model.dart';
import 'package:maos_a_obra/models/status_model.dart';
import 'package:maos_a_obra/models/user_model.dart';
import 'package:maos_a_obra/models/user_type_model.dart';

class DataController {
  static User? user;
  static User? selectedUser;
  static Address? selectedAddress;
  static Budget? selectedBudget;
  static List<NotificationModel> notifications = [];
  static List<Post> feed = [];
  static List<Budget> orcamentos = [];
  static List<Specialty> especialidades = [];
  static List<UserType> tiposUsuario = [];
  static List<Status> status = [];
  static List<User> resultadosBusca = [];
  static bool podeVoltar = false;

  static ValueNotifier pagina = ValueNotifier(0);
}
