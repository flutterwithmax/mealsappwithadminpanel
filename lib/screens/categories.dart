import 'package:flutter/material.dart';
import 'package:mealsapp/data/data.dart';
import 'package:mealsapp/models/category.dart';
import 'package:mealsapp/models/meal.dart';

import 'package:mealsapp/screens/meals_screen.dart';
import 'package:mealsapp/widgets/category_grid_item.dart';

class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({super.key, required this.availableMeals});
  final List<Meal> availableMeals;

  void _selectCategory(
    BuildContext context,
    Category category,
  ) {
    final meals = availableMeals
        .where((element) => element.categories.contains(category.id))
        .toList();
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => MealsScreen(
          title: category.title,
          meals: meals,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GridView(
      padding: const EdgeInsets.all(24),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 3 / 2,
          crossAxisSpacing: 20,
          mainAxisSpacing: 20),
      children: [
        for (final category in availableCategories)
          CategoryGridItem(
            category: category,
            onSelect: () {
              _selectCategory(context, category);
            },
          )
      ],
    );
  }
}
