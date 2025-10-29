import 'package:flutter/material.dart';
import 'package:maos_a_obra/screens/assessment_screen.dart';
import 'package:maos_a_obra/screens/edit_profile_screen.dart';
import 'package:maos_a_obra/screens/portfolio_screen.dart';
import 'package:maos_a_obra/screens/register_address_screen.dart';
import 'package:maos_a_obra/screens/budget_details_screen.dart';
import 'package:maos_a_obra/screens/create_budget_screen.dart';
import 'package:maos_a_obra/screens/experiences_screen.dart';
import 'package:maos_a_obra/screens/home_screen.dart';
import 'package:maos_a_obra/screens/selected_user_profile.dart';
import 'package:maos_a_obra/screens/specialties_screen.dart';
import 'package:maos_a_obra/screens/login_screen.dart';
import 'package:maos_a_obra/screens/register_screen.dart';
import 'package:maos_a_obra/screens/user_address_list_screen.dart';

class AppRoutes {
  static String initialRoute = "/login";
  static String ultimaRota = '';

  static Map<String, WidgetBuilder> namedRoutes() {
    return {
      "/home": (_) => HomeScreen(),
      "/login": (_) => LoginScreen(),
      "/register": (_) => RegisterScreen(),
      "/experiences": (_) => ExperiencesScreen(),
      "/specialties": (_) => SpecialtiesScreen(),
      "/address": (_) => RegisterAddressScreen(),
      "/createBudget": (_) => CreateBudgetScreen(),
      "/selectedUserProfile": (_) => SelectedUserProfile(),
      "/budgetDetails": (_) => BudgetDetailsScreen(),
      "/addresses": (_) => UserAddressListScreen(),
      "/assessment": (_) => AssessmentScreen(),
      "/editProfile": (_) => EditProfileScreen(),
      "/portfolio": (_) => PortfolioScreen(),
    };
  }
}
