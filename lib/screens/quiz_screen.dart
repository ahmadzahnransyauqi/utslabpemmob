import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/quiz_provider.dart';
import '../widgets/custom_button.dart';
import '../widgets/option_card.dart';
import 'result_screen.dart';

class QuizScreen extends StatelessWidget {
  const QuizScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final quizProvider = Provider.of<QuizProvider>(context);
    final currentQuestion = quizProvider.questions[quizProvider.currentQuestionIndex];

    return Scaffold(
      appBar: AppBar(
        title: Text('Soal ${quizProvider.currentQuestionIndex + 1}/${quizProvider.questions.length}'),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: Icon(quizProvider.isDarkMode ? Icons.light_mode : Icons.dark_mode),
            onPressed: () => quizProvider.toggleTheme(),
          ),
        ],
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: Padding(
              padding: EdgeInsets.all(mediaQuery.size.width * 0.05),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  LinearProgressIndicator(
                    value: (quizProvider.currentQuestionIndex + 1) / quizProvider.questions.length,
                    borderRadius: BorderRadius.circular(10),
                    minHeight: 8,
                  ),
                  SizedBox(height: mediaQuery.size.height * 0.03),
                  Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Text(
                        currentQuestion.questionText,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: mediaQuery.size.height * 0.02),
                  Expanded(
                    child: ListView.builder(
                      itemCount: currentQuestion.options.length,
                      itemBuilder: (context, index) {
                        final isSelected = quizProvider.userAnswers[quizProvider.currentQuestionIndex] == index;
                        return OptionCard(
                          text: currentQuestion.options[index],
                          isSelected: isSelected,
                          onTap: () => quizProvider.answerQuestion(index),
                        );
                      },
                    ),
                  ),
                  Row(
                    children: [
                      if (quizProvider.currentQuestionIndex > 0)
                        Expanded(
                          child: CustomButton(
                            text: 'Sebelumnya',
                            color: Colors.grey,
                            onPressed: () => quizProvider.previousQuestion(),
                          ),
                        ),
                      if (quizProvider.currentQuestionIndex > 0) const SizedBox(width: 12),
                      Expanded(
                        child: CustomButton(
                          text: quizProvider.currentQuestionIndex == quizProvider.questions.length - 1
                              ? 'Selesai'
                              : 'Selanjutnya',
                          onPressed: () {
                            if (quizProvider.currentQuestionIndex == quizProvider.questions.length - 1) {
                              quizProvider.calculateScore();
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(builder: (context) => const ResultScreen()),
                              );
                            } else {
                              quizProvider.nextQuestion();
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}