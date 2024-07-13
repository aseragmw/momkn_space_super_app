
import 'package:dartz/dartz.dart';
import '../../data/api/baseError.dart';
import '../../data/api/api_manager.dart';
import '../../data/repository/dataSource/service_dataSource.dart';
import '../../data/repository/repository/service_repo.dart';
import '../entities/ServiceCategoryResponseEntity.dart';
import '../repository/dataSource/service_dataSource.dart';
import '../repository/repository/service_repo.dart';

class GetAllCategoriesServiceUseCase{

  ServiceRepoContract repoContract;
  GetAllCategoriesServiceUseCase({required this.repoContract});

  Future<Either<BaseError, ServiceCategoryEntity>> invoke(){
    return repoContract.getAllServiceCategory();
  }

}

GetAllCategoriesServiceUseCase injectCategoryServiceUseCase(){
  return GetAllCategoriesServiceUseCase(repoContract: injectCategoryServiceRepoContract());
}

ServiceRepoContract injectCategoryServiceRepoContract(){
  return ServiceRepoImpl(remoteDataSource: injectCategoryServiceDatasource());
}

ServiceRemoteDataSource injectCategoryServiceDatasource(){
  return ServiceRemoteDataSourceImpl(apiManager: ApiManager.getInstance());
}