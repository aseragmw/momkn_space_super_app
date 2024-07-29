import 'dart:async';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:super_app/modules/Ordering_Notifications/core/extentions/screen_size.dart';
import 'package:super_app/modules/Ordering_Notifications/core/utils/app_theme.dart';
import 'package:super_app/modules/gaming/super_consts/strings.dart';

import '../gaming_cache_helper.dart';

class SuperPlayerCluesScreen extends StatefulWidget {
  const SuperPlayerCluesScreen({super.key});

  @override
  State<SuperPlayerCluesScreen> createState() => _SuperPlayerCluesScreenState();
}

class _SuperPlayerCluesScreenState extends State<SuperPlayerCluesScreen> {
  List<String> clues = [];
  String answer = "";
  int clueIndex = 0;
  int score = 0;
  bool isLoading = true;
  String errorMessage = '';
  late ClueTimerController _clueTimerController;
  List<String> possibleAnswers = [];
  List<String> filteredAnswers = [];
  final TextEditingController _answerController = TextEditingController();
  Timer? _checkLastVisitTimer;

  @override
  void initState() {
    super.initState();
    _checkLastVisit(); // newCode
    _clueTimerController = ClueTimerController();
    _fetchClues();
    _fetchAnswers();
  }


  @override
  void dispose() { // newCode
    _storeLastVisitTimestamp();
    _checkLastVisitTimer?.cancel();
    super.dispose();
  }

  Future<void> _storeLastVisitTimestamp() async {  // newCode
    final currentTime = DateTime.now().millisecondsSinceEpoch;
    await GamingCacheHelper.saveData(key: "lastVisitTimestampToClues", value: currentTime);
  }
  Future<void> _checkLastVisit() async {  // newCode
    _checkLastVisitTimer = Timer(Duration.zero, () async {
      final lastVisit = GamingCacheHelper.getData(key: "lastVisitTimestampToClues") ?? 0;
      final currentTime = DateTime.now().millisecondsSinceEpoch;

      if (currentTime - lastVisit < 12 * 60 * 60 * 1000) {
        if (mounted) {
          Fluttertoast.showToast(
            msg: "You can only access this screen once every 12 hours.",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.TOP,
            backgroundColor: Colors.red,
            textColor: Colors.white,
          );
          Navigator.of(context).pop();
        }
      }
    });
  }

  Future<void> _fetchClues() async {
    try {
      final docSnapshot = await FirebaseFirestore.instance
          .collection('GPClues')
          .doc('pmmuFMcmUFH9L1sFPPeD')
          .get();
      if (docSnapshot.exists) {
        final data = docSnapshot.data()!;
        if (mounted) {
          setState(() {
            clues = [
              data['clue1'],
              data['clue2'],
              data['clue3'],
              data['clue4'],
              data['clue5']
            ];
            answer = data['answer'];
            isLoading = false;
          });
        }
      } else {
        if (mounted) {
          setState(() {
            errorMessage = "Document does not exist.";
            isLoading = false;
          });
        }
      }
    } on FirebaseException catch (e) {
      log("Firebase error: $e");
      if (mounted) {
        setState(() {
          errorMessage = "Failed to fetch clues: ${e.message}";
          isLoading = false;
        });
      }
    } catch (e) {
      log("Error: $e");
      if (mounted) {
        setState(() {
          errorMessage = "An unexpected error occurred.";
          isLoading = false;
        });
      }
    }
  }

  Future<void> _fetchAnswers() async {
    try {
      setState(() {
        isLoading = true;
      });
      final docSnapshot = await FirebaseFirestore.instance
          .collection('GPControll')
          .doc('XgA333X4OmrDAcEARoAZ')
          .get();
      if (docSnapshot.exists) {
        final data = docSnapshot.data()!;
        if (mounted) {
          setState(() {
            possibleAnswers = List<String>.from(data['answers']);
            // newCode
            possibleAnswers.addAll(SuperStringsClass.appAnswers);
            // newCode
          });
        }
      } else {
        if (mounted) {
          setState(() {
            errorMessage = "Answers document does not exist.";
          });
        }
      }
    } on FirebaseException catch (e) {
      log("Firebase error: $e");
      if (mounted) {
        setState(() {
          errorMessage = "Failed to fetch answers: ${e.message}";
        });
      }
    } catch (e) {
      log("Error: $e");
      if (mounted) {
        setState(() {
          errorMessage = "An unexpected error occurred.";
        });
      }
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  void _addClue() {
    if (clueIndex < clues.length - 1) {
      setState(() {
        clueIndex++;
      });
      _clueTimerController.resetTimer();
      Fluttertoast.showToast(
        msg: "New Clue Available!",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.TOP,
        backgroundColor: Colors.green,
        textColor: Colors.white,
      );
    }
  }

  void _navigateToTypeHandlingScreen() {
    _calcScore();  // newCode
    Navigator.of(context).pop();
  }

  void _submitAnswer(String userAnswer) {
    setState(() {
      _answerController.text = userAnswer;
    });
  }

  void _calcScore() async {
    if (_answerController.text.trim().toLowerCase() ==
        answer.trim().toLowerCase()) {
      // newCode
      int lastScore = GamingCacheHelper.getData(key: "lastScore") ?? 0;
      int currentScore = lastScore + 3;
      await GamingCacheHelper.saveData(key: "lastScore", value: currentScore);
      // newCode
      Fluttertoast.showToast(
          msg: "Excellent! you got 3 points",
          toastLength: Toast.LENGTH_SHORT,
          textColor: Colors.green,
          gravity: ToastGravity.TOP);
    } else {
      Fluttertoast.showToast(
          msg: "Wrong answer try again!",
          toastLength: Toast.LENGTH_SHORT,
          textColor: Colors.red,
          gravity: ToastGravity.TOP);
    }
  }

  void _skipQuestion() {
    _submitAnswer(_answerController.text);
    _navigateToTypeHandlingScreen();
  }

  void _filterAnswers(String input) {
    setState(() {
      if (input.trim().isEmpty) {
        filteredAnswers = [];
      } else {
        filteredAnswers = possibleAnswers
            .where((answer) =>
            answer.toLowerCase().contains(input.trim().toLowerCase())) // newCode
            .toList();
      }
    });
  }




  @override
  Widget build(BuildContext context) {
    int userScore = GamingCacheHelper.getData(key: "lastScore") ?? 0;
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppTheme.screenBackgroundColor,
        body: isLoading
            ? const Center(
                child: CircularProgressIndicator(
                color: AppTheme.primaryGreenColor,
              ))
            : errorMessage.isNotEmpty
                ? Center(
                    child:
                        Text(errorMessage, style: TextStyle(color: Colors.red)))
                : SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(0),
                      child: Column(
                        children: [
                          Container(
                            height: MediaQuery.of(context).size.height * 0.21,
                            decoration: const BoxDecoration(
                                color: AppTheme.transparentColor),
                            child: Stack(children: [
                              Container(
                                decoration: const BoxDecoration(
                                    color: Color(0xFF0A271D),
                                    borderRadius: BorderRadius.only(
                                        bottomLeft: Radius.circular(40),
                                        bottomRight: Radius.circular(40))),
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
                                  ],
                                ),
                              ),
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Padding(
                                  padding:  EdgeInsets.only(left: context.screenAspectRatio*10),
                                  child: InkWell(
                                    onTap: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: Icon(Icons.arrow_back_ios_new,color: AppTheme.whiteColor,size: context.screenAspectRatio*16,),
                                  ),
                                ),
                              )
                            ]),
                          ),
                          Text("Your score is $userScore",style:  TextStyle(
                              color: AppTheme.orangeColor,
                              fontWeight: FontWeight.w800,fontSize: AppTheme.fontSize18(context)),),
                          const SizedBox(height: 10),

                          ClueTimer(
                            onTimeUp: () {
                              if (clueIndex < clues.length - 1) {
                                setState(() {
                                  clueIndex++;
                                });
                                _clueTimerController.resetTimer();
                                Fluttertoast.showToast(
                                  msg: "New Clue Available!",
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.TOP,
                                  backgroundColor: AppTheme.primaryGreenColor,
                                  textColor: Colors.white,
                                );
                              } else {
                                _navigateToTypeHandlingScreen();
                              }
                            },
                            controller: _clueTimerController,
                          ),
                          const SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              SizedBox(
                                width: 150,
                                child: ElevatedButton(
                                  onPressed: _skipQuestion,
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: AppTheme.orangeColor),
                                  child: const Text(
                                    "Skip question",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w700),
                                  ),
                                ),
                              ),
                              if (clueIndex < clues.length - 1)
                                SizedBox(
                                  width: 150,
                                  child: ElevatedButton(
                                    onPressed: _addClue,
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor: AppTheme.orangeColor),
                                    child: const Text(
                                      "Add clue",
                                      style: TextStyle(
                                          color: AppTheme.whiteColor,
                                          fontWeight: FontWeight.w700),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          Text(
                            "Your answer is: \t ${_answerController.text}",
                            style: TextStyle(
                                color: AppTheme.primaryGreenColor,
                                fontSize: AppTheme.fontSize18(context)),
                          ),
                          const SizedBox(height: 10),
                          TextField(
                            controller: _answerController,
                            decoration: const InputDecoration(
                              hintText: 'Enter your answer',
                              hintStyle: TextStyle(color: Colors.white),
                              border: OutlineInputBorder(),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.white70),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                              ),
                              fillColor: AppTheme.primaryGreenColor,
                              filled: true,
                            ),
                            style: const TextStyle(color: Colors.white),
                            onChanged: _filterAnswers,
                            onSubmitted: _submitAnswer,
                          ),
                          const SizedBox(height: 10),
                          filteredAnswers.isEmpty
                              ? const SizedBox()
                              : SizedBox(
                                  child: SingleChildScrollView(
                                    child: Wrap(
                                      children: filteredAnswers.map((answer) {
                                        return GestureDetector(
                                          onTap: () {
                                            _answerController.text = answer;
                                            _submitAnswer(answer);
                                          },
                                          child: Container(
                                            padding: const EdgeInsets.all(8.0),
                                            margin: const EdgeInsets.all(4.0),
                                            decoration: BoxDecoration(
                                              color: const Color.fromRGBO(
                                                  49, 71, 94, 1),
                                              borderRadius:
                                                  BorderRadius.circular(8.0),
                                              border: Border.all(
                                                  color: Colors.white70),
                                            ),
                                            child: Text(
                                              answer,
                                              style: const TextStyle(
                                                  color: Colors.white),
                                            ),
                                          ),
                                        );
                                      }).toList(),
                                    ),
                                  ),
                                ),
                          const SizedBox(height: 20),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: List.generate(clueIndex + 1, (index) {
                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Clue ${index + 1} : ",
                                      style: const TextStyle(
                                          color: AppTheme.primaryGreenColor,
                                          fontSize: 20,
                                          fontWeight: FontWeight.w900),
                                    ),
                                    Text(
                                      clues[index],
                                      style: const TextStyle(
                                          color: Colors.black, fontSize: 18),
                                      textAlign: TextAlign.end,
                                    ),
                                  ],
                                ),
                              );
                            }),
                          ),
                        ],
                      ),
                    ),
                  ),
      ),
    );
  }
}

class ClueTimerController {
  late Function() resetTimer;
}

class ClueTimer extends StatefulWidget {
  final VoidCallback onTimeUp;
  final ClueTimerController controller;

  const ClueTimer({required this.onTimeUp, required this.controller, Key? key})
      : super(key: key);

  @override
  _ClueTimerState createState() => _ClueTimerState();
}

class _ClueTimerState extends State<ClueTimer> {
  Timer? _timer;
  int _timeRemaining = SuperStringsClass.clueTime;

  @override
  void initState() {
    super.initState();
    _startTimer();
    widget.controller.resetTimer = resetTimer;
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_timeRemaining > 0) {
          _timeRemaining--;
        } else {
          widget.onTimeUp();
        }
      });
    });
  }

  void resetTimer() {
    setState(() {
      _timeRemaining = SuperStringsClass.clueTime;
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      "Time remaining: ${(_timeRemaining ~/ 60).toString().padLeft(2, '0')}:${(_timeRemaining % 60).toString().padLeft(2, '0')}",
      style: const TextStyle(color: AppTheme.primaryGreenColor),
    );
  }
}
