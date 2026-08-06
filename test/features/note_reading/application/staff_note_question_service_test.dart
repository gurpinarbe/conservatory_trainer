import 'dart:math';

import 'package:conservatory_trainer/features/note_reading/application/staff_note_question_service.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('question evaluation accepts the correct answer', () {
    final service = StaffNoteQuestionService(random: Random(11));
    final question = service.generateQuestion();

    expect(question.options, hasLength(4));
    expect(question.isCorrectAnswer(question.targetNote), isTrue);
  });

  test('fixed random source generates the same question deterministically', () {
    final firstService = StaffNoteQuestionService(random: Random(7));
    final secondService = StaffNoteQuestionService(random: Random(7));

    final firstQuestion = firstService.generateQuestion();
    final secondQuestion = secondService.generateQuestion();

    expect(
      firstQuestion.targetNote.midiNoteNumber,
      secondQuestion.targetNote.midiNoteNumber,
    );
    expect(
      firstQuestion.options
          .map((option) => option.midiNoteNumber)
          .toList(growable: false),
      secondQuestion.options
          .map((option) => option.midiNoteNumber)
          .toList(growable: false),
    );
  });
}
