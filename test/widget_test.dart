import 'package:flutter_test/flutter_test.dart';
import 'package:griyanusantara/models/quiz_question.dart';

void main() {
  group('QuizQuestion Model Tests', () {
    test('should correctly parse Firestore data', () {
      final mockData = {
        'questionText': 'Apa nama rumah adat Sumatera Barat?',
        'questionImageUrl': 'https://example.com/image.jpg',
        'options': ['Gadang', 'Joglo', 'Limas', 'Tongkonan'],
        'correctAnswerIndex': 0,
        'region': 'Sumatera',
      };

      final question = QuizQuestion.fromFirestore('q1', mockData);

      expect(question.id, 'q1');
      expect(question.questionText, 'Apa nama rumah adat Sumatera Barat?');
      expect(question.questionImageUrl, 'https://example.com/image.jpg');
      expect(question.options.length, 4);
      expect(question.options[0], 'Gadang');
      expect(question.correctAnswerIndex, 0);
      expect(question.region, 'Sumatera');
    });

    test('should fall back to default values when fields are missing', () {
      final mockData = <String, dynamic>{};
      final question = QuizQuestion.fromFirestore('q2', mockData);

      expect(question.id, 'q2');
      expect(question.questionText, '');
      expect(question.questionImageUrl, '');
      expect(question.options, isEmpty);
      expect(question.correctAnswerIndex, 0);
      expect(question.region, 'Umum');
    });
  });
}
