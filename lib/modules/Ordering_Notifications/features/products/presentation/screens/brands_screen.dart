import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:super_app/modules/Ordering_Notifications/core/extentions/screen_size.dart';
import 'package:super_app/modules/Ordering_Notifications/core/utils/app_theme.dart';
import 'package:super_app/modules/Ordering_Notifications/core/widgets/custom_app_bar.dart';
import 'package:super_app/modules/Ordering_Notifications/core/widgets/custom_circular_progress_indicator.dart';
import 'package:super_app/modules/Ordering_Notifications/core/widgets/main_layout.dart';
import 'package:super_app/modules/Ordering_Notifications/features/products/domain/entities/category_entity.dart';
import 'package:super_app/modules/Ordering_Notifications/features/products/domain/entities/sub_category_entity.dart';
import 'package:super_app/modules/Ordering_Notifications/features/products/presentation/bloc/bloc/products_bloc.dart';
import 'package:super_app/modules/Ordering_Notifications/features/products/presentation/screens/skus_screen.dart';
import 'package:super_app/modules/Ordering_Notifications/features/products/presentation/widgets/catalog_category_card.dart';

class BrandsScreen extends StatelessWidget {
  const BrandsScreen({super.key, required this.subCategoryEntity});
  final SubCategoryEntity subCategoryEntity;

  @override
  Widget build(BuildContext context) {
    context.read<ProductsBloc>().add(GetBrandsWithSKUsEvent(subCategoryEntity));
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
            subCategoryEntity.subCategoryName,
            style: TextStyle(
                fontSize: AppTheme.fontSize24(context),
                fontWeight: AppTheme.fontWeight700,
                color: AppTheme.primaryGreenColor),
          ),
        ),
        SizedBox(
          height: context.screenAspectRatio * 10,
        ),

        BlocConsumer<ProductsBloc, ProductsState>(
          listener: (BuildContext context, ProductsState state) {},
          builder: (BuildContext context, ProductsState state) {
            if(state is GetBrandsWithSKUsLoadingState){
              return const CustomCircularProgressIndicator(color: AppTheme.primaryGreenColor,);
            }
            else if(state is GetBrandsWithSKUsSuccessState){
              return GridView.builder(
                physics: const NeverScrollableScrollPhysics(),
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2),
                itemCount: state.brands.length,
                itemBuilder: (context, index) {
                  final brand = state.brands[index];
                  return InkWell(onTap: (){
                    Navigator.of(context).push(MaterialPageRoute(builder: (_)=>SKUsScreen(brand: brand)));
                  },
                    child: CatalogCategoryCardWidget(
                        title: brand.brandName,
                        imgUrl: "assets/product2.png"),
                  );
                },
              );
            }
              else{
                return const SizedBox();
            }
          },
        ),

        // GridView(
        //   physics: NeverScrollableScrollPhysics(),
        //   padding: EdgeInsets.zero,
        //   shrinkWrap: true,
        //   gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
        //   children: [
        //     CatalogCategoryCardWidget(title: "نسيج القطن", imgUrl: "assets/product2.png"),
        //     CatalogCategoryCardWidget(title: "نسيج القطن", imgUrl: "assets/product2.png"),
        //     CatalogCategoryCardWidget(title: "نسيج القطن", imgUrl: "assets/product2.png"),
        //     CatalogCategoryCardWidget(title: "نسيج القطن", imgUrl: "assets/product2.png"),
        //     CatalogCategoryCardWidget(title: "نسيج القطن", imgUrl: "assets/product2.png"),
        //     CatalogCategoryCardWidget(title: "نسيج القطن", imgUrl: "assets/product2.png"),
        //     CatalogCategoryCardWidget(title: "نسيج القطن", imgUrl: "assets/product2.png"),
        //     CatalogCategoryCardWidget(title: "نسيج القطن", imgUrl: "assets/product2.png"),
        //     CatalogCategoryCardWidget(title: "نسيج القطن", imgUrl: "assets/product2.png"),
        //     CatalogCategoryCardWidget(title: "نسيج القطن", imgUrl: "assets/product2.png"),
        //   ],
        // )
      ],
    ));
  }
}
