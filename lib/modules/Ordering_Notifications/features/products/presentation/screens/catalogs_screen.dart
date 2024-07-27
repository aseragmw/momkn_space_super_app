import 'dart:convert';
import 'dart:developer';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:super_app/modules/Ordering_Notifications/core/extentions/screen_size.dart';
import 'package:super_app/modules/Ordering_Notifications/core/network/api_caller.dart';
import 'package:super_app/modules/Ordering_Notifications/core/utils/app_theme.dart';
import 'package:super_app/modules/Ordering_Notifications/core/utils/snackbar_message.dart';
import 'package:super_app/modules/Ordering_Notifications/core/widgets/custom_app_bar.dart';
import 'package:super_app/modules/Ordering_Notifications/core/widgets/custom_circular_progress_indicator.dart';
import 'package:super_app/modules/Ordering_Notifications/core/widgets/main_layout.dart';
import 'package:super_app/modules/Ordering_Notifications/features/products/domain/entities/brand_entity.dart';
import 'package:super_app/modules/Ordering_Notifications/features/products/domain/entities/catalog_entity.dart';
import 'package:super_app/modules/Ordering_Notifications/features/products/domain/entities/category_entity.dart';
import 'package:super_app/modules/Ordering_Notifications/features/products/domain/entities/sku_entity.dart';
import 'package:super_app/modules/Ordering_Notifications/features/products/domain/entities/sub_category_entity.dart';
import 'package:super_app/modules/Ordering_Notifications/features/products/presentation/bloc/bloc/products_bloc.dart';
import 'package:super_app/modules/Ordering_Notifications/features/products/presentation/screens/categories_screen.dart';
import 'package:super_app/modules/Ordering_Notifications/features/products/presentation/widgets/catalog_category_card.dart';
import 'package:super_app/shared/app_constants.dart';

import '../../../../../../token_getter.dart';

class CatalogsScreen extends StatelessWidget {
  const CatalogsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    context.read<ProductsBloc>().add(const GetCatalogsCategoriesSubCategoriesEvent());
    List<CatalogEntity>catalogs=[];
    return MainLayout(
        body: Column(
      children: [
        CustomAppBar(
          title: Image.asset(
            "assets/logo.png",
            height: context.screenAspectRatio * 25,
            fit: BoxFit.fill,
          ),
          showBackCursor: true,
        ),

        Center(
          child: Text(
            "Catalogs",
            style: TextStyle(fontSize: AppTheme.fontSize24(context), fontWeight: AppTheme.fontWeight700, color: AppTheme.primaryGreenColor),
          ),
        ),
        SizedBox(
          height: context.screenAspectRatio * 10,
        ),
        BlocConsumer<ProductsBloc, ProductsState>(
          builder: (context, state) {
            if (state is GetCatalogsCategoriesSubCategoriesLoadingState) {
              return const CustomCircularProgressIndicator(
                color: AppTheme.primaryGreenColor,
              );
            } else if (state is GetCatalogsCategoriesSubCategoriesSuccessState) {
              catalogs = state.catalogs;
              return GridView.builder(
                physics: const NeverScrollableScrollPhysics(),
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
                itemCount: state.catalogs.length,
                itemBuilder: (context, index) {
                  final catalog = state.catalogs[index];
                  return FutureBuilder(future:getPicBytes(catalog), builder: (context,snapshot){
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    }  else if(snapshot.connectionState == ConnectionState.done){
                      if(snapshot.hasData){
                        print("genaa");
                        return InkWell(
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => CategoriesScreen(catalog: catalog),
                              ));
                            },
                            child: CatalogCategoryCardWidget(title: catalog.catalogName, imgUrl: "assets/product2.png", imgBytes: snapshot.data!,),);

                      }
                      else {
                        return SizedBox();

                      }
                      }
                    else{
                      return SizedBox();
                    }
                  });

                },
              );
            }
            else if(state is ProductsState){
              return GridView.builder(
                physics: const NeverScrollableScrollPhysics(),
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
                itemCount: catalogs.length,
                itemBuilder: (context, index) {
                  final catalog = catalogs[index];
                  return FutureBuilder(future:getPicBytes(catalog), builder: (context,snapshot){
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: CustomCircularProgressIndicator(color: AppTheme.primaryGreenColor,),
                      );
                    }  else if(snapshot.connectionState == ConnectionState.done){
                      if(snapshot.hasData){
                        print("genaa");
                        return InkWell(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => CategoriesScreen(catalog: catalog),
                            ));
                          },
                          child: CatalogCategoryCardWidget(title: catalog.catalogName, imgUrl: "assets/product2.png", imgBytes: snapshot.data!,),);

                      }
                      else {
                        return SizedBox();

                      }
                    }
                    else{
                      return SizedBox();
                    }
                  });

                },
              );

            }

            else {
              return const SizedBox();
            }
          },
          listener: (context, state) {
            if (state is GetCatalogsCategoriesSubCategoriesErrorState) {
              SnackBarMessage.showErrorSnackBar(message: state.message, context: context);
            }
          },
        ),
        
      ],
    ));
  }
}

Future<Uint8List> getPicBytes(Object object)async{
  if(object is CatalogEntity){
    final catalog = object as CatalogEntity;
    try{
      final res = await ApiCaller.getHTTP("http://52.21.250.81:54321/catalogTree/${catalog.catalogId}",null,TokenGetter.myToken);
      if(res.data["picture"]["data"] is String){
        String base64String = res.data["picture"]["data"];
        return base64Decode(base64String);
      }
      final List<dynamic> list =  res.data["picture"]["data"]["data"];
      return Uint8List.fromList(list.cast<int>());
    }catch(e){
      log(e.toString());
      return Uint8List(0);
    }
  }
  else if(object is CategoryEntity){
    final category = object as CategoryEntity;
    try{
      final res = await ApiCaller.getHTTP("http://52.21.250.81:54321/category/${category.categoryId}",null,TokenGetter.myToken);
      if(res.data["picture"]["data"] is String){
        String base64String = res.data["picture"]["data"];
        return base64Decode(base64String);
      }
      final List<dynamic> list =  res.data["picture"]["data"]["data"];
      return Uint8List.fromList(list.cast<int>());
    }catch(e){
      log(e.toString());
      return Uint8List(0);
    }
  }
  else if(object is SubCategoryEntity){
    final sub = object as SubCategoryEntity;
    try{
      final res = await ApiCaller.getHTTP("http://52.21.250.81:54321/subCategory/${sub.subCategoryId}",null,TokenGetter.myToken);
      if(res.data["picture"]["data"] is String){
        String base64String = res.data["picture"]["data"];
        return base64Decode(base64String);
      }
      final List<dynamic> list =  res.data["picture"]["data"]["data"];
      return Uint8List.fromList(list.cast<int>());
    }catch(e){
      log(e.toString());
      return Uint8List(0);
    }
  }
  else if(object is BrandEntity){
    final brand = object as BrandEntity;
    try{
      final res = await ApiCaller.getHTTP("http://52.21.250.81:54321/brand/${brand.brandId}",null,TokenGetter.myToken);
      if(res.data["picture"]["data"] is String){
        String base64String = res.data["picture"]["data"];
        return base64Decode(base64String);
      }
      final List<dynamic> list =  res.data["picture"]["data"]["data"];
      return Uint8List.fromList(list.cast<int>());
    }catch(e){
      log(e.toString());
      return Uint8List(0);
    }
  }
  else if(object is SKUEntity){
    final sku = object as SKUEntity;
    try{
      final res = await ApiCaller.getHTTP("http://52.21.250.81:54321/sku/${sku.skuID}",null,TokenGetter.myToken);
     if(res.data["picture"]["data"] is String){
       String base64String = res.data["picture"]["data"];
       return base64Decode(base64String);
     }

      final List<dynamic> list =  res.data["picture"]["data"]["data"];
      return Uint8List.fromList(list.cast<int>());
    }catch(e){
      log("aywa hena");
      log(e.toString());
      return Uint8List(0);
    }
  }
  else{
    return Uint8List(0);
  }
}