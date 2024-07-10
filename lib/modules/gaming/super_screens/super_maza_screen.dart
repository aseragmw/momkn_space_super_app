import 'dart:async';
import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:super_app/modules/gaming/super_consts/strings.dart';

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
    _clueTimerController = ClueTimerController();
    _fetchQuestionData();
    _fetchPossibleAnswers();
  }

  Future<void> _fetchQuestionData() async {
    try {
      final snapshot =
          await FirebaseFirestore.instance.collection('GPMaza').get();
      final data = snapshot.docs.first.data();
      setState(() {
        question = data['q'];
        answers = List<String>.from(data['answer']);
        isLoading = false;
      });
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

  void _filterAnswers(String query) {
    setState(() {
      filteredAnswers = possibleAnswers
          .where(
              (answer) => answer.toLowerCase().startsWith(query.toLowerCase()))
          .toList();
    });
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
        setState(() {
          wrongAttempts++;
        });
        if (wrongAttempts >= 3) {
          _navigateToAnotherScreen();
        }
      } else {
        setState(() {
          correctAnswers.add(userAnswer.trim().toLowerCase());
        });
        Fluttertoast.showToast(
            msg: "Excellent!",
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

      setState(() {
        wrongAttempts++;
      });
      if (wrongAttempts >= 3) {
        _navigateToAnotherScreen();
      }
    }
    _textController.clear();
    setState(() {
      filteredAnswers = [];
    });
  }

  void _skipQuestion() async {
    _navigateToAnotherScreen();
  }

  void _navigateToAnotherScreen() {
    Navigator.pop(context);
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
                                color: Colors.white,
                                fontWeight: FontWeight.w600),
                                textAlign: TextAlign.end,
                          ),
                          const SizedBox(height: 10),
                          TextField(
                            controller: _textController,
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
      style: const TextStyle(color: Colors.white),
    );
  }
}
