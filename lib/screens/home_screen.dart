import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:maos_a_obra/controllers/data_controller.dart';
import 'package:maos_a_obra/controllers/notifications_controller.dart';
import 'package:maos_a_obra/main.dart';
import 'package:maos_a_obra/screens/budget_screen.dart';
import 'package:maos_a_obra/screens/create_post_screen.dart';
import 'package:maos_a_obra/screens/feed_screen.dart';
import 'package:maos_a_obra/screens/menu_screen.dart';
import 'package:maos_a_obra/screens/notifications_screen.dart';
import 'package:maos_a_obra/services/data_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final notificationController = NotificationController();
  final DataService _dataService = DataService(baseUrl: baseUrl);
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadInitialData();
  }

  Future<void> requestPermission() async {
    bool isAllowed = await AwesomeNotifications().isNotificationAllowed();
    if (!isAllowed) {
      await AwesomeNotifications().requestPermissionToSendNotifications();
    }
  }

  Future<void> _loadInitialData() async {
    try {
      final especialidades = await _dataService.getSpecialtyList();
      await _dataService.getStatusList();

      await requestPermission();

      notificationController.startListeningNotifications(context);

      setState(() {
        DataController.especialidades = especialidades ?? [];
        _loading = false;
      });
    } catch (e) {
      debugPrint("Erro ao carregar dados iniciais: $e");
      setState(() {
        _loading = false; // mesmo com erro, remove loading pra não travar
      });
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      DataController.pagina.value = index;
    });
  }

  @override
  void dispose() {
    notificationController.stopListeningNotifications();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return ValueListenableBuilder(
      valueListenable: DataController.pagina,
      builder: (context, value, child) => Scaffold(
        body: Padding(
          padding: const EdgeInsets.only(top: 40),
          child: [
            const FeedScreen(),
            const NotificationsScreen(),
            if (DataController.user!.role == 'prestador')
              const CreatePostScreen(),
            const BudgetScreen(),
            const MenuScreen(),
          ][DataController.pagina.value],
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: DataController.pagina.value,
          onTap: _onItemTapped,
          unselectedItemColor: Colors.grey,
          selectedItemColor: Colors.black,
          items: [
            const BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: "Home",
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.notifications),
              label: "Notificações",
            ),
            if (DataController.user!.role == 'prestador')
              const BottomNavigationBarItem(
                icon: Icon(Icons.add),
                label: "Postar",
              ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.build),
              label: "Orçamentos",
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.menu),
              label: "Menu",
            ),
          ],
        ),
      ),
    );
  }
}
