class QuizQuestion {
  final String id;
  final String questionText;
  final String questionImageUrl; // Kosong = soal tanpa gambar (teks saja)
  final List<String> options; // 4 pilihan jawaban
  final int correctAnswerIndex; // Indeks jawaban yang benar (0 sampai 3)
  final String region; // Kategori wilayah (Sumatera, Jawa, dsb)

  const QuizQuestion({
    required this.id,
    required this.questionText,
    required this.questionImageUrl,
    required this.options,
    required this.correctAnswerIndex,
    required this.region,
  });

  factory QuizQuestion.fromFirestore(String id, Map<String, dynamic> data) {
    return QuizQuestion(
      id: id,
      questionText: data['questionText'] ?? '',
      questionImageUrl: data['questionImageUrl'] ?? '',
      options: List<String>.from(data['options'] ?? []),
      correctAnswerIndex: data['correctAnswerIndex'] ?? 0,
      region: data['region'] ?? 'Umum',
    );
  }
}
