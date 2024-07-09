import 'package:equatable/equatable.dart';

class SubCategoryEntity extends Equatable {
    final String categoryId;
  final String subCategoryName;
  final String subCategoryId;
  final List<dynamic> brands;

  const SubCategoryEntity({required this.categoryId, required this.subCategoryName, required this.subCategoryId, required this.brands});


  @override
  List<Object?> get props => [];

}


