import 'package:flutter/material.dart' hide SearchController;
import 'package:maos_a_obra/controllers/data_controller.dart';
import 'package:maos_a_obra/controllers/search_controller.dart';
import 'package:maos_a_obra/main.dart';
import 'package:maos_a_obra/models/user_model.dart';

class SearchDelegateScreen extends SearchDelegate<String> {
  final SearchController _searchController = SearchController();

  String? _selectedCity;
  String? _selectedEspecialidade;

  @override
  String get searchFieldLabel => "Buscar prestadores...";

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(onPressed: () => query = '', icon: const Icon(Icons.clear)),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () => close(context, ''),
      icon: const Icon(Icons.arrow_back),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    // só chama a API se cidade e especialidade estiverem selecionadas
    if (_selectedCity == null || _selectedEspecialidade == null) {
      return const Center(
        child: Text("Selecione uma cidade e uma especialidade"),
      );
    }

    return FutureBuilder<void>(
      future: _searchController.buscarPrestadores(
        city: _selectedCity,
        especialidade: _selectedEspecialidade,
        context: context,
      ),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return const Center(child: Text("Erro ao buscar prestadores"));
        }

        if (DataController.resultadosBusca.isEmpty) {
          return const Center(child: Text("Nenhum prestador encontrado"));
        }

        return ListView.builder(
          itemCount: DataController.resultadosBusca.length,
          itemBuilder: (context, index) {
            final User prestador = DataController.resultadosBusca[index];
            return ListTile(
              onTap: () {
                DataController.selectedUser = prestador;
                Navigator.pushNamed(context, '/selectedUserProfile');
              },
              leading: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(999),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(999),
                  child: Image.network(
                    '$imgUrl/${prestador.imagePath}',
                    height: 40,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return const Icon(
                        Icons.person,
                        size: 40,
                        color: Colors.grey,
                      );
                    },
                  ),
                ),
              ),
              title: Text(prestador.name),
              subtitle: Text(prestador.email),
            );
          },
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final cidades =
        DataController.user?.addresses.map((a) => a.city).toSet().toList() ??
        [];

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text(
          "Selecione a cidade",
          style: Theme.of(context).textTheme.titleMedium,
        ),
        Wrap(
          spacing: 8,
          children: cidades
              .map(
                (city) => ChoiceChip(
                  label: Text(city),
                  selected: _selectedCity == city,
                  onSelected: (selected) {
                    _selectedCity = selected ? city : null;
                    if (_selectedCity != null &&
                        _selectedEspecialidade != null) {
                      showResults(context);
                    } else {
                      // força rebuild pra refletir a seleção
                      (context as Element).markNeedsBuild();
                    }
                  },
                ),
              )
              .toList(),
        ),
        const SizedBox(height: 24),
        Text(
          "Selecione a especialidade",
          style: Theme.of(context).textTheme.titleMedium,
        ),
        Wrap(
          spacing: 8,
          children: DataController.especialidades
              .map(
                (esp) => ChoiceChip(
                  label: Text(esp.name),
                  selected: _selectedEspecialidade == esp.name,
                  onSelected: (selected) {
                    _selectedEspecialidade = selected ? esp.name : null;
                    if (_selectedCity != null &&
                        _selectedEspecialidade != null) {
                      showResults(context);
                    } else {
                      (context as Element).markNeedsBuild();
                    }
                  },
                ),
              )
              .toList(),
        ),
      ],
    );
  }
}
