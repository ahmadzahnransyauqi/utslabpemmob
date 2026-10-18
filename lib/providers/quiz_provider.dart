import 'package:flutter/material.dart';
import '../models/question_model.dart';

class QuizProvider extends ChangeNotifier {
  String _userName = '';
  int _currentQuestionIndex = 0;
  int _score = 0;
  bool _isDarkMode = false;
  final Map<int, int> _userAnswers = {};

  final List<Question> _questions = [
    Question(
      questionText: 'Apa framework UI lintas platform buatan Google?',
      options: ['React Native', 'Flutter', 'Xamarin', 'Ionic'],
      correctAnswerIndex: 1,
    ),
    Question(
      questionText: 'Bahasa pemrograman yang digunakan oleh Flutter adalah?',
      options: ['Java', 'Kotlin', 'Dart', 'Swift'],
      correctAnswerIndex: 2,
    ),
    Question(
      questionText: 'Widget mana yang digunakan untuk membuat layout vertikal?',
      options: ['Row', 'Column', 'Stack', 'Container'],
      correctAnswerIndex: 1,
    ),
    Question(
      questionText: 'State management apa yang direkomendasikan secara resmi oleh tim Flutter?',
      options: ['Provider', 'Redux', 'MobX', 'GetX'],
      correctAnswerIndex: 0,
    ),
  ];

  String get userName => _userName;
  int get currentQuestionIndex => _currentQuestionIndex;
  int get score => _score;
  bool get isDarkMode => _isDarkMode;
  List<Question> get questions => _questions;
  Map<int, int> get userAnswers => _userAnswers;

  void setUserName(String name) {
    _userName = name;
    notifyListeners();
  }

  void toggleTheme() {
    _isDarkMode = !_isDarkMode;
    notifyListeners();
  }

  void answerQuestion(int optionIndex) {
    _userAnswers[_currentQuestionIndex] = optionIndex;
    notifyListeners();
  }

  void nextQuestion() {
    if (_currentQuestionIndex < _questions.length - 1) {
      _currentQuestionIndex++;
      notifyListeners();
    }
  }

  void previousQuestion() {
    if (_currentQuestionIndex > 0) {
      _currentQuestionIndex--;
      notifyListeners();
    }
  }

  void calculateScore() {
    int correctCount = 0;
    _userAnswers.forEach((index, answer) {
      if (answer == _questions[index].correctAnswerIndex) {
        correctCount++;
      }
    });
    _score = ((correctCount / _questions.length) * 100).round();
    notifyListeners();
  }

  void resetQuiz() {
    _currentQuestionIndex = 0;
    _score = 0;
    _userAnswers.clear();
    notifyListeners();
  }
}