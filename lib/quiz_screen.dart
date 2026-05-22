import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async';
import 'dart:math' as math;
import 'models/quiz_question.dart';
import 'app_colors.dart';
import 'utils/badge_utils.dart';

class QuizScreen extends StatefulWidget {
  final String? region;

  const QuizScreen({super.key, this.region});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> with TickerProviderStateMixin {
  int currentQuestionIndex = 0;
  int totalScore = 0;
  int correctAnswersCount = 0;
  int? selectedAnswerIndex;

  /// Status apakah soal sudah dijawab pada percobaan ini
  bool isAnswered = false;

  /// Apakah jawaban yang dipilih benar
  bool isCorrect = false;

  List<QuizQuestion> questions = [];
  bool isLoading = true;

  late AnimationController _questionAnimController;
  late Animation<double> _questionFadeAnim;
  late Animation<Offset> _questionSlideAnim;

  @override
  void initState() {
    super.initState();
    _questionAnimController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _questionFadeAnim = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _questionAnimController, curve: Curves.easeOut),
    );
    _questionSlideAnim =
        Tween<Offset>(begin: const Offset(0.05, 0), end: Offset.zero).animate(
      CurvedAnimation(parent: _questionAnimController, curve: Curves.easeOut),
    );
    _fetchQuestions();
  }

  @override
  void dispose() {
    _questionAnimController.dispose();
    super.dispose();
  }

  void _playQuestionAnim() {
    _questionAnimController.reset();
    _questionAnimController.forward();
  }

  Future<void> _fetchQuestions() async {
    try {
      Query query = FirebaseFirestore.instance.collection('kuis_soal');

      if (widget.region != null && widget.region != 'Random') {
        query = query.where('region', isEqualTo: widget.region);
      }

      final snapshot = await query.get();

      if (snapshot.docs.isNotEmpty) {
        var fetchedQuestions = snapshot.docs
            .map(
              (doc) => QuizQuestion.fromFirestore(
                doc.id,
                doc.data() as Map<String, dynamic>,
              ),
            )
            .toList();

        fetchedQuestions.shuffle();

        if (fetchedQuestions.length > 10) {
          fetchedQuestions = fetchedQuestions.sublist(0, 10);
        }

        if (!mounted) return;
        setState(() {
          questions = fetchedQuestions;
          isLoading = false;
        });
        _playQuestionAnim();
      } else {
        _loadDummyData();
      }
    } catch (e) {
      debugPrint("Error fetching questions: $e");
      _loadDummyData();
    }
  }

  void _loadDummyData() {
    var dummyQuestions = [
      // --- SUMATERA (20 Soal) ---
      QuizQuestion(
        id: 's1',
        region: 'Sumatera',
        questionText:
            'Bagian atap berbentuk tanduk kerbau (gonjong) merupakan ciri khas dari...',
        questionImageUrl: '',
        options: ['Rumah Gadang', 'Rumah Joglo', 'Rumah Honai', 'Rumah Limas'],
        correctAnswerIndex: 0,
      ),
      QuizQuestion(
        id: 's2',
        region: 'Sumatera',
        questionText:
            'Fungsi utama rumah yang berbentuk panggung tinggi di Sumatera adalah untuk...',
        questionImageUrl: '',
        options: [
          'Keindahan estetika',
          'Menghindari binatang buas & banjir',
          'Menyimpan hasil bumi',
          'Tempat beribadah',
        ],
        correctAnswerIndex: 1,
      ),
      QuizQuestion(
        id: 's3',
        region: 'Sumatera',
        questionText:
            'Rumah tradisional Aceh yang memiliki ciri khas tangga masuk di bawah kolong rumah disebut...',
        questionImageUrl: '',
        options: [
          'Rumah Limas',
          'Krong Bade',
          'Rumah Gadang',
          'Rumah Selaso Jatuh Kembar',
        ],
        correctAnswerIndex: 1,
      ),
      QuizQuestion(
        id: 's4',
        region: 'Sumatera',
        questionText:
            'Rumah adat Palembang yang memiliki struktur bertingkat-tingkat untuk menunjukkan strata sosial disebut...',
        questionImageUrl: '',
        options: [
          'Rumah Melayu',
          'Rumah Panggung',
          'Rumah Limas',
          'Rumah Gadang',
        ],
        correctAnswerIndex: 2,
      ),
      QuizQuestion(
        id: 's5',
        region: 'Sumatera',
        questionText:
            'Ukiran khas Minangkabau di dinding Rumah Gadang umumnya bermotif...',
        questionImageUrl: '',
        options: ['Hewan buas', 'Alam dan tumbuhan', 'Senjata', 'Dewa-dewi'],
        correctAnswerIndex: 1,
      ),
      QuizQuestion(
        id: 's6',
        region: 'Sumatera',
        questionText:
            'Rumah Bolon yang berbentuk panggung kayu beratap ijuk adalah rumah tradisional dari suku...',
        questionImageUrl: '',
        options: ['Minangkabau', 'Batak', 'Melayu', 'Nias'],
        correctAnswerIndex: 1,
      ),
      QuizQuestion(
        id: 's7',
        region: 'Sumatera',
        questionText:
            'Lumbung padi tradisional di Minangkabau yang sering berada di depan Rumah Gadang disebut...',
        questionImageUrl: '',
        options: ['Rangkiang', 'Anjungan', 'Gebyok', 'Dalem'],
        correctAnswerIndex: 0,
      ),
      QuizQuestion(
        id: 's8',
        region: 'Sumatera',
        questionText:
            'Rumah adat khas Melayu Riau yang difungsikan sebagai tempat pertemuan adat dan musyawarah disebut...',
        questionImageUrl: '',
        options: [
          'Rumah Selaso Jatuh Kembar',
          'Rumah Gadang',
          'Rumah Bolon',
          'Rumah Bubungan Lima',
        ],
        correctAnswerIndex: 0,
      ),
      QuizQuestion(
        id: 's9',
        region: 'Sumatera',
        questionText:
            'Rumah adat terapung yang didirikan di atas rakit bambu tebal di daerah Bangka Belitung disebut...',
        questionImageUrl: '',
        options: [
          'Rumah Rakit',
          'Rumah Lanting',
          'Rumah Panggung',
          'Rumah Kaki Seribu',
        ],
        correctAnswerIndex: 0,
      ),
      QuizQuestion(
        id: 's10',
        region: 'Sumatera',
        questionText:
            'Nama rumah adat yang menjadi balai pertemuan masyarakat adat di Lampung adalah...',
        questionImageUrl: '',
        options: [
          'Rumah Nuwo Sesat',
          'Rumah Kebaya',
          'Rumah Limas',
          'Rumah Bubungan Lima',
        ],
        correctAnswerIndex: 0,
      ),
      QuizQuestion(
        id: 's11',
        region: 'Sumatera',
        questionText:
            'Rumah adat di Sumatera Barat yang memiliki anjungan di ujung kanan dan kiri bangunan untuk tempat kehormatan adalah tipe...',
        questionImageUrl: '',
        options: [
          'Rumah Gadang Batingkek',
          'Rumah Gadang Koto Piliang',
          'Rumah Gadang Bodi Caniago',
          'Rumah Gadang Kajang Padati',
        ],
        correctAnswerIndex: 1,
      ),
      QuizQuestion(
        id: 's12',
        region: 'Sumatera',
        questionText:
            'Rumah Bubungan Lima merupakan rumah adat dari provinsi...',
        questionImageUrl: '',
        options: ['Bengkulu', 'Jambi', 'Riau', 'Kepulauan Riau'],
        correctAnswerIndex: 0,
      ),
      QuizQuestion(
        id: 's13',
        region: 'Sumatera',
        questionText:
            'Bahan penutup atap yang umum digunakan pada Rumah Bolon Batak Toba tradisional adalah...',
        questionImageUrl: '',
        options: ['Ijuk', 'Seng', 'Genteng Tanah Liat', 'Jerami'],
        correctAnswerIndex: 0,
      ),
      QuizQuestion(
        id: 's14',
        region: 'Sumatera',
        questionText:
            'Rumah adat Belah Bubung merupakan rumah adat khas yang berasal dari...',
        questionImageUrl: '',
        options: [
          'Kepulauan Riau',
          'Bangka Belitung',
          'Aceh',
          'Sumatera Barat',
        ],
        correctAnswerIndex: 0,
      ),
      QuizQuestion(
        id: 's15',
        region: 'Sumatera',
        questionText:
            'Rumah adat Jambi yang atapnya melengkung menyerupai haluan perahu dan memiliki sebutan atap "Gajah Mabuk" adalah...',
        questionImageUrl: '',
        options: [
          'Rumah Panggung (Kajang Lako)',
          'Rumah Krong Bade',
          'Rumah Limas',
          'Rumah Bolon',
        ],
        correctAnswerIndex: 0,
      ),
      QuizQuestion(
        id: 's16',
        region: 'Sumatera',
        questionText:
            'Jumlah anak tangga pada akses masuk utama Rumah Krong Bade di Aceh secara adat harus berjumlah...',
        questionImageUrl: '',
        options: ['Ganjil', 'Genap', 'Bebas', 'Selalu sepuluh'],
        correctAnswerIndex: 0,
      ),
      QuizQuestion(
        id: 's17',
        region: 'Sumatera',
        questionText:
            'Bagian di bawah kolong Rumah Bolon Batak tradisional biasanya difungsikan untuk...',
        questionImageUrl: '',
        options: [
          'Kandang hewan ternak',
          'Tempat musyawarah',
          'Kamar tidur tamu',
          'Dapur utama',
        ],
        correctAnswerIndex: 0,
      ),
      QuizQuestion(
        id: 's18',
        region: 'Sumatera',
        questionText:
            'Ornamen ukiran pada Rumah Gadang Minangkabau dilarang menggambarkan makhluk hidup secara realistis karena...',
        questionImageUrl: '',
        options: [
          'Pengaruh ajaran Islam',
          'Sulit diukir',
          'Bahan kayu yang tidak cocok',
          'Aturan dari masa kolonial',
        ],
        correctAnswerIndex: 0,
      ),
      QuizQuestion(
        id: 's19',
        region: 'Sumatera',
        questionText:
            'Soko atau tiang utama penyangga Rumah Bolon diletakkan di atas batu sandi bertujuan untuk...',
        questionImageUrl: '',
        options: [
          'Ketahanan terhadap gempa bumi',
          'Menghindari rayap saja',
          'Estetika bangunan',
          'Mudah dipindahkan',
        ],
        correctAnswerIndex: 0,
      ),
      QuizQuestion(
        id: 's20',
        region: 'Sumatera',
        questionText:
            'Rumah adat Nuwo Sesat dari Lampung dibangun menghadap ke...',
        questionImageUrl: '',
        options: [
          'Aliran air atau sungai',
          'Arah barat saja',
          'Arah utara saja',
          'Pegunungan terdekat',
        ],
        correctAnswerIndex: 0,
      ),

      // --- JAWA (20 Soal) ---
      QuizQuestion(
        id: 'j1',
        region: 'Jawa',
        questionText:
            'Empat tiang utama penyangga penyangga atap pada Rumah Joglo disebut...',
        questionImageUrl: '',
        options: ['Tiang Tuo', 'Soko Guru', 'Soko Jajar', 'Tiang Seri'],
        correctAnswerIndex: 1,
      ),
      QuizQuestion(
        id: 'j2',
        region: 'Jawa',
        questionText:
            'Bagian teras depan terbuka di Rumah Joglo yang berfungsi menerima tamu disebut...',
        questionImageUrl: '',
        options: ['Pringgitan', 'Pendopo', 'Dalem', 'Sentong'],
        correctAnswerIndex: 1,
      ),
      QuizQuestion(
        id: 'j3',
        region: 'Jawa',
        questionText:
            'Rumah adat tradisional Suku Baduy di Banten yang bentuknya menyesuaikan kontur tanah disebut...',
        questionImageUrl: '',
        options: ['Sulah Nyanda', 'Rumah Kebaya', 'Joglo', 'Kasepuhan'],
        correctAnswerIndex: 0,
      ),
      QuizQuestion(
        id: 'j4',
        region: 'Jawa',
        questionText:
            'Pintu pembatas berukir di rumah tradisional Jawa yang menghubungkan antar ruangan disebut...',
        questionImageUrl: '',
        options: ['Gebyok', 'Tumpang Sari', 'Soko Guru', 'Blandar'],
        correctAnswerIndex: 0,
      ),
      QuizQuestion(
        id: 'j5',
        region: 'Jawa',
        questionText:
            'Atap bersusun yang digunakan di rumah-rumah keraton dan masjid kuno di Jawa disebut atap...',
        questionImageUrl: '',
        options: ['Tajug', 'Limasan', 'Panggang Pe', 'Sinom'],
        correctAnswerIndex: 0,
      ),
      QuizQuestion(
        id: 'j6',
        region: 'Jawa',
        questionText:
            'Rumah adat suku Betawi yang memiliki teras luas disebut...',
        questionImageUrl: '',
        options: [
          'Rumah Kebaya',
          'Rumah Gadang',
          'Rumah Kasepuhan',
          'Rumah Panggung',
        ],
        correctAnswerIndex: 0,
      ),
      QuizQuestion(
        id: 'j7',
        region: 'Jawa',
        questionText:
            'Susunan kayu bertingkat ke atas yang disangga oleh Soko Guru di Rumah Joglo disebut...',
        questionImageUrl: '',
        options: ['Gebyok', 'Dalem', 'Tumpang Sari', 'Pendopo'],
        correctAnswerIndex: 2,
      ),
      QuizQuestion(
        id: 'j8',
        region: 'Jawa',
        questionText:
            'Istana resmi keluarga Keraton Yogyakarta yang berornamen emas dengan lantai marmer disebut...',
        questionImageUrl: '',
        options: [
          'Rumah Bangsal Kencono',
          'Rumah Kasepuhan',
          'Rumah Joglo Situbondo',
          'Rumah Kebaya',
        ],
        correctAnswerIndex: 0,
      ),
      QuizQuestion(
        id: 'j9',
        region: 'Jawa',
        questionText:
            'Rumah adat Jawa Barat yang memadukan budaya Sunda, Hindu, dan kolonial dengan struktur tanpa paku besi adalah...',
        questionImageUrl: '',
        options: [
          'Rumah Kasepuhan Cirebon',
          'Rumah Sulah Nyanda',
          'Rumah Joglo',
          'Rumah Kebaya',
        ],
        correctAnswerIndex: 0,
      ),
      QuizQuestion(
        id: 'j10',
        region: 'Jawa',
        questionText:
            'Ukiran bermotif naga atau bunga (makara) di pintu masuk Joglo Situbondo berfungsi filosofis sebagai...',
        questionImageUrl: '',
        options: [
          'Penolak bala spiritual',
          'Simbol kekayaan',
          'Hiasan biasa',
          'Petunjuk arah mata angin',
        ],
        correctAnswerIndex: 0,
      ),
      QuizQuestion(
        id: 'j11',
        region: 'Jawa',
        questionText:
            'Rumah adat Banten "Sulah Nyanda" menggunakan bahan apa untuk membuat lantai rumah panggungnya?',
        questionImageUrl: '',
        options: [
          'Bilah bambu (talup)',
          'Papan kayu jati',
          'Marmer',
          'Semen cor',
        ],
        correctAnswerIndex: 0,
      ),
      QuizQuestion(
        id: 'j12',
        region: 'Jawa',
        questionText:
            'Rumah adat suku Sunda yang atapnya berbentuk seperti tanduk domba atau segitiga sama kaki disebut...',
        questionImageUrl: '',
        options: [
          'Julang Ngapak',
          'Badak Heuay',
          'Togo Anjing',
          'Capit Gunting',
        ],
        correctAnswerIndex: 0,
      ),
      QuizQuestion(
        id: 'j13',
        region: 'Jawa',
        questionText:
            'Bagian paling belakang pada rumah Joglo Jawa Tengah yang bersifat privat dan digunakan untuk tidur disebut...',
        questionImageUrl: '',
        options: ['Dalem / Omah Jero', 'Pendopo', 'Pringgitan', 'Gebyok'],
        correctAnswerIndex: 0,
      ),
      QuizQuestion(
        id: 'j14',
        region: 'Jawa',
        questionText:
            'Kamar suci di bagian belakang Joglo yang sering dikaitkan dengan pemujaan Dewi Sri (Dewi Padi) disebut...',
        questionImageUrl: '',
        options: [
          'Senthong Tengah',
          'Senthong Kiwa',
          'Senthong Tengen',
          'Pringgitan',
        ],
        correctAnswerIndex: 0,
      ),
      QuizQuestion(
        id: 'j15',
        region: 'Jawa',
        questionText:
            'Pagar kayu setinggi 80 cm di sekeliling teras Rumah Kebaya khas Betawi memiliki makna filosofis sebagai...',
        questionImageUrl: '',
        options: [
          'Batasan moral dan tata krama kesopanan',
          'Penghalau hewan liar',
          'Penyangga atap tambahan',
          'Pajangan estetika belaka',
        ],
        correctAnswerIndex: 0,
      ),
      QuizQuestion(
        id: 'j16',
        region: 'Jawa',
        questionText:
            'Bahan utama penyusun dinding (bilik) pada rumah adat Sulah Nyanda suku Baduy adalah...',
        questionImageUrl: '',
        options: [
          'Anyaman bambu',
          'Batu bata merah',
          'Lempengan batu kali',
          'Papan kayu tebal',
        ],
        correctAnswerIndex: 0,
      ),
      QuizQuestion(
        id: 'j17',
        region: 'Jawa',
        questionText:
            'Bangunan kecil terapung di atas kolam di depan Keraton Kasepuhan Cirebon yang digunakan untuk santai adalah...',
        questionImageUrl: '',
        options: ['Bale Kambang', 'Regol', 'Pakuwon', 'Babancong'],
        correctAnswerIndex: 0,
      ),
      QuizQuestion(
        id: 'j18',
        region: 'Jawa',
        questionText:
            'Pola hiasan pada pinggiran atap Rumah Kebaya Betawi yang berbentuk segitiga bergerigi melambangkan kegagahan disebut...',
        questionImageUrl: '',
        options: [
          'Gigi Balang',
          'Ornamen Banji',
          'Kembang Melati',
          'Pucuk Rebung',
        ],
        correctAnswerIndex: 0,
      ),
      QuizQuestion(
        id: 'j19',
        region: 'Jawa',
        questionText:
            'Di bawah ini yang merupakan tipe Joglo terkecil dan paling sederhana di Jawa Timur adalah...',
        questionImageUrl: '',
        options: [
          'Joglo Situbondo',
          'Joglo Sinom',
          'Joglo Hageng',
          'Joglo Pencu',
        ],
        correctAnswerIndex: 0,
      ),
      QuizQuestion(
        id: 'j20',
        region: 'Jawa',
        questionText:
            'Sistem sambungan kayu tradisional Jawa tanpa menggunakan paku besi melainkan pasak kayu disebut...',
        questionImageUrl: '',
        options: [
          'Sistem Purus dan Knockdown',
          'Sistem Las Kayu',
          'Sistem Kancing Besi',
          'Sistem Lem Selulosa',
        ],
        correctAnswerIndex: 0,
      ),

      // --- KALIMANTAN (20 Soal) ---
      QuizQuestion(
        id: 'k1',
        region: 'Kalimantan',
        questionText:
            'Rumah komunal memanjang Suku Dayak yang bisa menampung puluhan keluarga disebut...',
        questionImageUrl: '',
        options: [
          'Rumah Betang',
          'Rumah Banjar',
          'Rumah Lanting',
          'Rumah Honai',
        ],
        correctAnswerIndex: 0,
      ),
      QuizQuestion(
        id: 'k2',
        region: 'Kalimantan',
        questionText:
            'Rumah Betang umumnya dibangun sejajar atau menghadap ke arah...',
        questionImageUrl: '',
        options: ['Gunung', 'Hutan', 'Sungai', 'Barat'],
        correctAnswerIndex: 2,
      ),
      QuizQuestion(
        id: 'k3',
        region: 'Kalimantan',
        questionText:
            'Rumah Bubungan Tinggi merupakan istana tradisional dari suku...',
        questionImageUrl: '',
        options: ['Dayak Kenyah', 'Banjar', 'Melayu', 'Kutai'],
        correctAnswerIndex: 1,
      ),
      QuizQuestion(
        id: 'k4',
        region: 'Kalimantan',
        questionText:
            'Rumah Lanting adalah rumah unik khas Kalimantan yang dibangun di atas...',
        questionImageUrl: '',
        options: ['Pohon besar', 'Tanah gambut', 'Bukit', 'Air / Sungai'],
        correctAnswerIndex: 3,
      ),
      QuizQuestion(
        id: 'k5',
        region: 'Kalimantan',
        questionText:
            'Tangga masuk pada Rumah Betang tradisional biasanya berupa satu batang pohon utuh yang disebut...',
        questionImageUrl: '',
        options: ['Hejot', 'Undakan', 'Batur', 'Titian'],
        correctAnswerIndex: 0,
      ),
      QuizQuestion(
        id: 'k6',
        region: 'Kalimantan',
        questionText:
            'Rumah Lamin yang sangat luas dengan ukiran khas merah-kuning adalah milik Suku Dayak di provinsi...',
        questionImageUrl: '',
        options: ['Kaltim', 'Kalsel', 'Kalbar', 'Kaltara'],
        correctAnswerIndex: 0,
      ),
      QuizQuestion(
        id: 'k7',
        region: 'Kalimantan',
        questionText:
            'Tujuan arsitektur komunal pada Rumah Betang adalah untuk...',
        questionImageUrl: '',
        options: [
          'Menghemat lahan',
          'Mencari kehangatan',
          'Semangat gotong royong & pertahanan',
          'Hanya meniru tradisi',
        ],
        correctAnswerIndex: 2,
      ),
      QuizQuestion(
        id: 'k8',
        region: 'Kalimantan',
        questionText:
            'Rumah ritual berbentuk lingkaran setinggi 12 meter milik suku Dayak Bidayuh di Kalimantan Barat disebut...',
        questionImageUrl: '',
        options: [
          'Rumah Adat Baluk',
          'Rumah Radakng',
          'Rumah Lamin',
          'Rumah Banjar',
        ],
        correctAnswerIndex: 0,
      ),
      QuizQuestion(
        id: 'k9',
        region: 'Kalimantan',
        questionText:
            'Rumah panggung tradisional suku Dayak Tidung di Kalimantan Utara yang memiliki ukiran khas disebut...',
        questionImageUrl: '',
        options: [
          'Rumah Adat Baloy',
          'Rumah Betang',
          'Rumah Lanting',
          'Rumah Lamin',
        ],
        correctAnswerIndex: 0,
      ),
      QuizQuestion(
        id: 'k10',
        region: 'Kalimantan',
        questionText:
            'Bahan utama yang sangat kuat dan sering digunakan untuk fondasi tiang Rumah Betang karena tahan air adalah kayu...',
        questionImageUrl: '',
        options: ['Kayu Ulin (Besi)', 'Kayu Sengon', 'Kayu Pinus', 'Kayu Jati'],
        correctAnswerIndex: 0,
      ),
      QuizQuestion(
        id: 'k11',
        region: 'Kalimantan',
        questionText:
            'Rumah Radakng merupakan replika rumah panjang Suku Dayak Kanayatn yang didirikan di kota...',
        questionImageUrl: '',
        options: ['Pontianak', 'Banjarmasin', 'Samarinda', 'Balikpapan'],
        correctAnswerIndex: 0,
      ),
      QuizQuestion(
        id: 'k12',
        region: 'Kalimantan',
        questionText:
            'Rumah adat Lanting khas Kalimantan Selatan menggunakan apa agar tetap mengapung secara dinamis?',
        questionImageUrl: '',
        options: [
          'Batang kayu ulin besar atau bambu rakit',
          'Drum besi kedap udara',
          'Pelampung karet sintetis',
          'Semen ringan berongga',
        ],
        correctAnswerIndex: 0,
      ),
      QuizQuestion(
        id: 'k13',
        region: 'Kalimantan',
        questionText:
            'Rumah adat Dayak Kenyah di Kalimantan Timur yang memiliki hiasan patung dan ukiran burung enggang disebut...',
        questionImageUrl: '',
        options: ['Rumah Lamin', 'Rumah Betang', 'Rumah Baluk', 'Rumah Baloy'],
        correctAnswerIndex: 0,
      ),
      QuizQuestion(
        id: 'k14',
        region: 'Kalimantan',
        questionText:
            'Kayu Ulin (kayu besi) sangat populer di arsitektur Kalimantan karena keunggulannya, yaitu...',
        questionImageUrl: '',
        options: [
          'Semakin kuat dan keras jika terkena air',
          'Saras ringan dan elastis',
          'Mudah dibakar untuk perapian',
          'Memiliki aroma wangi yang khas',
        ],
        correctAnswerIndex: 0,
      ),
      QuizQuestion(
        id: 'k15',
        region: 'Kalimantan',
        questionText:
            'Jumlah pintu masuk pada Rumah Radakng atau Rumah Betang yang sangat banyak biasanya menunjukkan...',
        questionImageUrl: '',
        options: [
          'Banyaknya jumlah keluarga/klan yang tinggal',
          'Arah mata angin pelindung',
          'Jumlah hari dalam seminggu',
          'Jumlah musuh yang berhasil dikalahkan',
        ],
        correctAnswerIndex: 0,
      ),
      QuizQuestion(
        id: 'k16',
        region: 'Kalimantan',
        questionText:
            'Rumah adat tradisional Dayak Lundayeh di Malinau, Kalimantan Utara menggunakan atap dari...',
        questionImageUrl: '',
        options: [
          'Daun sagu atau rumbia',
          'Genteng tanah liat',
          'Seng baja ringan',
          'Ijuk tebal',
        ],
        correctAnswerIndex: 0,
      ),
      QuizQuestion(
        id: 'k17',
        region: 'Kalimantan',
        questionText:
            'Rumah adat Melayu Pontianak memiliki kemiringan atap 30 derajat yang dirancang khusus untuk...',
        questionImageUrl: '',
        options: [
          'Mempercepat sirkulasi udara panas khatulistiwa',
          'Menahan tumpukan salju',
          'Kemudahan pemasangan genteng',
          'Mengikuti adat Jawa murni',
        ],
        correctAnswerIndex: 0,
      ),
      QuizQuestion(
        id: 'k18',
        region: 'Kalimantan',
        questionText:
            'Ornamen ukiran Dayak pada Rumah Lamin yang didominasi warna kuning, merah, dan hitam melambangkan...',
        questionImageUrl: '',
        options: [
          'Keagungan, keberanian, dan kekuatan spiritual',
          'Kesedihan, kemarahan, dan kesunyian',
          'Perang, kekayaan, dan kemiskinan',
          'Alam bawah tanah, laut, dan awan',
        ],
        correctAnswerIndex: 0,
      ),
      QuizQuestion(
        id: 'k19',
        region: 'Kalimantan',
        questionText:
            'Mengapa tiang penyangga Rumah Betang atau Rumah Radakng dibuat sangat tinggi (mencapai 3-7 meter)?',
        questionImageUrl: '',
        options: [
          'Menghindari banjir sungai & serangan musuh/hewan buas',
          'Agar dekat dengan langit kediaman dewa',
          'Mengikuti kontur tanah berbukit terjal',
          'Kemudahan dalam membongkar pasang rumah',
        ],
        correctAnswerIndex: 0,
      ),
      QuizQuestion(
        id: 'k20',
        region: 'Kalimantan',
        questionText:
            'Bangunan adat suku Dayak Bidayuh yang khusus digunakan untuk menyimpan tengkorak hasil ritual adat adalah...',
        questionImageUrl: '',
        options: [
          'Rumah Baluk',
          'Rumah Betang',
          'Rumah Lanting',
          'Rumah Lamin',
        ],
        correctAnswerIndex: 0,
      ),

      // --- SULAWESI (20 Soal) ---
      QuizQuestion(
        id: 'sl1',
        region: 'Sulawesi',
        questionText:
            'Atap menjulang melengkung pada Rumah Tongkonan (Tana Toraja) terinspirasi dari bentuk...',
        questionImageUrl: '',
        options: ['Perahu', 'Gunung', 'Tanduk kerbau', 'Bulan sabit'],
        correctAnswerIndex: 0,
      ),
      QuizQuestion(
        id: 'sl2',
        region: 'Sulawesi',
        questionText:
            'Tumpukan tanduk kerbau di tiang utama Rumah Tongkonan melambangkan...',
        questionImageUrl: '',
        options: [
          'Jumlah hewan buruan',
          'Sistem pelindung rumah',
          'Status sosial & strata keluarga',
          'Tanda bahaya',
        ],
        correctAnswerIndex: 2,
      ),
      QuizQuestion(
        id: 'sl3',
        region: 'Sulawesi',
        questionText:
            'Rumah panggung tradisional masyarakat Bugis-Makassar dikenal dengan nama...',
        questionImageUrl: '',
        options: ['Tongkonan', 'Banua Tada', 'Balla / Bola', 'Dulohupa'],
        correctAnswerIndex: 2,
      ),
      QuizQuestion(
        id: 'sl4',
        region: 'Sulawesi',
        questionText: 'Ciri khas tiang rumah panggung Bugis adalah...',
        questionImageUrl: '',
        options: [
          'Ditanam ke dalam tanah',
          'Ditumpuk di atas batu tanpa ditanam',
          'Terbuat dari bambu',
          'Berbentuk segi delapan',
        ],
        correctAnswerIndex: 1,
      ),
      QuizQuestion(
        id: 'sl5',
        region: 'Sulawesi',
        questionText:
            'Rumah adat Banua Tada yang berarti rumah siku berasal dari daerah...',
        questionImageUrl: '',
        options: ['Buton', 'Minahasa', 'Toraja', 'Bugis'],
        correctAnswerIndex: 0,
      ),
      QuizQuestion(
        id: 'sl6',
        region: 'Sulawesi',
        questionText:
            'Ukiran khas Tana Toraja (Passura) pada Tongkonan umumnya menggunakan 4 warna dasar, yaitu...',
        questionImageUrl: '',
        options: [
          'Merah, Putih, Hitam, Kuning',
          'Merah, Biru, Hitam, Kuning',
          'Hijau, Putih, Biru, Kuning',
          'Hitam, Putih, Coklat, Emas',
        ],
        correctAnswerIndex: 0,
      ),
      QuizQuestion(
        id: 'sl7',
        region: 'Sulawesi',
        questionText:
            'Rumah Pewaris (Walewangko) merupakan rumah panggung khas daerah...',
        questionImageUrl: '',
        options: ['Minahasa (Sulut)', 'Toraja', 'Gorontalo', 'Mandar'],
        correctAnswerIndex: 0,
      ),
      QuizQuestion(
        id: 'sl8',
        region: 'Sulawesi',
        questionText:
            'Rumah tradisional Sulawesi Tengah yang memiliki atap segitiga curam sekaligus berfungsi sebagai dinding luar adalah...',
        questionImageUrl: '',
        options: [
          'Rumah Tambi',
          'Rumah Souraja',
          'Rumah Boyang',
          'Rumah Tongkonan',
        ],
        correctAnswerIndex: 0,
      ),
      QuizQuestion(
        id: 'sl9',
        region: 'Sulawesi',
        questionText:
            'Rumah panggung tradisional suku Mandar di Sulawesi Barat yang penutup bubungannya bersusun menunjukkan kasta bangsawan disebut...',
        questionImageUrl: '',
        options: [
          'Rumah Boyang',
          'Rumah Banua Tada',
          'Rumah Dulohupa',
          'Rumah Walewangko',
        ],
        correctAnswerIndex: 0,
      ),
      QuizQuestion(
        id: 'sl10',
        region: 'Sulawesi',
        questionText:
            'Bangunan bersejarah berupa istana kayu peninggalan Raja Yodjokodi di Palu dengan tiang penyangga berjumlah 36 adalah...',
        questionImageUrl: '',
        options: [
          'Rumah Souraja',
          'Rumah Tambi',
          'Rumah Tongkonan',
          'Rumah Dulohupa',
        ],
        correctAnswerIndex: 0,
      ),
      QuizQuestion(
        id: 'sl11',
        region: 'Sulawesi',
        questionText:
            'Rumah adat Tongkonan memiliki tipe banua terkecil yang hanya berupa kolong tanpa dinding pendukung disebut...',
        questionImageUrl: '',
        options: [
          'Tongkonan Barung-barung',
          'Tongkonan Layuk',
          'Tongkonan Pekamberan',
          'Tongkonan Batu',
        ],
        correctAnswerIndex: 0,
      ),
      QuizQuestion(
        id: 'sl12',
        region: 'Sulawesi',
        questionText:
            'Rumah Banua Tada di Buton dibedakan berdasarkan tingkat tiang. Istana Kesultanan yang berlantai 4 disebut...',
        questionImageUrl: '',
        options: [
          'Kamali / Malige',
          'Tare Pata Pale',
          'Tare Talu Pale',
          'Souraja',
        ],
        correctAnswerIndex: 0,
      ),
      QuizQuestion(
        id: 'sl13',
        region: 'Sulawesi',
        questionText:
            'Rumah adat Dulohupa di Gorontalo membagi bagian tiangnya menjadi tiga jenis, yang melambangkan...',
        questionImageUrl: '',
        options: [
          'Anatomi tubuh manusia (kaki, badan, kepala)',
          'Jumlah klan pendiri kerajaan',
          'Arah mata angin pelindung',
          'Tiga ajaran agama besar',
        ],
        correctAnswerIndex: 0,
      ),
      QuizQuestion(
        id: 'sl14',
        region: 'Sulawesi',
        questionText:
            'Tangga masuk ganda simetris di sisi kiri dan kanan Rumah Walewangko Minahasa secara filosofis berfungsi untuk...',
        questionImageUrl: '',
        options: [
          'Menangkal dan membingungkan roh jahat',
          'Menghemat ruang teras depan',
          'Tempat berjemur hasil panen',
          'Mempercepat evakuasi saat kebakaran',
        ],
        correctAnswerIndex: 0,
      ),
      QuizQuestion(
        id: 'sl15',
        region: 'Sulawesi',
        questionText:
            'Tiang penyangga utama pada Rumah Souraja di Palu berjumlah...',
        questionImageUrl: '',
        options: ['36 tiang', '10 tiang', '20 tiang', '50 tiang'],
        correctAnswerIndex: 0,
      ),
      QuizQuestion(
        id: 'sl16',
        region: 'Sulawesi',
        questionText:
            'Rumah adat Sulawesi Barat (Boyang Adaq) khusus dihuni oleh kasta bangsawan, yang dicirikan oleh...',
        questionImageUrl: '',
        options: [
          'Penutup bubungan bersusun 3 hingga 7',
          'Lantai yang langsung menyentuh tanah',
          'Atap berbahan seng baja',
          'Dinding dari anyaman bambu polos',
        ],
        correctAnswerIndex: 0,
      ),
      QuizQuestion(
        id: 'sl17',
        region: 'Sulawesi',
        questionText:
            'Bahan utama penyusun konstruksi tiang kokoh tanpa sambungan pada rumah Walewangko adalah...',
        questionImageUrl: '',
        options: [
          'Kayu besi / ulin utuh',
          'Bambu petung pilihan',
          'Batang pohon kelapa',
          'Balok semen cetak',
        ],
        correctAnswerIndex: 0,
      ),
      QuizQuestion(
        id: 'sl18',
        region: 'Sulawesi',
        questionText:
            'Ornamen patung kepala kerbau (pebaula) yang dipasang di bagian depan rumah Tambi melambangkan...',
        questionImageUrl: '',
        options: [
          'Kekayaan dan status sosial pemilik',
          'Batas suci pemujaan dewa',
          'Hewan peliharaan favorit keluarga',
          'Penunjuk arah kiblat ibadah',
        ],
        correctAnswerIndex: 0,
      ),
      QuizQuestion(
        id: 'sl19',
        region: 'Sulawesi',
        questionText:
            'Konsep pembagian ruangan secara aksial horizontal pada rumah adat Bugis-Makassar terdiri dari tiga tingkat, disebut...',
        questionImageUrl: '',
        options: ['Sulapa Eppa', 'Tiga Bola', 'Bengkilas', 'Soko Guru'],
        correctAnswerIndex: 0,
      ),
      QuizQuestion(
        id: 'sl20',
        region: 'Sulawesi',
        questionText:
            'Sulluk Banua pada tingkatan kolong Rumah Tongkonan difungsikan sebagai...',
        questionImageUrl: '',
        options: [
          'Tempat memelihara hewan ternak',
          'Kamar tidur anak perempuan',
          'Dapur dan tempat memasak',
          'Ruang penyimpanan harta warisan',
        ],
        correctAnswerIndex: 0,
      ),

      // --- PAPUA (20 Soal) ---
      QuizQuestion(
        id: 'p1',
        region: 'Papua',
        questionText:
            'Rumah adat Honai tidak memiliki jendela. Fungsi utamanya adalah untuk...',
        questionImageUrl: '',
        options: [
          'Kemudahan membangun',
          'Menghindari musuh',
          'Menahan udara dingin pegunungan',
          'Karena tidak ada kayu',
        ],
        correctAnswerIndex: 2,
      ),
      QuizQuestion(
        id: 'p2',
        region: 'Papua',
        questionText: 'Atap Rumah Honai umumnya terbuat dari...',
        questionImageUrl: '',
        options: ['Daun kelapa', 'Seng', 'Jerami / Ilalang', 'Sirap kayu'],
        correctAnswerIndex: 2,
      ),
      QuizQuestion(
        id: 'p3',
        region: 'Papua',
        questionText:
            'Selain Honai untuk laki-laki, terdapat bangunan khusus untuk perempuan yang disebut...',
        questionImageUrl: '',
        options: ['Wamai', 'Ebei', 'Kariwari', 'Jew'],
        correctAnswerIndex: 1,
      ),
      QuizQuestion(
        id: 'p4',
        region: 'Papua',
        questionText:
            'Rumah tinggi di atas pohon setinggi belasan meter merupakan arsitektur khas Suku...',
        questionImageUrl: '',
        options: ['Asmat', 'Korowai', 'Dani', 'Biak'],
        correctAnswerIndex: 1,
      ),
      QuizQuestion(
        id: 'p5',
        region: 'Papua',
        questionText:
            'Bangunan berbentuk panggung memanjang (bisa mencapai 100 meter) sebagai rumah komunal Suku Asmat disebut...',
        questionImageUrl: '',
        options: ['Jew', 'Kariwari', 'Honai', 'Mod Aki Aksa'],
        correctAnswerIndex: 0,
      ),
      QuizQuestion(
        id: 'p6',
        region: 'Papua',
        questionText:
            'Rumah adat Kariwari yang memiliki atap limas menjulang tinggi ke atas merupakan ciri khas masyarakat...',
        questionImageUrl: '',
        options: ['Danau Sentani', 'Lembah Baliem', 'Raja Ampat', 'Asmat'],
        correctAnswerIndex: 0,
      ),
      QuizQuestion(
        id: 'p7',
        region: 'Papua',
        questionText:
            'Fungsi api unggun kecil yang dinyalakan di lantai dasar Rumah Honai adalah untuk...',
        questionImageUrl: '',
        options: [
          'Memasak makanan utama',
          'Menghangatkan tubuh & mengawetkan atap',
          'Penerangan membaca',
          'Ritual memanggil hujan',
        ],
        correctAnswerIndex: 1,
      ),
      QuizQuestion(
        id: 'p8',
        region: 'Papua',
        questionText:
            'Rumah adat suku Arfak di Papua Barat yang ditopang oleh ratusan tiang penyangga kayu rapat disebut...',
        questionImageUrl: '',
        options: [
          'Rumah Mod Aki Aksa (Kaki Seribu)',
          'Rumah Rumsram',
          'Rumah Kariwari',
          'Rumah Jew',
        ],
        correctAnswerIndex: 0,
      ),
      QuizQuestion(
        id: 'p9',
        region: 'Papua',
        questionText:
            'Rumah adat suku Biak Numfor yang berbentuk panggung pesisir dengan atap melengkung mirip lambung perahu terbalik disebut...',
        questionImageUrl: '',
        options: ['Rumah Rumsram', 'Rumah Honai', 'Rumah Jew', 'Rumah Wamai'],
        correctAnswerIndex: 0,
      ),
      QuizQuestion(
        id: 'p10',
        region: 'Papua',
        questionText:
            'Struktur dapur umum terpusat untuk memasak bersama dalam satu komplek pemukiman adat suku Dani disebut...',
        questionImageUrl: '',
        options: ['Rumah Hunila', 'Rumah Ebei', 'Rumah Wamai', 'Rumah Honai'],
        correctAnswerIndex: 0,
      ),
      QuizQuestion(
        id: 'p11',
        region: 'Papua',
        questionText:
            'Rumah adat Honai yang khusus diperuntukkan bagi kaum laki-laki dewasa disebut...',
        questionImageUrl: '',
        options: ['Honai Pilamo', 'Honai Ebei', 'Honai Hunila', 'Honai Wamai'],
        correctAnswerIndex: 0,
      ),
      QuizQuestion(
        id: 'p12',
        region: 'Papua',
        questionText:
            'Mengapa rumah Honai tidak memiliki jendela dan berpintu rendah?',
        questionImageUrl: '',
        options: [
          'Untuk menjebak panas tungku dan melindungi dari udara dingin ekstrem',
          'Karena suku Dani tidak mengenal jendela kaca',
          'Untuk menghemat bahan kayu hutan',
          'Agar musuh tidak bisa melihat ke dalam',
        ],
        correctAnswerIndex: 0,
      ),
      QuizQuestion(
        id: 'p13',
        region: 'Papua',
        questionText:
            'Dinding bulat melingkar pada Rumah Honai biasanya dibuat menggunakan material...',
        questionImageUrl: '',
        options: [
          'Lempengan kayu rapat (papan kasar)',
          'Lumpur basah tebal',
          'Anyaman daun sagu',
          'Batu bata kali',
        ],
        correctAnswerIndex: 0,
      ),
      QuizQuestion(
        id: 'p14',
        region: 'Papua',
        questionText:
            'Rumah pohon suku Korowai di Papua Selatan dibangun pada ketinggian berapa meter dari tanah?',
        questionImageUrl: '',
        options: [
          '15 hingga 50 meter',
          '1 hingga 5 meter',
          '5 hingga 10 meter',
          'Lebih dari 100 meter',
        ],
        correctAnswerIndex: 0,
      ),
      QuizQuestion(
        id: 'p15',
        region: 'Papua',
        questionText:
            'Rumah Jew suku Asmat disebut juga sebagai "Rumah Bujang" karena difungsikan untuk...',
        questionImageUrl: '',
        options: [
          'Pusat kegiatan pemuda lajang, upacara adat, dan musyawarah',
          'Tempat tinggal eksklusif bagi keluarga raja',
          'Kamar tidur anak perempuan dewasa',
          'Tempat menyimpan persediaan ubi jalar',
        ],
        correctAnswerIndex: 0,
      ),
      QuizQuestion(
        id: 'p16',
        region: 'Papua',
        questionText:
            'Tiang penyangga utama di dalam Rumah Jew suku Asmat diukir dengan figur leluhur yang rumit, disebut...',
        questionImageUrl: '',
        options: ['Bisj Pole', 'Passura', 'Makara', 'Gebyok'],
        correctAnswerIndex: 0,
      ),
      QuizQuestion(
        id: 'p17',
        region: 'Papua',
        questionText:
            'Rumah adat Rumsram suku Biak Numfor digunakan sebagai pusat...',
        questionImageUrl: '',
        options: [
          'Inisiasi adat dan pendidikan bahari bagi para pemuda',
          'Penyimpanan hasil tangkapan ikan laut',
          'Kandang babi bersama suku Biak',
          'Pernikahan agung keluarga kepala adat',
        ],
        correctAnswerIndex: 0,
      ),
      QuizQuestion(
        id: 'p18',
        region: 'Papua',
        questionText:
            'Material penutup atap kubah bundar pada rumah Honai dan Ebei suku Dani adalah...',
        questionImageUrl: '',
        options: [
          'Alang-alang / jerami tebal',
          'Lembaran seng gelombang',
          'Genteng tanah liat',
          'Kulit kayu jati',
        ],
        correctAnswerIndex: 0,
      ),
      QuizQuestion(
        id: 'p19',
        region: 'Papua',
        questionText:
            'Mengapa suku Korowai membangun rumah tinggi di atas dahan pohon besar (elevasi ekstrem)?',
        questionImageUrl: '',
        options: [
          'Melindungi diri dari hewan buas, banjir, dan roh jahat (laleo)',
          'Mempermudah melihat kedatangan musuh dari jauh',
          'Agar mendapat hembusan angin laut pesisir',
          'Mengikuti adat istana Keraton Jawa',
        ],
        correctAnswerIndex: 0,
      ),
      QuizQuestion(
        id: 'p20',
        region: 'Papua',
        questionText:
            'Rumah adat Mod Aki Aksa suku Arfak dikenal dengan sebutan...',
        questionImageUrl: '',
        options: [
          'Rumah Kaki Seribu',
          'Rumah Bulat Honai',
          'Rumah Panggung Perahu',
          'Rumah Rakit Sungai',
        ],
        correctAnswerIndex: 0,
      ),
    ];

    if (widget.region != null && widget.region != 'Random') {
      dummyQuestions = dummyQuestions
          .where((q) => q.region == widget.region)
          .toList();
    }

    dummyQuestions.shuffle();
    if (dummyQuestions.length > 10) {
      dummyQuestions = dummyQuestions.sublist(0, 10);
    }

    if (!mounted) return;
    setState(() {
      questions = dummyQuestions;
      isLoading = false;
    });
    _playQuestionAnim();
  }

  Future<Map<String, dynamic>> _updateUserGamificationData(
    int sessionScore,
  ) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return {'xp': 0, 'level': 1, 'awardedBadges': <String>[]};

    final userDocRef = FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid);

    try {
      return await FirebaseFirestore.instance.runTransaction((
        transaction,
      ) async {
        final snapshot = await transaction.get(userDocRef);
        final data = snapshot.exists
            ? snapshot.data() as Map<String, dynamic>
            : <String, dynamic>{};

        final int currentXp = (data['xp'] ?? 0) as int;
        final int currentLevel = (data['level'] ?? 1) as int;
        final int currentAttempts = (data['quizAttempts'] ?? 0) as int;
        final List<String> currentBadges = List<String>.from(
          data['badges'] ?? <String>[],
        );

        final int newXp = currentXp + sessionScore;
        final int newLevel = _calculateLevel(newXp);
        final Set<String> updatedBadges = currentBadges.toSet();
        final List<String> awardedBadges = [];

        if (currentAttempts == 0) {
          updatedBadges.add('First Quiz');
          awardedBadges.add('First Quiz');
        }
        if (sessionScore == 100) {
          updatedBadges.add('Perfect Score');
          awardedBadges.add('Perfect Score');
        } else if (sessionScore >= 70) {
          updatedBadges.add('Cultural Hero');
          awardedBadges.add('Cultural Hero');
        }
        if (widget.region != null &&
            widget.region != 'Random' &&
            sessionScore == 100) {
          final regionBadge = 'Master ${widget.region}';
          if (updatedBadges.add(regionBadge)) {
            awardedBadges.add(regionBadge);
          }
        }
        if (widget.region != null &&
            widget.region != 'Random' &&
            sessionScore >= 40) {
          final regionExplorerBadge = 'Explorer ${widget.region}';
          if (updatedBadges.add(regionExplorerBadge)) {
            awardedBadges.add(regionExplorerBadge);
          }
        }
        if (newLevel > currentLevel) {
          final levelBadge = 'Level $newLevel Achieved';
          if (updatedBadges.add(levelBadge)) {
            awardedBadges.add(levelBadge);
          }
        }

        transaction.set(userDocRef, {
          'xp': newXp,
          'level': newLevel,
          'quizAttempts': currentAttempts + 1,
          'lastScore': sessionScore,
          'lastQuizAt': FieldValue.serverTimestamp(),
          'badges': updatedBadges.toList(),
        }, SetOptions(merge: true));

        return {'xp': newXp, 'level': newLevel, 'awardedBadges': awardedBadges};
      });
    } catch (e) {
      debugPrint('Error updating gamification data: $e');
      return {'xp': 0, 'level': 1, 'awardedBadges': <String>[]};
    }
  }

  int _calculateLevel(int xp) {
    if (xp < 200) return 1;
    if (xp < 500) return 2;
    if (xp < 900) return 3;
    if (xp < 1500) return 4;
    return 5;
  }

  String _levelTitle(int level) {
    switch (level) {
      case 1:
        return 'Penjelajah Budaya';
      case 2:
        return 'Pakar Daerah';
      case 3:
        return 'Nusantara Explorer';
      case 4:
        return 'Ahli Tradisi';
      case 5:
        return 'Guru Warisan';
      default:
        return 'Penjelajah Budaya';
    }
  }

  void _onAnswerSelected(int index) {
    if (isAnswered) return;

    final question = questions[currentQuestionIndex];
    final bool correct = index == question.correctAnswerIndex;

    setState(() {
      selectedAnswerIndex = index;
      isAnswered = true;
      isCorrect = correct;
    });

    if (correct) {
      correctAnswersCount++;
    }

    // Jeda 1.8 detik agar user melihat feedback, lalu lanjut
    Future.delayed(const Duration(milliseconds: 1800), () {
      if (!mounted) return;

      if (currentQuestionIndex < questions.length - 1) {
        setState(() {
          currentQuestionIndex++;
          selectedAnswerIndex = null;
          isAnswered = false;
          isCorrect = false;
        });
        _playQuestionAnim();
      } else {
        totalScore = (correctAnswersCount * 100 / questions.length).round();
        _submitScoreAndShowResult();
      }
    });
  }

  Future<void> _submitScoreAndShowResult() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await FirebaseFirestore.instance.collection('users_score').add({
          'userId': user.uid,
          'score': totalScore,
          'timestamp': FieldValue.serverTimestamp(),
        });
      }
    } catch (e) {
      debugPrint("Gagal menyimpan skor ke Firebase: $e");
    }

    final gamification = await _updateUserGamificationData(totalScore);
    final int finalLevel = gamification['level'] as int? ?? 1;
    final int finalXp = gamification['xp'] as int? ?? totalScore;
    final List<String> awardedBadges = List<String>.from(
      gamification['awardedBadges'] ?? <String>[],
    );

    if (!mounted) return;
    _showResultDialog(finalLevel, finalXp, awardedBadges);
  }

  // ============================================================
  // FEEDBACK WARNA
  // ✅ Benar  → pilihan yang diklik jadi HIJAU
  // ❌ Salah  → pilihan yang diklik jadi MERAH
  // ============================================================

  Color _getOptionBgColor(int index) {
    if (!isAnswered) return AppColors.white;
    if (index == selectedAnswerIndex) {
      return isCorrect
          ? const Color(0xFFE8F5E9)
          : const Color(0xFFFFEBEE);
    }
    return AppColors.white;
  }

  Color _getOptionBorderColor(int index) {
    if (!isAnswered) return AppColors.border;
    if (index == selectedAnswerIndex) {
      return isCorrect ? const Color(0xFF4CAF50) : const Color(0xFFE53935);
    }
    return AppColors.border.withValues(alpha: 0.5);
  }

  Color _getOptionLabelColor(int index) {
    if (!isAnswered) return AppColors.primary;
    if (index == selectedAnswerIndex) {
      return isCorrect ? const Color(0xFF2E7D32) : const Color(0xFFC62828);
    }
    return AppColors.greyText;
  }

  IconData? _getOptionIcon(int index) {
    if (!isAnswered || index != selectedAnswerIndex) return null;
    return isCorrect ? Icons.check_circle_rounded : Icons.cancel_rounded;
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        backgroundColor: AppColors.background,
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: 56,
                height: 56,
                child: CircularProgressIndicator(
                  color: AppColors.primary,
                  strokeWidth: 3,
                  backgroundColor: AppColors.primary.withValues(alpha: 0.15),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                "Memuat soal kuis...",
                style: GoogleFonts.poppins(
                  fontSize: 15,
                  color: AppColors.greyText,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      );
    }

    if (questions.isEmpty) {
      return Scaffold(
        backgroundColor: AppColors.background,
        appBar: _buildAppBar(),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(40),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.quiz_outlined,
                  size: 72,
                  color: AppColors.greyText.withValues(alpha: 0.4),
                ),
                const SizedBox(height: 20),
                Text(
                  "Belum ada soal kuis yang tersedia.",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    color: AppColors.greyText,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    final question = questions[currentQuestionIndex];

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // ── HEADER ──
            _buildQuizHeader(),

            // ── FEEDBACK BANNER ──
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 350),
              transitionBuilder: (child, animation) {
                return SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(0, -0.3),
                    end: Offset.zero,
                  ).animate(CurvedAnimation(
                    parent: animation,
                    curve: Curves.easeOut,
                  )),
                  child: FadeTransition(opacity: animation, child: child),
                );
              },
              child: isAnswered
                  ? _buildFeedbackBanner()
                  : const SizedBox.shrink(key: ValueKey('empty')),
            ),

            // ── CONTENT ──
            Expanded(
              child: FadeTransition(
                opacity: _questionFadeAnim,
                child: SlideTransition(
                  position: _questionSlideAnim,
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Gambar Soal
                        if (question.questionImageUrl.isNotEmpty)
                          _buildQuestionImage(question.questionImageUrl),

                        // Card Soal
                        _buildQuestionCard(question),

                        const SizedBox(height: 20),

                        // Pilihan Ganda
                        ...List.generate(question.options.length, (index) {
                          return _buildOptionTile(index, question.options[index]);
                        }),

                        const SizedBox(height: 16),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── APP BAR ──
  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: AppColors.primary,
      elevation: 0,
      iconTheme: const IconThemeData(color: Colors.white),
      centerTitle: true,
      title: Text(
        "Kuis Nusantara",
        style: GoogleFonts.lora(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 20,
        ),
      ),
    );
  }

  // ── QUIZ HEADER ──
  Widget _buildQuizHeader() {
    final regionLabel = widget.region == null || widget.region == 'Random'
        ? 'Nusantara'
        : widget.region!;

    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.primary, Color(0xFF2D6A4F)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      padding: const EdgeInsets.fromLTRB(8, 8, 20, 20),
      child: Column(
        children: [
          // Top row: back button + title + score
          Row(
            children: [
              IconButton(
                onPressed: () => _showExitConfirmation(),
                icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
                splashRadius: 24,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Kuis Arsitektur $regionLabel',
                      style: GoogleFonts.lora(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Pertanyaan ${currentQuestionIndex + 1} dari ${questions.length}',
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        color: Colors.white70,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              // Score indicator
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.25),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.star_rounded, color: AppColors.accent, size: 18),
                    const SizedBox(width: 5),
                    Text(
                      '$correctAnswersCount / ${questions.length}',
                      style: GoogleFonts.poppins(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Step indicators
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              children: List.generate(questions.length, (i) {
                final bool isDone = i < currentQuestionIndex;
                final bool isCurrent = i == currentQuestionIndex;
                return Expanded(
                  child: Container(
                    height: 4,
                    margin: const EdgeInsets.symmetric(horizontal: 2),
                    decoration: BoxDecoration(
                      color: isDone
                          ? AppColors.accent
                          : isCurrent
                              ? Colors.white
                              : Colors.white.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }

  // ── QUESTION IMAGE ──
  Widget _buildQuestionImage(String imageUrl) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16, top: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.12),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Stack(
          children: [
            Image.network(
              imageUrl,
              height: 200,
              width: double.infinity,
              fit: BoxFit.cover,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return Container(
                  height: 200,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.05),
                  ),
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          width: 32,
                          height: 32,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.5,
                            color: AppColors.primary,
                            value: loadingProgress.expectedTotalBytes != null
                                ? loadingProgress.cumulativeBytesLoaded /
                                    loadingProgress.expectedTotalBytes!
                                : null,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'Memuat gambar...',
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            color: AppColors.greyText,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  height: 160,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.05),
                    border: Border.all(
                      color: AppColors.border,
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.image_not_supported_outlined,
                        size: 40,
                        color: AppColors.greyText.withValues(alpha: 0.5),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Gambar tidak dapat dimuat',
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          color: AppColors.greyText,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
            // Gradient overlay di bawah gambar
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                height: 40,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withValues(alpha: 0.15),
                    ],
                  ),
                ),
              ),
            ),
            // Icon kamera kecil di sudut
            Positioned(
              top: 10,
              right: 10,
              child: Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.4),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.photo_camera_rounded,
                  color: Colors.white,
                  size: 16,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── QUESTION CARD ──
  Widget _buildQuestionCard(QuizQuestion question) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border.withValues(alpha: 0.6)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Badge nomor soal
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [AppColors.primary, Color(0xFF2D6A4F)],
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              'Soal ${currentQuestionIndex + 1}',
              style: GoogleFonts.poppins(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: Colors.white,
                letterSpacing: 0.5,
              ),
            ),
          ),
          const SizedBox(height: 14),
          // Teks soal
          Text(
            question.questionText,
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: AppColors.secondaryText,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  // ── OPTION TILE ──
  Widget _buildOptionTile(int index, String optionText) {
    final icon = _getOptionIcon(index);
    final bool isSelected = isAnswered && index == selectedAnswerIndex;
    final String label = String.fromCharCode(65 + index); // A, B, C, D

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: isAnswered ? null : () => _onAnswerSelected(index),
          borderRadius: BorderRadius.circular(14),
          splashColor: AppColors.primary.withValues(alpha: 0.08),
          highlightColor: AppColors.primary.withValues(alpha: 0.04),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 350),
            curve: Curves.easeInOut,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            decoration: BoxDecoration(
              color: _getOptionBgColor(index),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: _getOptionBorderColor(index),
                width: isSelected ? 2 : 1.5,
              ),
              boxShadow: [
                if (!isAnswered)
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.03),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                if (isSelected)
                  BoxShadow(
                    color: (isCorrect
                            ? const Color(0xFF4CAF50)
                            : const Color(0xFFE53935))
                        .withValues(alpha: 0.15),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
              ],
            ),
            child: Row(
              children: [
                // Label circle (A, B, C, D) atau ikon feedback
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  width: 38,
                  height: 38,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: isSelected
                        ? (isCorrect
                            ? const Color(0xFF4CAF50)
                            : const Color(0xFFE53935))
                        : AppColors.primary.withValues(alpha: 0.08),
                    shape: BoxShape.circle,
                    border: isSelected
                        ? null
                        : Border.all(
                            color: AppColors.primary.withValues(alpha: 0.2),
                            width: 1.5,
                          ),
                  ),
                  child: isSelected && icon != null
                      ? Icon(icon, color: Colors.white, size: 22)
                      : Text(
                          label,
                          style: GoogleFonts.poppins(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: isSelected
                                ? Colors.white
                                : _getOptionLabelColor(index),
                          ),
                        ),
                ),
                const SizedBox(width: 14),
                // Option text
                Expanded(
                  child: Text(
                    optionText,
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                      color: isSelected
                          ? (isCorrect
                              ? const Color(0xFF2E7D32)
                              : const Color(0xFFC62828))
                          : AppColors.secondaryText,
                      height: 1.4,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ── FEEDBACK BANNER ──
  Widget _buildFeedbackBanner() {
    return Container(
      key: ValueKey('feedback_$currentQuestionIndex'),
      margin: const EdgeInsets.fromLTRB(20, 8, 20, 4),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isCorrect
              ? [const Color(0xFFE8F5E9), const Color(0xFFC8E6C9)]
              : [const Color(0xFFFFEBEE), const Color(0xFFFFCDD2)],
        ),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isCorrect
              ? const Color(0xFF66BB6A)
              : const Color(0xFFEF5350),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: (isCorrect ? const Color(0xFF4CAF50) : const Color(0xFFE53935))
                .withValues(alpha: 0.12),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: isCorrect
                  ? const Color(0xFF4CAF50)
                  : const Color(0xFFE53935),
              shape: BoxShape.circle,
            ),
            child: Icon(
              isCorrect
                  ? Icons.check_rounded
                  : Icons.close_rounded,
              color: Colors.white,
              size: 22,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isCorrect ? 'Jawaban Benar!' : 'Jawaban Salah!',
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: isCorrect
                        ? const Color(0xFF2E7D32)
                        : const Color(0xFFC62828),
                  ),
                ),
                Text(
                  isCorrect
                      ? 'Hebat! Pengetahuan arsitekturmu luar biasa!'
                      : 'Jangan menyerah, terus belajar!',
                  style: GoogleFonts.poppins(
                    fontSize: 11,
                    color: isCorrect
                        ? const Color(0xFF388E3C)
                        : const Color(0xFFD32F2F),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── EXIT CONFIRMATION ──
  void _showExitConfirmation() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Text(
          'Keluar dari Kuis?',
          style: GoogleFonts.lora(
            fontWeight: FontWeight.bold,
            color: AppColors.secondaryText,
          ),
        ),
        content: Text(
          'Progress kuis kamu akan hilang jika keluar sekarang.',
          style: GoogleFonts.poppins(
            fontSize: 14,
            color: AppColors.greyText,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text(
              'Lanjutkan',
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w600,
                color: AppColors.primary,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              Navigator.of(context).pop();
            },
            child: Text(
              'Keluar',
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w600,
                color: Colors.red,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── RESULT DIALOG ──
  void _showResultDialog(int level, int xp, List<String> badges) {
    final double scorePercent = totalScore / 100;
    String message;
    IconData heroIcon;
    Color heroColor;

    if (totalScore == 100) {
      message = 'Sempurna! Kamu adalah ahli arsitektur Nusantara sejati!';
      heroIcon = Icons.emoji_events_rounded;
      heroColor = const Color(0xFFFFB300);
    } else if (totalScore >= 70) {
      message = 'Hebat! Pengetahuan arsitekturmu sangat baik!';
      heroIcon = Icons.military_tech_rounded;
      heroColor = const Color(0xFF66BB6A);
    } else if (totalScore >= 40) {
      message = 'Lumayan! Terus pelajari warisan arsitektur Nusantara.';
      heroIcon = Icons.school_rounded;
      heroColor = AppColors.primary;
    } else {
      message = 'Jangan menyerah! Pelajari lagi dan coba kembali.';
      heroIcon = Icons.auto_stories_rounded;
      heroColor = AppColors.greyText;
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withValues(alpha: 0.15),
                blurRadius: 30,
                offset: const Offset(0, 12),
              ),
            ],
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Header gradient
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.fromLTRB(24, 32, 24, 24),
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [AppColors.primary, Color(0xFF2D6A4F)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(24),
                      topRight: Radius.circular(24),
                    ),
                  ),
                  child: Column(
                    children: [
                      Text(
                        'Kuis Selesai!',
                        style: GoogleFonts.lora(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 20),
                      // Score circle
                      Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withValues(alpha: 0.15),
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.3),
                            width: 3,
                          ),
                        ),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            SizedBox(
                              width: 100,
                              height: 100,
                              child: CircularProgressIndicator(
                                value: scorePercent,
                                strokeWidth: 8,
                                backgroundColor: Colors.white.withValues(alpha: 0.2),
                                valueColor: const AlwaysStoppedAnimation<Color>(
                                  AppColors.accent,
                                ),
                                strokeCap: StrokeCap.round,
                              ),
                            ),
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  '$totalScore',
                                  style: GoogleFonts.poppins(
                                    fontSize: 36,
                                    fontWeight: FontWeight.w800,
                                    color: Colors.white,
                                    height: 1,
                                  ),
                                ),
                                Text(
                                  '/ 100',
                                  style: GoogleFonts.poppins(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white70,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Hero icon
                      Icon(heroIcon, size: 36, color: heroColor),
                      const SizedBox(height: 8),
                      Text(
                        message,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                          fontSize: 13,
                          color: Colors.white.withValues(alpha: 0.9),
                          fontWeight: FontWeight.w500,
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),

                // Stats area
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 20, 24, 8),
                  child: Column(
                    children: [
                      // Level & XP row
                      Row(
                        children: [
                          Expanded(
                            child: _buildStatCard(
                              icon: Icons.trending_up_rounded,
                              label: 'Level',
                              value: '$level',
                              subtitle: _levelTitle(level),
                              color: AppColors.primary,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _buildStatCard(
                              icon: Icons.star_rounded,
                              label: 'Total XP',
                              value: '$xp',
                              subtitle: 'Experience',
                              color: AppColors.accent,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      // Correct answers
                      _buildStatCard(
                        icon: Icons.check_circle_rounded,
                        label: 'Jawaban Benar',
                        value: '$correctAnswersCount / ${questions.length}',
                        subtitle: '${(correctAnswersCount * 100 / questions.length).round()}% akurasi',
                        color: const Color(0xFF4CAF50),
                        isWide: true,
                      ),
                    ],
                  ),
                ),

                // Badges
                if (badges.isNotEmpty) ...[
                  Padding(
                    padding: const EdgeInsets.fromLTRB(24, 8, 24, 0),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            const Icon(
                              Icons.workspace_premium_rounded,
                              color: AppColors.accent,
                              size: 20,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              'Badge Baru Diraih!',
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: AppColors.secondaryText,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Wrap(
                          alignment: WrapAlignment.center,
                          spacing: 8,
                          runSpacing: 8,
                          children: badges
                              .map(BadgeUtils.buildBadgeChip)
                              .toList(),
                        ),
                      ],
                    ),
                  ),
                ] else ...[
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Text(
                      'Tetap semangat untuk meraih badge baru!',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                        fontSize: 13,
                        color: AppColors.greyText,
                      ),
                    ),
                  ),
                ],

                // Action buttons
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          elevation: 0,
                        ),
                        onPressed: () {
                          Navigator.of(ctx).pop();
                          Navigator.of(context).pop();
                        },
                        child: Text(
                          "Kembali ke Beranda",
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w700,
                            fontSize: 15,
                          ),
                        ),
                      ),
                      if (totalScore < 100) ...[
                        const SizedBox(height: 12),
                        OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppColors.primary,
                            side: const BorderSide(
                              color: AppColors.primary,
                              width: 1.5,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                          onPressed: () {
                            Navigator.of(ctx).pop();
                            setState(() {
                              currentQuestionIndex = 0;
                              totalScore = 0;
                              correctAnswersCount = 0;
                              selectedAnswerIndex = null;
                              isAnswered = false;
                              isCorrect = false;
                            });
                            // Acak soal ulang saat coba lagi
                            questions.shuffle();
                            _playQuestionAnim();
                          },
                          child: Text(
                            "Coba Lagi",
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w700,
                              fontSize: 15,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ── STAT CARD (for result dialog) ──
  Widget _buildStatCard({
    required IconData icon,
    required String label,
    required String value,
    required String subtitle,
    required Color color,
    bool isWide = false,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withValues(alpha: 0.15)),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 22),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: GoogleFonts.poppins(
                    fontSize: 11,
                    color: AppColors.greyText,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  value,
                  style: GoogleFonts.poppins(
                    fontSize: isWide ? 18 : 22,
                    fontWeight: FontWeight.w800,
                    color: AppColors.secondaryText,
                    height: 1.2,
                  ),
                ),
                Text(
                  subtitle,
                  style: GoogleFonts.poppins(
                    fontSize: 10,
                    color: AppColors.greyText,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
