import 'dart:developer';

import 'package:super_app/modules/Ordering_Notifications/core/constants/api_conatsants.dart';
import 'package:super_app/modules/Ordering_Notifications/core/network/api_caller.dart';
import 'package:super_app/modules/Ordering_Notifications/features/products/data/models/catalog_model.dart';
import 'package:super_app/modules/Ordering_Notifications/features/products/data/models/category_model.dart';
import 'package:super_app/modules/Ordering_Notifications/features/products/data/models/sub_category_model.dart';
import 'package:super_app/modules/Ordering_Notifications/features/products/domain/entities/catalog_entity.dart';

abstract class ProductsRemoteDataSource {
  Future<List<CatalogEntity>> getCatalosCategoriesSubCategories();
}

class ProductsRemoteDataSourceImplWithDio extends ProductsRemoteDataSource {
  @override
  Future<List<CatalogEntity>> getCatalosCategoriesSubCategories() async {
    try {

      final jsonRes = await ApiCaller.getHTTP('/catalogTree/get/663cf8d5831af4f499b4bdb6', null,
          "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjY2NDdhOGRiY2QxM2FiMTczMzA4ZjEzNSIsInVzZXJfTW9iaWxlX051bWJlciI6IjMiLCJpYXQiOjE3MjA1MDg4MjgsImV4cCI6MTcyMDU5NTIyOH0.yOztvBs4eVNLBSbxJPPvGrkRk3RBn7ZlkFymLM0UgvU");      List<CatalogModel> catalogs = [];
      for (var catalogJson in jsonRes.data) {
        List<CategoryModel> categories = [];
        if (catalogJson[categoriesAPIKey].length != 0) {
          categories = await getCategories(catalogJson[catalogIdAPIKey]);
        }
        catalogs.add(CatalogModel(
            orgId: catalogJson[orgIdAPIKey],
            catalogName: catalogJson[catalogNameAPIKey],
            catalogId: catalogJson[catalogIdAPIKey],
            catalogStatus: catalogJson[catalogStatusAPIKey],
            categories: categories));
      }
      return catalogs;
    } catch (e) {
      log("${e.toString()} error in get catalogs in datasource");
      rethrow;
    }
  }
}

Future<List<CategoryModel>> getCategories(String catalogId) async {
  try {
    final jsonRes = await ApiCaller.getHTTP('/category/get/$catalogId', null,
        "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjY2NDdhOGRiY2QxM2FiMTczMzA4ZjEzNSIsInVzZXJfTW9iaWxlX051bWJlciI6IjMiLCJpYXQiOjE3MjA1MDg4MjgsImV4cCI6MTcyMDU5NTIyOH0.yOztvBs4eVNLBSbxJPPvGrkRk3RBn7ZlkFymLM0UgvU");    List<CategoryModel> categories = [];
    for (var categoryJson in jsonRes.data) {
      List<SubCategoryModel> subCategories = [];
      if (categoryJson[subCategoriesAPIKey].length != 0) {
        subCategories = await getSubCategories(categoryJson[categoryIdAPIKey]);
      }
      categories.add(CategoryModel(
          catalogId: categoryJson[catalogIdAPIKey],
          categoryName: categoryJson[categoryNameAPIKey],
          categoryId: categoryJson[categoryIdAPIKey],
          subCategories: subCategories));
    }
    return categories;
  } catch (e) {
    log("${e.toString()} error in get Categories in datasource");
    rethrow;
  }
}

Future<List<SubCategoryModel>> getSubCategories(String categoryId) async {
  try {
    final jsonRes = await ApiCaller.getHTTP('/subCategory/get/$categoryId', null,
        "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjY2NDdhOGRiY2QxM2FiMTczMzA4ZjEzNSIsInVzZXJfTW9iaWxlX051bWJlciI6IjMiLCJpYXQiOjE3MjA1MDg4MjgsImV4cCI6MTcyMDU5NTIyOH0.yOztvBs4eVNLBSbxJPPvGrkRk3RBn7ZlkFymLM0UgvU");    List<SubCategoryModel> subCategories = [];
    for (var subCategoryJson in jsonRes.data) {
      subCategories.add(SubCategoryModel(
          categoryId: subCategoryJson[categoryIdAPIKey],
          subCategoryName: subCategoryJson[subCategoryNameAPIKey],
          subCategoryId: subCategoryJson[subCategoryIdAPIKey],
          brands: subCategoryJson[brandsAPIKey]));
    }
    return subCategories;
  } catch (e) {
    log("${e.toString()} error in get subCategories in datasource");
    rethrow;
  }
}
