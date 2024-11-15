import 'package:get/state_manager.dart';
import 'package:mafatiuljinah_poc/providers/database/category_db_helper.dart';
import 'dart:developer';

import '../modals/category.dart';
import '../providers/category_provider.dart';
import '../utils/constants.dart';

class CategoryListController extends GetxController {
  var categoryData = <String, List<Category>>{}.obs;
  var isLoading = true.obs;
  final _dbHelper = CategoryDatabaseHelper();
  final CategoryProvider _categoryProvider =
      CategoryProvider(ApiConstants.token);

  // This method fetches data based on the selected menu item and its dynamic endpoint
  Future<void> fetchCategoryData(String menuItem) async {
    try {
      isLoading(true);

      // Try fetching data from API
      final endpoint = _getEndpointForMenuItem(menuItem);
      if (endpoint.isNotEmpty) {
        final response = await _categoryProvider.fetchCategoryData(endpoint);

        // Save the fetched data locally
        await _saveCategoriesToDatabase(response.categories);

        categoryData.value = response.categories;
      } else {
        log("No endpoint found for $menuItem");
      }
    } catch (e) {
      log("Error fetching data online: $e");

      // Fetch data from local database if API fails
      await _fetchCategoriesFromDatabase();
    } finally {
      isLoading(false);
    }
  }

  Future<void> _saveCategoriesToDatabase(
      Map<String, List<Category>> categories) async {
    await _dbHelper.clearCategories(); // Clear old data
    for (var entry in categories.entries) {
      for (var category in entry.value) {
        await _dbHelper.insertCategory({
          'id': category.id,
          'category': category.category,
          'title': category.title,
          'isFav': category.isFav,
          'cdata': category.cdata.map((data) => data.toJson()).toList().toString(),
        });
      }
    }
  }

  Future<void> _fetchCategoriesFromDatabase() async {
    final fetchedData = await _dbHelper.fetchCategories();

    Map<String, List<Category>> localData = {};
    for (var item in fetchedData) {
      final categoryName = item['category'];
      final category = Category(
        id: item['id'],
        category: item['category'],
        title: item['title'],
        isFav: item['isFav'],
        cdata: [], // Reconstruct ContentData if necessary
      );
      if (localData.containsKey(categoryName)) {
        localData[categoryName]?.add(category);
      } else {
        localData[categoryName] = [category];
      }
    }

    categoryData.value = localData;
  }

  // This function dynamically returns the endpoint URL for each menu item
  String _getEndpointForMenuItem(String menuItem) {
    switch (menuItem) {
      case "Daily Dua":
        return ApiConstants.dailyDuaEndpoint;
      case "Surah":
      // return ApiConstants.surahEndpoint;
      case "Dua":
        return ApiConstants.duaEndpoint;
      case "Ziyarat":
        return ApiConstants.ziyaratEndpoint;
      case "Amaal":
      // return ApiConstants.amaalEndpoint;
      case "Munajat":
        return ApiConstants.munajatEndpoint;
      case "Travel Ziyarat":
      // return ApiConstants.travelZiyaratEndpoint;
      default:
        return ApiConstants.baseUrl;
    }
  }
}
