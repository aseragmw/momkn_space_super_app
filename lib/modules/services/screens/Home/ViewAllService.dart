import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/ServiceCategoryResponseEntity.dart';
import '../../domain/useCase/getServicesCategories_useCase.dart';
import '../../domain/useCase/serviceProvider_useCase.dart';
import '../routes.dart';
import 'cubit/home_states.dart';
import 'cubit/home_view_model.dart';

class ViewAllServiceScreen extends StatefulWidget {
  const ViewAllServiceScreen({super.key});

  @override
  State<ViewAllServiceScreen> createState() => _ViewAllServiceScreen();
}

class _ViewAllServiceScreen extends State<ViewAllServiceScreen> {


  HomeScreenViewModel homeViewModel = HomeScreenViewModel(
      categoryUseCase: injectCategoryServiceUseCase(), providerUseCase: injectServiceProviderUseCase());

  @override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {


    return BlocProvider(
        create: (context) => homeViewModel..getAllServiceCategory(),
        child: BlocBuilder<HomeScreenViewModel, HomeStates>(
        builder: (context, state) {
      if (state is HomeLoadingState) {
        return Container(
          color: Colors.white, // Background color
          child: Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
              // Indicator color
              backgroundColor: Colors
                  .white, // Background color of the progress indicator
            ),
          ),
        );
      }
      else if (state is CategorySuccessState) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.black),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            title: Text(
              'Service Categories',
              style: TextStyle(
                  color: Colors.black, fontWeight: FontWeight.bold),
            ),
            centerTitle: true,
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 16.0),
                        decoration: BoxDecoration(
                          color: Colors.white70,
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.search, color: Colors.green),
                            SizedBox(height: 16.0),
                            Expanded(
                              child: TextField(
                                decoration: InputDecoration(
                                  hintText: '  Search..',
                                  border: InputBorder.none,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(width: 16.0),
                    Container(
                      decoration: BoxDecoration(
                        color: Color(0xFF12A770),
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                      child: IconButton(
                        icon: Icon(
                          Icons.filter_list_outlined, color: Colors.white,),
                        onPressed: () {
                          // Filter action
                        },
                        tooltip: 'Filter',
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16.0),
                Expanded(
                  child: ListView.builder(
                    itemCount: homeViewModel.categoryServiceList?.length,
                    itemBuilder: (context, index) {
                      return CategoryItem(category: homeViewModel.categoryServiceList![index]);
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      }
      else{
        return Container(
          color: Colors.white, // Background color
          child: Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
              // Indicator color
              backgroundColor: Colors
                  .white, // Background color of the progress indicator
            ),
          ),
        );
    }

        }
    )
    );
  }
}

class CategoryItem extends StatelessWidget {
  final Category category;

  const CategoryItem({Key? key, required this.category}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Container(
        padding: EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15.0),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 2,
              blurRadius: 5,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 90,
              height: 90,
              decoration: BoxDecoration(
                color: Color(0xFF3DAB25),
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: category.image != null && category.image!.secureUrl != null
                  ? CachedNetworkImage(
                imageUrl:                 category.image!.secureUrl!,

                fit: BoxFit.cover,
                progressIndicatorBuilder: (context, url, downloadProgress) =>
                    CircularProgressIndicator(value: downloadProgress.progress,),
                errorWidget: (context, url, error) => Icon(Icons.error),
              )
              // Image.network(
              //   category.image!.secureUrl!,
              //   fit: BoxFit.cover,
              // )
                  : Icon(
                Icons.ac_unit_rounded,
                color: Colors.white,
                size: 50,
              ),
            ),
            SizedBox(width: 16.0),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    category.categoryEnglishName!,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  SizedBox(height: 8.0),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pushNamed(serviceProviderRoute, arguments: category);
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(Color(0xFF12A770)),
                    ),
                    child: Container(
                      alignment: Alignment.center,
                      width: 70,
                      height: 30,
                      child: Text(
                        'Details',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}