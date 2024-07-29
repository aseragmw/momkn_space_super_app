import 'dart:async';
import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:super_app/modules/Ordering_Notifications/core/extentions/screen_size.dart';
import '../../Ordering_Notifications/core/utils/app_theme.dart';

import 'package:super_app/modules/gaming/super_consts/strings.dart';

import '../gaming_cache_helper.dart';

class SuperMazaScreen extends StatefulWidget {
  const SuperMazaScreen({
    super.key,
  });

  @override
  State<SuperMazaScreen> createState() => _SuperMazaScreenState();
}

class _SuperMazaScreenState extends State<SuperMazaScreen> {
  String question = '';
  List<String> answers = [];
  List<String> correctAnswers = [];
  List<String> possibleAnswers = [];
  List<String> filteredAnswers = [];
  bool isLoading = true;
  String errorMessage = '';
  int wrongAttempts = 0;
  late ClueTimerController _clueTimerController;
  final TextEditingController _textController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _checkLastVisit();
    _clueTimerController = ClueTimerController();
    _fetchQuestionData();
    _fetchPossibleAnswers();
  }

  Future<void> _fetchQuestionData() async {
    try {
      final snapshot = await FirebaseFirestore.instance.collection('GPMaza').get();
      final data = snapshot.docs.first.data();
      if (mounted) {
        setState(() {
          question = data['q'];
          answers = List<String>.from(data['answer']);
          isLoading = false;
        });
      }
    } on FirebaseException catch (e) {
      log("Firebase error: $e");
      if (mounted) {
        setState(() {
          errorMessage = "Failed to fetch data: ${e.message}";
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

  Future<void> _fetchPossibleAnswers() async {
    try {
      final docSnapshot = await FirebaseFirestore.instance
          .collection('GPControll')
          .doc('XgA333X4OmrDAcEARoAZ')
          .get();
      if (docSnapshot.exists) {
        final data = docSnapshot.data()!;
        if (mounted) {
          setState(() {
            possibleAnswers = List<String>.from(data['answers']);
            possibleAnswers.addAll(SuperStringsClass.appAnswers);
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
    }
  }

  void _filterAnswers(String query) {
    if (mounted) {
      setState(() {
        filteredAnswers = possibleAnswers
            .where((answer) => answer.toLowerCase().contains(query.toLowerCase()))
            .toList();
      });
    }
  }

  void _submitAnswer(String userAnswer) {
    String formattedAnswer = userAnswer.trim().toLowerCase();

    if (formattedAnswer.isEmpty) {
      Fluttertoast.showToast(msg: 'Please enter an answer.');
      return;
    }

    if (answers
        .map((answer) => answer.trim().toLowerCase())
        .contains(formattedAnswer)) {
      if (correctAnswers
          .map((answer) => answer.trim().toLowerCase())
          .contains(formattedAnswer)) {
        Fluttertoast.showToast(msg: 'This answer has already been given.');
        if (mounted) {
          setState(() {
            wrongAttempts++;
          });
        }
        if (wrongAttempts >= 3) {
          _navigateToAnotherScreen();
        }
      } else {
        if (mounted) {
          setState(() {
            correctAnswers.add(userAnswer.trim().toLowerCase());
          });
        }

        int lastScore = GamingCacheHelper.getData(key: "lastScore") ?? 0;
        int currentScore = lastScore + 1;
        GamingCacheHelper.saveData(key: "lastScore", value: currentScore);
        Fluttertoast.showToast(
            msg: "Excellent! you got 1 points",
            toastLength: Toast.LENGTH_SHORT,
            textColor: Colors.green,
            gravity: ToastGravity.TOP);
      }
    } else {
      Fluttertoast.showToast(
          msg: "Wrong answer try again!",
          toastLength: Toast.LENGTH_SHORT,
          textColor: Colors.green,
          gravity: ToastGravity.TOP);

      if (mounted) {
        setState(() {
          wrongAttempts++;
        });
      }
      if (wrongAttempts >= 3) {
        _navigateToAnotherScreen();
      }
    }
    _textController.clear();
    if (mounted) {
      setState(() {
        filteredAnswers = [];
      });
    }
  }

  void _skipQuestion() async {
    _navigateToAnotherScreen();
  }

  void _navigateToAnotherScreen() {
    Navigator.pop(context);
  }

  Timer? _checkLastVisitTimer;

  @override
  void dispose() {
    _storeLastVisitTimestamp();
    _checkLastVisitTimer?.cancel();
    super.dispose();
  }

  Future<void> _storeLastVisitTimestamp() async {
    final currentTime = DateTime.now().millisecondsSinceEpoch;
    await GamingCacheHelper.saveData(key: "lastVisitTimestampToMaza", value: currentTime);
  }

  Future<void> _checkLastVisit() async {
    _checkLastVisitTimer = Timer(Duration.zero, () async {
      final lastVisit = GamingCacheHelper.getData(key: "lastVisitTimestampToMaza") ?? 0;
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
                    child: Text(
                      errorMessage,
                      style: const TextStyle(color: Colors.red),
                    ),
                  )
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
                          Text("Your score is $userScore", style:  TextStyle(
                              color: AppTheme.orangeColor,
                              fontWeight: FontWeight.w800,fontSize: AppTheme.fontSize18(context)),),
                          const SizedBox(height: 10),

                          const SizedBox(height: 10),
                          wrongAttempts == 0
                              ? const SizedBox()
                              : Container(
                                  width: 150,
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.red),
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: List.generate(
                                      wrongAttempts,
                                      (index) => const Icon(Icons.close,
                                          color: Colors.red, size: 30),
                                    ),
                                  ),
                                ),
                          const SizedBox(height: 20),
                          ClueTimer(
                            onTimeUp: _skipQuestion,
                            controller: _clueTimerController,
                          ),
                          const SizedBox(height: 20),
                          Text(
                            question,
                            style: const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w600),
                            textAlign: TextAlign.end,
                          ),
                          const SizedBox(height: 10),
                          TextField(
                            controller: _textController,
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
                            onChanged: (value) {
                              if (value.isEmpty) {
                                setState(() {
                                  filteredAnswers = [];
                                });
                              } else {
                                _filterAnswers(value);
                              }
                            },
                            onSubmitted: _submitAnswer,
                          ),
                          const SizedBox(height: 20),
                          Wrap(
                            spacing: 8.0,
                            runSpacing: 4.0,
                            children: filteredAnswers.map((answer) {
                              return GestureDetector(
                                onTap: () {
                                  _submitAnswer(answer);
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 5.0, horizontal: 10.0),
                                  decoration: BoxDecoration(
                                    color: Colors.grey[
                                        800], // Adjust the color as needed
                                    borderRadius: BorderRadius.circular(5.0),
                                  ),
                                  child: Text(
                                    answer,
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                          const SizedBox(height: 20),
                          Wrap(
                            spacing: 8.0,
                            runSpacing: 4.0,
                            children: correctAnswers.map((answer) {
                              return Container(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 5.0, horizontal: 10),
                                decoration: BoxDecoration(
                                  color: const Color.fromARGB(255, 41, 53, 67),
                                  borderRadius: BorderRadius.circular(5.0),
                                ),
                                child: Text(
                                  answer,
                                  style: const TextStyle(color: Colors.green),
                                ),
                              );
                            }).toList(),
                          ),
                          const SizedBox(height: 20),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: _skipQuestion,
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    AppTheme.orangeColor,
                              ),
                              child: const Text(
                                "Skip question",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
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
  State<ClueTimer> createState() => _ClueTimerState();
}

class _ClueTimerState extends State<ClueTimer> {
  Timer? _timer;
  int _timeRemaining = SuperStringsClass.mazaTime;

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
      _timeRemaining = SuperStringsClass.mazaTime;
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final minutes = (_timeRemaining ~/ 60).toString().padLeft(2, '0');
    final seconds = (_timeRemaining % 60).toString().padLeft(2, '0');
    return Text(
      "Time remaining: $minutes:$seconds",
      style:  TextStyle(color: AppTheme.primaryGreenColor,fontSize: AppTheme.fontSize18(context)),
    );
  }
}
