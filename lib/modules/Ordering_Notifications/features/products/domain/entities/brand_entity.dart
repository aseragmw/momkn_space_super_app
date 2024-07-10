import 'package:super_app/modules/Ordering_Notifications/features/products/domain/entities/sku_entity.dart';

import '../../data/models/sku_model.dart';

class BrandEntity {
final String subCategoryId;
final String brandName;
final List<dynamic>paymentOptions;
final bool brandStatus;
final List<SKUEntity>SKUs;
final String brandId;

  BrandEntity(this.subCategoryId, this.brandName, this.paymentOptions, this.brandStatus, this.SKUs, this.brandId);

}


