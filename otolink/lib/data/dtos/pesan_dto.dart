import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/chat_message.dart';

class PesanDto {
  static Pesan fromMap(Map<String, dynamic> map, {required String id}) {
    final List<String> dibaca = (map['dibacaOleh'] as List?)
            ?.whereType<String>()
            .toList(growable: false) ??
        const <String>[];

    return Pesan(
      id: id,
      percakapanId: (map['percakapanId'] ?? '') as String,
      pengirimId: (map['pengirimId'] ?? '') as String,
      teks: map['teks'] as String?,
      urlGambar: map['urlGambar'] as String?,
      dibuatPada: _toDateTime(map['dibuatPada']) ?? DateTime.now(),
      jenis: _jenisFromString((map['jenis'] ?? 'teks') as String),
      hargaTawaran: (map['hargaTawaran'] is num) ? (map['hargaTawaran'] as num).toInt() : null,
      dibacaOleh: dibaca,
    );
  }

  static Map<String, dynamic> toMap(Pesan model) {
    return {
      'percakapanId': model.percakapanId,
      'pengirimId': model.pengirimId,
      'teks': model.teks,
      'urlGambar': model.urlGambar,
      'dibuatPada': Timestamp.fromDate(model.dibuatPada),
      'jenis': _jenisToString(model.jenis),
      'hargaTawaran': model.hargaTawaran,
      'dibacaOleh': model.dibacaOleh,
    }..removeWhere((key, value) => value == null);
  }

  static JenisPesan _jenisFromString(String v) {
    switch (v) {
      case 'gambar':
        return JenisPesan.gambar;
      case 'tawaran':
        return JenisPesan.tawaran;
      case 'teks':
      default:
        return JenisPesan.teks;
    }
  }

  static String _jenisToString(JenisPesan j) {
    switch (j) {
      case JenisPesan.gambar:
        return 'gambar';
      case JenisPesan.tawaran:
        return 'tawaran';
      case JenisPesan.teks:
        return 'teks';
    }
  }

  static DateTime? _toDateTime(dynamic value) {
    if (value == null) return null;
    if (value is Timestamp) return value.toDate();
    if (value is DateTime) return value;
    if (value is int) return DateTime.fromMillisecondsSinceEpoch(value);
    if (value is String) return DateTime.tryParse(value);
    return null;
  }
}

