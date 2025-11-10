import 'package:flutter/material.dart';
import 'package:maos_a_obra/controllers/data_controller.dart';
import 'package:maos_a_obra/main.dart';
import 'package:maos_a_obra/styles/style.dart';

class MenuScreen extends StatelessWidget {
  const MenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = DataController.user;

    return Container(
      color: Colors.grey[50],
      child: SafeArea(
        child: Column(
          children: [
            // Header do perfil
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
              child: Column(
                children: [
                  Row(
                    children: [
                      // Avatar com borda
                      Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 3),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: CircleAvatar(
                          radius: 32,
                          backgroundColor: Colors.white,
                          backgroundImage: user?.imagePath != null
                              ? NetworkImage('$imgUrl/${user!.imagePath!}')
                              : null,
                          child: user?.imagePath == null
                              ? Icon(
                                  Icons.person,
                                  size: 36,
                                  color: Color(AppColors.cinza),
                                )
                              : null,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              user?.name ?? 'Usuário',
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Color(AppColors.cinza),
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 4),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.blue[50],
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                user?.role ?? 'Usuário',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.blue[600],
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Opções do menu
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(vertical: 8),
                children: [
                  // Seção Principal
                  _buildSectionHeader('Principal'),
                  _buildMenuItem(
                    context: context,
                    icon: Icons.favorite_outline,
                    title: 'Favoritos',
                    onTap: () {},
                  ),
                  _buildMenuItem(
                    context: context,
                    icon: Icons.person_outline,
                    title: 'Minha conta',
                    onTap: () {
                      if (user!.role == 'prestador') {
                        DataController.selectedUser = user;
                        Navigator.pushNamed(context, '/selectedUserProfile');
                      }
                    },
                  ),
                  _buildMenuItem(
                    context: context,
                    icon: Icons.assignment_outlined,
                    title: 'Ordens de serviço',
                    onTap: () {},
                  ),

                  const SizedBox(height: 8),
                  const Divider(height: 1),
                  const SizedBox(height: 8),

                  // Seção Configurações
                  _buildSectionHeader('Configurações'),
                  _buildMenuItem(
                    context: context,
                    icon: Icons.location_on_outlined,
                    title: 'Endereços',
                    onTap: () {
                      Navigator.pushNamed(context, '/addresses');
                    },
                  ),
                  _buildMenuItem(
                    context: context,
                    icon: Icons.payment_outlined,
                    title: 'Gerenciar pagamentos',
                    onTap: () {},
                  ),

                  const SizedBox(height: 8),
                  const Divider(height: 1),
                  const SizedBox(height: 8),

                  // Seção Suporte
                  _buildSectionHeader('Suporte'),
                  _buildMenuItem(
                    context: context,
                    icon: Icons.help_outline,
                    title: 'Ajuda',
                    onTap: () {},
                  ),
                  _buildMenuItem(
                    context: context,
                    icon: Icons.logout,
                    title: 'Sair',
                    onTap: () {
                      _showLogoutDialog(context);
                    },
                    isDestructive: true,
                  ),
                ],
              ),
            ),

            // Versão do app (opcional)
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                'Versão 1.0.0',
                style: TextStyle(fontSize: 12, color: Colors.grey[500]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 8),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: Colors.grey[600],
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _buildMenuItem({
    required BuildContext context,
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    bool isDestructive = false,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.white,
      ),
      child: ListTile(
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: isDestructive ? Colors.red[50] : Colors.blue[50],
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(
            icon,
            size: 20,
            color: isDestructive ? Colors.red[600] : Colors.blue[600],
          ),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w500,
            color: isDestructive ? Colors.red[600] : Colors.grey[900],
          ),
        ),
        trailing: Icon(
          Icons.arrow_forward_ios,
          size: 14,
          color: Colors.grey[400],
        ),
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          'Sair da conta',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: const Text('Tem certeza que deseja sair da sua conta?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancelar',
              style: TextStyle(
                color: Colors.grey[600],
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red[600],
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushNamedAndRemoveUntil(
                context,
                '/login',
                (route) => false,
              );
            },
            child: const Text(
              'Sair',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}
