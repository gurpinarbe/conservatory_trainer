import '../../../core/music/music_note.dart';
import 'staff_note_question.dart';

class StaffNoteQuizState {
  const StaffNoteQuizState({
    required this.question,
    this.selectedAnswer,
    this.wasLastAnswerCorrect,
    this.correctAnswerCount = 0,
    this.wrongAnswerCount = 0,
  });

  final StaffNoteQuestion question;
  final MusicNote? selectedAnswer;
  final bool? wasLastAnswerCorrect;
  final int correctAnswerCount;
  final int wrongAnswerCount;

  bool get isAnswered => selectedAnswer != null;

  int get totalAnsweredQuestionCount => correctAnswerCount + wrongAnswerCount;

  StaffNoteQuizState copyWith({
    StaffNoteQuestion? question,
    MusicNote? selectedAnswer,
    bool preserveSelectedAnswer = true,
    bool? wasLastAnswerCorrect,
    bool preserveAnswerResult = true,
    int? correctAnswerCount,
    int? wrongAnswerCount,
  }) {
    return StaffNoteQuizState(
      question: question ?? this.question,
      selectedAnswer: preserveSelectedAnswer
          ? selectedAnswer ?? this.selectedAnswer
          : selectedAnswer,
      wasLastAnswerCorrect: preserveAnswerResult
          ? wasLastAnswerCorrect ?? this.wasLastAnswerCorrect
          : wasLastAnswerCorrect,
      correctAnswerCount: correctAnswerCount ?? this.correctAnswerCount,
      wrongAnswerCount: wrongAnswerCount ?? this.wrongAnswerCount,
    );
  }
}
