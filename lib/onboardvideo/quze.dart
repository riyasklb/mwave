import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/snackbar/snackbar.dart';
import 'package:mwave/constants/colors.dart';

import 'package:mwave/view/bottum_nav_bar.dart';

import 'package:mwave/view/bottumbar1.dart';
class QuizScreen extends StatefulWidget {
  final int videoNumber;

  const QuizScreen({Key? key, required this.videoNumber}) : super(key: key);

  @override
  _QuizScreenState createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  final List<int> _selectedAnswers = [-1, -1, -1, -1, -1]; // 5 questions
  bool _isSubmitted = false;

  // Correct answers mapping
  final Map<int, int> _correctAnswers = {
    1: 1, // Correct answer for Q1 (Video 1)
    2: 2, // Correct answer for Q2 (Video 2)
    3: 1, // Correct answer for Q3 (Video 3)
    4: 1, // Correct answer for Q4 (Video 1)
    5: 1, // Correct answer for Q5 (Video 2)
  };

  @override
  Widget build(BuildContext context) {
    // Define the questions and options based on the video number
    List<Map<String, dynamic>> questions = [];

    if (widget.videoNumber == 1) {
      questions = [
        {
          'question': '1."நீங்கள் மனி வேவ் திட்டத்தில் எவ்வளவு பணத்தை முதலீடு செய்கிறீர்கள்?"',
          'options': ['A.100', 'B.300', 'C.500'],
        },
        {
          'question': '2.மனி வேவ் திட்டத்தில் ஏற்றுக்கொள்ளப்படும் வாக்குறுதிகள் மற்றும் கொள்கைகள் என்ன?',
          'options': [
            'A.ஒருமுறை பணம் செலுத்திய பிறகு, அது திருப்பி அளிக்கப்படாது.',
            'B.நீங்கள் ₹100 செலுத்தினால், 100 நாட்களில் உங்கள் பணத்தைத் திரும்பப் பெறலாம்.',
          ],
        },
      ];
    } else if (widget.videoNumber == 2) {
      questions = [
        {
          'question': '3.மனி வேவ் திட்டத்தில் எவ்வாறு பணம் செலுத்தலாம்?',
          'options': ['A.UPI', 'B.நெட்பேங்கிங்', 'C.ரொக்கம்'],
        },
        {
          'question': '4.பரிந்துரை திட்டத்தில் பங்கேற்க ₹100 செலுத்திய பிறகு நீங்கள் என்ன செய்ய வேண்டும்?',
          'options': [
            'A.உங்கள் நண்பர்கள் மற்றும் குடும்பத்தினருக்கு 2 பேரை பரிந்துரை செய்யுங்கள், ₹100 பெறுவீர்கள்.',
            'B.2 பேருக்கு பரிந்துரை செய்யும் போது ₹300 பெறுவீர்கள்.',
            'C.2 பேருக்கு பரிந்துரை செய்யும் போது ₹1000 பெறுவீர்கள்.',
          ],
        },
      ];
    } else if (widget.videoNumber == 3) {
      questions = [
        {
          'question': '5.நீங்கள் ஒருவரை ஆப் உள்படுத்திய பிறகு, அவர்கள் பிறரை சேர்க்குமா?',
          'options': [
            'A.₹10 சம்பாதிக்கிறீர்கள்.',
            'B.₹30 சம்பாதிக்கிறீர்கள்.',
            'C.₹100 சம்பாதிக்கிறீர்கள்.',
          ],
        },
      ];
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Quiz for Video ${widget.videoNumber}'),
        backgroundColor: kwhite,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Quiz for Video ${widget.videoNumber}',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: kwhite),
              ),
              SizedBox(height: 20),

              // Build questions dynamically
              for (int i = 0; i < questions.length; i++)
                _buildQuestionCard(
                  question: questions[i]['question'],
                  options: questions[i]['options'],
                  questionNumber: i + 1,
                ),

              SizedBox(height: 30),

              // Show Submit button or Next Video button based on submission state
              if (!_isSubmitted) ...[
                Center(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: kwhite,
                      padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    onPressed: () {
                      setState(() {
                        _isSubmitted = true;
                      });

                      // Show Snackbar
                      Get.snackbar(
                        'Quiz Submitted',
                        'Your answers have been submitted.',
                        snackPosition: SnackPosition.BOTTOM,
                        duration: Duration(seconds: 2),
                      );

                      // Wait for 2 seconds and then navigate back
                      Future.delayed(Duration(seconds: 2), () {
                      
                      });
                    },
                    child: Text('Submit Quiz', style: TextStyle(fontSize: 18, color: kblack)),
                  ),
                ),
              ] else if (widget.videoNumber < 3) ...[
                Center(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: kwhite,
                      padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    onPressed: () {
                      // Navigate to the next video
                       Get.back();// Load next video quiz
                    },
                    child: Text('Next Video', style: TextStyle(fontSize: 18, color: kblack)),
                  ),
                ),
              ],

              // Show "Go to Home Screen" button only for Video 3
              if (_isSubmitted && widget.videoNumber == 3) ...[
                SizedBox(height: 20),
                Center(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: kwhite,
                      padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    onPressed: () {
                      // Navigate to Home Screen
                     Get.offAll(BottumNavBar()); // Assuming you have a HomeScreen widget
                    },
                    child: Text('Go to Home Screen', style: TextStyle(fontSize: 18, color: kblack)),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuestionCard({required String question, required List<String> options, required int questionNumber}) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
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
            Column(
              children: List.generate(options.length, (index) {
                return _buildAnswerOption(
                  questionNumber,
                  options[index],
                  _selectedAnswers[questionNumber - 1],
                  index + 1,
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAnswerOption(int questionNumber, String title, int selectedAnswer, int answerValue) {
    bool isCorrect = _isSubmitted && _correctAnswers[questionNumber] == answerValue;
    bool isWrong = _isSubmitted && selectedAnswer == answerValue && selectedAnswer != _correctAnswers[questionNumber];

    return RadioListTile<int>(
      title: Text(
        title,
        style: TextStyle(
          color: isCorrect ? Colors.green : (isWrong ? Colors.red : null),
        ),
      ),
      value: answerValue,
      groupValue: _selectedAnswers[questionNumber - 1],
      onChanged: _isSubmitted ? null : (int? value) {
        setState(() {
          _selectedAnswers[questionNumber - 1] = value!;
        });
      },
    );
  }
}
