import 'package:maos_a_obra/models/user_type_model.dart';

class RegisterValidator {
  static String? validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "Campo obrigatório";
    }

    if (value.length < 3) {
      return "Nome muito curto";
    }

    return null;
  }

  static String? validateEmail(String? value) {
    final regex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');

    if (value == null || value.trim().isEmpty) {
      return "Campo obrigatório";
    }

    if (!regex.hasMatch(value)) {
      return "E-mail inválido";
    }

    return null;
  }

  static String? validatePhone(String? value) {
    final regex = RegExp(r'^\d{10,11}$');

    if (value == null || value.trim().isEmpty) {
      return "Campo obrigatório";
    }

    if (!regex.hasMatch(value)) {
      return "Telefone inválido";
    }

    return null;
  }

  String? validatePassword(String value) {
    if (value.isEmpty) {
      return "Campo obrigatório";
    }

    if (value.length < 6) {
      return "A senha deve ter pelo menos 6 caracteres";
    }

    if (!RegExp(r'[A-Z]').hasMatch(value)) {
      return "A senha deve conter pelo menos uma letra maiúscula";
    }

    if (!RegExp(r'[a-z]').hasMatch(value)) {
      return "A senha deve conter pelo menos uma letra minúscula";
    }

    return null;
  }

  static String? validateConfirmPassword(String? value, String? password) {
    if (value == null || value.isEmpty) {
      return "Campo obrigatório";
    }

    if (value != password) {
      return "As senhas não coincidem";
    }

    return null;
  }

  static String? validateBirthDate(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "Campo obrigatório";
    }

    return null;
  }

  static String? validateCpf(String? value) {
    final regex = RegExp(r'^\d{11}$');

    if (value == null || value.trim().isEmpty) {
      return "Campo obrigatório";
    }

    if (!regex.hasMatch(value)) {
      return "CPF deve ter 11 dígitos";
    }

    return null;
  }

  static String? validateCnpj(String? value) {
    final regex = RegExp(r'^\d{14}$');

    if (value == null || value.trim().isEmpty) {
      return "Campo obrigatório";
    }

    if (!regex.hasMatch(value)) {
      return "CNPJ deve ter 14 dígitos";
    }

    return null;
  }

  static String? validateUserType(UserType? value) {
    if (value == null) {
      return "Selecione um tipo de usuário";
    }

    return null;
  }

  static String? validatePessoaTipo(String? value) {
    if (value == null || value.isEmpty) {
      return "Selecione o tipo de pessoa";
    }

    if (value != "Física" && value != "Jurídica") {
      return "Tipo de pessoa inválido";
    }

    return null;
  }
}

class LoginValidator {
  static String? validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "Campo obrigatório";
    }

    return null;
  }

  static String? validatePassword(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "Campo obrigatório";
    }

    return null;
  }
}
