import 'package:flutter/material.dart';
import 'package:maos_a_obra/screens/login_screen.dart';
import 'package:maos_a_obra/styles/style.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                Image.asset('assets/imgs/Mapa.png'),
                Image.asset('assets/imgs/Logog.png'),
              ],
            ),
            SizedBox(height: 60),
            Text(
              'Mãos a Obra',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Color(AppColors.cinza),
              ),
            ),
            SizedBox(height: 20),
            Text(
              ' A ponte entre clientes e\nprestadores de confiança.',
              style: TextStyle(
                color: Color(AppColors.cinzaClaro3),
                fontSize: 20,
              ),
            ),
            SizedBox(height: 60),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                fixedSize: Size(width * .80, 60),
                backgroundColor: Color(AppColors.roxo),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: () {
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  '/login',
                  (route) => false,
                );
              },
              child: Text(
                'Começar agora',
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
