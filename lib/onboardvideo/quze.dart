import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mwave/constants/colors.dart';
import 'package:mwave/constants/localisation.dart';
import 'package:mwave/view/paymet_screen.dart';

class QuizScreen extends StatefulWidget {
  final int videoNumber;
  final String language;

  const QuizScreen({
    Key? key,
    required this.videoNumber,
    required this.language,
  }) : super(key: key);

  @override
  _QuizScreenState createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  final List<int> _selectedAnswers = [0, 0, 0, 0, 0, 0];
  bool _isSubmitted = false;

  final Map<int, int> _correctAnswers = {
    0: 1,
    1: 1,
    2: 1,
    3: 0,
    4: 0,
  };

  List<bool> _isCorrectBlinking = [false, false, false, false, false];
  List<bool> _isWrongBlinking = [false, false, false, false, false];

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, designSize: const Size(500, 800)); // Responsive design
    List<Map<String, dynamic>> questions = _getQuestions(widget.videoNumber);

    return Scaffold(
      // appBar: AppBar(
      //   title: Text(
      //     'Quiz for Video ${widget.videoNumber}',
      //     style: GoogleFonts.roboto(fontSize: 22.sp),
      //   ),
      // ),
      body: Padding(
        padding: EdgeInsets.all(20.w),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [kheight40,
              Text(
                'Quiz for Video ${widget.videoNumber}',
                style: GoogleFonts.poppins(
                  fontSize: 28.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20.h),

              for (int i = 0; i < questions.length; i++)
                _buildQuestionCard(
                  question: questions[i]['question'],
                  options: questions[i]['options'],
                  questionNumber: i + 1,
                  isCorrectBlinking: _isCorrectBlinking[i],
                  isWrongBlinking: _isWrongBlinking[i],
                ),

              SizedBox(height: 30.h),

              if (!_isSubmitted)
                _buildButton('Submit Quiz', _submitQuiz),
              if (_isSubmitted && widget.videoNumber < 3)
                _buildButton('Next Video', () => Get.back()),
              if (_isSubmitted && widget.videoNumber == 3)
                _buildButton(
                  'Go to Payment Screen',
                  () => Get.offAll(PaymentPage()),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildButton(String text, VoidCallback onPressed) {
    return Center(
      child: SizedBox(
      
  width: double.infinity,
        height: 50.h,        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.r),
            ),
            textStyle: GoogleFonts.poppins(fontSize: 20.sp),
          ),
          onPressed: onPressed,
          child: Text(text),
        ),
      ),
    );
  }

  List<Map<String, dynamic>> _getQuestions(int videoNumber) {
    if (videoNumber == 1) {
      return [
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
      return [
        {
          'question': Localization.getString('question5', widget.language),
          'options': [
            Localization.getString('optionL', widget.language),
            Localization.getString('optionM', widget.language),
            Localization.getString('optionN', widget.language),
          ],
        },
      ];
    } else {
      return [
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
  }

  void _submitQuiz() {
    setState(() {
      _isSubmitted = true;

      for (int i = 0; i < _selectedAnswers.length; i++) {
        if (_selectedAnswers[i] == _correctAnswers[i + 1]) {
          _isCorrectBlinking[i] = true;
          _blinkCorrectAnswer(i);
        } else {
          _isWrongBlinking[i] = true;
          _blinkWrongAnswer(i);
        }
      }
    });
  }

  void _blinkCorrectAnswer(int index) {
    Future.delayed(Duration(milliseconds: 500), () {
      setState(() {
        _isCorrectBlinking[index] = false;
      });
    });
  }

  void _blinkWrongAnswer(int index) {
    Future.delayed(Duration(milliseconds: 500), () {
      setState(() {
        _isWrongBlinking[index] = false;
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
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              question,
              style: GoogleFonts.roboto(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10.h),
            for (int j = 0; j < options.length; j++)
              AnimatedContainer(
                duration: Duration(milliseconds: 300),
                color: _getAnswerColor(
                    j, questionNumber - 1, isCorrectBlinking, isWrongBlinking),
                child: RadioListTile<int>(
                  title: Text(options[j], style: GoogleFonts.poppins()),
                  value: j,
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
    if (_isSubmitted) {
      if (optionIndex == _correctAnswers[questionIndex + 1]) {
        return Colors.green.withOpacity(0.5);
      } else if (optionIndex == _selectedAnswers[questionIndex]) {
        return Colors.red.withOpacity(0.5);
      }
    }

    if (isCorrectBlinking &&
        optionIndex == _correctAnswers[questionIndex + 1]) {
      return Colors.green.withOpacity(0.5);
    } else if (isWrongBlinking &&
        optionIndex == _selectedAnswers[questionIndex]) {
      return Colors.red.withOpacity(0.5);
    }

    return Colors.transparent;
  }
}
