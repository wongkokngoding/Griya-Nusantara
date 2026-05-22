import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreSeeder {
  /// Melakukan seed data 10 Rumah Adat Sumatera, 6 Jawa, dan 11 Kalimantan ke Firestore
  static Future<void> seedSampleHouses() async {
    final CollectionReference houses = FirebaseFirestore.instance.collection(
      'houses',
    );

    final Map<String, Map<String, dynamic>> sampleHouses = {
      // ================== KATEGORI: SUMATERA ==================
      "kr9_Bade_Aceh_001": {
        "category": "Sumatera",
        "title": "Rumah Krong Bade",
        "location": "Aceh",
        "description":
            "Rumah panggung tradisional berbentuk persegi panjang yang memanjang dari timur ke barat. Ciri khas utamanya terletak pada tangga di bagian depan dengan jumlah anak tangga ganjil (7 hingga 9 anak tangga) sebagai akses utama masuk ke dalam rumah.",
        "imageUrl":
            "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTPeRIvJULJL6Qlt9NKksNeyMtYK30853N3Ow&s",
      },
      "bol9_Sumut_002": {
        "category": "Sumatera",
        "title": "Rumah Bolon",
        "location": "Sumatera Utara",
        "description":
            "Simbol budaya suku Batak/Nias di Sumatera Utara. Arsitektur panggung masif dengan tiang penyangga diletakkan di atas batu sandi untuk isolasi seismik (tahan gempa) tradisional, menyajikan harmoni rekayasa struktural kayu vernakular.",
        "imageUrl":
            "https://www.indonesia.travel/contentassets/e443bcd07329418fa189071677af489a/rumah-boton-toba.png",
      },
      "gad9_Sumbar_003": {
        "category": "Sumatera",
        "title": "Rumah Gadang",
        "location": "Sumatera Barat",
        "description":
            "Rumah adat khas Minangkabau dengan bentuk atap melengkung tajam menyerupai tanduk kerbau (gonjong) yang berbahan serat ijuk tahan lama. Berfungsi sebagai tempat tinggal sekaligus representasi tatanan adat matrilineal.",
        "imageUrl":
            "https://www.indonesia.travel/contentassets/90830eb7cbde49599d15941b1e129dc3/rumah-gadang-batingkek.jpeg",
      },
      "sel9_Riau_004": {
        "category": "Sumatera",
        "title": "Rumah Selaso Jatuh Kembar",
        "location": "Riau",
        "description":
            "Rumah adat Melayu Riau yang memiliki ciri khas berupa dua selasar keliling yang memberikan kesan luas dan terbuka. Bangunan ini murni difungsikan sebagai tempat berkumpul, bermusyawarah, dan upacara adat.",
        "imageUrl":
            "https://indonesiatraveler.id/wp-content/uploads/2021/02/Riau-Rumah-Adat-Balai-Salaso-Jatuh-Photo-by-@SeniBudayaIndonesiaBlogger.jpg",
      },
      "bel9_Kepri_005": {
        "category": "Sumatera",
        "title": "Rumah Belah Bubung",
        "location": "Kepulauan Riau",
        "description":
            "Rumah panggung kayu setinggi 2 meter khas Melayu pesisir dengan atap berbentuk pelana kuda. Terbagi secara linear menjadi selasar, ruang induk, ruang penghubung dapur, dan dapur, di mana ukuran fisiknya mencerminkan status ekonomi pemilik.",
        "imageUrl":
            "https://lh4.googleusercontent.com/proxy/FL5bbDhwx6NMUd8XRl-nrYxVpEJI5vdkFwFNBSmrKeM4FoqBBdXr1VgsiXvi-USXzpWcgnxWHugtv-9ZEhcr0pCRlRETdsBCGoEzW9uUNM0_5NAQMz8vM1KCtRQBBw1HIUih4pbc0UCLoEpRm-gs6Pm9MK56laXK",
      },
      "bub9_Bengkulu_006": {
        "category": "Sumatera",
        "title": "Rumah Bubungan Lima",
        "location": "Bengkulu",
        "description":
            "Rumah panggung kokoh yang ditopang tiang-tiang independen dari material kayu Medang Kemuning yang sangat awet. Tidak digunakan sebagai hunian harian, melainkan khusus untuk menyelenggarakan upacara adat dan kegiatan komunal.",
        "imageUrl":
            "https://radarbengkulu.disway.id//upload/6370d6beb82f359d0866d3898d8c6997.jpg",
      },
      "pan9_Jambi_007": {
        "category": "Sumatera",
        "title": "Rumah Panggung",
        "location": "Jambi",
        "description":
            "Salah satu arsitektur panggung tertua di Sumatera dengan bentuk persegi panjang. Memiliki atap unik berciri 'Gajah Mabuk' yang ujungnya melengkung menyerupai haluan perahu, berfungsi sebagai hunian dan tempat musyawarah.",
        "imageUrl":
            "https://pariwisataindonesia.id/wp-content/uploads/2020/12/Rumah-Kajang-Lako-Jambi-foto-freedomsiana.id_.jpg",
      },
      "lim9_Sumsel_008": {
        "category": "Sumatera",
        "title": "Rumah Limas",
        "location": "Sumatera Selatan",
        "description":
            "Rumah panggung megah beratap limas dengan konfigurasi lantai bertingkat-tingkat (Bengkilas) yang mencerminkan sistem pelapisan sosial pemiliknya. Memiliki aturan adat yang mewajibkan tamu singgah di area teras atas terlebih dahulu.",
        "imageUrl":
            "https://www.indonesia.travel/contentassets/a7674ddd39a44f52a3c7c74651a3e411/rumah-limas.jpeg",
      },
      "rak9_Babel_009": {
        "category": "Sumatera",
        "title": "Rumah Rakit",
        "location": "Bangka Belitung",
        "description":
            "Rumah terapung adaptif di atas rakit bambu tebal berlapis kayu ulin dan diikat erat menggunakan rotan. Berfungsi penuh sebagai hunian masyarakat pesisir dan sungai dengan perpaduan gaya Melayu lokal serta arsitektur Tionghoa.",
        "imageUrl":
            "https://media.tampang.com/tm_images/article/202406/desain-tanpap6otjxbyzivphr6e.jpg",
      },
      "nuw9_Lampung_010": {
        "category": "Sumatera",
        "title": "Rumah Nuwo Sesat",
        "location": "Lampung",
        "description":
            "Balai panggung agung (Balai Agung) berukuran monumental dengan ragam hias ukiran ornamen khas Lampung pada sisinya. Difungsikan secara eksklusif sebagai pusat musyawarah adat (Pepung Adat) para Penyimbang.",
        "imageUrl":
            "https://www.indonesia.travel/contentassets/f11b52c9349c43f78e9872b2ae3417bc/nuwo-sesat-traditional-house.jpg",
      },

      // ================== KATEGORI: JAWA ==================
      "doc_baduy_01a": {
        "category": "Jawa",
        "title": "Rumah Sulah Nyanda",
        "location": "Banten",
        "description":
            "Rumah panggung tradisional suku Baduy yang dibangun secara gotong royong mengikuti kontur tanah alami tanpa eksploitasi. Menggunakan batu kali sebagai tumpuan tiang kayu, lantai bambu bilah, dinding anyaman bambu, serta atap ijuk kering. Pembagian ruangannya terdiri dari sosoro untuk area sosial dan menenun, tepas untuk ruang keluarga, dan ipah di bagian belakang sebagai dapur serta tempat penyimpanan hasil panen padi.",
        "imageUrl":
            "https://www.indonesia.travel/contentassets/b92c93070d87405e8dcc7627fd057b28/sulah-nyanda-house.jpg",
      },

      "doc_betawi_02b": {
        "category": "Jawa",
        "title": "Rumah Kebaya",
        "location": "DKI Jakarta",
        "description":
            "Rumah adat suku Betawi yang dicirikan oleh atap pelana lipat menyerupai kain kebaya tradisional. Memiliki teras depan (amben) terbuka yang sangat luas untuk menyambut tamu, dibatasi oleh pagar kayu setinggi 80 cm sebagai simbol batasan moral keagamaan. Dinding panel kayunya fleksibel dan dapat digeser untuk memperluas ruangan saat hajatan, serta dihiasi ukiran gigi balang dan motif banji.",
        "imageUrl":
            "https://www.indonesia.travel/contentassets/39b319d7764b49c6bdc465f55df7fac4/rumah-kebaya-betawi.jpg",
      },

      "doc_sunda_03c": {
        "category": "Jawa",
        "title": "Rumah Kasepuhan Cirebon",
        "location": "Jawa Barat",
        "description":
            "Bangunan istana bersejarah yang menampilkan perpaduan budaya Sunda, Cirebon, Hindu, dan kolonial. Konstruksi kayunya dirakit tanpa paku menggunakan pasak kayu (paseuk). Tata ruangnya meliputi regol sebagai gerbang utama, bale kambang yang terapung di atas kolam untuk peristirahatan, babancong sebagai panggung pejabat di dekat alun-alun, serta pakuwon sebagai pekarangan pribadi.",
        "imageUrl":
            "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTdlhlz9pR39VQZUIlxRtRb2yNqIagu2pFw4A&s",
      },

      "doc_jateng_04d": {
        "category": "Jawa",
        "title": "Rumah Joglo Jawa Tengah",
        "location": "Jawa Tengah",
        "description":
            "Hunian tradisional Jawa Tengah dengan denah dasar bujur sangkar dan atap tajug menjulang menyerupai bentuk gunung suci. Struktur utamanya ditopang oleh soko guru berupa empat tiang kayu jati di tengah ruangan dengan langit-langit tumpang sari berukir. Pembagian ruangnya meliputi pendopo terbuka di bagian depan, pringgitan untuk pementasan wayang, dan dalem dengan tiga senthong.",
        "imageUrl":
            "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRqh9guwqGyS634lHa-mxQHOW4aIroQMY9C0Q&s",
      },

      "doc_diy_05e": {
        "category": "Jawa",
        "title": "Rumah Bangsal Kencono",
        "location": "DI Yogyakarta",
        "description":
            "Istana resmi keluarga Keraton Yogyakarta yang mengadopsi bentuk joglo monumental dengan teras dan halaman yang sangat luas. Menggunakan pilar soko guru kokoh dari kayu jati dan nangka berhias ukiran emas, lantai marmer dan granit yang ditinggikan, serta memadukan konsep kejawen murni dengan ornamen dekoratif asal Belanda, Portugis, Cina, dan Hindu.",
        "imageUrl":
            "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcT9UOv0W5SYFo2zrrBxVOkbtarJAAr_eIkWsQ&s",
      },

      "doc_jatim_06f": {
        "category": "Jawa",
        "title": "Rumah Joglo Situbondo",
        "location": "Jawa Timur",
        "description":
            "Rumah tradisional khas Jawa Timur bagian timur yang dibangun menggunakan kayu jati murni berukuran compact dengan atap limasan sederhana. Memiliki pintu masuk utama (makara) berhiaskan ukiran seluru gelung sebagai penolak bala spiritual, serta senthong tengah yang disakralkan dan diterangi lampu siang malam sebagai pusat meditasi keluarga.",
        "imageUrl":
            "https://seringjalan.com/wp-content/uploads/2020/04/joglositubondo.jpg",
      },

      // ================== KATEGORI: KALIMANTAN ==================
      "doc_kalteng_betang_01": {
        "category": "Kalimantan",
        "title": "Rumah Betang",
        "location": "Kalimantan Tengah",
        "description":
            "Rumah panggung tradisional ikonik suku Dayak di Kalimantan Tengah yang dicirikan oleh struktur memanjang hingga mencapai 150 meter dengan lebar 30 meter dan tinggi tiang penyangga 3-5 meter dari permukaan tanah untuk menghindari ancaman banjir musiman di sekitar sungai. Berfungsi sebagai jantung struktur sosial komunal yang menyatukan puluhan keluarga dari satu klan kekerabatan dalam satu atap guna memupuk nilai kebersamaan.",
        "imageUrl":
            "https://static.promediateknologi.id/crop/0x0:0x0/0x0/webp/photo/p2/243/2024/08/13/c31b27fa-7313-4763-b8a5-d584600cc722-2157154275.jpg",
      },

      "doc_kaltim_lamin_02": {
        "category": "Kalimantan",
        "title": "Rumah Lamin",
        "location": "Kalimantan Timur",
        "description":
            "Rumah panjang khas suku Dayak Kenyah di Kalimantan Timur berukuran besar dengan panjang sekitar 300 meter, lebar 15 meter, dan tinggi tiang pancang sekitar 3 meter untuk menampung puluhan keluarga.[2]",
        "imageUrl":
            "https://akselerasi.id/wp-content/uploads/2021/07/egzk3hvwqdn3lmbdda79.jpg",
      },

      "doc_kaltara_baloy_03": {
        "category": "Kalimantan",
        "title": "Rumah Adat Baloy",
        "location": "Kalimantan Utara",
        "description":
            "Rumah panggung tradisional Dayak Tidung di Kalimantan Utara yang dibangun menggunakan material utama kayu ulin berserat kuat dengan pintu utama menghadap selatan dan hunian menghadap utara.[1, 3]",
        "imageUrl":
            "https://backpackerjakarta.com/wp-content/uploads/2018/02/Rumah-Adat-Baloy-Mayo-Tarakan.jpg",
      },

      "doc_kalsel_bubung_04": {
        "category": "Kalimantan",
        "title": "Rumah Bubungan Tinggi",
        "location": "Kalimantan Selatan",
        "description":
            "Arsitektur kasta tertinggi suku Banjar di Kalimantan Selatan yang dahulu menjadi istana resmi Sultan Banjar, bercirikan atap pelana tegak lurus menjulang tinggi yang merepresentasikan pohon kehidupan.",
        "imageUrl":
            "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcS6uZtgaLT7ek6vWHTpdtRpnunG3We3S-nvAA&s",
      },

      "doc_kalbar_baluk_05": {
        "category": "Kalimantan",
        "title": "Rumah Adat Baluk",
        "location": "Kalimantan Barat",
        "description":
            "Rumah ritual berbentuk lingkaran dengan diameter 10 meter dan tinggi 12 meter milik suku Dayak Bidayuh, disangga 20 tiang miring dan berfungsi menyimpan pusaka tengkorak upacara Nyobeng.[4, 5]",
        "imageUrl":
            "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcS9bvjse5nyRl11OpuNrHNQi0_ffbRxWocRqQ&s",
      },

      "doc_kalsel_lanting_06": {
        "category": "Kalimantan",
        "title": "Rumah Lanting",
        "location": "Kalimantan Selatan",
        "description":
            "Rumah terapung vernakular masyarakat Banjar yang didirikan di sepanjang aliran sungai dengan fondasi rakit batang log ulin besar yang terikat kuat agar dinamis naik-turun mengikuti pasang surut.[6, 7]",
        "imageUrl":
            "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTQUOT5PdTPgghmwvCKtbcGNYheBC2gUBpPjw&s",
      },

      "doc_kalbar_radakng_07": {
        "category": "Kalimantan",
        "title": "Rumah Radakng",
        "location": "Kalimantan Barat",
        "description":
            "Replika rumah panjang raksasa suku Dayak Kanayatn di Pontianak sepanjang 138 meter dan tinggi lantai 7 meter dari tanah yang kokoh menggunakan struktur kayu ulin sebagai pusat preservasi kesenian.[8, 4]",
        "imageUrl": "https://pontinesia.com/radakng/2.jpg",
      },

      "doc_kalsel_gajah_08": {
        "category": "Kalimantan",
        "title": "Rumah Gajah Baliku",
        "location": "Kalimantan Selatan",
        "description":
            "Rumah tradisional suku Banjar bagi keluarga dekat sultan, mirip tipe Bubungan Tinggi namun memiliki lantai ruang tamu datar tanpa jenjang bertingkat ekstrem serta atap ditopang konstruksi kuda-kuda.[7, 9]",
        "imageUrl":
            "https://indonesiatraveler.id/wp-content/uploads/2020/10/Banjarmasin-Rumah-Adat-Banjar-Rumah-Gajah-Baliku.jpg",
      },

      "doc_kalbar_melayu_10": {
        "category": "Kalimantan",
        "title": "Rumah Adat Melayu Pontianak",
        "location": "Kalimantan Barat",
        "description":
            "Rumah panggung tradisional Melayu Pontianak dengan atap segitiga curam kemiringan 30 derajat pengaruh Jawa untuk memperlancar pelepasan udara panas khatulistiwa secara alami pasif.[10, 4]",
        "imageUrl":
            "https://www.indonesia.travel/contentassets/c4bc60304e984510893f4cdd98c8c0f6/keunikan-rumah-adat-melayu-di-kalimantan-barat.jpg",
      },

      "doc_kalbar_balai_11": {
        "category": "Kalimantan",
        "title": "Rumah Balai",
        "location": "Kalimantan Barat",
        "description":
            "Rumah panjang tradisional suku Dayak Iban di Kalimantan Barat dengan struktur knock-down ramah lingkungan serta tiang penopang dari batang kayu bulat utuh alami yang adaptif gempa.[10, 5]",
        "imageUrl":
            "https://pariwisataindonesia.id/wp-content/uploads/2020/06/Rumah-Adat-Banjar-Balai-Laki-foto-banjarmasin.tribunnews.com_.jpg",
      },
      "doc_kaltara_lundayeh_12": {
        "category": "Kalimantan",
        "title": "Rumah Panjang Lundayeh",
        "location": "Kalimantan Utara",
        "description":
            "Rumah panjang tradisional Dayak Lundayeh di Desa Wisata Setulang, Malinau yang menggunakan material kayu ulin pada lantai serta dihiasi ukiran tanaman pakis dan burung enggang khas Lundayeh.[11, 12]",
        "imageUrl":
            "https://upload.wikimedia.org/wikipedia/commons/thumb/7/75/Rumah_Panjang_Dayak_Lundayeh_-_Lundayeh_Dayaknese_Long_House.jpg/1920px-Rumah_Panjang_Dayak_Lundayeh_-_Lundayeh_Dayaknese_Long_House.jpg",
      },

      // ================== KATEGORI: SULAWESI ==================
      "doc_sulsel_tongkonan_2026": {
        "category": "Sulawesi",
        "title": "Rumah Tongkonan",
        "location": "Sulawesi Selatan",
        "description":
            "Rumah adat panggung suku Toraja yang terkenal dengan atap melengkung ekstrem menyerupai perahu sebagai bentuk penghormatan kosmologis terhadap nenek moyang. Bangunan ini dikonstruksikan dari kayu uru tanpa menggunakan paku besi. Terdiri dari tiga tingkatan ruang: Rattiang Banua (loteng pusaka), Kale Banua (ruang harian keluarga), dan Sulluk Banua (kolong ternak). Keberadaan tanduk dan kepala kerbau di bagian depan menjadi indikator stratifikasi sosial pemiliknya.",
        "imageUrl":
            "https://ik.imagekit.io/goodid/gnfi/uploads/articles/large-rumah-tongkonan-filosofi-dan-simbol-masyarakat-suku-toraja-219436b5ac979aece2074adecc.jpg?tr=w-1200,h-675,fo-center",
      },

      "doc_sulteng_tambi_2026": {
        "category": "Sulawesi",
        "title": "Rumah Tambi",
        "location": "Sulawesi Tengah",
        "description":
            "Rumah tradisional suku Lore dan Kaili yang berbentuk panggung rendah dengan ketinggian tiang penyangga kurang dari satu meter. Atapnya berbentuk prisma segitiga curam dari bahan ijuk atau daun rumbia yang menjulur ke bawah berfungsi langsung sebagai dinding luar rumah. Desain interior mengusung konsep ruang tunggal terbuka tanpa sekat untuk menjaga kebersamaan, dilengkapi hiasan kepala kerbau (pebaula) sebagai lambang kekayaan pemilik.",
        "imageUrl":
            "https://indomgb.s3.amazonaws.com/wp-content/uploads/2022/11/22020857/Rumah-Tambi-768x512.jpeg",
      },

      "doc_sulteng_souraja_2026": {
        "category": "Sulawesi",
        "title": "Rumah Souraja",
        "location": "Sulawesi Tengah",
        "description":
            "Istana kayu megah berukuran 32 x 11.5 meter peninggalan Raja Yodjokodi dari Kerajaan Palu yang didirikan pada tahun 1892. Mengintegrasikan perpaduan arsitektur Kaili dan Bugis, rumah panggung seismik ini ditopang oleh 36 tiang kayu besi tanpa paku. Dinding dan kusen dihiasi oleh seni ukiran kaligrafi Arab serta motif tradisional pompeninie. Tata ruang dibagi menjadi tiga zona aksial untuk menjaga privasi urusan keluarga dari area publik.",
        "imageUrl":
            "https://cdn.grid.id/crop/0x0:0x0/700x465/photo/bobofoto/original/2809_rumah-adat-keluarga-bangsawan.jpg",
      },

      "doc_sulbar_boyang_2026": {
        "category": "Sulawesi",
        "title": "Rumah Boyang",
        "location": "Sulawesi Barat",
        "description":
            "Hunian tradisional suku Mandar yang mengadopsi struktur panggung dengan kaki-kaki tiang yang berdiri bebas di atas batu fondasi alam demi meredam getaran gempa. Terbagi menjadi tipe Boyang Adaq untuk kasta bangsawan dengan penutup bubungan (tumbaq layar) bersusun tiga hingga tujuh serta tangga ganda berpararang, dan tipe Boyang Beasa dengan bubungan tunggal untuk rakyat biasa.",
        "imageUrl":
            "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQnxeQQr335ypwQ7HrxVI9LBfMfX_pLQE1KPw&s",
      },

      "doc_sultra_banuatada_2026": {
        "category": "Sulawesi",
        "title": "Rumah Banua Tada",
        "location": "Sulawesi Tenggara",
        "description":
            "Rumah adat suku Wolio di Buton yang didesain secara unik tanpa menggunakan paku besi tunggal pun, melainkan mengandalkan sambungan siku kayu jati yang presisi. Berdasarkan strata sosial, hunian ini dibedakan menjadi Kamali atau Malige (istana kesultanan berlantai empat dengan 40 tiang), Banua Tada Tare Pata Pale (hunian bertiang empat untuk pejabat), dan Banua Tada Tare Talu Pale (hunian bertiang tiga untuk rakyat). Kemiringan atapnya melambangkan dua tangan yang sedang berdoa.",
        "imageUrl":
            "https://www.indonesia.travel/contentassets/189b0277459d443b8e6263bb2785380c/banua-tada-traditional-house.jpg",
      },

      "doc_gorontalo_dulohupa_2026": {
        "category": "Sulawesi",
        "title": "Rumah Dulohupa",
        "location": "Gorontalo",
        "description":
            "Balai pertemuan dan pengadilan adat tertinggi di Gorontalo yang melambangkan musyawarah mufakat di bawah falsafah adat bersendikan syarak. Desain panggung bangunan merepresentasikan anatomi tubuh manusia (atap kepala, badan rumah, dan tiang kaki). Didukung oleh 2 tiang utama (wolihi) sebagai simbol ikrar persatuan Gorontalo-Limboto tahun 1664, 6 tiang depan pelambang keluhuran sifat, serta 32 pilar penunjuk arah mata angin.",
        "imageUrl":
            "https://www.indonesia.travel/contentassets/3a00d8b93a384251a2d9f8d8790ff7f3/the-dulohupa-traditional-house.jpg",
      },

      "doc_sulut_walewangko_2026": {
        "category": "Sulawesi",
        "title": "Rumah Walewangko",
        "location": "Sulawesi Utara",
        "description":
            "Rumah panggung tradisional warisan suku Minahasa di Tanah Malesung yang memiliki ketahanan seismik unggul berkat 26 tiang penyangga kayu utuh tanpa sambungan. Struktur depannya dicirikan oleh keberadaan tangga ganda simetris di sisi kiri dan kanan yang dipercaya secara filosofis dapat menangkal dan memutarbalikkan peredaran roh jahat. Dinding luarnya dihiasi ukiran berwarna kuning, putih, dan hitam sebagai penolak bala.",
        "imageUrl":
            "https://pariwisataindonesia.id/wp-content/uploads/2020/08/Rumah-Adat-Walewangko-foto-by-polarumahcom.jpg",
      },

      // ================== KATEGORI: PAPUA ==================
      "doc_papua_honai_2026": {
        "category": "Papua",
        "title": "Rumah Honai",
        "location": "Papua Pegunungan",
        "description":
            "Rumah adat khas suku Dani yang diperuntukkan bagi kaum laki-laki dewasa (Honai Pilamo). Bangunan berstruktur lingkaran dengan diameter rata-rata 5 meter dan tinggi 2.5 meter ini dirancang tanpa jendela dengan satu pintu masuk rendah. Desain aerodinamis ini dikombinasikan dengan atap kubah jerami atau alang-alang tebal guna menjebak panas dari tungku api pusat (hearth) dan memberikan perlindungan termal maksimal terhadap suhu dingin ekstrem pegunungan tengah Papua.",
        "imageUrl":
            "https://image.idn.media/post/20201028/rumah-adat-papua-honai-7e2ee11c0f892f5fa5ee919ac8116528.jpg",
      },

      "doc_papua_ebei_2026": {
        "category": "Papua",
        "title": "Rumah Ebei",
        "location": "Papua Pegunungan",
        "description":
            "Rumah adat tradisional suku Dani yang difungsikan khusus sebagai hunian bagi kaum wanita, anak-anak perempuan, serta anak laki-laki yang belum dewasa. Secara arsitektural, bentuknya menyerupai Honai namun dengan dimensi vertikal yang lebih rendah. Rumah ini memiliki nilai filosofis tinggi sebagai simbol rahim kehidupan dan berfungsi sebagai pusat transfer pengetahuan adat non-formal, di mana para ibu mendidik anak gadis mengenai keterampilan domestik, moralitas, dan pembuatan kerajinan tangan.",
        "imageUrl":
            "https://pesonapapua.com/wp-content/uploads/2024/04/Deretan-Rumah-Adat-Papua-beserta-Nama-Keunikan-Ciri-ciri-dan-Gambarnya.jpg",
      },

      "doc_papua_hunila_2026": {
        "category": "Papua",
        "title": "Rumah Hunila",
        "location": "Papua Pegunungan",
        "description":
            "Merupakan struktur dapur umum terpusat yang melayani beberapa unit keluarga di dalam satu kompleks pemukiman adat (silimo) suku Dani. Bangunan ini memiliki desain yang jauh lebih memanjang dan luas dibandingkan Honai atau Ebei. Di dalam Hunila, para wanita berkolaborasi mengolah bahan makanan pokok seperti sagu dan ubi jalar di atas perapian batu besar, untuk kemudian dibagikan secara adil kepada seluruh penghuni silimo sebagai perwujudan nyata dari nilai gotong royong dan kebersamaan.",
        "imageUrl":
            "https://i0.wp.com/www.rukita.co/stories/wp-content/uploads/2022/04/Rumah-Hunila.jpeg?resize=720%2C443&ssl=1",
      },

      "doc_papua_wamai_2026": {
        "category": "Papua",
        "title": "Rumah Wamai",
        "location": "Papua Pegunungan",
        "description":
            "Unit struktural berbentuk lingkaran di dalam komplek silimo suku Dani yang dibangun khusus untuk mengandangkan ternak, terutama babi. Penggunaan material dinding kayu rapat dan atap jerami tebal pada Wamai bertujuan melindungi aset ekonomi penting tersebut dari serangan hawa dingin pegunungan dan predator malam. Struktur ini membuktikan pendekatan holistik masyarakat pegunungan dalam merancang tata ruang yang mengintegrasikan ruang hunian manusia dengan perlindungan hewan domestik.",
        "imageUrl":
            "https://pesonapapua.com/wp-content/uploads/2023/10/WhatsApp-Image-2023-10-24-at-20.27.39.jpeg",
      },

      "doc_papua_kariwari_2026": {
        "category": "Papua",
        "title": "Rumah Kariwari",
        "location": "Papua",
        "description":
            "Rumah adat sakral milik suku Tobati-Enggros yang mendiami wilayah pesisir danau. Bangunan ini berbentuk limas segi delapan (oktagonal) dengan atap mengerucut tinggi setinggi tiga lantai yang melambangkan hubungan spiritual bertingkat antara manusia dengan roh leluhur dan Tuhan. Dibangun menggunakan kayu besi kokoh, lantai pertama difungsikan untuk mendidik pemuda dalam keterampilan berburu dan perang, lantai kedua untuk musyawarah dewan adat, dan lantai ketiga sebagai ruang sakral penyimpanan artefak suci.",
        "imageUrl":
            "https://blog.sahabatpedalaman.org/wp-content/uploads/2022/12/rumah-kariwari.jpg",
      },

      "doc_papua_rumsram_2026": {
        "category": "Papua",
        "title": "Rumah Rumsram",
        "location": "Papua",
        "description":
            "Rumah adat suku Biak Numfor yang dibangun dengan model panggung setinggi 6 hingga 8 meter untuk mengantisipasi pasang surut air laut di pesisir utara. Ciri paling menonjol adalah struktur atapnya yang melengkung menyerupai lambung perahu terbalik, yang merepresentasikan identitas sejarah suku Biak sebagai pelaut tangguh. Menggunakan material lantai dari kulit kayu kasar dan dinding dari belahan bambu air, Rumsram digunakan sebagai pusat inisiasi adat dan pendidikan bahari bagi para pemuda sebelum beranjak dewasa.",
        "imageUrl":
            "https://asset.kompas.com/crops/gjDHghr0c4djkbnWEpuEaKOjvwA=/0x7:468x319/1200x800/data/photo/2023/01/09/63bbf2d018de3.jpg",
      },
      "doc_papua_pohon_2026": {
        "category": "Papua",
        "title": "Rumah Pohon",
        "location": "Papua Selatan",
        "description":
            "Struktur hunian ekstrem milik suku Korowai yang didirikan di atas dahan pohon besar pada ketinggian 15 hingga 50 meter dari permukaan tanah. Rangka bangunan dibuat dari kayu hutan berdensitas tinggi, berlantai bambu bilah, dan beratap daun sagu. Selain melindungi dari hewan buas dan banjir luapan sungai hutan, elevasi ekstrem ini didasarkan pada kepercayaan spiritual suku Korowai untuk menjauhkan diri dari jangkauan roh jahat pemakan manusia (laleo) yang diyakini berkeliaran di permukaan tanah pada malam hari.",
        "imageUrl":
            "https://pdbifiles.nos.jkt-1.neo.id/files/2017/10/28/apriyn7_750x500-mengintip-suku-korowai-di-kabupaten-mappi-irian-jaya-160701z.jpg",
      },

      "doc_papua_jew_2026": {
        "category": "Papua",
        "title": "Rumah Jew",
        "location": "Papua Selatan",
        "description":
            "Dikenal sebagai Rumah Bujang, Jew merupakan bangunan komunal paling sakral bagi suku Asmat yang didirikan di atas rawa pasang surut menggunakan sistem panggung tanpa paku. Memiliki panjang antara 30 hingga 60 meter, rumah ini memiliki jumlah pintu masuk yang disesuaikan secara presisi dengan jumlah klan (Mew) di desa tersebut. Tiang penyangga utamanya diukir dengan figur leluhur (Bisj Pole) yang rumit. Jew berfungsi sebagai pusat pemerintahan adat, perencanaan perang, inisiasi spiritual pemuda, dan galeri seni ukir dunia.",
        "imageUrl":
            "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTfeDkXdveK520_EDd5FFYMH3UCRa-pdnN7UQ&s",
      },

      "doc_papua_modakiaksa_2026": {
        "category": "Papua",
        "title": "Rumah Mod Aki Aksa",
        "location": "Papua Barat",
        "description":
            "Dikenal luas sebagai Rumah Kaki Seribu, bangunan panggung tradisional suku Arfak ini ditopang oleh ratusan tiang kayu berdiameter kecil (10-15 cm) yang ditanam sangat rapat di bawah lantai setinggi 1 hingga 1.5 meter. Struktur pilar masif ini berfungsi menyebarkan beban secara merata di atas permukaan tanah pegunungan yang labil dan rawan longsor. Dinding luar terbuat dari lembaran kulit kayu tebal yang diikat serat rotan tanpa adanya jendela, mengisolasi bagian dalam rumah dari angin dingin pegunungan Arfak.",
        "imageUrl":
            "https://upload.wikimedia.org/wikipedia/commons/thumb/3/3d/Rumah_Kaki_Seribu_%28Mod_Aki_Aksa%29.jpg/1920px-Rumah_Kaki_Seribu_%28Mod_Aki_Aksa%29.jpg",
      },
    };

    // Gunakan WriteBatch agar proses pengiriman data aman, cepat, dan atomik
    final WriteBatch batch = FirebaseFirestore.instance.batch();
    sampleHouses.forEach((key, value) {
      final docRef = houses.doc(key);
      batch.set(docRef, value);
    });
    await batch.commit();
  }

  /// Melakukan seed data 100 pertanyaan kuis ke Firestore (kuis_soal)
  static Future<void> seedQuizQuestions() async {
    final CollectionReference quizCollection = FirebaseFirestore.instance
        .collection('kuis_soal');

    // Hapus data lama terlebih dahulu agar tidak duplikat jika di-sync ulang
    final oldDocs = await quizCollection.get();
    final WriteBatch deleteBatch = FirebaseFirestore.instance.batch();
    for (var doc in oldDocs.docs) {
      deleteBatch.delete(doc.reference);
    }
    await deleteBatch.commit();

    final List<Map<String, dynamic>> questions = [
      // --- SUMATERA ---
      {
        'region': 'Sumatera',
        'questionText':
            'Bagian atap berbentuk tanduk kerbau (gonjong) merupakan ciri khas dari...',
        'questionImageUrl': '',
        'options': [
          'Rumah Gadang',
          'Rumah Joglo',
          'Rumah Honai',
          'Rumah Limas',
        ],
        'correctAnswerIndex': 0,
      },
      {
        'region': 'Sumatera',
        'questionText':
            'Fungsi utama rumah yang berbentuk panggung tinggi di Sumatera adalah untuk...',
        'questionImageUrl': '',
        'options': [
          'Keindahan estetika',
          'Menghindari binatang buas & banjir',
          'Menyimpan hasil bumi',
          'Tempat beribadah',
        ],
        'correctAnswerIndex': 1,
      },
      {
        'region': 'Sumatera',
        'questionText':
            'Rumah tradisional Aceh yang memiliki ciri khas tangga masuk di bawah kolong rumah disebut...',
        'questionImageUrl': '',
        'options': [
          'Rumah Limas',
          'Krong Bade',
          'Rumah Gadang',
          'Rumah Selaso Jatuh Kembar',
        ],
        'correctAnswerIndex': 1,
      },
      {
        'region': 'Sumatera',
        'questionText':
            'Rumah adat Palembang yang memiliki struktur bertingkat-tingkat untuk menunjukkan strata sosial disebut...',
        'questionImageUrl': '',
        'options': [
          'Rumah Melayu',
          'Rumah Panggung',
          'Rumah Limas',
          'Rumah Gadang',
        ],
        'correctAnswerIndex': 2,
      },
      {
        'region': 'Sumatera',
        'questionText':
            'Ukiran khas Minangkabau di dinding Rumah Gadang umumnya bermotif...',
        'questionImageUrl': '',
        'options': ['Hewan buas', 'Alam dan tumbuhan', 'Senjata', 'Dewa-dewi'],
        'correctAnswerIndex': 1,
      },
      {
        'region': 'Sumatera',
        'questionText':
            'Rumah Bolon yang berbentuk panggung kayu beratap ijuk adalah rumah tradisional dari suku...',
        'questionImageUrl': '',
        'options': ['Minangkabau', 'Batak', 'Melayu', 'Nias'],
        'correctAnswerIndex': 1,
      },
      {
        'region': 'Sumatera',
        'questionText':
            'Lumbung padi tradisional di Minangkabau yang sering berada di depan Rumah Gadang disebut...',
        'questionImageUrl': '',
        'options': ['Rangkiang', 'Anjungan', 'Gebyok', 'Dalem'],
        'correctAnswerIndex': 0,
      },
      {
        'region': 'Sumatera',
        'questionText':
            'Rumah adat khas Melayu Riau yang difungsikan sebagai tempat pertemuan adat dan musyawarah disebut...',
        'questionImageUrl': '',
        'options': [
          'Rumah Selaso Jatuh Kembar',
          'Rumah Gadang',
          'Rumah Bolon',
          'Rumah Bubungan Lima',
        ],
        'correctAnswerIndex': 0,
      },
      {
        'region': 'Sumatera',
        'questionText':
            'Rumah adat terapung yang didirikan di atas rakit bambu tebal di daerah Bangka Belitung disebut...',
        'questionImageUrl': '',
        'options': [
          'Rumah Rakit',
          'Rumah Lanting',
          'Rumah Panggung',
          'Rumah Kaki Seribu',
        ],
        'correctAnswerIndex': 0,
      },
      {
        'region': 'Sumatera',
        'questionText':
            'Nama rumah adat yang menjadi balai pertemuan masyarakat adat di Lampung adalah...',
        'questionImageUrl': '',
        'options': [
          'Rumah Nuwo Sesat',
          'Rumah Kebaya',
          'Rumah Limas',
          'Rumah Bubungan Lima',
        ],
        'correctAnswerIndex': 0,
      },
      {
        'region': 'Sumatera',
        'questionText':
            'Rumah adat di Sumatera Barat yang memiliki anjungan di ujung kanan dan kiri bangunan untuk tempat kehormatan adalah tipe...',
        'questionImageUrl': '',
        'options': [
          'Rumah Gadang Batingkek',
          'Rumah Gadang Koto Piliang',
          'Rumah Gadang Bodi Caniago',
          'Rumah Gadang Kajang Padati',
        ],
        'correctAnswerIndex': 1,
      },
      {
        'region': 'Sumatera',
        'questionText':
            'Rumah Bubungan Lima merupakan rumah adat dari provinsi...',
        'questionImageUrl': '',
        'options': ['Bengkulu', 'Jambi', 'Riau', 'Kepulauan Riau'],
        'correctAnswerIndex': 0,
      },
      {
        'region': 'Sumatera',
        'questionText':
            'Bahan penutup atap yang umum digunakan pada Rumah Bolon Batak Toba tradisional adalah...',
        'questionImageUrl': '',
        'options': ['Ijuk', 'Seng', 'Genteng Tanah Liat', 'Jerami'],
        'correctAnswerIndex': 0,
      },
      {
        'region': 'Sumatera',
        'questionText':
            'Rumah adat Belah Bubung merupakan rumah adat khas yang berasal dari...',
        'questionImageUrl': '',
        'options': [
          'Kepulauan Riau',
          'Bangka Belitung',
          'Aceh',
          'Sumatera Barat',
        ],
        'correctAnswerIndex': 0,
      },
      {
        'region': 'Sumatera',
        'questionText':
            'Rumah adat Jambi yang atapnya melengkung menyerupai haluan perahu dan memiliki sebutan atap "Gajah Mabuk" adalah...',
        'questionImageUrl': '',
        'options': [
          'Rumah Panggung (Kajang Lako)',
          'Rumah Krong Bade',
          'Rumah Limas',
          'Rumah Bolon',
        ],
        'correctAnswerIndex': 0,
      },
      {
        'region': 'Sumatera',
        'questionText':
            'Jumlah anak tangga pada akses masuk utama Rumah Krong Bade di Aceh secara adat harus berjumlah...',
        'questionImageUrl': '',
        'options': ['Ganjil', 'Genap', 'Bebas', 'Selalu sepuluh'],
        'correctAnswerIndex': 0,
      },
      {
        'region': 'Sumatera',
        'questionText':
            'Bagian di bawah kolong Rumah Bolon Batak tradisional biasanya difungsikan untuk...',
        'questionImageUrl': '',
        'options': [
          'Kandang hewan ternak',
          'Tempat musyawarah',
          'Kamar tidur tamu',
          'Dapur utama',
        ],
        'correctAnswerIndex': 0,
      },
      {
        'region': 'Sumatera',
        'questionText':
            'Ornamen ukiran pada Rumah Gadang Minangkabau dilarang menggambarkan makhluk hidup secara realistis karena...',
        'questionImageUrl': '',
        'options': [
          'Pengaruh ajaran Islam',
          'Sulit diukir',
          'Bahan kayu yang tidak cocok',
          'Aturan dari masa kolonial',
        ],
        'correctAnswerIndex': 0,
      },
      {
        'region': 'Sumatera',
        'questionText':
            'Soko atau tiang utama penyangga Rumah Bolon diletakkan di atas batu sandi bertujuan untuk...',
        'questionImageUrl': '',
        'options': [
          'Ketahanan terhadap gempa bumi',
          'Menghindari rayap saja',
          'Estetika bangunan',
          'Mudah dipindahkan',
        ],
        'correctAnswerIndex': 0,
      },
      {
        'region': 'Sumatera',
        'questionText':
            'Rumah adat Nuwo Sesat dari Lampung dibangun menghadap ke...',
        'questionImageUrl': '',
        'options': [
          'Aliran air atau sungai',
          'Arah barat saja',
          'Arah utara saja',
          'Pegunungan terdekat',
        ],
        'correctAnswerIndex': 0,
      },

      // --- JAWA ---
      {
        'region': 'Jawa',
        'questionText':
            'Empat tiang utama penyangga penyangga atap pada Rumah Joglo disebut...',
        'questionImageUrl': '',
        'options': ['Tiang Tuo', 'Soko Guru', 'Soko Jajar', 'Tiang Seri'],
        'correctAnswerIndex': 1,
      },
      {
        'region': 'Jawa',
        'questionText':
            'Bagian teras depan terbuka di Rumah Joglo yang berfungsi menerima tamu disebut...',
        'questionImageUrl': '',
        'options': ['Pringgitan', 'Pendopo', 'Dalem', 'Sentong'],
        'correctAnswerIndex': 1,
      },
      {
        'region': 'Jawa',
        'questionText':
            'Rumah adat tradisional Suku Baduy di Banten yang bentuknya menyesuaikan kontur tanah disebut...',
        'questionImageUrl': '',
        'options': ['Sulah Nyanda', 'Rumah Kebaya', 'Joglo', 'Kasepuhan'],
        'correctAnswerIndex': 0,
      },
      {
        'region': 'Jawa',
        'questionText':
            'Pintu pembatas berukir di rumah tradisional Jawa yang menghubungkan antar ruangan disebut...',
        'questionImageUrl': '',
        'options': ['Gebyok', 'Tumpang Sari', 'Soko Guru', 'Blandar'],
        'correctAnswerIndex': 0,
      },
      {
        'region': 'Jawa',
        'questionText':
            'Atap bersusun yang digunakan di rumah-rumah keraton dan masjid kuno di Jawa disebut atap...',
        'questionImageUrl': '',
        'options': ['Tajug', 'Limasan', 'Panggang Pe', 'Sinom'],
        'correctAnswerIndex': 0,
      },
      {
        'region': 'Jawa',
        'questionText':
            'Rumah adat suku Betawi yang memiliki teras luas disebut...',
        'questionImageUrl': '',
        'options': [
          'Rumah Kebaya',
          'Rumah Gadang',
          'Rumah Kasepuhan',
          'Rumah Panggung',
        ],
        'correctAnswerIndex': 0,
      },
      {
        'region': 'Jawa',
        'questionText':
            'Susunan kayu bertingkat ke atas yang disangga oleh Soko Guru di Rumah Joglo disebut...',
        'questionImageUrl': '',
        'options': ['Gebyok', 'Dalem', 'Tumpang Sari', 'Pendopo'],
        'correctAnswerIndex': 2,
      },
      {
        'region': 'Jawa',
        'questionText':
            'Istana resmi keluarga Keraton Yogyakarta yang berornamen emas dengan lantai marmer disebut...',
        'questionImageUrl': '',
        'options': [
          'Rumah Bangsal Kencono',
          'Rumah Kasepuhan',
          'Rumah Joglo Situbondo',
          'Rumah Kebaya',
        ],
        'correctAnswerIndex': 0,
      },
      {
        'region': 'Jawa',
        'questionText':
            'Rumah adat Jawa Barat yang memadukan budaya Sunda, Hindu, dan kolonial dengan struktur tanpa paku besi adalah...',
        'questionImageUrl': '',
        'options': [
          'Rumah Kasepuhan Cirebon',
          'Rumah Sulah Nyanda',
          'Rumah Joglo',
          'Rumah Kebaya',
        ],
        'correctAnswerIndex': 0,
      },
      {
        'region': 'Jawa',
        'questionText':
            'Ukiran bermotif naga atau bunga (makara) di pintu masuk Joglo Situbondo berfungsi filosofis sebagai...',
        'questionImageUrl': '',
        'options': [
          'Penolak bala spiritual',
          'Simbol kekayaan',
          'Hiasan biasa',
          'Petunjuk arah mata angin',
        ],
        'correctAnswerIndex': 0,
      },
      {
        'region': 'Jawa',
        'questionText':
            'Rumah adat Banten "Sulah Nyanda" menggunakan bahan apa untuk membuat lantai rumah panggungnya?',
        'questionImageUrl': '',
        'options': [
          'Bilah bambu (talup)',
          'Papan kayu jati',
          'Marmer',
          'Semen cor',
        ],
        'correctAnswerIndex': 0,
      },
      {
        'region': 'Jawa',
        'questionText':
            'Rumah adat suku Sunda yang atapnya berbentuk seperti tanduk domba atau segitiga sama kaki disebut...',
        'questionImageUrl': '',
        'options': [
          'Julang Ngapak',
          'Badak Heuay',
          'Togo Anjing',
          'Capit Gunting',
        ],
        'correctAnswerIndex': 0,
      },
      {
        'region': 'Jawa',
        'questionText':
            'Bagian paling belakang pada rumah Joglo Jawa Tengah yang bersifat privat dan digunakan untuk tidur disebut...',
        'questionImageUrl': '',
        'options': ['Dalem / Omah Jero', 'Pendopo', 'Pringgitan', 'Gebyok'],
        'correctAnswerIndex': 0,
      },
      {
        'region': 'Jawa',
        'questionText':
            'Kamar suci di bagian belakang Joglo yang sering dikaitkan dengan pemujaan Dewi Sri (Dewi Padi) disebut...',
        'questionImageUrl': '',
        'options': [
          'Senthong Tengah',
          'Senthong Kiwa',
          'Senthong Tengen',
          'Pringgitan',
        ],
        'correctAnswerIndex': 0,
      },
      {
        'region': 'Jawa',
        'questionText':
            'Pagar kayu setinggi 80 cm di sekeliling teras Rumah Kebaya khas Betawi memiliki makna filosofis sebagai...',
        'questionImageUrl': '',
        'options': [
          'Batasan moral dan tata krama kesopanan',
          'Penghalau hewan liar',
          'Penyangga atap tambahan',
          'Pajangan estetika belaka',
        ],
        'correctAnswerIndex': 0,
      },
      {
        'region': 'Jawa',
        'questionText':
            'Bahan utama penyusun dinding (bilik) pada rumah adat Sulah Nyanda suku Baduy adalah...',
        'questionImageUrl': '',
        'options': [
          'Anyaman bambu',
          'Batu bata merah',
          'Lempengan batu kali',
          'Papan kayu tebal',
        ],
        'correctAnswerIndex': 0,
      },
      {
        'region': 'Jawa',
        'questionText':
            'Bangunan kecil terapung di atas kolam di depan Keraton Kasepuhan Cirebon yang digunakan untuk santai adalah...',
        'questionImageUrl': '',
        'options': ['Bale Kambang', 'Regol', 'Pakuwon', 'Babancong'],
        'correctAnswerIndex': 0,
      },
      {
        'region': 'Jawa',
        'questionText':
            'Pola hiasan pada pinggiran atap Rumah Kebaya Betawi yang berbentuk segitiga bergerigi melambangkan kegagahan disebut...',
        'questionImageUrl': '',
        'options': [
          'Gigi Balang',
          'Ornamen Banji',
          'Kembang Melati',
          'Pucuk Rebung',
        ],
        'correctAnswerIndex': 0,
      },
      {
        'region': 'Jawa',
        'questionText':
            'Di bawah ini yang merupakan tipe Joglo terkecil dan paling sederhana di Jawa Timur adalah...',
        'questionImageUrl': '',
        'options': [
          'Joglo Situbondo',
          'Joglo Sinom',
          'Joglo Hageng',
          'Joglo Pencu',
        ],
        'correctAnswerIndex': 0,
      },
      {
        'region': 'Jawa',
        'questionText':
            'Sistem sambungan kayu tradisional Jawa tanpa menggunakan paku besi melainkan pasak kayu disebut...',
        'questionImageUrl': '',
        'options': [
          'Sistem Purus dan Knockdown',
          'Sistem Las Kayu',
          'Sistem Kancing Besi',
          'Sistem Lem Selulosa',
        ],
        'correctAnswerIndex': 0,
      },

      // --- KALIMANTAN ---
      {
        'region': 'Kalimantan',
        'questionText':
            'Rumah komunal memanjang Suku Dayak yang bisa menampung puluhan keluarga disebut...',
        'questionImageUrl': '',
        'options': [
          'Rumah Betang',
          'Rumah Banjar',
          'Rumah Lanting',
          'Rumah Honai',
        ],
        'correctAnswerIndex': 0,
      },
      {
        'region': 'Kalimantan',
        'questionText':
            'Rumah Betang umumnya dibangun sejajar atau menghadap ke arah...',
        'questionImageUrl': '',
        'options': ['Gunung', 'Hutan', 'Sungai', 'Barat'],
        'correctAnswerIndex': 2,
      },
      {
        'region': 'Kalimantan',
        'questionText':
            'Rumah Bubungan Tinggi merupakan istana tradisional dari suku...',
        'questionImageUrl': '',
        'options': ['Dayak Kenyah', 'Banjar', 'Melayu', 'Kutai'],
        'correctAnswerIndex': 1,
      },
      {
        'region': 'Kalimantan',
        'questionText':
            'Rumah Lanting adalah rumah unik khas Kalimantan yang dibangun di atas...',
        'questionImageUrl': '',
        'options': ['Pohon besar', 'Tanah gambut', 'Bukit', 'Air / Sungai'],
        'correctAnswerIndex': 3,
      },
      {
        'region': 'Kalimantan',
        'questionText':
            'Tangga masuk pada Rumah Betang tradisional biasanya berupa satu batang pohon utuh yang disebut...',
        'questionImageUrl': '',
        'options': ['Hejot', 'Undakan', 'Batur', 'Titian'],
        'correctAnswerIndex': 0,
      },
      {
        'region': 'Kalimantan',
        'questionText':
            'Rumah Lamin yang sangat luas dengan ukiran khas merah-kuning adalah milik Suku Dayak di provinsi...',
        'questionImageUrl': '',
        'options': ['Kaltim', 'Kalsel', 'Kalbar', 'Kaltara'],
        'correctAnswerIndex': 0,
      },
      {
        'region': 'Kalimantan',
        'questionText':
            'Tujuan arsitektur komunal pada Rumah Betang adalah untuk...',
        'questionImageUrl': '',
        'options': [
          'Menghemat lahan',
          'Mencari kehangatan',
          'Semangat gotong royong & pertahanan',
          'Hanya meniru tradisi',
        ],
        'correctAnswerIndex': 2,
      },
      {
        'region': 'Kalimantan',
        'questionText':
            'Rumah ritual berbentuk lingkaran setinggi 12 meter milik suku Dayak Bidayuh di Kalimantan Barat disebut...',
        'questionImageUrl': '',
        'options': [
          'Rumah Adat Baluk',
          'Rumah Radakng',
          'Rumah Lamin',
          'Rumah Banjar',
        ],
        'correctAnswerIndex': 0,
      },
      {
        'region': 'Kalimantan',
        'questionText':
            'Rumah panggung tradisional suku Dayak Tidung di Kalimantan Utara yang memiliki ukiran khas disebut...',
        'questionImageUrl': '',
        'options': [
          'Rumah Adat Baloy',
          'Rumah Betang',
          'Rumah Lanting',
          'Rumah Lamin',
        ],
        'correctAnswerIndex': 0,
      },
      {
        'region': 'Kalimantan',
        'questionText':
            'Bahan utama yang sangat kuat dan sering digunakan untuk fondasi tiang Rumah Betang karena tahan air adalah kayu...',
        'questionImageUrl': '',
        'options': [
          'Kayu Ulin (Besi)',
          'Kayu Sengon',
          'Kayu Pinus',
          'Kayu Jati',
        ],
        'correctAnswerIndex': 0,
      },
      {
        'region': 'Kalimantan',
        'questionText':
            'Rumah Radakng merupakan replika rumah panjang Suku Dayak Kanayatn yang didirikan di kota...',
        'questionImageUrl': '',
        'options': ['Pontianak', 'Banjarmasin', 'Samarinda', 'Balikpapan'],
        'correctAnswerIndex': 0,
      },
      {
        'region': 'Kalimantan',
        'questionText':
            'Rumah adat Lanting khas Kalimantan Selatan menggunakan apa agar tetap mengapung secara dinamis?',
        'questionImageUrl': '',
        'options': [
          'Batang kayu ulin besar atau bambu rakit',
          'Drum besi kedap udara',
          'Pelampung karet sintetis',
          'Semen ringan berongga',
        ],
        'correctAnswerIndex': 0,
      },
      {
        'region': 'Kalimantan',
        'questionText':
            'Rumah adat Dayak Kenyah di Kalimantan Timur yang memiliki hiasan patung dan ukiran burung enggang disebut...',
        'questionImageUrl': '',
        'options': [
          'Rumah Lamin',
          'Rumah Betang',
          'Rumah Baluk',
          'Rumah Baloy',
        ],
        'correctAnswerIndex': 0,
      },
      {
        'region': 'Kalimantan',
        'questionText':
            'Kayu Ulin (kayu besi) sangat populer di arsitektur Kalimantan karena keunggulannya, yaitu...',
        'questionImageUrl': '',
        'options': [
          'Semakin kuat dan keras jika terkena air',
          'Saras ringan dan elastis',
          'Mudah dibakar untuk perapian',
          'Memiliki aroma wangi yang khas',
        ],
        'correctAnswerIndex': 0,
      },
      {
        'region': 'Kalimantan',
        'questionText':
            'Jumlah pintu masuk pada Rumah Radakng atau Rumah Betang yang sangat banyak biasanya menunjukkan...',
        'questionImageUrl': '',
        'options': [
          'Banyaknya jumlah keluarga/klan yang tinggal',
          'Arah mata angin pelindung',
          'Jumlah hari dalam seminggu',
          'Jumlah musuh yang berhasil dikalahkan',
        ],
        'correctAnswerIndex': 0,
      },
      {
        'region': 'Kalimantan',
        'questionText':
            'Rumah adat tradisional Dayak Lundayeh di Malinau, Kalimantan Utara menggunakan atap dari...',
        'questionImageUrl': '',
        'options': [
          'Daun sagu atau rumbia',
          'Genteng tanah liat',
          'Seng baja ringan',
          'Ijuk tebal',
        ],
        'correctAnswerIndex': 0,
      },
      {
        'region': 'Kalimantan',
        'questionText':
            'Rumah adat Melayu Pontianak memiliki kemiringan atap 30 derajat yang dirancang khusus untuk...',
        'questionImageUrl': '',
        'options': [
          'Mempercepat sirkulasi udara panas khatulistiwa',
          'Menahan tumpukan salju',
          'Kemudahan pemasangan genteng',
          'Mengikuti adat Jawa murni',
        ],
        'correctAnswerIndex': 0,
      },
      {
        'region': 'Kalimantan',
        'questionText':
            'Ornamen ukiran Dayak pada Rumah Lamin yang didominasi warna kuning, merah, dan hitam melambangkan...',
        'questionImageUrl': '',
        'options': [
          'Keagungan, keberanian, dan kekuatan spiritual',
          'Kesedihan, kemarahan, dan kesunyian',
          'Perang, kekayaan, dan kemiskinan',
          'Alam bawah tanah, laut, dan awan',
        ],
        'correctAnswerIndex': 0,
      },
      {
        'region': 'Kalimantan',
        'questionText':
            'Mengapa tiang penyangga Rumah Betang atau Rumah Radakng dibuat sangat tinggi (mencapai 3-7 meter)?',
        'questionImageUrl': '',
        'options': [
          'Menghindari banjir sungai & serangan musuh/hewan buas',
          'Agar dekat dengan langit kediaman dewa',
          'Mengikuti kontur tanah berbukit terjal',
          'Kemudahan dalam membongkar pasang rumah',
        ],
        'correctAnswerIndex': 0,
      },
      {
        'region': 'Kalimantan',
        'questionText':
            'Bangunan adat suku Dayak Bidayuh yang khusus digunakan untuk menyimpan tengkorak hasil ritual adat adalah...',
        'questionImageUrl': '',
        'options': [
          'Rumah Baluk',
          'Rumah Betang',
          'Rumah Lanting',
          'Rumah Lamin',
        ],
        'correctAnswerIndex': 0,
      },

      // --- SULAWESI ---
      {
        'region': 'Sulawesi',
        'questionText':
            'Atap menjulang melengkung pada Rumah Tongkonan (Tana Toraja) terinspirasi dari bentuk...',
        'questionImageUrl': '',
        'options': ['Perahu', 'Gunung', 'Tanduk kerbau', 'Bulan sabit'],
        'correctAnswerIndex': 0,
      },
      {
        'region': 'Sulawesi',
        'questionText':
            'Tumpukan tanduk kerbau di tiang utama Rumah Tongkonan melambangkan...',
        'questionImageUrl': '',
        'options': [
          'Jumlah hewan buruan',
          'Status sosial & strata keluarga',
          'Tanda bahaya',
          'Sistem pelindung rumah',
        ],
        'correctAnswerIndex': 1,
      },
      {
        'region': 'Sulawesi',
        'questionText':
            'Rumah panggung tradisional masyarakat Bugis-Makassar dikenal dengan nama...',
        'questionImageUrl': '',
        'options': ['Tongkonan', 'Banua Tada', 'Balla / Bola', 'Dulohupa'],
        'correctAnswerIndex': 2,
      },
      {
        'region': 'Sulawesi',
        'questionText': 'Ciri khas tiang rumah panggung Bugis adalah...',
        'questionImageUrl': '',
        'options': [
          'Ditanam ke dalam tanah',
          'Ditumpuk di atas batu tanpa ditanam',
          'Terbuat dari bambu',
          'Berbentuk segi delapan',
        ],
        'correctAnswerIndex': 1,
      },
      {
        'region': 'Sulawesi',
        'questionText':
            'Rumah adat Banua Tada yang berarti rumah siku berasal dari daerah...',
        'questionImageUrl': '',
        'options': ['Buton', 'Minahasa', 'Toraja', 'Bugis'],
        'correctAnswerIndex': 0,
      },
      {
        'region': 'Sulawesi',
        'questionText':
            'Ukiran khas Tana Toraja (Passura) pada Tongkonan umumnya menggunakan 4 warna dasar, yaitu...',
        'questionImageUrl': '',
        'options': [
          'Merah, Putih, Hitam, Kuning',
          'Merah, Biru, Hitam, Kuning',
          'Hijau, Putih, Biru, Kuning',
          'Hitam, Putih, Coklat, Emas',
        ],
        'correctAnswerIndex': 0,
      },
      {
        'region': 'Sulawesi',
        'questionText':
            'Rumah Pewaris (Walewangko) merupakan rumah panggung khas daerah...',
        'questionImageUrl': '',
        'options': ['Minahasa (Sulut)', 'Toraja', 'Gorontalo', 'Mandar'],
        'correctAnswerIndex': 0,
      },
      {
        'region': 'Sulawesi',
        'questionText':
            'Rumah tradisional Sulawesi Tengah yang memiliki atap segitiga curam sekaligus berfungsi sebagai dinding luar adalah...',
        'questionImageUrl': '',
        'options': [
          'Rumah Tambi',
          'Rumah Souraja',
          'Rumah Boyang',
          'Rumah Tongkonan',
        ],
        'correctAnswerIndex': 0,
      },
      {
        'region': 'Sulawesi',
        'questionText':
            'Rumah panggung tradisional suku Mandar di Sulawesi Barat yang penutup bubungannya bersusun menunjukkan kasta bangsawan disebut...',
        'questionImageUrl': '',
        'options': [
          'Rumah Boyang',
          'Rumah Banua Tada',
          'Rumah Dulohupa',
          'Rumah Walewangko',
        ],
        'correctAnswerIndex': 0,
      },
      {
        'region': 'Sulawesi',
        'questionText':
            'Bangunan bersejarah berupa istana kayu peninggalan Raja Yodjokodi di Palu dengan tiang penyangga berjumlah 36 adalah...',
        'questionImageUrl': '',
        'options': [
          'Rumah Souraja',
          'Rumah Tambi',
          'Rumah Tongkonan',
          'Rumah Dulohupa',
        ],
        'correctAnswerIndex': 0,
      },
      {
        'region': 'Sulawesi',
        'questionText':
            'Rumah adat Tongkonan memiliki tipe banua terkecil yang hanya berupa kolong tanpa dinding pendukung disebut...',
        'questionImageUrl': '',
        'options': [
          'Tongkonan Barung-barung',
          'Tongkonan Layuk',
          'Tongkonan Pekamberan',
          'Tongkonan Batu',
        ],
        'correctAnswerIndex': 0,
      },
      {
        'region': 'Sulawesi',
        'questionText':
            'Rumah Banua Tada di Buton dibedakan berdasarkan tingkat tiang. Istana Kesultanan yang berlantai 4 disebut...',
        'questionImageUrl': '',
        'options': [
          'Kamali / Malige',
          'Tare Pata Pale',
          'Tare Talu Pale',
          'Souraja',
        ],
        'correctAnswerIndex': 0,
      },
      {
        'region': 'Sulawesi',
        'questionText':
            'Rumah adat Dulohupa di Gorontalo membagi bagian tiangnya menjadi tiga jenis, yang melambangkan...',
        'questionImageUrl': '',
        'options': [
          'Anatomi tubuh manusia (kaki, badan, kepala)',
          'Jumlah klan pendiri kerajaan',
          'Arah mata angin pelindung',
          'Tiga ajaran agama besar',
        ],
        'correctAnswerIndex': 0,
      },
      {
        'region': 'Sulawesi',
        'questionText':
            'Tangga masuk ganda simetris di sisi kiri dan kanan Rumah Walewangko Minahasa secara filosofis berfungsi untuk...',
        'questionImageUrl': '',
        'options': [
          'Menangkal dan membingungkan roh jahat',
          'Menghemat ruang teras depan',
          'Tempat berjemur hasil panen',
          'Mempercepat evakuasi saat kebakaran',
        ],
        'correctAnswerIndex': 0,
      },
      {
        'region': 'Sulawesi',
        'questionText':
            'Tiang penyangga utama pada Rumah Souraja di Palu berjumlah...',
        'questionImageUrl': '',
        'options': ['36 tiang', '10 tiang', '20 tiang', '50 tiang'],
        'correctAnswerIndex': 0,
      },
      {
        'region': 'Sulawesi',
        'questionText':
            'Rumah adat Sulawesi Barat (Boyang Adaq) khusus dihuni oleh kasta bangsawan, yang dicirikan oleh...',
        'questionImageUrl': '',
        'options': [
          'Penutup bubungan bersusun 3 hingga 7',
          'Lantai yang langsung menyentuh tanah',
          'Atap berbahan seng baja',
          'Dinding dari anyaman bambu polos',
        ],
        'correctAnswerIndex': 0,
      },
      {
        'region': 'Sulawesi',
        'questionText':
            'Bahan utama penyusun konstruksi tiang kokoh tanpa sambungan pada rumah Walewangko adalah...',
        'questionImageUrl': '',
        'options': [
          'Kayu besi / ulin utuh',
          'Bambu petung pilihan',
          'Batang pohon kelapa',
          'Balok semen cetak',
        ],
        'correctAnswerIndex': 0,
      },
      {
        'region': 'Sulawesi',
        'questionText':
            'Ornamen patung kepala kerbau (pebaula) yang dipasang di bagian depan rumah Tambi melambangkan...',
        'questionImageUrl': '',
        'options': [
          'Kekayaan dan status sosial pemilik',
          'Batas suci pemujaan dewa',
          'Hewan peliharaan favorit keluarga',
          'Penunjuk arah kiblat ibadah',
        ],
        'correctAnswerIndex': 0,
      },
      {
        'region': 'Sulawesi',
        'questionText':
            'Konsep pembagian ruangan secara aksial horizontal pada rumah adat Bugis-Makassar terdiri dari tiga tingkat, disebut...',
        'questionImageUrl': '',
        'options': ['Sulapa Eppa', 'Tiga Bola', 'Bengkilas', 'Soko Guru'],
        'correctAnswerIndex': 0,
      },
      {
        'region': 'Sulawesi',
        'questionText':
            'Sulluk Banua pada tingkatan kolong Rumah Tongkonan difungsikan sebagai...',
        'questionImageUrl': '',
        'options': [
          'Tempat memelihara hewan ternak',
          'Kamar tidur anak perempuan',
          'Dapur dan tempat memasak',
          'Ruang penyimpanan harta warisan',
        ],
        'correctAnswerIndex': 0,
      },

      // --- PAPUA ---
      {
        'region': 'Papua',
        'questionText':
            'Rumah adat Honai tidak memiliki jendela. Fungsi utamanya adalah untuk...',
        'questionImageUrl': '',
        'options': [
          'Kemudahan membangun',
          'Menghindari musuh',
          'Menahan udara dingin pegunungan',
          'Karena tidak ada kayu',
        ],
        'correctAnswerIndex': 2,
      },
      {
        'region': 'Papua',
        'questionText': 'Atap Rumah Honai umumnya terbuat dari...',
        'questionImageUrl': '',
        'options': ['Daun kelapa', 'Seng', 'Jerami / Ilalang', 'Sirap kayu'],
        'correctAnswerIndex': 2,
      },
      {
        'region': 'Papua',
        'questionText':
            'Selain Honai untuk laki-laki, terdapat bangunan khusus untuk perempuan yang disebut...',
        'questionImageUrl': '',
        'options': ['Wamai', 'Ebei', 'Kariwari', 'Jew'],
        'correctAnswerIndex': 1,
      },
      {
        'region': 'Papua',
        'questionText':
            'Rumah tinggi di atas pohon setinggi belasan meter merupakan arsitektur khas Suku...',
        'questionImageUrl': '',
        'options': ['Asmat', 'Korowai', 'Dani', 'Biak'],
        'correctAnswerIndex': 1,
      },
      {
        'region': 'Papua',
        'questionText':
            'Bangunan berbentuk panggung memanjang (bisa mencapai 100 meter) sebagai rumah komunal Suku Asmat disebut...',
        'questionImageUrl': '',
        'options': ['Jew', 'Kariwari', 'Honai', 'Mod Aki Aksa'],
        'correctAnswerIndex': 0,
      },
      {
        'region': 'Papua',
        'questionText':
            'Rumah adat Kariwari yang memiliki atap limas menjulang tinggi ke atas merupakan ciri khas masyarakat...',
        'questionImageUrl': '',
        'options': ['Danau Sentani', 'Lembah Baliem', 'Raja Ampat', 'Asmat'],
        'correctAnswerIndex': 0,
      },
      {
        'region': 'Papua',
        'questionText':
            'Fungsi api unggun kecil yang dinyalakan di lantai dasar Rumah Honai adalah untuk...',
        'questionImageUrl': '',
        'options': [
          'Memasak makanan utama',
          'Menghangatkan tubuh & mengawetkan atap',
          'Penerangan membaca',
          'Ritual memanggil hujan',
        ],
        'correctAnswerIndex': 1,
      },
      {
        'region': 'Papua',
        'questionText':
            'Rumah adat suku Arfak di Papua Barat yang ditopang oleh ratusan tiang penyangga kayu rapat disebut...',
        'questionImageUrl': '',
        'options': [
          'Rumah Mod Aki Aksa (Kaki Seribu)',
          'Rumah Rumsram',
          'Rumah Kariwari',
          'Rumah Jew',
        ],
        'correctAnswerIndex': 0,
      },
      {
        'region': 'Papua',
        'questionText':
            'Rumah adat suku Biak Numfor yang berbentuk panggung pesisir dengan atap melengkung mirip lambung perahu terbalik disebut...',
        'questionImageUrl': '',
        'options': ['Rumah Rumsram', 'Rumah Honai', 'Rumah Jew', 'Rumah Wamai'],
        'correctAnswerIndex': 0,
      },
      {
        'region': 'Papua',
        'questionText':
            'Struktur dapur umum terpusat untuk memasak bersama dalam satu komplek pemukiman adat suku Dani disebut...',
        'questionImageUrl': '',
        'options': ['Rumah Hunila', 'Rumah Ebei', 'Rumah Wamai', 'Rumah Honai'],
        'correctAnswerIndex': 0,
      },
      {
        'region': 'Papua',
        'questionText':
            'Rumah adat Honai yang khusus diperuntukkan bagi kaum laki-laki dewasa disebut...',
        'questionImageUrl': '',
        'options': [
          'Honai Pilamo',
          'Honai Ebei',
          'Honai Hunila',
          'Honai Wamai',
        ],
        'correctAnswerIndex': 0,
      },
      {
        'region': 'Papua',
        'questionText':
            'Mengapa rumah Honai tidak memiliki jendela dan berpintu rendah?',
        'questionImageUrl': '',
        'options': [
          'Untuk menjebak panas tungku dan melindungi dari udara dingin ekstrem',
          'Karena suku Dani tidak mengenal jendela kaca',
          'Untuk menghemat bahan kayu hutan',
          'Agar musuh tidak bisa melihat ke dalam',
        ],
        'correctAnswerIndex': 0,
      },
      {
        'region': 'Papua',
        'questionText':
            'Dinding bulat melingkar pada Rumah Honai biasanya dibuat menggunakan material...',
        'questionImageUrl': '',
        'options': [
          'Lempengan kayu rapat (papan kasar)',
          'Lumpur basah tebal',
          'Anyaman daun sagu',
          'Batu bata kali',
        ],
        'correctAnswerIndex': 0,
      },
      {
        'region': 'Papua',
        'questionText':
            'Rumah pohon suku Korowai di Papua Selatan dibangun pada ketinggian berapa meter dari tanah?',
        'questionImageUrl': '',
        'options': [
          '15 hingga 50 meter',
          '1 hingga 5 meter',
          '5 hingga 10 meter',
          'Lebih dari 100 meter',
        ],
        'correctAnswerIndex': 0,
      },
      {
        'region': 'Papua',
        'questionText':
            'Rumah Jew suku Asmat disebut juga sebagai "Rumah Bujang" karena difungsikan untuk...',
        'questionImageUrl': '',
        'options': [
          'Pusat kegiatan pemuda lajang, upacara adat, dan musyawarah',
          'Tempat tinggal eksklusif bagi keluarga raja',
          'Kamar tidur anak perempuan dewasa',
          'Tempat menyimpan persediaan ubi jalar',
        ],
        'correctAnswerIndex': 0,
      },
      {
        'region': 'Papua',
        'questionText':
            'Tiang penyangga utama di dalam Rumah Jew suku Asmat diukir dengan figur leluhur yang rumit, disebut...',
        'questionImageUrl': '',
        'options': ['Bisj Pole', 'Passura', 'Makara', 'Gebyok'],
        'correctAnswerIndex': 0,
      },
      {
        'region': 'Papua',
        'questionText':
            'Rumah adat Rumsram suku Biak Numfor digunakan sebagai pusat...',
        'questionImageUrl': '',
        'options': [
          'Inisiasi adat dan pendidikan bahari bagi para pemuda',
          'Penyimpanan hasil tangkapan ikan laut',
          'Kandang babi bersama suku Biak',
          'Pernikahan agung keluarga kepala adat',
        ],
        'correctAnswerIndex': 0,
      },
      {
        'region': 'Papua',
        'questionText':
            'Material penutup atap kubah bundar pada rumah Honai dan Ebei suku Dani adalah...',
        'questionImageUrl': '',
        'options': [
          'Alang-alang / jerami tebal',
          'Lembaran seng gelombang',
          'Genteng tanah liat',
          'Kulit kayu jati',
        ],
        'correctAnswerIndex': 0,
      },
      {
        'region': 'Papua',
        'questionText':
            'Mengapa suku Korowai membangun rumah tinggi di atas dahan pohon besar (elevasi ekstrem)?',
        'questionImageUrl': '',
        'options': [
          'Melindungi diri dari hewan buas, banjir, dan roh jahat (laleo)',
          'Mempermudah melihat kedatangan musuh dari jauh',
          'Agar mendapat hembusan angin laut pesisir',
          'Mengikuti adat istana Keraton Jawa',
        ],
        'correctAnswerIndex': 0,
      },
      {
        'region': 'Papua',
        'questionText':
            'Rumah adat Mod Aki Aksa suku Arfak dikenal dengan sebutan...',
        'questionImageUrl': '',
        'options': [
          'Rumah Kaki Seribu',
          'Rumah Bulat Honai',
          'Rumah Panggung Perahu',
          'Rumah Rakit Sungai',
        ],
        'correctAnswerIndex': 0,
      },
    ];

    final WriteBatch batch = FirebaseFirestore.instance.batch();
    for (var q in questions) {
      final docRef = quizCollection.doc();
      batch.set(docRef, q);
    }
    await batch.commit();
  }
}
