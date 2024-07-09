
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:super_app/modules/OCR_QR_AUTH/features/auth/presentation/views/widgets/custome_btn.dart';

import 'login_screen.dart';

class OnBoardingScreen extends StatelessWidget {
  const OnBoardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Center(
            child: Image(
              image: AssetImage("assets/logo.png"),
            ),
          ),
          const Text(
            "Supper App",
            style: TextStyle(
                color: Colors.black, fontSize: 30, fontWeight: FontWeight.bold),
          ),
          const SizedBox(
            height: 110,
          ),
          const SizedBox(
            height: 30,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Center(
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: CustomButton(
                  func: () {
                    Navigator.of(context).pushAndRemoveUntil(
                      CupertinoPageRoute(
                        builder: (BuildContext context) {
                          return const LoginScreen();
                        },
                      ),
                      (_) => false,
                    );
                  },
                  text: "Start",
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
