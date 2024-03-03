import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:mealsapp/models/meal.dart';

class MealsNotifier extends StateNotifier<List<Meal>> {
  MealsNotifier() : super([]);
  List<Meal> loadedMeals = [];

  Affordability affordability(String title) {
    if (title == 'affordable') {
      return Affordability.affordable;
    }
    if (title == 'pricey') {
      return Affordability.pricey;
    }
    if (title == 'luxurious') {
      return Affordability.luxurious;
    }
    return Affordability.affordable;
  }

  Complexity complexity(String title) {
    if (title == 'simple') {
      return Complexity.simple;
    }
    if (title == 'Challeging') {
      return Complexity.challenging;
    }
    if (title == 'hard') {
      return Complexity.hard;
    }
    return Complexity.simple;
  }

  void loadItems() async {
    final url = Uri.https(
        'meals-app-e403b-default-rtdb.europe-west1.firebasedatabase.app',
        'meals-list.json');
    final response = await http.get(url);
    final Map<String, dynamic> resData = jsonDecode(response.body);
    for (final entry in resData.entries) {
      final String id = entry.key;
      final Map<String, dynamic> itemData = entry.value;

      final List<String> categories = List<String>.from(itemData['categories']);
      final String title = itemData['title'];
      final String imageUrl = itemData['imageUrl'];
      final List<String> ingredients =
          List<String>.from(itemData['ingredients']);
      final List<String> steps = List<String>.from(itemData['steps']);
      final int duration = int.parse(itemData['duration']);

      // Convert affordability from String to Affordability enum

      // Convert complexity from String to Complexity enum

      final bool isGlutenFree = itemData['isGlutenFree'];
      final bool isLactoseFree = itemData['isLactoseFree'];
      final bool isVegan = itemData['isVegan'];
      final bool isVegetarian = itemData['isVegetarian'];

      final Meal meal = Meal(
        id: id,
        categories: categories,
        title: title,
        imageUrl: imageUrl,
        ingredients: ingredients,
        steps: steps,
        duration: duration,
        complexity: complexity(itemData['complexity']),
        affordability: affordability(itemData['affordability']),
        isGlutenFree: isGlutenFree,
        isLactoseFree: isLactoseFree,
        isVegan: isVegan,
        isVegetarian: isVegetarian,
      );

      loadedMeals.add(meal);
    }
    print(loadedMeals.length);
    state = loadedMeals;
  }

  void addMeal(Meal meal) {
    state = [...state, meal];
  }
}

final mealsProvider =
    StateNotifierProvider<MealsNotifier, List<Meal>>((ref) => MealsNotifier());
