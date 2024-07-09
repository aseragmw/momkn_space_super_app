
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:super_app/modules/services/domain/entities/AgentServiceResponseEntity.dart';
import 'package:super_app/modules/services/domain/useCase/AgentCalender_useCase.dart';

import '../../domain/entities/ServiceEntity.dart';
import '../../domain/useCase/agentServiceById_useCase.dart';
import '../../domain/useCase/getAgentServices_useCase.dart';
import '../../domain/useCase/service_useCase.dart';
import '../routes.dart';
import 'cubit/service_states.dart';
import 'cubit/service_view_model.dart';
class AgentServiceDetailsScreen extends StatefulWidget {
  const AgentServiceDetailsScreen({super.key});

  @override
  _AgentServiceDetailsScreen createState() => _AgentServiceDetailsScreen();
}

class _AgentServiceDetailsScreen extends State<AgentServiceDetailsScreen> {
  ServiceScreenViewModel serviceViewModel = ServiceScreenViewModel(
    agentServiceUseCase: injectAgentServiceUseCase(),
    specificAgentServiceUseCase: injectSpecificAgentServiceUseCase(),
    serviceUseCase: injectServiceUseCase(), agentCalenderUseCase: injectAgentCalenderUseCase(),
  );

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var args = ModalRoute
        .of(context)!
        .settings
        .arguments as Services;


    return BlocProvider(
        create: (context) => serviceViewModel..getAllAgentService(args.id!),
        child: BlocBuilder<ServiceScreenViewModel, ServiceStates>(
            builder: (context, state) {
              if (state is ServiceLoadingState) {
                return Container(
                  color: Colors.white, // Background color
                  child: const Center(
                    child:  CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
                      // Indicator color
                      backgroundColor: Colors
                          .white, // Background color of the progress indicator
                    ),
                  ),
                );
              }
              else if (state is ServiceSuccessState) {
                return Scaffold(
                  appBar: PreferredSize(
                    preferredSize: const Size.fromHeight(211.0),
                    // Set your custom height here
                    child: ClipRRect(
                      borderRadius: const BorderRadius.vertical(
                        bottom: Radius.circular(
                            20.0), // Set your custom border radius here
                      ),
                      child: AppBar(
                        backgroundColor: const Color(0xFFFABE3C),
                        title: const Text('Service Details'
                          ,
                          style: TextStyle(fontSize: 24, color: Colors.white),),
                        leading: IconButton(
                          icon: const Icon(Icons.arrow_back, color: Colors.white,),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                        actions: [
                          GestureDetector(
                            onTap: () {},
                            child: Container(
                              padding: const EdgeInsets.fromLTRB(0, 0, 15, 0),
                              child: Image.asset(
                                'assets/images/save.png',
                                // fit: BoxFit.cover,
                                width: 36,
                                height: 36,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  body: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          args.name!,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'CHECK AVAILABLE DOCTORS',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.green,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Expanded(
                          child: ListView.builder(
                            itemCount: serviceViewModel.agentServiceList?.length ?? 0,
                            itemBuilder: (context, index) {
                              return buildDoctorCard(service: serviceViewModel.agentServiceList![index]);
                            },
                          ),
                        ),

                      ],
                    ),
                  ),
                );
              }
              else {
                return Container(
                  color: Colors.white, // Background color
                  child: const Center(
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

class buildDoctorCard extends StatelessWidget {
  final Service service;

  const buildDoctorCard({super.key,required this.service});
  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color(0xFFFFFFFF),
      shadowColor: const Color(0xFF979797),
      margin: const EdgeInsets.symmetric(vertical: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12.0),
              child: Image.asset(
                'assets/images/doctor.png',
                width: 92,
                height: 92,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    service.agentEnglishName!,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'DMSans'
                    ),
                  ),
                  const SizedBox(height: 25),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                       '${service.serviceAgentfees} EG',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF3DAB25),
                        ),
                      ),
                      const SizedBox(width: 18),
                      ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pushNamed(agentCalenderRoute, arguments:service);
                          },
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(horizontal: 15,vertical: 5),
                            backgroundColor: const Color(0xFF12A770),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(7),
                            ),
                          ),
                          child: const Text(
                            'Set a schedule',
                            style: TextStyle(color: Colors.white,fontSize: 12,fontWeight: FontWeight.bold),
                          ),
                        ),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  }

