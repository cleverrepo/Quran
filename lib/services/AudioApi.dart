import 'dart:convert';

import 'package:http/http.dart' as http;

class AudioPlayList {
  AudioPlayList({
    required this.code,
    required this.status,
    required this.data,
  });

  final int? code;
  final String? status;
  final Data? data;

  factory AudioPlayList.fromJson(Map<String, dynamic> json) {
    return AudioPlayList(
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

Future<AudioPlayList> fetchAudioPlayList() async {
  final response = await http
      .get(Uri.parse('https://api.alquran.cloud/v1/quran/ar.alafasy'));

  if (response.statusCode == 200) {
    return AudioPlayList.fromJson(json.decode(response.body));
  } else {
    throw Exception('Failed to load status respond');
  }
}

class Data {
  Data({
    required this.surahs,
    required this.edition,
  });

  final List<Sura> surahs;
  final Edit? edition;

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      surahs: json["surahs"] == null
          ? []
          : List<Sura>.from(json["surahs"]!.map((x) => Sura.fromJson(x))),
      edition:
      json["edition"] == null ? null : Edit.fromJson(json["edition"]),
    );
  }

  Map<String, dynamic> toJson() => {
    "surahs": surahs.map((x) => x?.toJson()).toList(),
    "edition": edition?.toJson(),
  };
}

class Edit {
  Edit({
    required this.identifier,
    required this.language,
    required this.name,
    required this.englishName,
    required this.format,
    required this.type,
  });

  final String? identifier;
  final String? language;
  final String? name;
  final String? englishName;
  final String? format;
  final String? type;

  factory Edit.fromJson(Map<String, dynamic> json) {
    return Edit(
      identifier: json["identifier"],
      language: json["language"],
      name: json["name"],
      englishName: json["englishName"],
      format: json["format"],
      type: json["type"],
    );
  }

  Map<String, dynamic> toJson() => {
    "identifier": identifier,
    "language": language,
    "name": name,
    "englishName": englishName,
    "format": format,
    "type": type,
  };
}

class Sura {
  Sura({
    required this.number,
    required this.name,
    required this.englishName,
    required this.englishNameTranslation,
    required this.revelationType,
    required this.ayahs,
  });

  final int? number;
  final String? name;
  final String? englishName;
  final String? englishNameTranslation;
  final String? revelationType;
  final List<Aya> ayahs;

  factory Sura.fromJson(Map<String, dynamic> json) {
    return Sura(
      number: json["number"],
      name: json["name"],
      englishName: json["englishName"],
      englishNameTranslation: json["englishNameTranslation"],
      revelationType: json["revelationType"],
      ayahs: json["ayahs"] == null
          ? []
          : List<Aya>.from(json["ayahs"]!.map((x) => Aya.fromJson(x))),
    );
  }

  Map<String, dynamic> toJson() => {
    "number": number,
    "name": name,
    "englishName": englishName,
    "englishNameTranslation": englishNameTranslation,
    "revelationType": revelationType,
    "ayahs": ayahs.map((x) => x?.toJson()).toList(),
  };
}

class Aya {
  Aya({
    required this.number,
    required this.audio,
    required this.audioSecondary,
    required this.text,
    required this.numberInSurah,
    required this.juz,
    required this.manzil,
    required this.page,
    required this.ruku,
    required this.hizbQuarter,
    required this.sajda,
  });

  final int? number;
  final String? audio;
  final List<String> audioSecondary;
  final String? text;
  final int? numberInSurah;
  final int? juz;
  final int? manzil;
  final int? page;
  final int? ruku;
  final int? hizbQuarter;
  final dynamic? sajda;

  factory Aya.fromJson(Map<String, dynamic> json) {
    return Aya(
      number: json["number"],
      audio: json["audio"],
      audioSecondary: json["audioSecondary"] == null
          ? []
          : List<String>.from(json["audioSecondary"]!.map((x) => x)),
      text: json["text"],
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
    "audio": audio,
    "audioSecondary": audioSecondary.map((x) => x).toList(),
    "text": text,
    "numberInSurah": numberInSurah,
    "juz": juz,
    "manzil": manzil,
    "page": page,
    "ruku": ruku,
    "hizbQuarter": hizbQuarter,
    "sajda": sajda,
  };
}

class SajdaClass {
  SajdaClass({
    required this.id,
    required this.recommended,
    required this.obligatory,
  });

  final int? id;
  final bool? recommended;
  final bool? obligatory;

  factory SajdaClass.fromJson(Map<String, dynamic> json) {
    return SajdaClass(
      id: json["id"],
      recommended: json["recommended"],
      obligatory: json["obligatory"],
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "recommended": recommended,
    "obligatory": obligatory,
  };
}
class Reciter {
  final String? id;
  final String? name;
  final String? server;
  final String? rewaya;
  final String? count;
  final String? letter;
  final String? suras;

  Reciter({
    required this.id,
    required this.name,
    required this.server,
    required this.rewaya,
    required this.count,
    required this.letter,
    required this.suras,
  });

  factory Reciter.fromJson(Map<String, dynamic> json) {
    return Reciter(
      id: json["id"],
      name: json["name"],
      server: json["Server"],
      rewaya: json["rewaya"],
      count: json["count"],
      letter: json["letter"],
      suras: json["suras"],
    );
  }
}

class Audio {
  final List<Reciter> reciters;

  Audio({
    required this.reciters,
  });

  factory Audio.fromJson(Map<String, dynamic> json) {
    return Audio(
      reciters: List<Reciter>.from(json["data"]["reciters"].map((x) => Reciter.fromJson(x))),
    );
  }
}

Future<Audio> fetchAudio() async {
  final response = await http.get(Uri.parse('https://mp3quran.net/api/_english.php'));

  if (response.statusCode == 200) {
    return Audio.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Failed to load audio playlist');
  }
}



