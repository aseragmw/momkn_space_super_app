import 'package:dartz/dartz.dart';
import 'package:super_app/modules/Ordering_Notifications/core/errors/failures.dart';
import 'package:super_app/modules/Ordering_Notifications/features/products/domain/entities/catalog_entity.dart';
abstract class ProductsRepository {
  Future<Either<Failure, List<CatalogEntity>>> getCatalosCategoriesSubCategories();
}
