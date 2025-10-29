import 'package:flutter/material.dart';
import 'package:maos_a_obra/controllers/data_controller.dart';
import 'package:maos_a_obra/main.dart';
import 'package:maos_a_obra/models/post_model.dart';
import 'package:maos_a_obra/models/user_model.dart';
import 'package:maos_a_obra/controllers/post_controller.dart';
import 'package:share_plus/share_plus.dart';

class SelectedUserProfile extends StatefulWidget {
  const SelectedUserProfile({super.key});

  @override
  State<SelectedUserProfile> createState() => _SelectedUserProfileState();
}

class _SelectedUserProfileState extends State<SelectedUserProfile> {
  final PostController postController = PostController();
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserPosts();
  }

  Future<void> _loadUserPosts() async {
    await postController.getPostsByUser(
      DataController.selectedUser!.id,
      context,
    );
    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    User user = DataController.selectedUser!;
    User loggedUser = DataController.user!;

    return Scaffold(
      body: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            title: const Text("Perfil do Usuário"),
            actions: [
              IconButton(
                icon: const Icon(Icons.share),
                onPressed: () => SharePlus.instance.share(
                  ShareParams(text: 'check out my website https://example.com'),
                ),
              ),
            ],
          ),
          body: Column(
            children: [
              const SizedBox(height: 16),
              Center(
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 40,
                      backgroundImage: user.imagePath != null
                          ? NetworkImage('$imgUrl/${user.imagePath!}')
                          : null,
                      child: user.imagePath == null
                          ? const Icon(Icons.person, size: 24)
                          : null,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      user.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
              const TabBar(
                tabs: [
                  Tab(text: "Perfil"),
                  Tab(text: "Avaliações"),
                ],
              ),
              Expanded(
                child: TabBarView(
                  children: [
                    // ===== PERFIL =====
                    isLoading
                        ? const Center(child: CircularProgressIndicator())
                        : SingleChildScrollView(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Column(
                                      children: const [
                                        Text(
                                          "4,5",
                                          style: TextStyle(
                                            fontSize: 24,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text("Avaliações"),
                                      ],
                                    ),
                                    Column(
                                      children: const [
                                        Text("122"),
                                        Text("Orçamentos"),
                                      ],
                                    ),
                                    Column(
                                      children: const [
                                        Text("145"),
                                        Text("Serviços finalizados"),
                                      ],
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 16),
                                const Text(
                                  "Sobre",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(user.experiencia.toString()),
                                const SizedBox(height: 16),
                                const Text(
                                  "Publicações",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Column(
                                  children: user.posts.isEmpty
                                      ? [
                                          const Text(
                                            "Esse usuário ainda não possui publicações.",
                                          ),
                                        ]
                                      : user.posts.map((Post post) {
                                          return SizedBox(
                                            width: double.infinity,
                                            child: Card(
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                              ),
                                              child: Padding(
                                                padding: const EdgeInsets.all(
                                                  12,
                                                ),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      user.name,
                                                      style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                    const SizedBox(height: 4),
                                                    Text(post.descricao ?? ""),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          );
                                        }).toList(),
                                ),
                              ],
                            ),
                          ),
                    // ===== AVALIAÇÕES =====
                    ListView(
                      padding: const EdgeInsets.all(16),
                      children: [
                        _buildReview(
                          name: "Renan Jacinto Leite",
                          rating: 2,
                          date: "9 meses atrás",
                          comment:
                              "Odiei o serviço dele, não recomendo! Pintou tudo mal feito, manchou o chão e ainda não quis corrigir o erro.",
                          avatarUrl: 'https://i.pravatar.cc/150?img=6',
                        ),
                        _buildReview(
                          name: "Fabiola Pereira",
                          rating: 5,
                          date: "2 dias atrás",
                          comment:
                              "Amei o trabalho, recomendo demais... Podem confiar totalmente no trabalho dele. 😊",
                          avatarUrl: 'https://i.pravatar.cc/150?img=7',
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: user.id != loggedUser.id
          ? FloatingActionButton.extended(
              onPressed: () {
                Navigator.pushNamed(context, '/createBudget');
              },
              label: const Text("Contratar"),
              icon: const Icon(Icons.shopping_cart),
            )
          : null, // <-- se for o mesmo usuário, não mostra
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget _buildReview({
    required String name,
    required int rating,
    required String date,
    required String comment,
    required String avatarUrl,
  }) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundImage: NetworkImage(avatarUrl),
                  radius: 16,
                ),
                const SizedBox(width: 8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      date,
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),
                const Spacer(),
                Row(
                  children: List.generate(
                    5,
                    (index) => Icon(
                      index < rating ? Icons.star : Icons.star_border,
                      size: 16,
                      color: Colors.amber,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(comment),
          ],
        ),
      ),
    );
  }
}
