import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:maos_a_obra/screens/budget_screen.dart';
import 'package:maos_a_obra/screens/create_post_screen.dart';
import 'package:maos_a_obra/screens/feed_screen.dart';
import 'package:maos_a_obra/screens/menu_screen.dart';
import 'package:maos_a_obra/screens/notifications_screen.dart';
import 'package:maos_a_obra/screens/search_delegate_screen.dart';
import 'package:maos_a_obra/styles/style.dart';
import 'package:maos_a_obra/controllers/data_controller.dart';
import 'package:maos_a_obra/controllers/notifications_controller.dart';
import 'package:maos_a_obra/main.dart';
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
      await requestPermission();
      notificationController.startListeningNotifications(context);

      final especialidades = await _dataService.getSpecialtyList();
      await _dataService.getStatusList();

      setState(() {
        DataController.especialidades = especialidades ?? [];
        _loading = false;
      });
    } catch (e) {
      debugPrint("Erro ao carregar dados iniciais: $e");
      setState(() {
        _loading = false;
      });
    }
  }

  void _abrirBusca() {
    showSearch(context: context, delegate: SearchDelegateScreen());
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
        backgroundColor: const Color(0xFFF5F5F7),
        appBar: DataController.pagina.value == 0
            ? AppBar(
                automaticallyImplyLeading: false,
                backgroundColor: const Color(0xFFF5F5F7),
                elevation: 0,
                title: GestureDetector(
                  onTap: _abrirBusca,
                  child: Container(
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: const AbsorbPointer(
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: "Buscar",
                          prefixIcon: Icon(Icons.search, color: Colors.grey),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(vertical: 10),
                        ),
                      ),
                    ),
                  ),
                ),
              )
            : null,
        body: IndexedStack(
          index: DataController.pagina.value,
          children: [
            const FeedScreen(),
            const NotificationsScreen(),
            if (DataController.user!.role == 'prestador')
              const CreatePostScreen(),
            const BudgetScreen(),
            const MenuScreen(),
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: DataController.pagina.value,
          onTap: _onItemTapped,
          unselectedItemColor: const Color(AppColors.azulescuro),
          selectedItemColor: const Color(AppColors.roxo),
          type: BottomNavigationBarType.fixed,
          items: [
            const BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: "Início",
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
