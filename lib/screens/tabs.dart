import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mealsapp/provider/meals_provider.dart';
import 'package:mealsapp/screens/new_meal.dart';

import '../provider/filters_provider.dart';
import 'package:mealsapp/provider/favorites_provider.dart';

import 'package:mealsapp/screens/categories.dart';
import 'package:mealsapp/screens/filteres.dart';
import 'package:mealsapp/screens/meals_screen.dart';
import 'package:mealsapp/widgets/main_drawer.dart';

class TabsScreen extends ConsumerStatefulWidget {
  const TabsScreen({super.key});

  @override
  ConsumerState<TabsScreen> createState() => _TabsScreenState();
}

class _TabsScreenState extends ConsumerState<TabsScreen> {
  var _isLoading = true;
  @override
  void initState() {
    _loaditems();
    super.initState();
  }

  void _loaditems() {
    ref.read(mealsProvider.notifier).loadItems();
    setState(() {
      _isLoading = false;
    });
  }

  void _selecteScreen(String identifier) async {
    Navigator.of(context).pop();
    if (identifier == 'filters') {
      Navigator.of(context).push<Map<Filter, bool>>(MaterialPageRoute(
        builder: (context) => const Filters(),
      ));
    }
    if (identifier == 'new-meal') {
      Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => const NewMeal(),
      ));
    }
  }

  int _selectedPageIndex = 0;
  void _selectePage(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final availableMeals = ref.watch(filteredMeals);

    Widget activePage = CategoriesScreen(
      availableMeals: availableMeals,
    );
    var activePageTitle = 'Categories';

    if (_selectedPageIndex == 1) {
      final favoriteMeals = ref.watch(favoriteMealsProvider);
      activePageTitle = 'Your Favorites';
      activePage = MealsScreen(
        meals: favoriteMeals,
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(activePageTitle),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => const NewMeal(),
              ));
            },
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: _isLoading ? const CircularProgressIndicator() : activePage,
      drawer: MainDrawer(
        onSelectScreen: _selecteScreen,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedPageIndex,
        onTap: (value) {
          _selectePage(value);
        },
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.set_meal), label: 'Categories'),
          BottomNavigationBarItem(icon: Icon(Icons.star), label: 'Favorites'),
        ],
      ),
    );
  }
}
