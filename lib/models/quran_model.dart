// To parse this JSON data, do
//
//     final quranModel = quranModelFromJson(jsonString);

import 'dart:convert';

import 'package:ibadahku/models/ayat_model.dart';

QuranModel quranModelFromJson(String str) =>
    QuranModel.fromJson(json.decode(str));

String quranModelToJson(QuranModel data) => json.encode(data.toJson());

class QuranModel {
  final bool? status;
  final Request? request;
  final Info? info;
  final List<Ayat>? data;

  QuranModel({
    this.status,
    this.request,
    this.info,
    this.data,
  });

  factory QuranModel.fromJson(Map<String, dynamic> json) => QuranModel(
        status: json["status"],
        request: Request.fromJson(json["request"]),
        info: Info.fromJson(json["info"]),
        // data: List<Map<String, String>>.from(json["data"].map(
        //     (x) => Map.from(x).map((k, v) => MapEntry<String, String>(k, v)))),
        data: List<Ayat>.from(json["data"].map((x) => Ayat.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "request": request?.toJson(),
        "info": info?.toJson(),
        // "data": List<dynamic>.from(data.map(
        //     (x) => Map.from(x).map((k, v) => MapEntry<String, dynamic>(k, v)))),
        "data": List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class Info {
  final Surat surat;

  Info({
    required this.surat,
  });

  factory Info.fromJson(Map<String, dynamic> json) => Info(
        surat: Surat.fromJson(json["surat"]),
      );

  Map<String, dynamic> toJson() => {
        "surat": surat.toJson(),
      };
}

class Surat {
  final int id;
  final Nama nama;
  final String relevasi;
  final int ayatMax;

  Surat({
    required this.id,
    required this.nama,
    required this.relevasi,
    required this.ayatMax,
  });

  factory Surat.fromJson(Map<String, dynamic> json) => Surat(
        id: json["id"],
        nama: Nama.fromJson(json["nama"]),
        relevasi: json["relevasi"],
        ayatMax: json["ayat_max"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "nama": nama.toJson(),
        "relevasi": relevasi,
        "ayat_max": ayatMax,
      };
}

class Nama {
  final String ar;
  final String id;

  Nama({
    required this.ar,
    required this.id,
  });

  factory Nama.fromJson(Map<String, dynamic> json) => Nama(
        ar: json["ar"],
        id: json["id"],
      );

  Map<String, dynamic> toJson() => {
        "ar": ar,
        "id": id,
      };
}

class Request {
  final String path;
  final String surat;
  final String ayat;
  final String panjang;

  Request({
    required this.path,
    required this.surat,
    required this.ayat,
    required this.panjang,
  });

  factory Request.fromJson(Map<String, dynamic> json) => Request(
        path: json["path"],
        surat: json["surat"],
        ayat: json["ayat"],
        panjang: json["panjang"],
      );

  Map<String, dynamic> toJson() => {
        "path": path,
        "surat": surat,
        "ayat": ayat,
        "panjang": panjang,
      };
}
