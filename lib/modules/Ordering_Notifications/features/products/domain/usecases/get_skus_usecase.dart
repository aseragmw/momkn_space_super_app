import 'package:dartz/dartz.dart';
import 'package:super_app/modules/Ordering_Notifications/core/errors/failures.dart';
import 'package:super_app/modules/Ordering_Notifications/features/products/data/models/sku_model.dart';
import 'package:super_app/modules/Ordering_Notifications/features/products/domain/entities/brand_entity.dart';
import 'package:super_app/modules/Ordering_Notifications/features/products/domain/entities/catalog_entity.dart';
import 'package:super_app/modules/Ordering_Notifications/features/products/domain/entities/sub_category_entity.dart';
import 'package:super_app/modules/Ordering_Notifications/features/products/domain/repositories/products_repository.dart';

import '../entities/sku_entity.dart';

class GetSKUsUsecase {
  final ProductsRepository productsRepository;

  GetSKUsUsecase({required this.productsRepository});
  Future<Either<Failure, List<SKUEntity>>> call(BrandEntity brandEntity ) => productsRepository.getSKUs(brandEntity);
}
