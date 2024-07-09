import 'dart:convert';

import 'package:barcode_widget/barcode_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:super_app/modules/Ordering_Notifications/core/extentions/screen_size.dart';
import 'package:super_app/modules/Ordering_Notifications/core/extentions/string_extensions.dart';

import '../../../../../../shared/app_constants.dart';
import '../../../../../Ordering_Notifications/core/utils/app_theme.dart';
import '../../../../../Ordering_Notifications/core/utils/snackbar_message.dart';
import '../../../../../Ordering_Notifications/core/widgets/custom_circular_progress_indicator.dart';
import '../../../../../Ordering_Notifications/features/ordering/presentation/screens/cart_screen.dart';
import '../../../../../Ordering_Notifications/features/products/presentation/bloc/bloc/products_bloc.dart';
import '../../../../../Ordering_Notifications/features/products/presentation/screens/catalogs_screen.dart';
import '../../../../../Ordering_Notifications/features/products/presentation/screens/categories_screen.dart';
import '../../../../../Ordering_Notifications/features/profile/presentation/screens/profile_screen.dart';
import '../../../../../services/domain/useCase/getServicesCategories_useCase.dart';
import '../../../../../services/domain/useCase/serviceProvider_useCase.dart';
import '../../../../../services/screens/Home/cubit/home_states.dart';
import '../../../../../services/screens/Home/cubit/home_view_model.dart';
import '../../../../../services/screens/routes.dart';
import '../../../../constants.dart';

class ConsumerHomeView extends StatefulWidget {
  const ConsumerHomeView({super.key});
  static const String routeName = 'ConsumerHomeView';

  @override
  State<ConsumerHomeView> createState() => _ConsumerHomeViewState();
}

class _ConsumerHomeViewState extends State<ConsumerHomeView> {
  HomeScreenViewModel homeViewModel =
      HomeScreenViewModel(categoryUseCase: injectCategoryServiceUseCase(), providerUseCase: injectServiceProviderUseCase());

  @override
  void initState() {
    super.initState();
    homeViewModel.getAllServiceCategory();
  }

  final cardColors = [AppTheme.orangeColor, AppTheme.lightGreenColor, AppTheme.mustardColor, AppTheme.primaryGreenColor];

  @override
  Widget build(BuildContext context) {
    context.read<ProductsBloc>().add(const GetCatalogsCategoriesSubCategoriesEvent());

    return BlocProvider(
      create: (context) => homeViewModel,
      child: BlocBuilder<HomeScreenViewModel, HomeStates>(
        builder: (context, state) {
          if (state is HomeLoadingState) {
            return Container(
              color: Colors.white, // Background color
              child: const Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
                  // Indicator color
                  backgroundColor: Colors.white, // Background color of the progress indicator
                ),
              ),
            );
          } else if (state is CategorySuccessState) {
            return Scaffold(
              floatingActionButton: IconButton(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(builder: (_) => const ProfileScreen()));
                  },
                  icon: Container(
                      padding: EdgeInsets.all(context.screenAspectRatio * 5),
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(100), color: AppTheme.primaryGreenColor),
                      child: Icon(
                        Icons.person,
                        size: context.screenAspectRatio * 17,
                        color: AppTheme.whiteColor,
                      ))),
              backgroundColor: AppTheme.screenBackgroundColor,
              body: GestureDetector(
                onTap: () {
                  FocusScope.of(context).unfocus();
                },
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: MediaQuery.of(context).size.height * 0.25,
                        decoration: const BoxDecoration(color: AppTheme.transparentColor),
                        child: Stack(children: [
                          Container(
                            decoration: const BoxDecoration(
                                color: Color(0xFF0A271D),
                                borderRadius: BorderRadius.only(bottomLeft: Radius.circular(40), bottomRight: Radius.circular(40))),
                            height: context.screenHeight * 0.2,
                            child: Stack(
                              children: [
                                SvgPicture.asset(
                                  "assets/ahly_momkn_bg_home.svg",
                                  width: context.screenWidth,
                                  fit: BoxFit.fill,
                                ),
                                Align(
                                  child: Image.asset(
                                    "assets/logo.png",
                                    height: context.screenAspectRatio * 50,
                                    fit: BoxFit.fill,
                                  ),
                                ),
                                Align(
                                    alignment: Alignment.centerRight,
                                    child: Padding(
                                      padding: EdgeInsets.only(right: context.screenAspectRatio * 15),
                                      child: Icon(
                                        Icons.notifications_outlined,
                                        color: AppTheme.whiteColor,
                                        size: context.screenAspectRatio * 15,
                                      ),
                                    )),
                                Align(
                                    alignment: Alignment.centerLeft,
                                    child: Padding(
                                      padding: EdgeInsets.only(left: context.screenAspectRatio * 15),
                                      child: InkWell(
                                        onTap: () {
                                          Navigator.of(context).push(MaterialPageRoute(builder: (_) => CartScreen()));
                                        },
                                        child: Icon(
                                          Icons.shopping_bag_outlined,
                                          color: AppTheme.whiteColor,
                                          size: context.screenAspectRatio * 15,
                                        ),
                                      ),
                                    )),
                              ],
                            ),
                          ),
                          Positioned(
                            top: context.screenHeight * 0.165,
                            child: Container(
                              margin: EdgeInsets.only(left: context.screenWidth * 0.145),
                              decoration: BoxDecoration(color: const Color(0xffffffff).withOpacity(0.99), borderRadius: AppTheme.boxRadius),
                              padding: EdgeInsets.symmetric(vertical: context.screenAspectRatio * 4, horizontal: context.screenWidth * 0.3),
                              child: InkWell(
                                onTap: () {
                                  showDialog(
                                    context: context,
                                    builder: (context) {
                                      return Padding(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: context.screenWidth * 0.05,
                                          vertical: context.screenHeight * 0.25,
                                        ),
                                        child: Container(
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(30),
                                            color: Colors.white,
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 50,
                                            ),
                                            child: BarcodeWidget(
                                              data: jsonEncode({
                                                "_id": AppConstants.cachedCurrentUserObject!.userID,
                                                "userName": AppConstants.cachedCurrentUserObject!.userName,
                                                "nationalId": AppConstants.cachedCurrentUserObject!.nid!.nationalId,
                                                "location": AppConstants.cachedCurrentUserObject!.nid!.address,
                                                "birthDate": AppConstants.cachedCurrentUserObject!.nid!.birthday,
                                                "gender": AppConstants.cachedCurrentUserObject!.nid!.gender
                                              }),
                                              barcode: Barcode.qrCode(),
                                              color: Constants.primaryGreen,
                                              height: 70,
                                              width: 70,
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                },
                                child: Column(
                                  children: [
                                    SvgPicture.asset(
                                      "assets/qr_code.svg",
                                      height: context.screenAspectRatio * 15,
                                    ),
                                    SizedBox(
                                      height: context.screenAspectRatio,
                                    ),
                                    Text(
                                      "My QR",
                                      style: TextStyle(fontSize: AppTheme.fontSize16(context), fontWeight: AppTheme.fontWeight600),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          )
                        ]),
                      ),
                      SizedBox(
                        height: context.screenAspectRatio * 10,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: context.screenWidth * 0.05,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Bills",
                              style: TextStyle(fontSize: AppTheme.fontSize18(context), fontWeight: AppTheme.fontWeight600),
                            ),
                            SizedBox(
                              height: context.screenAspectRatio * 10,
                            ),
                            const Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                BillWidget(billTitle: "First Bill"),
                                BillWidget(billTitle: "Second Bill"),
                                BillWidget(billTitle: "Third Bill"),
                              ],
                            ),
                            SizedBox(
                              height: context.screenAspectRatio * 20,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Services Booking List",
                                  style: TextStyle(fontSize: AppTheme.fontSize18(context), fontWeight: AppTheme.fontWeight600),
                                ),
                                InkWell(
                                  onTap: () {},
                                  child: Text(
                                    "View all",
                                    style: TextStyle(
                                        fontSize: AppTheme.fontSize14(context),
                                        fontWeight: AppTheme.fontWeight600,
                                        color: AppTheme.primaryGreenColor),
                                  ),
                                )
                              ],
                            ),
                            SizedBox(
                              height: context.screenAspectRatio * 10,
                            ),
                            SizedBox(
                              width: context.screenWidth,
                              height: context.screenHeight * 0.15,
                              child: ListView.builder(
                                physics: const NeverScrollableScrollPhysics(),
                                padding: EdgeInsets.zero,
                                scrollDirection: Axis.horizontal,
                                shrinkWrap: true,
                                itemCount: state.ServiceCategory.data!.length,
                                itemBuilder: (context, index) {
                                  final category = state.ServiceCategory.data![index];
                                  return GestureDetector(
                                      onTap: () {
                                        // Navigate to the appropriate screen based on the category
                                        Navigator.of(context).pushNamed(serviceProviderRoute, arguments: category);
                                      },
                                      child: SizedBox(
                                        child: ServicesBookingWidget(
                                            serviceTitle: category.categoryEnglishName!,
                                            icon: Icons.miscellaneous_services_rounded,
                                            backgroundColor: AppTheme.orangeColor),
                                      ));
                                },
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Catalogs",
                                  style: TextStyle(fontSize: AppTheme.fontSize18(context), fontWeight: AppTheme.fontWeight600),
                                ),
                                InkWell(
                                  onTap: () {
                                    Navigator.of(context).push(MaterialPageRoute(builder: (_) => const CatalogsScreen()));
                                  },
                                  child: Text(
                                    "View all",
                                    style: TextStyle(
                                        fontSize: AppTheme.fontSize14(context),
                                        fontWeight: AppTheme.fontWeight600,
                                        color: AppTheme.primaryGreenColor),
                                  ),
                                )
                              ],
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
                                  return ListView.builder(
                                    physics: const NeverScrollableScrollPhysics(),
                                    padding: EdgeInsets.zero,
                                    shrinkWrap: true,
                                    itemCount: 5,
                                    itemBuilder: (context, index) {
                                      final catalog = state.catalogs[index];
                                      return InkWell(
                                        onTap: () {
                                          Navigator.of(context).push(MaterialPageRoute(
                                            builder: (context) => CategoriesScreen(catalog: catalog),
                                          ));
                                        },
                                        child: OrderNowWidget(
                                            serviceTitle: state.catalogs[index].catalogName,
                                            icon: Icons.shield,
                                            backgroundColor: cardColors[index % 4]),
                                      );
                                    },
                                  );
                                } else {
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
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }
          return const SizedBox();
        },
      ),
    );
  }
}

class BillWidget extends StatelessWidget {
  const BillWidget({super.key, required this.billTitle});
  final String billTitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(200),
            color: AppTheme.lightGreyColor,
            border: Border.all(color: AppTheme.orangeColor),
          ),
          padding: EdgeInsets.all(context.screenAspectRatio * 15),
        ),
        Text(
          billTitle,
          style: TextStyle(fontSize: AppTheme.fontSize14(context), fontWeight: AppTheme.fontWeight500),
        )
      ],
    );
  }
}

class ServicesBookingWidget extends StatelessWidget {
  const ServicesBookingWidget({super.key, required this.serviceTitle, required this.icon, required this.backgroundColor});
  final String serviceTitle;
  final IconData icon;
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
            margin: EdgeInsets.only(bottom: context.screenAspectRatio * 3),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25),
              color: backgroundColor,
            ),
            padding: EdgeInsets.all(context.screenAspectRatio * 10),
            child: Icon(
              icon,
              color: AppTheme.whiteColor,
            )),
        Text(
          serviceTitle.capitalize(),
          style: TextStyle(fontSize: AppTheme.fontSize16(context), fontWeight: AppTheme.fontWeight500),
        )
      ],
    );
  }
}

class OrderNowWidget extends StatelessWidget {
  const OrderNowWidget({super.key, required this.serviceTitle, required this.icon, required this.backgroundColor});
  final String serviceTitle;
  final IconData icon;
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: context.screenAspectRatio * 5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25),
              color: backgroundColor,
            ),
            padding: EdgeInsets.all(context.screenAspectRatio * 15),
          ),
          SizedBox(
            width: context.screenAspectRatio * 5,
          ),
          Text(
            serviceTitle.capitalize(),
            style: TextStyle(fontSize: AppTheme.fontSize16(context), fontWeight: AppTheme.fontWeight500),
          )
        ],
      ),
    );
  }
}
