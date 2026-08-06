import 'dart:math';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/music/music_note.dart';
import '../domain/staff_note_quiz_state.dart';
import 'staff_note_question_service.dart';

final staffNoteQuestionServiceProvider = Provider<StaffNoteQuestionService>((
  Ref ref,
) {
  return StaffNoteQuestionService(random: Random());
});

final staffNoteQuizControllerProvider =
    NotifierProvider<StaffNoteQuizController, StaffNoteQuizState>(
      StaffNoteQuizController.new,
    );

class StaffNoteQuizController extends Notifier<StaffNoteQuizState> {
  late final StaffNoteQuestionService _questionService = ref.read(
    staffNoteQuestionServiceProvider,
  );

  @override
  StaffNoteQuizState build() {
    return StaffNoteQuizState(question: _questionService.generateQuestion());
  }

  void submitAnswer(MusicNote answer) {
    if (state.isAnswered) {
      return;
    }

    final bool isCorrect = state.question.isCorrectAnswer(answer);
    state = state.copyWith(
      selectedAnswer: answer,
      wasLastAnswerCorrect: isCorrect,
      correctAnswerCount: isCorrect
          ? state.correctAnswerCount + 1
          : state.correctAnswerCount,
      wrongAnswerCount: isCorrect
          ? state.wrongAnswerCount
          : state.wrongAnswerCount + 1,
    );
  }

  void nextQuestion() {
    state = state.copyWith(
      question: _questionService.generateQuestion(),
      selectedAnswer: null,
      preserveSelectedAnswer: false,
      wasLastAnswerCorrect: null,
      preserveAnswerResult: false,
    );
  }
}
