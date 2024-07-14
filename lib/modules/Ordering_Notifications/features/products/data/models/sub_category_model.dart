import 'dart:developer';

import 'package:super_app/modules/Ordering_Notifications/core/constants/api_conatsants.dart';
import 'package:super_app/modules/Ordering_Notifications/features/products/domain/entities/sub_category_entity.dart';

class SubCategoryModel extends SubCategoryEntity {
  SubCategoryModel({required super.categoryId, required super.subCategoryName, required super.subCategoryId, required super.brands});

  factory SubCategoryModel.fromJson(Map<String, dynamic> jsonData) {
    return SubCategoryModel(
        categoryId: jsonData[categoryIdAPIKey],
        subCategoryName: jsonData[subCategoryNameAPIKey],
        subCategoryId: jsonData[subCategoryIdAPIKey],
        brands: jsonData[brandsAPIKey]);
  }
  Map<String, dynamic> toJson() {
    return {
      categoryIdAPIKey: categoryId,
      subCategoryNameAPIKey: subCategoryName,
      subCategoryIdAPIKey: subCategoryId,
      brandsAPIKey: brands,
    };
  }
}
