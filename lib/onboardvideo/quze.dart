import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mwave/constants/localisation.dart';
import 'package:mwave/view/paymet_screen.dart';

class QuizScreen extends StatefulWidget {
  final int videoNumber;
  final String language; // Pass the language code (e.g., 'en' or 'ta')

  const QuizScreen(
      {Key? key, required this.videoNumber, required this.language})
      : super(key: key);

  @override
  _QuizScreenState createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  final List<int> _selectedAnswers = [0, 0, 0, 0, 0, 0]; // 5 questions
  bool _isSubmitted = false;

  // Correct answers mapping
  final Map<int, int> _correctAnswers = {
    0: 1,
    1: 1, // Correct answer for Q2
    2: 1, // Correct answer for Q3
    3: 0, // Correct answer for Q4
    4: 0, // Correct answer for Q5
  };

  // Track whether the correct answer is blinking
  List<bool> _isCorrectBlinking = [false, false, false, false, false];
  List<bool> _isWrongBlinking = [false, false, false, false, false];

  @override
  Widget build(BuildContext context) {
    // Define the questions and options based on the video number
    List<Map<String, dynamic>> questions = _getQuestions(widget.videoNumber);

    return Scaffold(
      appBar: AppBar(
        title: Text('Quiz for Video ${widget.videoNumber}'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Quiz for Video ${widget.videoNumber}',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),

              // Build questions dynamically
              for (int i = 0; i < questions.length; i++)
                _buildQuestionCard(
                  question: questions[i]['question'],
                  options: questions[i]['options'],
                  questionNumber: i + 1,
                  isCorrectBlinking: _isCorrectBlinking[i],
                  isWrongBlinking: _isWrongBlinking[i],
                ),

              SizedBox(height: 30),

              // Show Submit button or Next Video button based on submission state
              if (!_isSubmitted) ...[
                Center(
                  child: ElevatedButton(
                    onPressed: _submitQuiz,
                    child: Text('Submit Quiz'),
                  ),
                ),
              ] else if (widget.videoNumber < 3) ...[
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      // Navigate to the next video
                      Get.back(); // Load next video quiz
                    },
                    child: Text('Next Video'),
                  ),
                ),
              ],

              // Show "Go to Home Screen" button only for Video 3
              if (_isSubmitted && widget.videoNumber == 3) ...[
                SizedBox(height: 20),
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      // Navigate to Home Screen
                      Get.offAll(
                          PaymentPage()); // Assuming you have a HomeScreen widget
                    },
                    child: Text('Go to Payment Screen'),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  List<Map<String, dynamic>> _getQuestions(int videoNumber) {
    List<Map<String, dynamic>> questions = [];
    if (videoNumber == 1) {
      questions = [
        {
          'question': Localization.getString('question1', widget.language),
          'options': [
            Localization.getString('optionA', widget.language),
            Localization.getString('optionB', widget.language),
            Localization.getString('optionC', widget.language),
          ],
        },
        {
          'question': Localization.getString('question2', widget.language),
          'options': [
            Localization.getString('optionD', widget.language),
            Localization.getString('optionE', widget.language),
          ],
        },
      ];
    } else if (videoNumber == 2) {
      questions = [
        {
          'question': Localization.getString('question5', widget.language),
          'options': [
            Localization.getString('optionL', widget.language),
            Localization.getString('optionM', widget.language),
            Localization.getString('optionN', widget.language),
          ],
        },
        {
          'question': Localization.getString('question4', widget.language),
          'options': [
            Localization.getString('optionI', widget.language),
            Localization.getString('optionJ', widget.language),
            Localization.getString('optionK', widget.language),
          ],
        },
      ];
    } else if (videoNumber == 3) {
      questions = [
        {
          'question': Localization.getString('question3', widget.language),
          'options': [
            Localization.getString('optionF', widget.language),
            Localization.getString('optionG', widget.language),
            Localization.getString('optionH', widget.language),
          ],
        },
      ];
    }
    return questions;
  }

  void _submitQuiz() {
    setState(() {
      _isSubmitted = true;

      for (int i = 0; i < _selectedAnswers.length; i++) {
        if (_selectedAnswers[i] == _correctAnswers[i + 1]) {
          _isCorrectBlinking[i] = true; // Correct answer selected
          _blinkCorrectAnswer(i); // Start blinking effect for correct answer
        } else {
          _isWrongBlinking[i] = true; // Wrong answer selected
          _blinkWrongAnswer(i); // Start blinking effect for wrong answer
        }
      }
    });
  }

  void _blinkCorrectAnswer(int index) {
    Future.delayed(Duration(milliseconds: 500), () {
      setState(() {
        _isCorrectBlinking[index] = false; // Stop blinking after some time
      });
    });
  }

  void _blinkWrongAnswer(int index) {
    Future.delayed(Duration(milliseconds: 500), () {
      setState(() {
        _isWrongBlinking[index] = false; // Stop blinking after some time
      });
    });
  }

  Widget _buildQuestionCard({
    required String question,
    required List<String> options,
    required int questionNumber,
    required bool isCorrectBlinking,
    required bool isWrongBlinking,
  }) {
    return Card(
      elevation: 5,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              question,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            for (int j = 0; j < options.length; j++)
              AnimatedContainer(
                duration: Duration(milliseconds: 300),
                color: _getAnswerColor(
                    j, questionNumber - 1, isCorrectBlinking, isWrongBlinking),
                child: RadioListTile<int>(
                  title: Text(options[j]),
                  value: j, // Option index as value
                  groupValue: _selectedAnswers[questionNumber - 1],
                  onChanged: (value) {
                    setState(() {
                      _selectedAnswers[questionNumber - 1] = value!;
                    });
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }

  Color _getAnswerColor(int optionIndex, int questionIndex,
      bool isCorrectBlinking, bool isWrongBlinking) {
    // Check if the answer is submitted
    if (_isSubmitted) {
      if (optionIndex == _correctAnswers[questionIndex + 1]) {
        return Colors.green
            .withOpacity(0.5); // Correct answer highlighted green
      } else if (optionIndex == _selectedAnswers[questionIndex]) {
        return Colors.red
            .withOpacity(0.5); // Selected wrong answer highlighted red
      }
    }

    // Check blinking effect
    if (isCorrectBlinking &&
        optionIndex == _correctAnswers[questionIndex + 1]) {
      return Colors.green.withOpacity(0.5); // Correct answer blinking green
    } else if (isWrongBlinking &&
        optionIndex == _selectedAnswers[questionIndex]) {
      return Colors.red.withOpacity(0.5); // Wrong answer blinking red
    }

    return Colors.transparent; // Default color
  }
}
