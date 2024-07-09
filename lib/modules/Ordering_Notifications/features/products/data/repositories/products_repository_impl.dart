import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:super_app/modules/Ordering_Notifications/core/errors/failures.dart';
import 'package:super_app/modules/Ordering_Notifications/features/products/data/datasources/products_remote_data_source.dart';
import 'package:super_app/modules/Ordering_Notifications/features/products/domain/entities/catalog_entity.dart';
import 'package:super_app/modules/Ordering_Notifications/features/products/domain/repositories/products_repository.dart';

class ProductsRepositoryImpl extends ProductsRepository {
  final ProductsRemoteDataSource productsRemoteDataSource;
  ProductsRepositoryImpl({required this.productsRemoteDataSource});

  @override
  Future<Either<Failure, List<CatalogEntity>>> getCatalosCategoriesSubCategories() async {
    try {
      final val = await productsRemoteDataSource.getCatalosCategoriesSubCategories();
      return Right(val);
    } catch (e) {
      log(e.toString());
      return const Left(Failure(message: 'Error Getting Catalogs'));
    }
  }
}
