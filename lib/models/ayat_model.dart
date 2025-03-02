// To parse this JSON data, do
//
//     final ayat = ayatFromJson(jsonString);

import 'dart:convert';

Ayat ayatFromJson(String str) => Ayat.fromJson(json.decode(str));

String ayatToJson(Ayat data) => json.encode(data.toJson());

class Ayat {
  final String arab;
  final String asbab;
  final String audio;
  final String ayah;
  final String hizb;
  final String id;
  final String juz;
  final String latin;
  final dynamic notes;
  final String page;
  final String surah;
  final String text;
  final String theme;

  Ayat({
    required this.arab,
    required this.asbab,
    required this.audio,
    required this.ayah,
    required this.hizb,
    required this.id,
    required this.juz,
    required this.latin,
    required this.notes,
    required this.page,
    required this.surah,
    required this.text,
    required this.theme,
  });

  factory Ayat.fromJson(Map<String, dynamic> json) => Ayat(
        arab: json["arab"],
        asbab: json["asbab"],
        audio: json["audio"],
        ayah: json["ayah"],
        hizb: json["hizb"],
        id: json["id"],
        juz: json["juz"],
        latin: json["latin"],
        notes: json["notes"],
        page: json["page"],
        surah: json["surah"],
        text: json["text"],
        theme: json["theme"],
      );

  Map<String, dynamic> toJson() => {
        "arab": arab,
        "asbab": asbab,
        "audio": audio,
        "ayah": ayah,
        "hizb": hizb,
        "id": id,
        "juz": juz,
        "latin": latin,
        "notes": notes,
        "page": page,
        "surah": surah,
        "text": text,
        "theme": theme,
      };
}
