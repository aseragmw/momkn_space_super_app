import 'package:dartz/dartz.dart';
import 'package:super_app/modules/services/data/repository/repository/service_repo.dart';
import 'package:super_app/modules/services/domain/entities/agentCalenderEntity.dart';
import '../../data/api/baseError.dart';
import '../../data/api/api_manager.dart';
import '../../data/repository/dataSource/service_dataSource.dart';
import '../repository/dataSource/service_dataSource.dart';
import '../repository/repository/service_repo.dart';

class GetAgentCalenderUseCase{

  ServiceRepoContract repoContract;
  GetAgentCalenderUseCase({required this.repoContract});

  Future<Either<BaseError, AgentCalenderEntity>> invoke(String? id){
    return repoContract.getAllAgentCalenders(id!);
  }

}

GetAgentCalenderUseCase injectAgentCalenderUseCase(){
  return GetAgentCalenderUseCase(repoContract: injectAgentCalenderRepoContract());
}

ServiceRepoContract injectAgentCalenderRepoContract(){
  return ServiceRepoImpl(remoteDataSource: injectAgentCalenderDatasource());
}

ServiceRemoteDataSource injectAgentCalenderDatasource(){
  return ServiceRemoteDataSourceImpl(apiManager: ApiManager.getInstance());
}