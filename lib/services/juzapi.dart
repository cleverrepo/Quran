import 'dart:convert';
import 'package:http/http.dart' as http;

class JuzApi {
  JuzApi({
    required this.code,
    required this.status,
    required this.data,
  });

  final int? code;
  final String? status;
  final Data? data;

  factory JuzApi.fromJson(Map<String, dynamic> json) {
    return JuzApi(
      code: json["code"],
      status: json["status"],
      data: json["data"] == null ? null : Data.fromJson(json["data"]),
    );
  }

  Map<String, dynamic> toJson() => {
        "code": code,
        "status": status,
        "data": data?.toJson(),
      };
}

class Data {
  Data({
    required this.number,
    required this.ayahs,
    required this.surahs,
    required this.edition,
  });

  final int? number;
  final List<Ayahs> ayahs;
  final Map<String, Surahs> surahs;
  final Edition? edition;

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      number: json["number"],
      ayahs: json["ayahs"] == null
          ? []
          : List<Ayahs>.from(json["ayahs"]!.map((x) => Ayahs.fromJson(x))),
      surahs: Map.from(json["surahs"])
          .map((k, v) => MapEntry<String, Surahs>(k, Surahs.fromJson(v))),
      edition:
          json["edition"] == null ? null : Edition.fromJson(json["edition"]),
    );
  }

  Map<String, dynamic> toJson() => {
        "number": number,
        "ayahs": ayahs.map((x) => x?.toJson()).toList(),
        "surahs": Map.from(surahs)
            .map((k, v) => MapEntry<String, dynamic>(k, v?.toJson())),
        "edition": edition?.toJson(),
      };
}

class Ayahs {
  Ayahs({
    required this.number,
    required this.arabicText,
    this.englishText,
    required this.surah,
    required this.numberInSurah,
    required this.juz,
    required this.manzil,
    required this.page,
    required this.ruku,
    required this.hizbQuarter,
    required this.sajda,
  });

  final int? number;
  final String? arabicText;
    String? englishText;
  final Surahs? surah;
  final int? numberInSurah;
  final int? juz;
  final int? manzil;
  final int? page;
  final int? ruku;
  final int? hizbQuarter;
  final dynamic? sajda;

  factory Ayahs.fromJson(Map<String, dynamic> json) {
    return Ayahs(
      number: json["number"],
      arabicText: json["text"],
        englishText: null, // Placeholder, update while combining data
      surah: json["surah"] == null ? null : Surahs.fromJson(json["surah"]),
      numberInSurah: json["numberInSurah"],
      juz: json["juz"],
      manzil: json["manzil"],
      page: json["page"],
      ruku: json["ruku"],
      hizbQuarter: json["hizbQuarter"],
      sajda: json["sajda"],
    );
  }

  Map<String, dynamic> toJson() => {
        "number": number,
        "arabicText": arabicText,
        "englishText": englishText,
        "surah": surah?.toJson(),
        "numberInSurah": numberInSurah,
        "juz": juz,
        "manzil": manzil,
        "page": page,
        "ruku": ruku,
        "hizbQuarter": hizbQuarter,
        "sajda": sajda,
      };
}

class Surahs {
  Surahs({
    required this.number,
    required this.name,
    required this.englishName,
    required this.englishNameTranslation,
    required this.revelationType,
    required this.numberOfAyahs,
  });

  final int? number;
  final String? name;
  final String? englishName;
  final String? englishNameTranslation;
  final String? revelationType;
  final int? numberOfAyahs;

  factory Surahs.fromJson(Map<String, dynamic> json) {
    return Surahs(
      number: json["number"],
      name: json["name"],
      englishName: json["englishName"],
      englishNameTranslation: json["englishNameTranslation"],
      revelationType: json["revelationType"],
      numberOfAyahs: json["numberOfAyahs"],
    );
  }

  Map<String, dynamic> toJson() => {
        "number": number,
        "name": name,
        "englishName": englishName,
        "englishNameTranslation": englishNameTranslation,
        "revelationType": revelationType,
        "numberOfAyahs": numberOfAyahs,
      };
}

Future<List<Ayahs>> fetchAyahs(int surahNumber) async {
  final responseArabic = await http.get(Uri.parse('https://api.alquran.cloud/v1/surah/$surahNumber/quran-uthmani'));
  final responseEnglish = await http.get(Uri.parse('https://api.alquran.cloud/v1/surah/$surahNumber/en.asad'));

  if (responseArabic.statusCode == 200 && responseEnglish.statusCode == 200) {
    List<dynamic> arabicAyahsJson = jsonDecode(responseArabic.body)['data']['ayahs'];
    List<dynamic> englishAyahsJson = jsonDecode(responseEnglish.body)['data']['ayahs'];

    List<Ayahs> arabicAyahs = arabicAyahsJson.map((json) => Ayahs.fromJson(json)).toList();
    List<Ayahs> englishAyahs = englishAyahsJson.map((json) => Ayahs.fromJson(json)).toList();

    for (int i = 0; i < arabicAyahs.length; i++) {
      arabicAyahs[i].englishText = englishAyahs[i].arabicText;
    }

    return arabicAyahs;
  } else {
    throw Exception('Failed to load Ayahs');
  }
}

class Edition {
  Edition({
    required this.identifier,
    required this.language,
    required this.name,
    required this.englishName,
    required this.format,
    required this.type,
    required this.direction,
  });

  final String? identifier;
  final String? language;
  final String? name;
  final String? englishName;
  final String? format;
  final String? type;
  final String? direction;

  factory Edition.fromJson(Map<String, dynamic> json) {
    return Edition(
      identifier: json["identifier"],
      language: json["language"],
      name: json["name"],
      englishName: json["englishName"],
      format: json["format"],
      type: json["type"],
      direction: json["direction"],
    );
  }

  Map<String, dynamic> toJson() => {
        "identifier": identifier,
        "language": language,
        "name": name,
        "englishName": englishName,
        "format": format,
        "type": type,
        "direction": direction,
      };
}
