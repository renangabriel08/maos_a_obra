import 'package:flutter/material.dart';

class AppColors {
  static const cinza = (0xFF172936);
  static const roxo = (0xFF5669FF);
  static const cinzaClaro = (0xFFFBFBFB);
  static const cinzaClaro2 = (0xFFEBEBEB);
  static const cinzaClaro3 = (0xFFA4A4AA);
  static const azulescuro = (0xFF172936);
}

class AppDecorations {
  static InputDecoration inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(color: Color(AppColors.azulescuro)),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Color(AppColors.azulescuro), width: 2),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Color(AppColors.azulescuro), width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Color(AppColors.azulescuro), width: 2),
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Color(AppColors.azulescuro), width: 2),
      ),
      disabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Color(AppColors.azulescuro), width: 2),
      ),
    );
  }
}
