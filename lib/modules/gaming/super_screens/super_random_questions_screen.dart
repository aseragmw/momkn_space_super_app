import 'dart:async';
import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:super_app/modules/gaming/super_consts/strings.dart';

class SuperRandomQuestionsScreen extends StatefulWidget {
  const SuperRandomQuestionsScreen({
    super.key,
  });

  @override
  State<SuperRandomQuestionsScreen> createState() =>
      _SuperRandomQuestionsScreenState();
}

class _SuperRandomQuestionsScreenState
    extends State<SuperRandomQuestionsScreen> {
  List<String> questions = List.filled(6, '');
  List<String> answers = List.filled(6, '');
  List<String> userAnswers = List.filled(6, '');
  List<bool> answeredCorrectly = List.filled(6, false);
  List<String> possibleAnswers = [];
  List<String> filteredAnswers = [];
  int activeTextFieldIndex = -1;
  bool isLoading = true;
  String errorMessage = '';
  late ClueTimerController _clueTimerController;
  final List<TextEditingController> _answerControllers = List.generate(
    6,
    (_) => TextEditingController(),
  );

  @override
  void initState() {
    super.initState();
    _clueTimerController = ClueTimerController();
    _fetchData();
    _fetchPossibleAnswers();
  }

  Future<void> _fetchData() async {
    try {
      final docSnapshot = await FirebaseFirestore.instance
          .collection('GPRandomQ')
          .doc('K6ALgIwHzqOzdNuvmD5e')
          .get();
      if (docSnapshot.exists) {
        final data = docSnapshot.data()!;
        setState(() {
          for (int i = 0; i < 6; i++) {
            questions[i] = data['q${i + 1}'];
            answers[i] = data['a${i + 1}'];
          }
          isLoading = false;
        });
      } else {
        setState(() {
          errorMessage = "Document does not exist.";
          isLoading = false;
        });
      }
    } on FirebaseException catch (e) {
      log("Firebase error: $e");
      setState(() {
        errorMessage = "Failed to fetch data: ${e.message}";
        isLoading = false;
      });
    } catch (e) {
      log("Error: $e");
      setState(() {
        errorMessage = "An unexpected error occurred.";
        isLoading = false;
      });
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
        setState(() {
          possibleAnswers = List<String>.from(data['answers']);
        });
      } else {
        setState(() {
          errorMessage = "Answers document does not exist.";
        });
      }
    } on FirebaseException catch (e) {
      log("Firebase error: $e");
      setState(() {
        errorMessage = "Failed to fetch answers: ${e.message}";
      });
    } catch (e) {
      log("Error: $e");
      setState(() {
        errorMessage = "An unexpected error occurred.";
      });
    }
  }

  void _navigateToAnotherScreen() {
    Navigator.of(context).pop();
  }

  void _submitAnswer(int questionIndex, String userAnswer) {
    if (userAnswer.trim().isEmpty) return;

    setState(() {
      userAnswers[questionIndex] = userAnswer;
      if (_checkAnswer(answers[questionIndex], userAnswer)) {
        if (!answeredCorrectly[questionIndex]) {
          answeredCorrectly[questionIndex] = true;
          Fluttertoast.showToast(
              msg: "Excellent!",
              toastLength: Toast.LENGTH_SHORT,
              textColor: Colors.green,
              gravity: ToastGravity.TOP);
        }
      } else {
        if (answeredCorrectly[questionIndex]) {
          answeredCorrectly[questionIndex] = false;
        }
        Fluttertoast.showToast(
            msg: "Wrong answer try again!",
            toastLength: Toast.LENGTH_SHORT,
            textColor: Colors.red,
            gravity: ToastGravity.TOP);
      }
    });
  }

  bool _checkAnswer(String correctAnswer, String userAnswer) {
    return correctAnswer.trim().toLowerCase() ==
        userAnswer.trim().toLowerCase();
  }

  void _skipQuestion() {
    _navigateToAnotherScreen();
  }

  void _filterAnswers(String input, int index) {
    setState(() {
      activeTextFieldIndex = index;
      if (input.trim().isEmpty) {
        filteredAnswers = [];
      } else {
        filteredAnswers = possibleAnswers
            .where((answer) =>
                answer.toLowerCase().startsWith(input.trim().toLowerCase()))
            .toList();
      }
    });
  }

  void _clearFilteredAnswers() {
    setState(() {
      filteredAnswers = [];
      activeTextFieldIndex = -1;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color.fromRGBO(26, 27, 47, 1),
        body: isLoading
            ? const Center(child: CircularProgressIndicator())
            : errorMessage.isNotEmpty
                ? Center(
                    child: Text(
                      errorMessage,
                      style: const TextStyle(color: Colors.red),
                    ),
                  )
                : SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          
                          const SizedBox(height: 10),
                          ClueTimer(
                            onTimeUp: _skipQuestion,
                            controller: _clueTimerController,
                          ),
                          const SizedBox(height: 20),
                          for (int i = 0; i < questions.length; i++)
                            _buildQuestionWidget(
                                i, questions[i], userAnswers[i]),
                          const SizedBox(height: 20),
                          
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: _skipQuestion,
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    const Color.fromARGB(255, 76, 98, 124),
                              ),
                              child: const Text(
                                "Skip question",
                                style: TextStyle(
                                  color: Colors.red,
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

  Widget _buildQuestionWidget(
      int questionIndex, String question, String userAnswer) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(6.0),
          decoration: const BoxDecoration(
            color: Color.fromARGB(255, 41, 53, 67),
          ),
          child: Text(
            question,
            style: const TextStyle(color: Colors.white),
            textAlign: TextAlign.end,
          ),
        ),
        if (userAnswer.isNotEmpty)
          Padding(
            padding: const EdgeInsets.all(6.0),
            child: Text(
              "Your Answer: $userAnswer",
              style: const TextStyle(color: Colors.green),
            ),
          ),
        Focus(
          onFocusChange: (hasFocus) {
            if (!hasFocus) {
              _clearFilteredAnswers();
            }
          },
          child: TextField(
            controller: _answerControllers[questionIndex],
            decoration: const InputDecoration(
              hintText: 'Enter your answer',
              hintStyle: TextStyle(color: Colors.white70),
              border: OutlineInputBorder(),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.white70),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.white),
              ),
              fillColor: Color.fromRGBO(49, 71, 94, 1),
              filled: true,
            ),
            style: const TextStyle(color: Colors.white),
            onChanged: (value) => _filterAnswers(value, questionIndex),
            onSubmitted: (value) => _submitAnswer(questionIndex, value),
          ),
        ),
        if (activeTextFieldIndex == questionIndex)
          Wrap(
            children: filteredAnswers.map((answer) {
              return GestureDetector(
                onTap: () {
                  _answerControllers[questionIndex].text = answer;
                  _submitAnswer(
                    questionIndex,
                    _answerControllers[questionIndex].text,
                  );
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 6.0,
                    horizontal: 10.0,
                  ),
                  margin: const EdgeInsets.symmetric(
                    vertical: 4.0,
                    horizontal: 2.0,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.blueAccent,
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Text(
                    answer,
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              );
            }).toList(),
          ),
        const SizedBox(height: 10),
      ],
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
  int _timeRemaining = SuperStringsClass.randomTime;

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
      _timeRemaining = SuperStringsClass.randomTime;
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
      style: const TextStyle(color: Colors.white),
    );
  }
}
