part of 'products_bloc.dart';

sealed class ProductsState extends Equatable {
  const ProductsState();

  @override
  List<Object> get props => [];
}

final class ProductsInitial extends ProductsState {}

class GetCatalogsCategoriesSubCategoriesLoadingState extends ProductsState {}

class GetCatalogsCategoriesSubCategoriesErrorState extends ProductsState {
  final String message;

  const GetCatalogsCategoriesSubCategoriesErrorState({required this.message});
}

class GetCatalogsCategoriesSubCategoriesSuccessState extends ProductsState {
  final List<CatalogEntity> catalogs;

  const GetCatalogsCategoriesSubCategoriesSuccessState({required this.catalogs});
}
