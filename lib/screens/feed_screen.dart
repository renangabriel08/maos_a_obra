import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:maos_a_obra/controllers/data_controller.dart';
import 'package:maos_a_obra/controllers/post_controller.dart';
import 'package:maos_a_obra/main.dart';
import 'package:maos_a_obra/screens/search_delegate_screen.dart';

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

  void openSearchModal() {
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

    return loading
        ? Center(child: CircularProgressIndicator())
        : Column(
            children: [
              InkWell(
                onTap: () => showSearch(
                  context: context,
                  delegate: SearchDelegateScreen(),
                ),
                child: Container(
                  margin: const EdgeInsets.all(12),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 14,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: const [
                      Icon(Icons.search, color: Colors.grey),
                      SizedBox(width: 8),
                      Text(
                        "Buscar prestadores...",
                        style: TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: posts.isEmpty
                    ? const Center(child: Text("Nenhum post disponível"))
                    : RefreshIndicator(
                        onRefresh: () async {
                          await postController.getPosts(context);
                          setState(() {});
                        },
                        child: ListView.builder(
                          padding: const EdgeInsets.all(12),
                          itemCount: posts.length,
                          itemBuilder: (context, index) {
                            final post = posts[index];

                            return Card(
                              margin: const EdgeInsets.only(bottom: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(12),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    ListTile(
                                      onTap: () {
                                        DataController.selectedUser = post.user;
                                        Navigator.pushNamed(
                                          context,
                                          '/selectedUserProfile',
                                        );
                                      },
                                      leading: Container(
                                        width: 40,
                                        height: 40,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                            999,
                                          ),
                                        ),
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(
                                            999,
                                          ),
                                          child: Image.network(
                                            '$imgUrl/${post.user.imagePath}',
                                            height: 40,
                                            width: double.infinity,
                                            fit: BoxFit.cover,
                                            errorBuilder:
                                                (context, error, stackTrace) {
                                                  return Center(
                                                    child: Icon(
                                                      Icons.person,
                                                      size: 40,
                                                      color: Colors.grey,
                                                    ),
                                                  );
                                                },
                                          ),
                                        ),
                                      ),
                                      title: Text(
                                        post.user.name,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      subtitle: Text(
                                        post.user.email,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      trailing: Text(
                                        timeAgo(post.data),
                                        style: const TextStyle(
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 12),
                                    if (post.images.isNotEmpty)
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(12),
                                        child: Image.network(
                                          '$imgUrl/${post.images.first.path}',
                                          height: 250,
                                          width: double.infinity,
                                          fit: BoxFit.cover,
                                          errorBuilder:
                                              (context, error, stackTrace) {
                                                return Container(
                                                  height: 250,
                                                  decoration: BoxDecoration(
                                                    color: Colors.grey.shade300,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          12,
                                                        ),
                                                  ),
                                                  child: const Center(
                                                    child: Icon(
                                                      Icons.image,
                                                      size: 50,
                                                      color: Colors.grey,
                                                    ),
                                                  ),
                                                );
                                              },
                                        ),
                                      )
                                    else
                                      Container(
                                        height: 150,
                                        decoration: BoxDecoration(
                                          color: Colors.grey.shade300,
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                        ),
                                        child: const Center(
                                          child: Icon(
                                            Icons.image,
                                            size: 50,
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ),
                                    const SizedBox(height: 12),
                                    Text(post.descricao.toString()),
                                    const SizedBox(height: 12),
                                    Row(
                                      children: [
                                        IconButton(
                                          icon: const Icon(
                                            Icons.favorite_border,
                                          ),
                                          onPressed: () {},
                                        ),
                                        Text("${post.curtidas}"),
                                        const SizedBox(width: 16),
                                        IconButton(
                                          icon: const Icon(
                                            Icons.comment_outlined,
                                          ),
                                          onPressed: () {},
                                        ),
                                        Text("${post.comments.length}"),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
              ),
            ],
          );
  }
}
