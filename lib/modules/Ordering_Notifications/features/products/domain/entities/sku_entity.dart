import 'package:super_app/modules/Ordering_Notifications/features/products/data/models/sku_model.dart';

class SKUEntity {
  final String brandId;
  final String skuName;
  final String skuDescription;
  final num skuCost;
  final num skuPrice;
  final num skuExtendedPriceOne;
  final num skuExtendedPriceTwo;
  final bool activeSKU;
  final String skuID;

  SKUEntity(this.brandId, this.skuName, this.skuDescription, this.skuCost, this.skuPrice, this.skuExtendedPriceOne, this.skuExtendedPriceTwo, this.activeSKU, this.skuID);
}


