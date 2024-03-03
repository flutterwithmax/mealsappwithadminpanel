import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mealsapp/models/meal.dart';
import 'package:mealsapp/provider/meals_provider.dart';
import 'package:http/http.dart' as http;

class NewMeal extends ConsumerStatefulWidget {
  const NewMeal({super.key});

  @override
  ConsumerState<NewMeal> createState() => _NewMealState();
}

class _NewMealState extends ConsumerState<NewMeal> {
  bool _isSending = false;
  List<String> _steps = [];
  List<String> _ingredients = [];
  List<String> categories = [];

  void categoriesEdit() {
    categoryValues.forEach((key, value) {
      if (value) {
        switch (key) {
          case 'Italian':
            categories.add('c1');
            break;
          case 'Quick and Easy':
            categories.add('c2');
            break;
          case 'Hamburgers':
            categories.add('c3');
            break;
          case 'German':
            categories.add('c4');
            break;
          case 'Light and Lovely':
            categories.add('c5');
            break;
          case 'Exotic':
            categories.add('c6');
            break;
          case 'Breakfast':
            categories.add('c7');
            break;
          case 'Asian':
            categories.add('c8');
            break;
          case 'French':
            categories.add('c9');
            break;
          case 'Summer':
            categories.add('c10');
            break;
        }
      }
    });
  }

  void showSnackBar(String title) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(title)));
  }

  Complexity get complexity {
    if (selectedIndexOfComplexity == 0) {
      return Complexity.simple;
    }
    if (selectedIndexOfComplexity == 1) {
      return Complexity.challenging;
    } else {
      return Complexity.hard;
    }
  }

  Affordability get affordability {
    if (selectedIndexOfAffordability == 0) {
      return Affordability.affordable;
    }
    if (selectedIndexOfAffordability == 1) {
      return Affordability.luxurious;
    } else {
      return Affordability.pricey;
    }
  }

  Map<String, bool> filtersVal = {
    'Gluten-Free': false,
    'Lactose-Free': false,
    'Vegetarian': false,
    'Vegan': false,
  };
  Map<String, bool> categoryValues = {
    'Italian': false,
    'Quick and Easy': false,
    'Hamburgers': false,
    'German': false,
    'Light and Lovly ': false,
    'Exotic': false,
    'Breakfast': false,
    'Asian': false,
    'French': false,
    'Summer': false,
  };
  final titleController = TextEditingController();
  final urlController = TextEditingController();
  final durController = TextEditingController();
  final stepsController = TextEditingController();
  final ingController = TextEditingController();
  int selectedIndexOfAffordability = 0;
  int selectedIndexOfComplexity = 0;

  _onSave() async {
    if (titleController.text.trim().length <= 1 ||
        urlController.text.trim().length <= 1 ||
        durController.text.trim().isEmpty ||
        int.tryParse(durController.text) == null ||
        durController.text == '0') {
      print('working');
      showSnackBar('Please fill a valid title or img url or duration');
      return;
    }

    List<String> inputSteps = stepsController.text.split(".");

    inputSteps = inputSteps.where((step) => step.trim().isNotEmpty).toList();
    _steps = inputSteps;

    List<String> inputIngredients = stepsController.text.split(".");

    inputIngredients =
        inputIngredients.where((step) => step.trim().isNotEmpty).toList();
    _ingredients = inputIngredients;
    if (_steps.isEmpty || _ingredients.isEmpty) {
      showSnackBar('Please fill the steps or ingridients');
      return;
    }
    categoriesEdit();
    if (categories.isEmpty) {
      showSnackBar('Please pick a category');
      return;
    }
    setState(() {
      _isSending = true;
    });
    final url = Uri.https(
        'meals-app-e403b-default-rtdb.europe-west1.firebasedatabase.app',
        'meals-list.json');

    final response = await http.post(url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'categories': categories,
          'title': titleController.text,
          'imageUrl': urlController.text,
          'ingredients': _ingredients,
          'steps': _steps,
          'duration': durController.text,
          'affordability': affordability.name,
          'complexity': complexity.name,
          'isGlutenFree': filtersVal['Gluten-Free']!,
          'isLactoseFree': filtersVal['Lactose-Free']!,
          'isVegan': filtersVal['Vegan']!,
          'isVegetarian': filtersVal['Vegetarian']!
        }));
    print(response.statusCode);
    ref.read(mealsProvider.notifier).addMeal(Meal(
        id: DateTime.now().toString(),
        categories: categories,
        title: titleController.text,
        imageUrl: urlController.text,
        ingredients: _ingredients,
        steps: _steps,
        duration: int.parse(durController.text),
        complexity: complexity,
        affordability: affordability,
        isGlutenFree: filtersVal['Gluten-Free']!,
        isLactoseFree: filtersVal['Lactose-Free']!,
        isVegan: filtersVal['Vegan']!,
        isVegetarian: filtersVal['Vegetarian']!));

    if (!context.mounted) {
      return;
    }
    Navigator.of(context).pop();
  }

  @override
  void dispose() {
    titleController.dispose();
    urlController.dispose();
    durController.dispose();
    stepsController.dispose();
    ingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget afforabilityPick() {
      return Column(
        children: [
          Center(
            child: Text(
              'Affordability',
              style: Theme.of(context).textTheme.titleLarge!.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.normal),
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: CupertinoSlidingSegmentedControl(
              children: const {
                0: Text(
                  'Affordable',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                1: Text(
                  'Pricey',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                2: Text(
                  'Luxurious',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              },
              groupValue: selectedIndexOfAffordability,
              onValueChanged: (value) {
                setState(() {
                  selectedIndexOfAffordability = value!;
                });
              },
            ),
          ),
        ],
      );
    }

    Widget complexityPick() {
      return Column(
        children: [
          Center(
            child: Text(
              'Complexity',
              style: Theme.of(context).textTheme.titleLarge!.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.normal),
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: CupertinoSlidingSegmentedControl(
              children: const {
                0: Text(
                  'Simple',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                1: Text(
                  'Challenging',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                2: Text(
                  'Hard',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              },
              groupValue: selectedIndexOfComplexity,
              onValueChanged: (value) {
                setState(() {
                  selectedIndexOfComplexity = value!;
                });
              },
            ),
          ),
        ],
      );
    }

    Widget filters() {
      return Column(
        children: [
          Center(
            child: Text(
              'Filters',
              style: Theme.of(context).textTheme.titleLarge!.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.normal),
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          SizedBox(
            height: 250,
            child: ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              itemCount: filtersVal.length,
              itemBuilder: (context, index) {
                String key = filtersVal.keys.elementAt(index);
                bool value = filtersVal[key] ??
                    false; // Get the value, defaulting to false if null

                return CheckboxListTile(
                  title: Text(key),
                  value: value,
                  onChanged: (newValue) {
                    setState(() {
                      filtersVal[key] =
                          newValue ?? false; // Update the map value
                    });
                  },
                );
              },
            ),
          ),
        ],
      );
    }

    Widget steps() {
      return Column(
        children: [
          Center(
            child: Text(
              'Steps',
              style: Theme.of(context).textTheme.titleLarge!.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.normal),
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          TextField(
            style: const TextStyle(color: Colors.white),
            controller: stepsController,
            keyboardType: TextInputType.multiline,
            maxLines: null,
            decoration: const InputDecoration(
              hintText: 'Enter cooking steps separated by periods "."',
            ),
          ),
        ],
      );
    }

    Widget duration() {
      return Column(
        children: [
          Center(
            child: Text(
              'Duration',
              style: Theme.of(context).textTheme.titleLarge!.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.normal),
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          Row(
            children: [
              Expanded(
                child: TextField(
                  style: const TextStyle(
                    color: Colors.white,
                  ),
                  decoration: const InputDecoration(
                      labelText: 'Enter the duration in minutes'),
                  keyboardType: TextInputType.number,
                  maxLength: 3,
                  controller: durController,
                ),
              ),
              const Spacer(),
              ElevatedButton(
                onPressed: _isSending ? null : _onSave,
                child: const Text('Save all'),
              ),
            ],
          ),
          const SizedBox(
            height: 20,
          )
        ],
      );
    }

    Widget ingredients() {
      return Column(
        children: [
          Center(
            child: Text(
              'Ingredients',
              style: Theme.of(context).textTheme.titleLarge!.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.normal),
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          TextField(
            style: const TextStyle(color: Colors.white),
            controller: ingController,
            keyboardType: TextInputType.multiline,
            maxLines: null,
            decoration: const InputDecoration(
              hintText: 'Enter meal ingredients separated by periods "."',
            ),
          ),
        ],
      );
    }

    Widget categoryVals() {
      return Column(
        children: [
          Center(
            child: Text(
              'Categories',
              style: Theme.of(context).textTheme.titleLarge!.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.normal),
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          SizedBox(
            height: 600,
            child: ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              itemCount: categoryValues.length,
              itemBuilder: (context, index) {
                String key = categoryValues.keys.elementAt(index);
                bool value = categoryValues[key] ??
                    false; // Get the value, defaulting to false if null

                return CheckboxListTile(
                  title: Text(key),
                  value: value,
                  onChanged:
                      ((filtersVal['Vegan']! || filtersVal['Vegetarian']!) &&
                              key == 'Hamburgers')
                          ? null
                          : (newValue) {
                              setState(() {
                                categoryValues[key] =
                                    newValue ?? false; // Update the map value
                              });
                            },
                );
              },
            ),
          ),
        ],
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Add a new meal'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              TextField(
                style: const TextStyle(color: Colors.white),
                controller: titleController,
                decoration: const InputDecoration(
                    labelText: 'Meal Name', fillColor: Colors.white), //title
              ),
              const SizedBox(
                height: 10,
              ),
              TextField(
                style: const TextStyle(color: Colors.white),
                controller: urlController,
                decoration:
                    const InputDecoration(labelText: 'Image url'), //image url
              ),
              const SizedBox(
                height: 10,
              ),
              afforabilityPick(),
              const SizedBox(
                height: 10,
              ),
              complexityPick(),
              const SizedBox(
                height: 10,
              ),
              filters(),
              const SizedBox(
                height: 10,
              ),
              categoryVals(),
              steps(),
              const SizedBox(
                height: 10,
              ),
              ingredients(),
              const SizedBox(
                height: 10,
              ),
              duration(), // duration and button
            ],
          ),
        ),
      ),
    );
  }
}
