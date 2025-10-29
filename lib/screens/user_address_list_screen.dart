import 'package:flutter/material.dart';
import 'package:maos_a_obra/controllers/data_controller.dart';
import 'package:maos_a_obra/routes/app_routes.dart';
import 'package:maos_a_obra/screens/register_address_screen.dart';

class UserAddressListScreen extends StatefulWidget {
  const UserAddressListScreen({super.key});

  @override
  State<UserAddressListScreen> createState() => _UserAddressListScreenState();
}

class _UserAddressListScreenState extends State<UserAddressListScreen> {
  @override
  Widget build(BuildContext context) {
    final addresses = DataController.user?.addresses ?? [];

    return Scaffold(
      appBar: AppBar(title: Text("Endereços cadastrados")),
      body: ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: addresses.length,
        itemBuilder: (context, index) {
          final endereco = addresses[index];

          return Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListTile(
              leading: const Icon(Icons.location_on, color: Colors.red),
              title: Text(
                endereco.street.toString(),
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                "${endereco.city} - ${endereco.state}, CEP: ${endereco.zipCode}",
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          AppRoutes.ultimaRota = '/addresses';
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const RegisterAddressScreen()),
          );

          setState(() {});
        },
        label: const Text("Cadastrar novo endereço"),
        icon: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
