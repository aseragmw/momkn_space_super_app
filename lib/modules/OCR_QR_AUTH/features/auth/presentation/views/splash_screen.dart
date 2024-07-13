import 'package:flutter/material.dart';
import 'package:super_app/modules/OCR_QR_AUTH/features/auth/presentation/views/on_boarding_screen.dart';

import '../../../../../../shared/app_constants.dart';
import '../../../home/presentation/views/agent_home_view.dart';
import '../../../home/presentation/views/consumer_home_view.dart';
import 'login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  void _checkLoginStatus() async {
    await Future.delayed(const Duration(seconds: 2));

    final user = AppConstants.cachedCurrentUserObject;

    if (user != null) {
      if (user.permission!.consumer!) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => const ConsumerHomeView(),
          ),
        );
      } else {
         Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => const AgentHomeView(),
          ),
        );
      }
    } else {
      // No user is signed in
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const OnBoardingScreen(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
