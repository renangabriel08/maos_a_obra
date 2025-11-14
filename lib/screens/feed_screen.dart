import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:maos_a_obra/controllers/data_controller.dart';
import 'package:maos_a_obra/controllers/post_controller.dart';
import 'package:maos_a_obra/main.dart';
import 'package:maos_a_obra/styles/style.dart';

class FeedScreen extends StatefulWidget {
  const FeedScreen({super.key});

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  final List<String> searchHistory = ["Pintura", "Elétrica"];
  final TextEditingController searchController = TextEditingController();
  PostController postController = PostController();
  bool loading = true;

  void openSearcaaaaahModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 16,
            right: 16,
            top: 24,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: searchController,
                decoration: InputDecoration(
                  hintText: "Buscar...",
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () {
                      searchController.clear();
                    },
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onSubmitted: (value) {
                  if (value.isNotEmpty && !searchHistory.contains(value)) {
                    setState(() {
                      searchHistory.add(value);
                    });
                  }
                  Navigator.pop(context);
                },
              ),
              const SizedBox(height: 16),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Histórico",
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: searchHistory
                    .map(
                      (term) => Chip(
                        label: Text(term),
                        onDeleted: () {
                          setState(() {
                            searchHistory.remove(term);
                          });
                        },
                      ),
                    )
                    .toList(),
              ),
              const SizedBox(height: 16),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Especialidades",
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: DataController.especialidades
                    .map(
                      (esp) => ActionChip(
                        label: Text(esp.name),
                        onPressed: () {
                          Navigator.pop(context);
                          setState(() {
                            searchController.text = esp.name;
                          });
                        },
                      ),
                    )
                    .toList(),
              ),
              const SizedBox(height: 24),
            ],
          ),
        );
      },
    );
  }

  String timeAgo(DateTime date) {
    final diff = DateTime.now().difference(date);
    if (diff.inMinutes < 60) return "${diff.inMinutes} min atrás";
    if (diff.inHours < 24) return "${diff.inHours} h atrás";
    return DateFormat("dd/MM/yyyy").format(date);
  }

  startApp() async {
    await postController.getPosts(context);
    loading = false;
    setState(() {});
  }

  @override
  void initState() {
    startApp();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final posts = DataController.feed;
    double width = MediaQuery.of(context).size.width;

    return loading
        ? Center(child: CircularProgressIndicator())
        : posts.isEmpty
        ? const Center(child: Text("Nenhum post disponível"))
        : RefreshIndicator(
            onRefresh: () async {
              await postController.getPosts(context);
              setState(() {});
            },
            child: ListView.builder(
              padding: const EdgeInsets.all(0),
              itemCount: posts.length,
              itemBuilder: (context, index) {
                final post = posts[index];

                return Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadiusGeometry.circular(0),
                  ),
                  color: Colors.white,
                  margin: const EdgeInsets.only(bottom: 12),
                  elevation: 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ListTile(
                        leading: CircleAvatar(
                          backgroundImage: NetworkImage(
                            '$imgUrl/${post.user.imagePath}',
                          ),
                        ),
                        title: GestureDetector(
                          onTap: () {
                            DataController.selectedUser = post.user;
                            Navigator.pushNamed(
                              context,
                              '/selectedUserProfile',
                            );
                          },
                          child: Text(
                            post.user.name,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        subtitle: Text(
                          post.user.experiencia ?? "Sem descrição",
                          style: TextStyle(fontSize: 12),
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.star, color: Colors.amber, size: 18),
                            SizedBox(width: 4),
                            Text(post.user.nota.toStringAsFixed(1)),
                          ],
                        ),
                      ),

                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 4,
                        ),
                        child: Text(post.descricao.toString()),
                      ),
                      Container(height: 8),
                      if (post.images.isEmpty)
                        Container(
                          height: 220,
                          width: width,
                          color: Colors.grey.shade300,
                          child: const Icon(
                            Icons.image,
                            size: 50,
                            color: Colors.grey,
                          ),
                        )
                      else
                        Image.network(
                          '$imgUrl/${post.images.first.path}',
                          height: 220,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Container(
                            height: 220,
                            width: width,
                            color: Colors.grey.shade300,
                            child: const Icon(
                              Icons.image,
                              size: 50,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        child: Row(
                          children: const [
                            Text("Você e mais 32 pessoas"),
                            Spacer(),
                            Text("2 comentários"),
                          ],
                        ),
                      ),
                      const Divider(height: 1),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          TextButton.icon(
                            style: TextButton.styleFrom(
                              foregroundColor: Color(AppColors.roxo),
                            ),
                            onPressed: () {},
                            icon: const Icon(Icons.thumb_up_alt_outlined),
                            label: const Text("Gostei"),
                          ),
                          TextButton.icon(
                            style: TextButton.styleFrom(
                              foregroundColor: Color(AppColors.azulescuro),
                            ),
                            onPressed: () {},
                            icon: const Icon(Icons.comment_outlined),
                            label: const Text("Comentar"),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          );
  }
}
