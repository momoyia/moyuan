import 'package:flutter/material.dart';
import 'package:peiban_app/data/mock_data.dart';
import 'package:peiban_app/models/recipe.dart';
import 'package:peiban_app/screens/discover/recipe_detail_screen.dart';
import 'package:peiban_app/widgets/recipe_card.dart';

class RecipeSearchScreen extends StatefulWidget {
  const RecipeSearchScreen({super.key});

  @override
  State<RecipeSearchScreen> createState() => _RecipeSearchScreenState();
}

class _RecipeSearchScreenState extends State<RecipeSearchScreen> {
  String _query = '';

  List<Recipe> get _results {
    if (_query.trim().isEmpty) return MockData.recipes;
    final q = _query.toLowerCase();
    return MockData.recipes
        .where(
          (recipe) =>
              recipe.title.toLowerCase().contains(q) ||
              recipe.description.toLowerCase().contains(q) ||
              recipe.category.toLowerCase().contains(q),
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          autofocus: true,
          decoration: const InputDecoration(
            hintText: '搜索食谱、食材...',
            border: InputBorder.none,
            hintStyle: TextStyle(fontSize: 14),
          ),
          onChanged: (value) => setState(() => _query = value),
        ),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(20),
        itemCount: _results.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final recipe = _results[index];
          return RecipeCard(
            recipe: recipe,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => RecipeDetailScreen(recipe: recipe),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
