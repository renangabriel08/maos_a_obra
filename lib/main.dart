import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:maos_a_obra/routes/app_routes.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  AwesomeNotifications().initialize(null, [
    NotificationChannel(
      channelKey: 'basic_channel',
      channelName: 'Notificações Simples',
      channelDescription: 'Canal para notificações básicas',
      defaultColor: const Color(0xFF9D50DD),
      ledColor: Colors.white,
      importance: NotificationImportance.High,
    ),
  ]);

  runApp(const MyApp());
}

final String baseUrl = "http://10.91.226.81:3000/api";
final String imgUrl = "http://10.91.226.81:3000/storage";

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      routes: AppRoutes.namedRoutes(),
      initialRoute: AppRoutes.initialRoute,
    );
  }
}
