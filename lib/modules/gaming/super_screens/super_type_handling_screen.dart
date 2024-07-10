import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:super_app/modules/gaming/super_screens/loading_screen.dart';
import 'package:super_app/modules/gaming/super_screens/super_maza_screen.dart';
import 'package:super_app/modules/gaming/super_screens/super_photo_players_screen.dart';
import 'package:super_app/modules/gaming/super_screens/super_player_clubs_screen.dart';
import 'package:super_app/modules/gaming/super_screens/super_player_clues_screen.dart';
import 'package:super_app/modules/gaming/super_screens/super_random_questions_screen.dart';

class SuperTypeHandlingScreen extends StatefulWidget {
  const SuperTypeHandlingScreen({super.key});

  @override
  State<SuperTypeHandlingScreen> createState() =>
      _SuperTypeHandlingScreenState();
}

class _SuperTypeHandlingScreenState extends State<SuperTypeHandlingScreen> {
  bool isLoading = true;

  bool showClues = false;
  bool showMazyra = false;
  bool showMaza = false;
  bool showPhoto = false;
  bool showRandom = false;

  String errMsg = "";

  @override
  void initState() {
    super.initState();
    _checkForNewVersion();
  }

  Future<void> _checkForNewVersion() async {
    setState(() {
      isLoading = true;
    });
    try {
      // Fetch version and control values from GPControll collection
      DocumentSnapshot versionDoc = await FirebaseFirestore.instance
          .collection('GPControll')
          .doc('XgA333X4OmrDAcEARoAZ')
          .get();

      bool clues = versionDoc.get('clues');
      bool masyra = versionDoc.get('masyra');
      bool maza = versionDoc.get('maza');
      bool photo = versionDoc.get('photo');
      bool random = versionDoc.get('random');

      setState(() {
        showClues = clues;
        showMazyra = masyra;
        showMaza = maza;
        showPhoto = photo;
        showRandom = random;
      });
    } on FirebaseException catch (e) {
      log('Error fetching data: $e');
      setState(() {
        errMsg = "There is an unexpected error!";
      });
    } catch (e) {
      log('Error fetching data: $e');
      setState(() {
        errMsg = "There is an unexpected error!";
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: LoadingScreen(
        isLoading: isLoading,
        child: Scaffold(
          backgroundColor: const Color.fromRGBO(26, 27, 47, 1),
          body: isLoading
              ? const Center(child: CircularProgressIndicator())
              : errMsg.isEmpty
                  ? Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          if (showClues)
                            CustomButton(
                                fun: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            const SuperPlayerCluesScreen(),
                                      ));
                                },
                                txt: "من اللاعب؟"),

                          if (showMaza)
                            CustomButton(
                                fun: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            const SuperMazaScreen(),
                                      ));
                                },
                                txt: "ماذا تعرف؟"),
                          if (showPhoto)
                            CustomButton(
                                fun: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            const SuperPhotoPlayersScreen(),
                                      ));
                                },
                                txt: "مين فى الصورة؟"),
                          if (showMazyra)
                            CustomButton(
                                fun: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            const SuperPlayerClubsScreen(),
                                      ));
                                },
                                txt: "مسيرة لاعبين"),
                          if (showRandom)
                            CustomButton(
                                fun: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            const SuperRandomQuestionsScreen(),
                                      ));
                                },
                                txt: "اسئلة عشوائية"),
                        ],
                      ),
                    )
                  : Center(
                      child: Text(
                        errMsg,
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
        ),
      ),
    );
  }
}

class ScoreText extends StatelessWidget {
  const ScoreText({
    super.key,
    required this.userTotalScore,
  });

  final int userTotalScore;

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        children: [
          const TextSpan(
            text: 'Your last total score: ',
            style: TextStyle(color: Colors.white),
          ),
          TextSpan(
            text: userTotalScore.toString(),
            style: const TextStyle(
              color: Colors.lightGreenAccent,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
        ],
      ),
    );
  }
}

class CustomButton extends StatelessWidget {
  final VoidCallback fun;
  final String txt;
  const CustomButton({
    super.key,
    required this.fun,
    required this.txt,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: fun,
      child: Container(
        alignment: Alignment.center,
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 20.0),
        decoration: const BoxDecoration(
          color: Color.fromRGBO(49, 71, 94, 1),
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
        ),
        child: Text(
          txt,
          style:
              const TextStyle(color: Colors.white, fontWeight: FontWeight.w900),
        ),
      ),
    );
  }
}
