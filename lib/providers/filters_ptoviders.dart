import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:learn_flutter/models/meal.dart';
import 'package:learn_flutter/providers/meal_providers.dart';

enum Filter {
  glutenFree,
  lactoseFree,
  vegan,
  vegetarian,
}

class FilterProvider extends StateNotifier<Map<Filter, bool>> {
  FilterProvider()
      : super({
          Filter.glutenFree: false,
          Filter.lactoseFree: false,
          Filter.vegan: false,
          Filter.vegetarian: false,
        });

  void toggleFilter(Filter filter) {
    state[filter] = !state[filter]!;
    state = {...state};
  }

  void toggleFilters(Map<Filter, bool> filters) {
    state = filters;
  }
}

final filterProvider = StateNotifierProvider<FilterProvider, Map<Filter, bool>>(
  (ref) {
    return FilterProvider();
  },
);


final filteredMeals = Provider<List<Meal>>((ref) {
  final meals = ref.watch(mealsProvider);
  final filters = ref.watch(filterProvider);
  return meals.where((meal) {
    if (filters[Filter.glutenFree]! && !meal.isGlutenFree) {
      return false;
    }
    if (filters[Filter.lactoseFree]! && !meal.isLactoseFree) {
      return false;
    }
    if (filters[Filter.vegan]! && !meal.isVegan) {
      return false;
    }
    if (filters[Filter.vegetarian]! && !meal.isVegetarian) {
      return false;
    }
    return true;
  }).toList();
});
