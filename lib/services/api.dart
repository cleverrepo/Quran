import 'dart:convert';

import 'package:http/http.dart' as http;

class SurahClass {
  int code;
  String status;
  Data data;

  SurahClass({
    required this.code,
    required this.status,
    required this.data,
  });
  factory SurahClass.fromJson(Map<String, dynamic> json) {
    return SurahClass(
      code: json['code'],
      status: json['status'],
      data: Data.fromJson(json['data']),
    );
  }
}

class Data {
  List<Surah> surahs;
  Edition edition;

  Data({
    required this.surahs,
    required this.edition,
  });
  factory Data.fromJson(Map<String, dynamic> json) {
    var list = json['surahs'] as List;
    List<Surah> surahList = list.map((i) => Surah.fromJson(i)).toList();

    return Data(
      surahs: surahList,
      edition: Edition.fromJson(json['edition']),
    );
  }
}

Future<SurahClass> fetchJuzStatusRespond() async {
  final response =
      await http.get(Uri.parse('http://api.alquran.cloud/v1/juz/30/en.asad'));

  if (response.statusCode == 200) {
    return SurahClass.fromJson(json.decode(response.body));
  } else {
    throw Exception('Failed to load status respond');
  }
}

Future<SurahClass> fetchSurah() async {
  final response = await http
      .get(Uri.parse('https://api.alquran.cloud/v1/quran/ar.alafasy'));

  if (response.statusCode == 200) {
    return SurahClass.fromJson(json.decode(response.body));
  } else {
    throw Exception('Failed to load status respond');
  }
}

class Edition {
  String identifier;
  String language;
  String name;
  String englishName;
  String format;
  String type;

  Edition({
    required this.identifier,
    required this.language,
    required this.name,
    required this.englishName,
    required this.format,
    required this.type,
  });
  factory Edition.fromJson(Map<String, dynamic> json) {
    return Edition(
      identifier: json['identifier'] ?? "",
      language: json['language'] ?? "",
      name: json['name'] ?? "",
      englishName: json['englishName'] ?? "",
      format: json['format'] ?? "",
      type: json['type'] ?? "",
    );
  }
}

Future<List<Ayah>> fetchAyahs(int surahNumber) async {
  final responseArabic = await http
      .get(Uri.parse('http://api.alquran.cloud/v1/surah/$surahNumber/ar'));
  final responseEnglish = await http
      .get(Uri.parse('http://api.alquran.cloud/v1/surah/$surahNumber/en.asad'));

  if (responseArabic.statusCode == 200 && responseEnglish.statusCode == 200) {
    List<dynamic> arabicAyahs =
        json.decode(responseArabic.body)['data']['ayahs'];
    List<dynamic> englishAyahs =
        json.decode(responseEnglish.body)['data']['ayahs'];

    List<Ayah> ayahs = [];
    for (int i = 0; i < arabicAyahs.length; i++) {
      final arabicAyah = Ayah.fromJson(arabicAyahs[i], language: 'ar');
      final englishAyah = Ayah.fromJson(englishAyahs[i], language: 'en');

      ayahs.add(Ayah(
        number: arabicAyah.number,
        audio: arabicAyah.audio,
        audioSecondary: arabicAyah.audioSecondary,
        arabicText: arabicAyah.arabicText,
        englishText: englishAyah.englishText,
        numberInSurah: arabicAyah.numberInSurah,
        juz: arabicAyah.juz,
        manzil: arabicAyah.manzil,
        page: arabicAyah.page,
        ruku: arabicAyah.ruku,
        hizbQuarter: arabicAyah.hizbQuarter,
        sajda: arabicAyah.sajda,
      ));
    }

    return ayahs;
  } else {
    throw Exception('Failed to load ayahs');
  }
}

class Surah {
  int number;
  String name;
  String englishName;
  String englishNameTranslation;
  RevelationType revelationType;
  List<Ayah> ayahs;

  Surah({
    required this.number,
    required this.name,
    required this.englishName,
    required this.englishNameTranslation,
    required this.revelationType,
    required this.ayahs,
  });

  factory Surah.fromJson(Map<String, dynamic> json) {
    var list = json['ayahs'] as List;
    List<Ayah> ayahList =
        list.map((i) => Ayah.fromJson(i, language: '')).toList();

    return Surah(
      number: json['number'],
      name: json['name'],
      englishName: json['englishName'],
      englishNameTranslation: json['englishNameTranslation'],
      revelationType: RevelationType.values.firstWhere(
        (e) =>
            e.toString().split('.').last.toUpperCase() ==
            json['revelationType'].toUpperCase(),
      ),
      ayahs: ayahList,
    );
  }
}

class Ayah {
  bool isFavorite = false;
  int number;
  String? audio;
  List<String>? audioSecondary;
  String arabicText;
  String englishText;
  int numberInSurah;
  int juz;
  int manzil;
  int page;
  int ruku;
  int hizbQuarter;
  dynamic sajda;

  Ayah({
    required this.number,
    required this.audio,
    required this.audioSecondary,
    required this.arabicText,
    required this.englishText,
    required this.numberInSurah,
    required this.juz,
    required this.manzil,
    required this.page,
    required this.ruku,
    required this.hizbQuarter,
    required this.sajda,
  });

  factory Ayah.fromJson(Map<String, dynamic> json, {required String language}) {
    return Ayah(
      number: json['number'],
      audio: json['audio'],
      audioSecondary: json['audioSecondary'] != null
          ? List<String>.from(json['audioSecondary'])
          : null,
      arabicText: language == 'ar' ? json['text'] : '',
      englishText: language == 'en' ? json['text'] : '',
      numberInSurah: json['numberInSurah'],
      juz: json['juz'],
      manzil: json['manzil'],
      page: json['page'],
      ruku: json['ruku'],
      hizbQuarter: json['hizbQuarter'],
      sajda: json['sajda'],
    );
  }
}

class SajdaClass {
  int id;
  bool recommended;
  bool obligatory;

  SajdaClass({
    required this.id,
    required this.recommended,
    required this.obligatory,
  });
}

enum RevelationType { MECCAN, MEDINAN }
