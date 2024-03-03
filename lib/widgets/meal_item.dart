import 'package:flutter/material.dart';
import 'package:mealsapp/models/meal.dart';
import 'package:mealsapp/screens/meal_details.dart';
import 'package:mealsapp/widgets/meal_item_trait.dart';
import 'package:transparent_image/transparent_image.dart';

class MealItem extends StatelessWidget {
  final Meal meal;
  const MealItem({
    super.key,
    required this.meal,
  });

  String get upperCaseComplaxity {
    return meal.complexity.name[0].toUpperCase() +
        meal.complexity.name.substring(1);
  }

  String get upperCaseAffordability {
    return meal.affordability.name[0].toUpperCase() +
        meal.affordability.name.substring(1);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      clipBehavior: Clip.hardEdge,
      elevation: 2,
      margin: const EdgeInsets.all(8),
      child: InkWell(
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => MealDetails(
              meal: meal,
            ),
          ));
        },
        child: Stack(children: [
          FadeInImage(
            fit: BoxFit.cover,
            height: 200,
            width: double.infinity,
            placeholder: MemoryImage(kTransparentImage),
            image: NetworkImage(
              meal.imageUrl,
            ),
            // Use the imageErrorBuilder property to provide a fallback image
            imageErrorBuilder: (context, error, stackTrace) {
              // Return a local asset image as a fallback
              return Image.asset(
                'assets/images/img.png', // Replace 'default_image.png' with your asset image path
                fit: BoxFit.cover,
                width: double.infinity,
                height: 200,
              );
            },
          ),
          Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 6, horizontal: 44),
                color: Colors.black54,
                child: Column(
                  children: [
                    Text(
                      meal.title,
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      softWrap: true,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          MealItemTreat(
                            icon: Icons.schedule,
                            label: '${meal.duration} min',
                          ),
                          MealItemTreat(
                            icon: Icons.work,
                            label: upperCaseComplaxity,
                          ),
                          MealItemTreat(
                            icon: Icons.attach_money,
                            label: upperCaseAffordability,
                          ),
                        ]),
                  ],
                ),
              )),
        ]),
      ),
    );
  }
}
