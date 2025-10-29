import 'package:flutter/material.dart';
import 'package:maos_a_obra/controllers/data_controller.dart';
import 'package:maos_a_obra/main.dart';

class MenuScreen extends StatelessWidget {
  const MenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = DataController.user;

    return Padding(
      padding: const EdgeInsets.all(8),
      child: Column(
        children: [
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundImage: user?.imagePath != null
                      ? NetworkImage('$imgUrl/${user!.imagePath!}')
                      : null,
                  child: user?.imagePath == null
                      ? const Icon(Icons.person, size: 40)
                      : null,
                ),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      user?.name ?? 'Usuário',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Meu perfil',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          Expanded(
            child: ListView(
              children: [
                _buildOption(context, 'Favoritos', () {}),
                _buildOption(context, 'Minha conta', () {
                  if (user!.role == 'prestador') {
                    DataController.selectedUser = user;
                    Navigator.pushNamed(context, '/selectedUserProfile');
                  }
                }),
                _buildOption(context, 'Ordens de serviço', () {}),
                _buildOption(context, 'Endereços', () {
                  Navigator.pushNamed(context, '/addresses');
                }),
                _buildOption(context, 'Gerenciar pagamentos', () {}),
                _buildOption(context, 'Ajuda', () {}),
                _buildOption(context, 'Sair', () {
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    '/login',
                    (route) => false,
                  );
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOption(BuildContext context, String title, VoidCallback onTap) {
    return ListTile(
      title: Text(title),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16),
    );
  }
}
